% ------------------------------------------------------------------------------
% Compute NITRATE from UV_INTENSITY_NITRATE provided by the SUNA sensor.
%
% SYNTAX :
%  [o_NITRATE] = compute_drift_NITRATE_BIS_105_to_109( ...
%    a_UV_INTENSITY_NITRATE, a_UV_INTENSITY_DARK_NITRATE, ...
%    a_UV_INTENSITY_NITRATE_fill_value, a_UV_INTENSITY_DARK_NITRATE_fill_value, ...
%    a_NITRATE_fill_value, ...
%    a_UV_INTENSITY_NITRATE_dates, a_ctdDates, a_ctdData, ...
%    a_PRES_fill_value, a_TEMP_fill_value, a_PSAL_fill_value, ...
%    a_profSuna)
%
% INPUT PARAMETERS :
%   a_UV_INTENSITY_NITRATE                 : input UV_INTENSITY_NITRATE data
%   a_UV_INTENSITY_DARK_NITRATE            : input UV_INTENSITY_DARK_NITRATE
%                                            data
%   a_UV_INTENSITY_NITRATE_fill_value      : fill value for input
%                                            UV_INTENSITY_NITRATE data
%   a_UV_INTENSITY_DARK_NITRATE_fill_value : fill value for input
%                                            UV_INTENSITY_DARK_NITRATE data
%   a_NITRATE_fill_value                   : fill value for output NITRATE data
%   a_UV_INTENSITY_NITRATE_dates           : dates of the UV_INTENSITY_NITRATE
%                                            data
%   a_ctdDates                             : dates of ascociated CTD (P, T, S)
%                                            data
%   a_ctdData                              : ascociated CTD (P, T, S) data
%   a_PRES_fill_value                      : fill value for input PRES data
%   a_TEMP_fill_value                      : fill value for input TEMP data
%   a_PSAL_fill_value                      : fill value for input PSAL data
%   a_profSuna                             : input SUNA profile structure
%
% OUTPUT PARAMETERS :
%   o_NITRATE : output NITRATE data
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   12/08/2015 - RNU - creation
% ------------------------------------------------------------------------------
function [o_NITRATE] = compute_drift_NITRATE_BIS_105_to_109( ...
   a_UV_INTENSITY_NITRATE, a_UV_INTENSITY_DARK_NITRATE, ...
   a_UV_INTENSITY_NITRATE_fill_value, a_UV_INTENSITY_DARK_NITRATE_fill_value, ...
   a_NITRATE_fill_value, ...
   a_UV_INTENSITY_NITRATE_dates, a_ctdDates, a_ctdData, ...
   a_PRES_fill_value, a_TEMP_fill_value, a_PSAL_fill_value, ...
   a_profSuna)

% output parameters initialization
o_NITRATE = ones(size(a_UV_INTENSITY_NITRATE, 1), 1)*a_NITRATE_fill_value;

% current float WMO number
global g_decArgo_floatNum;

% arrays to store calibration information
global g_decArgo_calibInfo;


if (isempty(a_UV_INTENSITY_NITRATE) || isempty(a_UV_INTENSITY_DARK_NITRATE))
   return;
end

% check that the 'fitlm' function is available in the Matlab configuration
if (isempty(which('fitlm')))
   fprintf('WARNING: Float #%d Cycle #%d Profile #%d: the ''fitlm'' function is not available in your Matlab configuration => NITRATE data set to fill value in ''%c'' profile of SUNA sensor\n', ...
      g_decArgo_floatNum, ...
      a_profSuna.cycleNumber, ...
      a_profSuna.profileNumber, ...
      a_profSuna.direction);
   return;
end

% get calibration information
if (isempty(g_decArgo_calibInfo))
   fprintf('WARNING: Float #%d Cycle #%d Profile #%d: SUNA calibration information are missing => NITRATE data set to fill value in ''%c'' profile of SUNA sensor\n', ...
      g_decArgo_floatNum, ...
      a_profSuna.cycleNumber, ...
      a_profSuna.profileNumber, ...
      a_profSuna.direction);
   return;
elseif (isfield(g_decArgo_calibInfo, 'SUNA') && ...
      isfield(g_decArgo_calibInfo.SUNA, 'TabOpticalWavelengthUv') && ...
      isfield(g_decArgo_calibInfo.SUNA, 'TabENitrate') && ...
      isfield(g_decArgo_calibInfo.SUNA, 'TabESwaNitrate') && ...
      isfield(g_decArgo_calibInfo.SUNA, 'TabUvIntensityRefNitrate') && ...
      isfield(g_decArgo_calibInfo.SUNA, 'TEMP_CAL_NITRATE'))
   tabOpticalWavelengthUv = g_decArgo_calibInfo.SUNA.TabOpticalWavelengthUv;
   tabENitrate = g_decArgo_calibInfo.SUNA.TabENitrate;
   tabESwaNitrate = g_decArgo_calibInfo.SUNA.TabESwaNitrate;
   tabUvIntensityRefNitrate = g_decArgo_calibInfo.SUNA.TabUvIntensityRefNitrate;
   tempCalNitrate = g_decArgo_calibInfo.SUNA.TEMP_CAL_NITRATE;
else
   fprintf('WARNING: Float #%d Cycle #%d Profile #%d: inconsistent SUNA calibration information => NITRATE data set to fill value in ''%c'' profile of SUNA sensor\n', ...
      g_decArgo_floatNum, ...
      a_profSuna.cycleNumber, ...
      a_profSuna.profileNumber, ...
      a_profSuna.direction);
   return;
end

% retrieve configuration information
floatPixelBegin = get_static_config_value('CONFIG_PX_1_6_0_0_3');
floatPixelEnd = get_static_config_value('CONFIG_PX_1_6_0_0_4');
if (isempty(floatPixelBegin) || isempty(floatPixelBegin))
   fprintf('WARNING: Float #%d Cycle #%d Profile #%d: SUNA information (PIXEL_BEGIN, PIXEL_END) are missing => NITRATE data set to fill value in ''%c'' profile of SUNA sensor\n', ...
      g_decArgo_floatNum, ...
      a_profSuna.cycleNumber, ...
      a_profSuna.profileNumber, ...
      a_profSuna.direction);
   return;
end

% assign the CTD data to the UV_INTENSITY_NITRATE measurements (timely closest
% association)
ctdLinkData = assign_CTD_measurements(a_ctdDates, a_ctdData, a_UV_INTENSITY_NITRATE_dates);

% compute pixel interval that covers the [217 nm, 240 nm] wavelength interval
idF1 = find(tabOpticalWavelengthUv >= 217);
idF2 = find(tabOpticalWavelengthUv <= 240);
pixelBegin = idF1(1);
pixelEnd = idF2(end);

% select useful data
tabOpticalWavelengthUv = tabOpticalWavelengthUv(pixelBegin:pixelEnd);
tabENitrate = tabENitrate(pixelBegin:pixelEnd);
tabESwaNitrate = tabESwaNitrate(pixelBegin:pixelEnd);
tabUvIntensityRefNitrate = tabUvIntensityRefNitrate(pixelBegin:pixelEnd);

% tabUvIntensityNitrate = a_UV_INTENSITY_NITRATE(:, floatPixelBegin-pixelBegin+1:end-(floatPixelEnd-pixelEnd));
tabUvIntensityNitrate = a_UV_INTENSITY_NITRATE(:, floatPixelBegin-pixelBegin+1:floatPixelBegin-pixelBegin+1+(pixelEnd-pixelBegin+1)-1);

% if (size(tabUvIntensityRefNitrate, 2) ~= size(tabUvIntensityNitrate, 2))
%    fprintf('WARNING: Float #%d Cycle #%d Profile #%d: SUNA data are inconsistent (in size) => NITRATE data set to fill value in ''%c'' profile of SUNA sensor\n', ...
%       g_decArgo_floatNum, ...
%       a_profSuna.cycleNumber, ...
%       a_profSuna.profileNumber, ...
%       a_profSuna.direction);
%    return;
% end

% format useful data
tabUvIntensityDarkNitrate = repmat(a_UV_INTENSITY_DARK_NITRATE, 1, size(tabUvIntensityNitrate, 2));
tabUvIntensityRefNitrate = repmat(tabUvIntensityRefNitrate, size(tabUvIntensityNitrate, 1), 1);
tabESwaNitrate = repmat(tabESwaNitrate, size(tabUvIntensityNitrate, 1), 1);
tempCalNitrate = repmat(tempCalNitrate, size(ctdLinkData(:, 2)));
tabPsal = repmat(ctdLinkData(:, 3), 1, size(tabUvIntensityNitrate, 2));
tabPres = repmat(ctdLinkData(:, 1), 1, size(tabUvIntensityNitrate, 2));

% to test management of NoDef values
% if (size(ctdLinkData, 1) == 9)
%    tempo = 1
%    tabUvIntensityNitrate(2, :) = ones(1, size(tabUvIntensityNitrate, 2))*a_UV_INTENSITY_NITRATE_fill_value;
%    tabUvIntensityNitrate(8, :) = ones(1, size(tabUvIntensityNitrate, 2))*a_UV_INTENSITY_NITRATE_fill_value;
%    ctdLinkData(4, 1) = a_PRES_fill_value;
%    ctdLinkData(6, 2) = a_TEMP_fill_value;
%    ctdLinkData(6, 3) = a_PSAL_fill_value;
% end

% exclude fill values
idDef = [];
for idL = 1:size(tabUvIntensityNitrate, 1)
   data = tabUvIntensityNitrate(idL, :);
   if ((length(unique(data)) == 1) && (unique(data) == a_UV_INTENSITY_NITRATE_fill_value))
      idDef = [idDef; idL];
   end
end

idDef = sort([idDef; ...
   find((a_UV_INTENSITY_DARK_NITRATE == a_UV_INTENSITY_DARK_NITRATE_fill_value) | ...
   (ctdLinkData(:, 1) == a_PRES_fill_value) | ...
   (ctdLinkData(:, 2) == a_TEMP_fill_value) | ...
   (ctdLinkData(:, 3) == a_PSAL_fill_value))]);

idNoDef = setdiff([1:size(tabUvIntensityNitrate, 1)], idDef)';

if (~isempty(idNoDef))
   
   tabUvIntensityNitrate = tabUvIntensityNitrate(idNoDef, :);
   tabUvIntensityDarkNitrate = tabUvIntensityDarkNitrate(idNoDef, :);
   tabUvIntensityRefNitrate = tabUvIntensityRefNitrate(idNoDef, :);
   tabESwaNitrate = tabESwaNitrate(idNoDef, :);
   tempCalNitrate = tempCalNitrate(idNoDef);
   tabPsal = tabPsal(idNoDef, :);
   tabPres = tabPres(idNoDef, :);
   ctdData = ctdLinkData(idNoDef, :);
   
   % compute NITRATE
   
   % Equation #1
   absorbanceSw = -log10((tabUvIntensityNitrate - tabUvIntensityDarkNitrate) ./ tabUvIntensityRefNitrate);
   
   % Equation #2
   eSwaInsitu = tabESwaNitrate .* ...
      f_function(tabOpticalWavelengthUv, ctdData(:, 2)) ./ ...
      f_function(tabOpticalWavelengthUv, tempCalNitrate);
   
   % Equation #4 (with the pressure effect taken into account)
   absorbanceCorNitrate = absorbanceSw - (eSwaInsitu .* tabPsal) .* (1 - (0.02 * tabPres / 1000));
   
   % Equation #5
   % solve:
   % A11*x1 + A12x2 + A13*X3 = B1
   % A21*x1 + A22x2 + A23*X3 = B2
   % ...
   % Ar1*x1 + Ar2x2 + Ar3*X3 = Br
   % where B1 ... Br = ABSORBANCE_COR_NITRATE(r)
   % where A12 ... Ar2 = OPTICAL_WAVELENGTH_UV(r)
   % where A13 ... Ar3 = E_NITRATE(r)
   % then X3 = MOLAR_NITRATE
   
   tabMolarNitrate = ones(size(tabUvIntensityDarkNitrate, 1), 1)*double(a_NITRATE_fill_value);
   for idL = 1:length(tabMolarNitrate)
      b = absorbanceCorNitrate(idL, :)';
      a = [tabOpticalWavelengthUv' tabENitrate'];
      mdl = fitlm(a, b);
      tabMolarNitrate(idL) = mdl.Coefficients.Estimate(end);
   end
   
   % Equation #6
   % compute potential temperature and potential density
   tpot = tetai(ctdData(:, 1), ctdData(:, 2), ctdData(:, 3), 0);
   [null, sigma0] = swstat90(ctdData(:, 3), tpot, 0);
   rho = (sigma0+1000)/1000;
   
   % compute NITRATE data (units convertion: micromol/L to micromol/kg)
   o_NITRATE(idNoDef) = tabMolarNitrate ./ rho;
   
end

return;

% ------------------------------------------------------------------------------
% Subfunction for NITRATE processing from UV_INTENSITY_NITRATE.
%
% SYNTAX :
%  [o_output] = f_function(a_opticalWavelength, a_temp)
%
% INPUT PARAMETERS :
%   a_opticalWavelength : OPTICAL_WAVELENGTH_UV calibration information
%   a_temp              : temperature used in the processing
%
% OUTPUT PARAMETERS :
%   o_output : result
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   12/08/2015 - RNU - creation
% ------------------------------------------------------------------------------
function [o_output] = f_function(a_opticalWavelength, a_temp)

A = 1.1500276;
B = 0.02840;
C = -0.3101349;
D = 0.001222;
OPTICAL_WAVELENGTH_OFFSET = 210;

tabOpticalWavelength = repmat(a_opticalWavelength, size(a_temp, 1), 1);
tabTemp = repmat(a_temp, 1, size(a_opticalWavelength, 2));
o_output = (A + B*tabTemp) .* exp((C + D*tabTemp) .* (tabOpticalWavelength - OPTICAL_WAVELENGTH_OFFSET));

return;
