% ------------------------------------------------------------------------------
% Initialize configuration values.
%
% SYNTAX :
%  [o_unusedVarargin, o_inputError] = init_config_values(a_varargin)
%
% INPUT PARAMETERS :
%   a_varargin : input parameters
%
% OUTPUT PARAMETERS :
%   o_unusedVarargin : not already used input parameters
%   o_inputError     : input error flag
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   09/11/2010 - RNU - creation
% ------------------------------------------------------------------------------
function [o_unusedVarargin, o_inputError] = init_config_values(a_varargin)

% output parameters initialization
o_unusedVarargin = [];
o_inputError = 0;

% global configuration values
global g_decArgo_floatListFileName;
global g_decArgo_expectedCycleList;
global g_decArgo_floatTransType;

global g_decArgo_floatInformationFileName;
global g_decArgo_dirInputJsonFloatDecodingParametersFile;

global g_decArgo_hexArgosFileFormat;
global g_decArgo_dirInputHexArgosFileFormat1;
global g_decArgo_dirInputHexArgosFileFormat2;
global g_decArgo_hexArgosDataDirStruct;

global g_decArgo_dirInputRsyncData;
global g_decArgo_dirInputRsyncLog;

global g_decArgo_dirInputJsonTechLabelFile;
global g_decArgo_dirInputJsonConfLabelFile;

global g_decArgo_dirInputJsonFloatMetaDataFile;

global g_decArgo_dirInputDmBufferList;

global g_decArgo_dirOutputLogFile;
global g_decArgo_dirOutputCsvFile;
global g_decArgo_dirOutputXmlFile;
global g_decArgo_dirOutputNetcdfFile;

global g_decArgo_generateNcTraj;
global g_decArgo_generateNcMultiProf;
global g_decArgo_generateNcMonoProf;
global g_decArgo_generateNcTech;
global g_decArgo_generateNcMeta;

global g_decArgo_applyRtqc;

global g_decArgo_rtqcTest1;
global g_decArgo_rtqcTest2;
global g_decArgo_rtqcTest3;
global g_decArgo_rtqcTest4;
global g_decArgo_rtqcTest5;
global g_decArgo_rtqcTest6;
global g_decArgo_rtqcTest7;
global g_decArgo_rtqcTest8;
global g_decArgo_rtqcTest9;
global g_decArgo_rtqcTest11;
global g_decArgo_rtqcTest12;
global g_decArgo_rtqcTest13;
global g_decArgo_rtqcTest14;
global g_decArgo_rtqcTest15;
global g_decArgo_rtqcTest16;
global g_decArgo_rtqcTest18;
global g_decArgo_rtqcTest19;
global g_decArgo_rtqcTest20;
global g_decArgo_rtqcTest21;
global g_decArgo_rtqcTest22;
global g_decArgo_rtqcTest23;
global g_decArgo_rtqcTest57;
global g_decArgo_rtqcTest63;

global g_decArgo_rtqcEtopoFile;
global g_decArgo_rtqcGreyList;

global g_decArgo_add3Min;
global g_decArgo_iridiumDataDirectory;

% configuration parameters
configVar = [];
configVar{end+1} = 'FLOAT_LIST_FILE_NAME';
configVar{end+1} = 'EXPECTED_CYCLE_LIST';
configVar{end+1} = 'FLOAT_TRANSMISSION_TYPE';

configVar{end+1} = 'FLOAT_INFORMATION_FILE_NAME';
configVar{end+1} = 'DIR_INPUT_JSON_FLOAT_DECODING_PARAMETERS_FILE';

configVar{end+1} = 'HEX_ARGOS_FILE_FORMAT';
configVar{end+1} = 'DIR_INPUT_HEX_ARGOS_FILE_FORMAT_1';
configVar{end+1} = 'DIR_INPUT_HEX_ARGOS_FILE_FORMAT_2';
configVar{end+1} = 'HEX_ARGOS_DATA_DIRECTORY_STRUCTURE';

configVar{end+1} = 'DIR_INPUT_RSYNC_DATA';
configVar{end+1} = 'DIR_INPUT_RSYNC_LOG';

configVar{end+1} = 'DIR_INPUT_JSON_TECH_LABEL_FILE';
configVar{end+1} = 'DIR_INPUT_JSON_CONF_LABEL_FILE';

configVar{end+1} = 'DIR_INPUT_JSON_FLOAT_META_DATA_FILE';

configVar{end+1} = 'DIR_INPUT_DM_BUFFER_LIST';

configVar{end+1} = 'IRIDIUM_DATA_DIRECTORY';

configVar{end+1} = 'DIR_OUTPUT_LOG_FILE';
configVar{end+1} = 'DIR_OUTPUT_CSV_FILE';
configVar{end+1} = 'DIR_OUTPUT_XML_FILE';
configVar{end+1} = 'DIR_OUTPUT_NETCDF_FILE';

configVar{end+1} = 'GENERATE_NC_TRAJ';
configVar{end+1} = 'GENERATE_NC_MULTI_PROF';
configVar{end+1} = 'GENERATE_NC_MONO_PROF';
configVar{end+1} = 'GENERATE_NC_TECH';
configVar{end+1} = 'GENERATE_NC_META';

configVar{end+1} = 'APPLY_RTQC';

configVar{end+1} = 'TEST001_PLATFORM_IDENTIFICATION';
configVar{end+1} = 'TEST002_IMPOSSIBLE_DATE';
configVar{end+1} = 'TEST003_IMPOSSIBLE_LOCATION';
configVar{end+1} = 'TEST004_POSITION_ON_LAND';
configVar{end+1} = 'TEST005_IMPOSSIBLE_SPEED';
configVar{end+1} = 'TEST006_GLOBAL_RANGE';
configVar{end+1} = 'TEST007_REGIONAL_RANGE';
configVar{end+1} = 'TEST008_PRESSURE_INCREASING';
configVar{end+1} = 'TEST009_SPIKE';
configVar{end+1} = 'TEST011_GRADIENT';
configVar{end+1} = 'TEST012_DIGIT_ROLLOVER';
configVar{end+1} = 'TEST013_STUCK_VALUE';
configVar{end+1} = 'TEST014_DENSITY_INVERSION';
configVar{end+1} = 'TEST015_GREY_LIST';
configVar{end+1} = 'TEST016_GROSS_SALINITY_OR_TEMPERATURE_SENSOR_DRIFT';
configVar{end+1} = 'TEST018_FROZEN_PRESSURE';
configVar{end+1} = 'TEST019_DEEPEST_PRESSURE';
configVar{end+1} = 'TEST020_QUESTIONABLE_ARGOS_POSITION';
configVar{end+1} = 'TEST021_NS_UNPUMPED_SALINITY';
configVar{end+1} = 'TEST022_NS_MIXED_AIR_WATER';
configVar{end+1} = 'TEST023_DEEP_FLOAT';
configVar{end+1} = 'TEST057_DOXY';
configVar{end+1} = 'TEST063_CHLA';

configVar{end+1} = 'TEST004_ETOPO2_FILE';
configVar{end+1} = 'TEST015_GREY_LIST_FILE';

configVar{end+1} = 'ADD_THREE_MINUTES';

% get configuration parameters
[ ...
   configVal, ...
   o_unusedVarargin, ...
   o_inputError ...
   ] = get_config_dec_argo(configVar, a_varargin);

if (o_inputError == 0)
   
   g_decArgo_floatListFileName = configVal{1};
   configVal(1) = [];
   g_decArgo_expectedCycleList = configVal{1};
   configVal(1) = [];
   g_decArgo_floatTransType = str2num(configVal{1});
   configVal(1) = [];
   
   g_decArgo_floatInformationFileName = configVal{1};
   configVal(1) = [];
   g_decArgo_dirInputJsonFloatDecodingParametersFile = configVal{1};
   configVal(1) = [];
   
   g_decArgo_hexArgosFileFormat = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_dirInputHexArgosFileFormat1 = configVal{1};
   configVal(1) = [];
   g_decArgo_dirInputHexArgosFileFormat2 = configVal{1};
   configVal(1) = [];
   g_decArgo_hexArgosDataDirStruct = str2num(configVal{1});
   configVal(1) = [];
   
   g_decArgo_dirInputRsyncData = configVal{1};
   configVal(1) = [];
   g_decArgo_dirInputRsyncLog = configVal{1};
   configVal(1) = [];
   
   g_decArgo_dirInputJsonTechLabelFile = configVal{1};
   configVal(1) = [];
   g_decArgo_dirInputJsonConfLabelFile = configVal{1};
   configVal(1) = [];
   
   g_decArgo_dirInputJsonFloatMetaDataFile = configVal{1};
   configVal(1) = [];
   
   g_decArgo_dirInputDmBufferList = configVal{1};
   configVal(1) = [];
   
   g_decArgo_iridiumDataDirectory = configVal{1};
   configVal(1) = [];
   
   g_decArgo_dirOutputLogFile = configVal{1};
   configVal(1) = [];
   g_decArgo_dirOutputCsvFile = configVal{1};
   configVal(1) = [];
   g_decArgo_dirOutputXmlFile = configVal{1};
   configVal(1) = [];
   g_decArgo_dirOutputNetcdfFile = configVal{1};
   configVal(1) = [];
   
   g_decArgo_generateNcTraj = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_generateNcMultiProf = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_generateNcMonoProf = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_generateNcTech = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_generateNcMeta = str2num(configVal{1});
   configVal(1) = [];
   
   g_decArgo_applyRtqc = str2num(configVal{1});
   configVal(1) = [];
   
   g_decArgo_rtqcTest1 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest2 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest3 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest4 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest5 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest6 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest7 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest8 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest9 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest11 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest12 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest13 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest14 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest15 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest16 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest18 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest19 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest20 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest21 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest22 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest23 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest57 = str2num(configVal{1});
   configVal(1) = [];
   g_decArgo_rtqcTest63 = str2num(configVal{1});
   configVal(1) = [];
   
   g_decArgo_rtqcEtopoFile = configVal{1};
   configVal(1) = [];
   g_decArgo_rtqcGreyList = configVal{1};
   configVal(1) = [];
   
   g_decArgo_add3Min = str2num(configVal{1});
   configVal(1) = [];
   
end

return;
