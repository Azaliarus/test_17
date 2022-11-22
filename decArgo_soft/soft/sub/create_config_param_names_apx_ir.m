% ------------------------------------------------------------------------------
% Create configuration parameter lists of decoder names and NetCDF names.
%
% SYNTAX :
%  [o_decArgoConfParamNames, o_ncConfParamNames, o_ncConfParamIds] = ...
%    create_config_param_names_apx_ir(a_decoderId)
%
% INPUT PARAMETERS :
%    a_decoderId : decoder Id
%
% OUTPUT PARAMETERS :.
%    o_decArgoConfParamNames : internal configuration parameter names
%    o_ncConfParamNames      : NetCDF configuration parameter names
%    o_ncConfParamIds        : NetCDF configuration parameter Ids
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   07/10/2017 - RNU - creation
% ------------------------------------------------------------------------------
function [o_decArgoConfParamNames, o_ncConfParamNames, o_ncConfParamIds] = ...
   create_config_param_names_apx_ir(a_decoderId)

% output parameters initialization
o_decArgoConfParamNames = [];
o_ncConfParamNames = [];
o_ncConfParamIds = [];

% current float WMO number
global g_decArgo_floatNum;

% output NetCDF configuration parameter Ids
global g_decArgo_outputNcConfParamId;

% output NetCDF configuration parameter labels
global g_decArgo_outputNcConfParamLabel;


% create configuration names for decoder and associated one for NetCDF
configIds = [];
decConfNames = [];
ncConfNames = [];
ncConfIds = [];
switch (a_decoderId)
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   case {1101, 1110, 1112}
      % 030410, 092813, 102815
      
      configIds = [ ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_CHR'} ...
         {'CONFIG_CTO'} ...
         {'CONFIG_CPAP'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_DB'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_FLBB'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_MLS'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_N'} ...
         {'CONFIG_DIR'} ...
         {'CONFIG_TRI'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_DEBUG'} ...
         ];
      
   case {1102}
      % 120210
      
      configIds = [ ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_CTO'} ...
         {'CONFIG_CPAP'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_DB'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_IMLT'} ...
         {'CONFIG_ICEM'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_MLS'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_N'} ...
         {'CONFIG_DIR'} ...
         {'CONFIG_RAFOS'} ...
         {'CONFIG_TRI'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_DEBUG'} ...
         ];
      
   case {1103, 1104, 1106, 1107}
      % 012811, 020212, 060612, 062813_1
      
      configIds = [ ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_CHR'} ...
         {'CONFIG_CTO'} ...
         {'CONFIG_CPAP'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_DB'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_MLS'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_N'} ...
         {'CONFIG_DIR'} ...
         {'CONFIG_TRI'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_DEBUG'} ...
         ];
      
   case {1105}
      % 030512
      
      configIds = [ ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_CTO'} ...
         {'CONFIG_CPAP'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_DB'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_FLBB'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_IDP'} ...
         {'CONFIG_IEP'} ...
         {'CONFIG_IMLT'} ...
         {'CONFIG_ICEM'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_MLS'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_N'} ...
         {'CONFIG_DIR'} ...
         {'CONFIG_RAFOS'} ...
         {'CONFIG_TRI'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_DEBUG'} ...
         ];
      
   case {1108, 1109, 1113, 1314}
      % 062813_2, 062813_3, 110216, 090215
      
      configIds = [ ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_CTO'} ...
         {'CONFIG_CPAP'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_DB'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_IDP'} ...
         {'CONFIG_IEP'} ...
         {'CONFIG_IMLT'} ...
         {'CONFIG_ICEM'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_MLS'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_N'} ...
         {'CONFIG_DIR'} ...
         {'CONFIG_RAFOS'} ...
         {'CONFIG_TRI'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_DEBUG'} ...
         ];
      
   case {1111, 1114}
      % 073014
      % 073014_2
      
      configIds = [ ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_CHR'} ...
         {'CONFIG_CTO'} ...
         {'CONFIG_CPAP'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_DB'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_FLBB'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_IDP'} ...
         {'CONFIG_IEP'} ...
         {'CONFIG_IMLT'} ...
         {'CONFIG_ICEM'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_MLS'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_N'} ...
         {'CONFIG_DIR'} ...
         {'CONFIG_TRI'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_DEBUG'} ...
         ];
      
   case {1201}
      % 061113
      
      configIds = [ ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_CTO'} ...
         {'CONFIG_CPAP'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_DB'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_HPVE'} ...
         {'CONFIG_HPVR'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_MLS'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_OIAM'} ...
         {'CONFIG_OTPO'} ...
         {'CONFIG_OVO'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_N'} ...
         {'CONFIG_DIR'} ...
         {'CONFIG_TRI'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_DEBUG'} ...
         ];
      
   case {1321, 1322, 1323, 1121, 1123, 1126, 1127}
      % 2.10.1.S, 2.11.1.S, 2.12.2.1.S
      % 2.11.3.R, 2.12.3.R, 2.10.4.R, 2.12.2.1.R
      
      configIds = [ ...
         {'CONFIG_DIR'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_ARM'} ...
         {'CONFIG_AR'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_ATI'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DDTI'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_ETI'} ...
         {'CONFIG_HRC'} ...
         {'CONFIG_HRP'} ...
         {'CONFIG_IBD'} ...
         {'CONFIG_IMLT'} ...
         {'CONFIG_IDP'} ...
         {'CONFIG_IEP'} ...
         {'CONFIG_ICEM'} ...
         {'CONFIG_ITI'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_LD'} ...
         {'CONFIG_DEBUG'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_MAP'} ...
         {'CONFIG_MBC'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PBN'} ...
         {'CONFIG_PDB'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PDTI'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_PTI'} ...
         {'CONFIG_N'} ...
         {'CONFIG_PST'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_SPSPC'} ...
         {'CONFIG_REP'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_VM'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_COP'} ...
         {'CONFIG_SAMPLE01'} ...
         {'CONFIG_SAMPLE02'} ...
         {'CONFIG_SAMPLE03'} ...
         {'CONFIG_SAMPLE04'} ...
         {'CONFIG_SAMPLE05'} ...
         {'CONFIG_SAMPLE06'} ...
         {'CONFIG_PROFILE01'} ...
         {'CONFIG_PROFILE02'} ...
         {'CONFIG_PROFILE03'} ...
         {'CONFIG_PROFILE04'} ...
         {'CONFIG_PROFILE05'} ...
         {'CONFIG_PROFILE06'} ...
         {'CONFIG_MEASURE01'} ...
         {'CONFIG_MEASURE02'} ...
         {'CONFIG_PX_1_6_0_0_3'} ...
         {'CONFIG_PX_1_6_0_0_4'} ...
         {'CONFIG_PX_1_5_0_0_1'} ...
         {'CONFIG_PX_1_5_0_0_6'} ...
         {'CONFIG_PX_1_5_0_0_0'} ...
         {'CONFIG_PX_1_3_0_0_2'} ...
         {'CONFIG_PX_3_3_0_1_1'} ...
         {'CONFIG_PX_3_3_0_1_0'} ...
         {'CONFIG_PX_2_3_1_0_3'} ...
         {'CONFIG_PX_2_3_1_0_1'} ...
         {'CONFIG_PX_2_3_1_0_2'} ...
         {'CONFIG_PX_2_3_1_0_0'} ...
         {'CONFIG_PX_2_3_0_0_3'} ...
         {'CONFIG_PX_2_3_0_0_1'} ...
         {'CONFIG_PX_2_3_0_0_2'} ...
         {'CONFIG_PX_2_3_0_0_0'} ...
         {'CONFIG_PX_1_3_0_0_0'} ...
         {'CONFIG_PX_3_2_0_1_3'} ...
         {'CONFIG_PX_3_2_0_2_3'} ...
         {'CONFIG_PX_3_2_0_3_3'} ...
         {'CONFIG_PX_3_2_0_4_3'} ...
         {'CONFIG_PX_3_2_0_1_2'} ...
         {'CONFIG_PX_3_2_0_2_2'} ...
         {'CONFIG_PX_3_2_0_3_2'} ...
         {'CONFIG_PX_3_2_0_4_2'} ...
         {'CONFIG_PX_1_2_0_0_0'} ...
         {'CONFIG_PX_1_1_0_0_0'} ...
         {'CONFIG_PX_1_1_0_0_7'} ...
         {'CONFIG_PX_1_1_0_0_8'} ...
         {'CONFIG_PX_1_6_0_0_0'} ...
         {'CONFIG_PX_1_6_0_0_5'} ...
         {'CONFIG_PX_1_4_0_0_0'} ...
         ];
      
   case {1122, 1124}
      % 2.13.1.R & 2.13.1.1.R, 2.14.3.R
      
      configIds = [ ...
         {'CONFIG_DIR'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_ARM'} ...
         {'CONFIG_AR'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_ATI'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DDTI'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_ETI'} ...
         {'CONFIG_HRC'} ...
         {'CONFIG_HRP'} ...
         {'CONFIG_IBD'} ...
         {'CONFIG_IMLT'} ...
         {'CONFIG_IDC'} ...
         {'CONFIG_IDP'} ...
         {'CONFIG_IEP'} ...
         {'CONFIG_ICEM'} ...
         {'CONFIG_ITI'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_LD'} ...
         {'CONFIG_DEBUG'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_MAP'} ...
         {'CONFIG_MBC'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PBN'} ...
         {'CONFIG_PDB'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PDTI'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_PTI'} ...
         {'CONFIG_N'} ...
         {'CONFIG_PST'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_SPSPC'} ...
         {'CONFIG_TSD'} ...
         {'CONFIG_TED'} ...
         {'CONFIG_REP'} ...
         {'CONFIG_TT'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_VM'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_COP'} ...
         {'CONFIG_SAMPLE01'} ...
         {'CONFIG_SAMPLE02'} ...
         {'CONFIG_SAMPLE03'} ...
         {'CONFIG_SAMPLE04'} ...
         {'CONFIG_SAMPLE05'} ...
         {'CONFIG_SAMPLE06'} ...
         {'CONFIG_PROFILE01'} ...
         {'CONFIG_PROFILE02'} ...
         {'CONFIG_PROFILE03'} ...
         {'CONFIG_PROFILE04'} ...
         {'CONFIG_PROFILE05'} ...
         {'CONFIG_PROFILE06'} ...
         {'CONFIG_MEASURE01'} ...
         {'CONFIG_MEASURE02'} ...
         {'CONFIG_POWER_START'} ...
         {'CONFIG_POWER_STOP'} ...
         {'CONFIG_PX_1_6_0_0_3'} ...
         {'CONFIG_PX_1_6_0_0_4'} ...
         {'CONFIG_PX_1_5_0_0_1'} ...
         {'CONFIG_PX_1_5_0_0_6'} ...
         {'CONFIG_PX_1_5_0_0_0'} ...
         {'CONFIG_PX_1_3_0_0_2'} ...
         {'CONFIG_PX_3_3_0_1_1'} ...
         {'CONFIG_PX_3_3_0_1_0'} ...
         {'CONFIG_PX_2_3_1_0_3'} ...
         {'CONFIG_PX_2_3_1_0_1'} ...
         {'CONFIG_PX_2_3_1_0_2'} ...
         {'CONFIG_PX_2_3_1_0_0'} ...
         {'CONFIG_PX_2_3_0_0_3'} ...
         {'CONFIG_PX_2_3_0_0_1'} ...
         {'CONFIG_PX_2_3_0_0_2'} ...
         {'CONFIG_PX_2_3_0_0_0'} ...
         {'CONFIG_PX_1_3_0_0_0'} ...
         {'CONFIG_PX_3_2_0_1_3'} ...
         {'CONFIG_PX_3_2_0_2_3'} ...
         {'CONFIG_PX_3_2_0_3_3'} ...
         {'CONFIG_PX_3_2_0_4_3'} ...
         {'CONFIG_PX_3_2_0_1_2'} ...
         {'CONFIG_PX_3_2_0_2_2'} ...
         {'CONFIG_PX_3_2_0_3_2'} ...
         {'CONFIG_PX_3_2_0_4_2'} ...
         {'CONFIG_PX_1_2_0_0_0'} ...
         {'CONFIG_PX_1_1_0_0_0'} ...
         {'CONFIG_PX_1_1_0_0_7'} ...
         {'CONFIG_PX_1_1_0_0_8'} ...
         {'CONFIG_PX_1_6_0_0_0'} ...
         {'CONFIG_PX_1_6_0_0_5'} ...
         {'CONFIG_PX_1_4_0_0_0'} ...
         ];
      
   case {1125, 1128}
      % 2.15.0.R, 2.15.2.R
      
      configIds = [ ...
         {'CONFIG_DIR'} ...
         {'CONFIG_CT'} ...
         {'CONFIG_ARM'} ...
         {'CONFIG_AR'} ...
         {'CONFIG_TOD'} ...
         {'CONFIG_ASCEND'} ...
         {'CONFIG_ATI'} ...
         {'CONFIG_NUDGE'} ...
         {'CONFIG_TPP'} ...
         {'CONFIG_TP'} ...
         {'CONFIG_DPDP'} ...
         {'CONFIG_DDTI'} ...
         {'CONFIG_DPF'} ...
         {'CONFIG_DOWN'} ...
         {'CONFIG_ETI'} ...
         {'CONFIG_HRC'} ...
         {'CONFIG_HRP'} ...
         {'CONFIG_IAT'} ...
         {'CONFIG_IBD'} ...
         {'CONFIG_IMLT'} ...
         {'CONFIG_IDCO'} ...
         {'CONFIG_IDC'} ...
         {'CONFIG_IDN'} ...
         {'CONFIG_IDPRES'} ...
         {'CONFIG_IDT'} ...
         {'CONFIG_IDTI'} ...
         {'CONFIG_IDP'} ...
         {'CONFIG_IEP'} ...
         {'CONFIG_ICEM'} ...
         {'CONFIG_ITI'} ...
         {'CONFIG_IBN'} ...
         {'CONFIG_LD'} ...
         {'CONFIG_DEBUG'} ...
         {'CONFIG_PACT'} ...
         {'CONFIG_MAP'} ...
         {'CONFIG_MBC'} ...
         {'CONFIG_OK'} ...
         {'CONFIG_PBDP'} ...
         {'CONFIG_PBN'} ...
         {'CONFIG_PDB'} ...
         {'CONFIG_PPP'} ...
         {'CONFIG_PDP'} ...
         {'CONFIG_PDTI'} ...
         {'CONFIG_PRKP'} ...
         {'CONFIG_PTI'} ...
         {'CONFIG_N'} ...
         {'CONFIG_PST'} ...
         {'CONFIG_PRE'} ...
         {'CONFIG_SPSPC'} ...
         {'CONFIG_TSD'} ...
         {'CONFIG_TED'} ...
         {'CONFIG_REP'} ...
         {'CONFIG_TT'} ...
         {'CONFIG_UP'} ...
         {'CONFIG_VM'} ...
         {'CONFIG_TBP'} ...
         {'CONFIG_FRET'} ...
         {'CONFIG_FEXT'} ...
         {'CONFIG_COP'} ...
         {'CONFIG_SAMPLE01'} ...
         {'CONFIG_SAMPLE02'} ...
         {'CONFIG_SAMPLE03'} ...
         {'CONFIG_SAMPLE04'} ...
         {'CONFIG_SAMPLE05'} ...
         {'CONFIG_SAMPLE06'} ...
         {'CONFIG_PROFILE01'} ...
         {'CONFIG_PROFILE02'} ...
         {'CONFIG_PROFILE03'} ...
         {'CONFIG_PROFILE04'} ...
         {'CONFIG_PROFILE05'} ...
         {'CONFIG_PROFILE06'} ...
         {'CONFIG_MEASURE01'} ...
         {'CONFIG_MEASURE02'} ...
         {'CONFIG_POWER_START'} ...
         {'CONFIG_POWER_STOP'} ...
         {'CONFIG_LISTEN_START'} ...
         {'CONFIG_LISTEN_DURATION'} ...
         {'CONFIG_PX_1_6_0_0_3'} ...
         {'CONFIG_PX_1_6_0_0_4'} ...
         {'CONFIG_PX_1_5_0_0_1'} ...
         {'CONFIG_PX_1_5_0_0_6'} ...
         {'CONFIG_PX_1_5_0_0_0'} ...
         {'CONFIG_PX_1_3_0_0_2'} ...
         {'CONFIG_PX_3_3_0_1_1'} ...
         {'CONFIG_PX_3_3_0_1_0'} ...
         {'CONFIG_PX_2_3_1_0_3'} ...
         {'CONFIG_PX_2_3_1_0_1'} ...
         {'CONFIG_PX_2_3_1_0_2'} ...
         {'CONFIG_PX_2_3_1_0_0'} ...
         {'CONFIG_PX_2_3_0_0_3'} ...
         {'CONFIG_PX_2_3_0_0_1'} ...
         {'CONFIG_PX_2_3_0_0_2'} ...
         {'CONFIG_PX_2_3_0_0_0'} ...
         {'CONFIG_PX_1_3_0_0_0'} ...
         {'CONFIG_PX_3_2_0_1_3'} ...
         {'CONFIG_PX_3_2_0_2_3'} ...
         {'CONFIG_PX_3_2_0_3_3'} ...
         {'CONFIG_PX_3_2_0_4_3'} ...
         {'CONFIG_PX_3_2_0_1_2'} ...
         {'CONFIG_PX_3_2_0_2_2'} ...
         {'CONFIG_PX_3_2_0_3_2'} ...
         {'CONFIG_PX_3_2_0_4_2'} ...
         {'CONFIG_PX_1_2_0_0_0'} ...
         {'CONFIG_PX_1_1_0_0_0'} ...
         {'CONFIG_PX_1_1_0_0_7'} ...
         {'CONFIG_PX_1_1_0_0_8'} ...
         {'CONFIG_PX_1_6_0_0_0'} ...
         {'CONFIG_PX_1_6_0_0_5'} ...
         {'CONFIG_PX_1_4_0_0_0'} ...
         ];      
      
   otherwise
      fprintf('WARNING: Float #%d: Nothing implemented yet for decoderId #%d\n', ...
         g_decArgo_floatNum, ...
         a_decoderId);
end

if (~isempty(configIds))
   for idC = 1:length(configIds)
      idParamName = find(strcmp(g_decArgo_outputNcConfParamId, configIds{idC}) == 1);
      if (isempty(idParamName))
         fprintf('ERROR: Float #%d: Configuration parameter not managed ''%s''\n', ...
            g_decArgo_floatNum, ...
            configIds{idC});
         continue
      end
      decConfNames{end+1} = configIds{idC};
      ncConfNames{end+1} = g_decArgo_outputNcConfParamLabel{idParamName};
      ncConfIds = [ncConfIds g_decArgo_outputNcConfParamId(idParamName)];
   end
end

% output for check
% for id = 1:length(decConfNames)
%    fprintf('%s;%s\n', decConfNames{id}, ncConfNames{id});
% end

% update output parameters
o_decArgoConfParamNames = decConfNames;
o_ncConfParamNames = ncConfNames;
o_ncConfParamIds = ncConfIds;

return
