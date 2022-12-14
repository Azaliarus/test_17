% ------------------------------------------------------------------------------
% Compute dissolved oxygen measurements (DOXY) from oxygen sensor measurements
% (PHASE_DELAY_DOXY) using the Stern-Volmer equation
%
% SYNTAX :
%  [o_doxyValues] = compute_DOXY_SBE_209_2002( ...
%    a_phaseDelayDoxyValues, a_tempDoxyValues, ...
%    a_presValues, a_tempValues, a_psalValues)
%
% INPUT PARAMETERS :
%   a_phaseDelayDoxyValues : input PHASE_DELAY_DOXY optode data
%   a_tempDoxyValues       : input TEMP_DOXY optode data
%   a_presValues           : input PRES CTD data
%   a_tempValues           : input TEMP CTD data
%   a_psalValues           : input PSAL CTD data
%
% OUTPUT PARAMETERS :
%   o_doxyValues : output DOXY data
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   07/03/2015 - RNU - creation
% ------------------------------------------------------------------------------
function [o_doxyValues] = compute_DOXY_SBE_209_2002( ...
   a_phaseDelayDoxyValues, a_tempDoxyValues, ...
   a_presValues, a_tempValues, a_psalValues)

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% default values
global g_decArgo_phaseDelayDoxyDef;
global g_decArgo_tempDoxyDef;
global g_decArgo_doxyDef;
global g_decArgo_presDef;
global g_decArgo_tempDef;
global g_decArgo_salDef;

% arrays to store calibration information
global g_decArgo_calibInfo;

% retrieve global coefficient default values
global g_decArgo_doxy_103_208_307_d0;
global g_decArgo_doxy_103_208_307_d1;
global g_decArgo_doxy_103_208_307_d2;
global g_decArgo_doxy_103_208_307_d3;
global g_decArgo_doxy_103_208_307_sPreset;
global g_decArgo_doxy_103_208_307_solB0;
global g_decArgo_doxy_103_208_307_solB1;
global g_decArgo_doxy_103_208_307_solB2;
global g_decArgo_doxy_103_208_307_solB3;
global g_decArgo_doxy_103_208_307_solC0;
global g_decArgo_doxy_103_208_307_pCoef1;
global g_decArgo_doxy_103_208_307_pCoef2;
global g_decArgo_doxy_103_208_307_pCoef3;

% output parameters initialization
o_doxyValues = ones(length(a_phaseDelayDoxyValues), 1)*g_decArgo_doxyDef;


if (isempty(a_phaseDelayDoxyValues) || isempty(a_tempDoxyValues))
   return;
end

% get calibration information
if (isempty(g_decArgo_calibInfo))
   fprintf('WARNING: Float #%d Cycle #%d: DOXY calibration coefficients are missing => DOXY data set to fill value\n', ...
      g_decArgo_floatNum, ...
      g_decArgo_cycleNum);
   return;
elseif ((isfield(g_decArgo_calibInfo, 'OPTODE')) && (isfield(g_decArgo_calibInfo.OPTODE, 'SbeTabDoxyCoef')))
   tabDoxyCoef = g_decArgo_calibInfo.OPTODE.SbeTabDoxyCoef;
   % the size of the tabDoxyCoef should be: size(tabDoxyCoef) = 1 9
   if (~isempty(find((size(tabDoxyCoef) == [1 9]) ~= 1, 1)))
      fprintf('ERROR: Float #%d Cycle #%d: DOXY calibration coefficients are inconsistent => DOXY data set to fill value\n', ...
      g_decArgo_floatNum, ...
      g_decArgo_cycleNum);
      return;
   end
else
   fprintf('WARNING: Float #%d Cycle #%d: DOXY calibration coefficients are missing => DOXY data set to fill value\n', ...
      g_decArgo_floatNum, ...
      g_decArgo_cycleNum);
   return;
end

idDef = find( ...
   (a_phaseDelayDoxyValues == g_decArgo_phaseDelayDoxyDef) | ...
   (a_tempDoxyValues == g_decArgo_tempDoxyDef) | ...
   (a_presValues == g_decArgo_presDef) | ...
   (a_tempValues == g_decArgo_tempDef) | ...
   (a_psalValues == g_decArgo_salDef));
idNoDef = setdiff(1:length(o_doxyValues), idDef);

if (~isempty(idNoDef))
   
   phaseDelayDoxyValues = a_phaseDelayDoxyValues(idNoDef);
   tempDoxyValues = a_tempDoxyValues(idNoDef);
   presValues = a_presValues(idNoDef);
   tempValues = a_tempValues(idNoDef);
   psalValues = a_psalValues(idNoDef);

   % compute MLPL_DOXY from PHASE_DELAY_DOXY reported by the SBE 63 optode
   mlplDoxyValues = calcoxy_sbe63_sternvolmer( ...
      phaseDelayDoxyValues, presValues, tempDoxyValues, tabDoxyCoef, ...
      g_decArgo_doxy_103_208_307_pCoef1);
   
   % convert MLPL_DOXY in micromol/L
   molarDoxyValues = 44.6596*mlplDoxyValues;
   
   % salinity effect correction
   sRef = 0; % not considered since a PHASE_DOXY is transmitted
   oxygenSalComp = calcoxy_salcomp(molarDoxyValues, tempValues, psalValues, sRef, ...
      g_decArgo_doxy_103_208_307_d0, ...
      g_decArgo_doxy_103_208_307_d1, ...
      g_decArgo_doxy_103_208_307_d2, ...
      g_decArgo_doxy_103_208_307_d3, ...
      g_decArgo_doxy_103_208_307_sPreset, ...
      g_decArgo_doxy_103_208_307_solB0, ...
      g_decArgo_doxy_103_208_307_solB1, ...
      g_decArgo_doxy_103_208_307_solB2, ...
      g_decArgo_doxy_103_208_307_solB3, ...
      g_decArgo_doxy_103_208_307_solC0 ...
      );
   
   % pressure effect correction
   oxygenPresComp = calcoxy_prescomp(oxygenSalComp, presValues, tempValues, ...
      g_decArgo_doxy_103_208_307_pCoef2, ...
      g_decArgo_doxy_103_208_307_pCoef3 ...
      );
   
   % units convertion (micromol/L to micromol/kg)
   rho = potential_density(presValues, tempValues, psalValues);
   oxyValues = oxygenPresComp ./ rho;
   
   o_doxyValues(idNoDef) = oxyValues;     
end

return;
