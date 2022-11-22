% ------------------------------------------------------------------------------
% Process meta-data exported from Coriolis data base and save it in individual
% json files.
%
% SYNTAX :
%  generate_json_float_meta_prv_cts4_ir_sbd
%
% INPUT PARAMETERS :
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   12/01/2014 - RNU - creation
%   09/01/2017 - RNU - RT version added
% ------------------------------------------------------------------------------
function generate_json_float_meta_prv_cts4_ir_sbd

% meta-data file exported from Coriolis data base
% FLOAT_META_FILE_NAME = 'C:\Users\jprannou\_RNU\DecPrv_info\_configParamNames\meta_PRV_from_VB_REFERENCE_20150217.txt';
% FLOAT_META_FILE_NAME = 'C:\Users\jprannou\_RNU\DecPrv_info\_configParamNames\meta_PRV_from_VB_REFERENCE_20150519.txt';
% FLOAT_META_FILE_NAME = 'C:\Users\jprannou\_RNU\DecPrv_info\Remocean\finalisation_meta_sensor&param\export_JPR_from_VB_Rem_all_20160511.txt';
FLOAT_META_FILE_NAME = 'C:\Users\jprannou\_RNU\DecPrv_info\_configParamNames\export_DOXY_from_VB_20160518.txt';
% FLOAT_META_FILE_NAME = 'C:\Users\jprannou\Desktop\MAJ_REM_20170306\DBexport_BioArgo_from_VB_20170307.txt';

% list of concerned floats
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_nke_ir_sbd_rem_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_nke_rem_all_20160512.txt';
FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_nke_rem_flbb_20160512.txt';

% calibration coefficient file decoded from data
% CALIB_FILE_NAME = 'C:\Users\jprannou\_RNU\DecPrv_info\Remocean\DataFromFloatToMeta\CalibCoef\calib_coef.txt';
CALIB_FILE_NAME = 'C:\Users\jprannou\_DATA\IN\collectes_20170315\decArgo_config_floats\Remocean_from_vb_20170322\DataFromFloatToMeta\CalibCoef\calib_coef.txt';

% directory of individual configuration commands report files
% CONFIG_DIR_NAME = 'C:\Users\jprannou\_RNU\DecPrv_info\Remocean\ConfigAtLaunch\FLBB\';
% CONFIG_DIR_NAME = 'C:\Users\jprannou\_RNU\DecPrv_info\Remocean\ConfigAtLaunch\ArvorCM\';
% CONFIG_DIR_NAME = 'C:\Users\jprannou\_RNU\DecPrv_info\Remocean\finalisation_meta_sensor&param\JPR\ConfigAtLaunch\FLBB\';
CONFIG_DIR_NAME = 'C:\Users\jprannou\_DATA\IN\collectes_20170315\decArgo_config_floats\Remocean_from_vb_20170322\ConfigAtLaunch\FLBB\';

% directory of individual json float meta-data files
OUTPUT_DIR_NAME = ['C:\Users\jprannou\_RNU\DecArgo_soft\work\generate_json_float_meta_' datestr(now, 'yyyymmddTHHMMSS')];

% directory to store the log file
DIR_LOG_FILE = 'C:\Users\jprannou\_RNU\DecArgo_soft\work\';


% store the start time of the run
currentTime = datestr(now, 'yyyymmddTHHMMSSZ');

% log file creation
logFileName = [DIR_LOG_FILE '/generate_json_float_meta_prv_cts4_ir_sbd_' currentTime '.log'];
diary(logFileName);

% generate JSON meta-data files
generate_json_float_meta_prv_cts4_ir_sbd_(...
   FLOAT_META_FILE_NAME, ...
   FLOAT_LIST_FILE_NAME, ...
   CALIB_FILE_NAME, ...
   CONFIG_DIR_NAME, ...
   OUTPUT_DIR_NAME);

diary off;

return;