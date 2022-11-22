% ------------------------------------------------------------------------------
% Get the basic structure to store meta-data information.
%
% SYNTAX :
%  [o_metaStruct] = get_meta_init_struct()
%
% INPUT PARAMETERS :
%
% OUTPUT PARAMETERS :
%   o_metaStruct : meta-data structure
%
% EXAMPLES :
%
% SEE ALSO : 
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/16/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_metaStruct] = get_meta_init_struct()

% output parameters initialization
o_metaStruct = struct( ...
   'ARGO_USER_MANUAL_VERSION', '', ...
   'PLATFORM_NUMBER', '', ...
   'PTT', '', ...
   'IMEI', '', ...
   'TRANS_SYSTEM', [], ...
   'TRANS_SYSTEM_ID', [], ...
   'TRANS_FREQUENCY', [], ...
   'POSITIONING_SYSTEM', [], ...
   'PLATFORM_FAMILY', '', ...
   'PLATFORM_TYPE', '', ...
   'PLATFORM_MAKER', '', ...
   'FIRMWARE_VERSION', '', ...
   'MANUAL_VERSION', '', ...
   'FLOAT_SERIAL_NO', '', ...
   'STANDARD_FORMAT_ID', '', ...
   'DAC_FORMAT_ID', '', ...
   'WMO_INST_TYPE', '', ...
   'PROJECT_NAME', '', ...
   'DATA_CENTRE', '', ...
   'PI_NAME', '', ...
   'ANOMALY', '', ...
   'BATTERY_TYPE', '', ...
   'BATTERY_PACKS', '', ...
   'CONTROLLER_BOARD_TYPE_PRIMARY', '', ...
   'CONTROLLER_BOARD_TYPE_SECONDARY', '', ...
   'CONTROLLER_BOARD_SERIAL_NO_PRIMARY', '', ...
   'CONTROLLER_BOARD_SERIAL_NO_SECONDARY', '', ...
   'SPECIAL_FEATURES', '', ...
   'FLOAT_OWNER', '', ...
   'OPERATING_INSTITUTION', '', ...
   'CUSTOMISATION', '', ...
   'LAUNCH_DATE', '', ...
   'LAUNCH_LATITUDE', '', ...
   'LAUNCH_LONGITUDE', '', ...
   'LAUNCH_QC', '', ...
   'START_DATE', '', ...
   'START_DATE_QC', '', ...
   'STARTUP_DATE', '', ...
   'STARTUP_DATE_QC', '', ...
   'DEPLOYMENT_PLATFORM', '', ...
   'DEPLOYMENT_CRUISE_ID', '', ...
   'DEPLOYMENT_REFERENCE_STATION_ID', '', ...
   'END_MISSION_DATE', '', ...
   'END_MISSION_STATUS', '', ...
   'END_DECODING_DATE', '', ...
   'CONFIG_PARAMETER_NAME', [], ...
   'CONFIG_PARAMETER_VALUE', [], ...
   'CONFIG_MISSION_NUMBER', [], ...
   'CONFIG_MISSION_COMMENT', [], ...
   'CONFIG_REPETITION_RATE', [], ...
   'SENSOR', [], ...
   'SENSOR_MAKER', [], ...
   'SENSOR_MODEL', [], ...
   'SENSOR_SERIAL_NO', [], ...
   'PARAMETER_SENSOR', [], ...
   'PARAMETER_UNITS', [], ...
   'PARAMETER_ACCURACY', [], ...
   'PARAMETER_RESOLUTION', [], ...
   'PARAMETER', [], ...
   'PREDEPLOYMENT_CALIB_EQUATION', [], ...
   'PREDEPLOYMENT_CALIB_COEFFICIENT', [], ...
   'PREDEPLOYMENT_CALIB_COMMENT', [], ...
   'CALIB_RT_PARAMETER', [], ...
   'CALIB_RT_EQUATION', [], ...
   'CALIB_RT_COEFFICIENT', [], ...
   'CALIB_RT_COMMENT', [], ...
   'CALIB_RT_ADJUSTED_ERROR', [], ...
   'CALIB_RT_ADJ_ERROR_METHOD', [], ...
   'CALIB_RT_DATE', [], ...
   'CALIBRATION_COEFFICIENT', [], ...
   'SENSOR_MOUNTED_ON_FLOAT', []);

return
