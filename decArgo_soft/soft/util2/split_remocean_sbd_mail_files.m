% ------------------------------------------------------------------------------
% Pre-process Remocean mail files.
%   - save mail contents in a dedicated file
%   - extract SBD mail attachement and split its contents by storing only one
%     packet per file
%   - check resulting files to assign its processing rank
%
% SYNTAX :
%   split_remocean_sbd_mail_files or split_remocean_sbd_mail_files(6900189, 7900118)
%
% INPUT PARAMETERS :
%   varargin : WMO number of floats to process
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   13/02/2015 - RNU - creation
% ------------------------------------------------------------------------------
function split_remocean_sbd_mail_files(varargin)

% mode processing flags
global g_decArgo_realtimeFlag;
global g_decArgo_delayedModeFlag;


% default values initialization
init_default_values;

% directory to store the log and CSV files
DIR_LOG_FILE = 'C:\users\RNU\Argo\work\';

% if we only want to check existing split SBD files
CHECK_BUFF_ONLY = 0;

% to generate a CSV file without buffer contents
GENERATE_CSV_OUTPUT = 1;


% configuration parameters
configVar = [];
configVar{end+1} = 'FLOAT_LIST_FILE_NAME';
configVar{end+1} = 'FLOAT_INFORMATION_FILE_NAME';
configVar{end+1} = 'IRIDIUM_DATA_DIRECTORY';

% get configuration parameters
g_decArgo_realtimeFlag = 0;
g_decArgo_delayedModeFlag = 0;
[configVal, unusedVarargin, inputError] = get_config_dec_argo(configVar, []);
floatListFileName = configVal{1};
floatInformationFileName = configVal{2};
irDataDirName = configVal{3};

if (nargin == 0)
   % floats to process come from floatListFileName
   if ~(exist(floatListFileName, 'file') == 2)
      fprintf('File not found: %s\n', floatListFileName);
      return;
   end
   
   fprintf('Floats from list: %s\n', floatListFileName);
   floatList = load(floatListFileName);
else
   % floats to process come from input parameters
   floatList = cell2mat(varargin);
end

% create and start log file recording
if (nargin == 0)
   [pathstr, name, ext] = fileparts(floatListFileName);
   name = ['_' name];
else
   name = sprintf('_%d', floatList);
end

currentDate = datestr(now, 'yyyymmddTHHMMSS');
logFile = [DIR_LOG_FILE '/' 'split_remocean_sbd_mail_files' name '_' currentDate '.log'];
diary(logFile);
tic;

% read the list to associate a WMO number to a login name
[numWmo, listDecId, loginName, listFrameLen, ...
   listCycleTime, listDriftSamplingPeriod, listDelay, ...
   listLaunchDate, listLaunchLon, listLaunchLat, ...
   listRefDay, listEndDate] = get_floats_info(floatInformationFileName);
if (isempty(numWmo))
   return;
end

% process the floats
nbFloats = length(floatList);
for idFloat = 1:nbFloats
   
   floatNum = floatList(idFloat);
   floatNumStr = num2str(floatNum);
   fprintf('%03d/%03d %s\n', idFloat, nbFloats, floatNumStr);
   
   fidOutCsv = '';
   if (GENERATE_CSV_OUTPUT)
      outputFileName = [DIR_LOG_FILE '/split_remocean_sbd_mail_files_' floatNumStr '_' currentDate '.csv'];
      fidOutCsv = fopen(outputFileName, 'wt');
      if (fidOutCsv == -1)
         return;
      end
   end
   outputFileName = [DIR_LOG_FILE '/' floatNumStr '_buffers.txt'];
   fidOutTxt = fopen(outputFileName, 'wt');
   if (fidOutTxt == -1)
      return;
   end
      
   % find the login name of the float
   [imei] = find_login_name(floatNum, numWmo, loginName);
   if (isempty(imei))
      return;
   end
   
   inputDirName = [irDataDirName '/' imei '_' floatNumStr '/archive/'];
   outputDirName = [irDataDirName '/' imei '_' floatNumStr '/archive_dm/'];
   
   idF = find(numWmo == floatNum, 1);
   if (isempty(idF))
      return;
   end
   floatLaunchDate = listLaunchDate(idF);
   floatEndDate = listEndDate(idF);
   
   if (~CHECK_BUFF_ONLY)
      
      % create the output directory
      if (exist(outputDirName, 'dir') == 7)
         rmdir(outputDirName, 's');
      end
      mkdir(outputDirName);
      
      split_mail_files(inputDirName, outputDirName);
   end
   
   % process generated sbd files
   create_buffers(outputDirName, floatLaunchDate, floatEndDate, fidOutTxt, fidOutCsv);
   
   fclose(fidOutTxt);
   if (GENERATE_CSV_OUTPUT)
      fclose(fidOutCsv);
   end
end

ellapsedTime = toc;
fprintf('done (Elapsed time is %.1f seconds)\n', ellapsedTime);

diary off;

return;
