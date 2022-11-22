% ------------------------------------------------------------------------------
% Check and retrieve statistical information on raw Argos files.
%
% SYNTAX :
%   check_argos_raw_files or check_argos_raw_files(6900189, 7900118)
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
%   02/21/2014 - RNU - creation
% ------------------------------------------------------------------------------
function check_argos_raw_files(varargin)

% directory of the argos files to check
DIR_INPUT_ARGOS_FILES = 'C:\Users\jprannou\_DATA\IN\split_apex_061609\in_split_cycle - copie\';

% directory to store the log and CSV files
DIR_LOG_FILE = 'C:\Users\jprannou\_RNU\DecArgo_soft\work\';

% min non-trans duration (in hour) to use the ghost detection
MIN_NON_TRANS_DURATION_FOR_GHOST = 7;

% mode processing flags
global g_decArgo_realtimeFlag;
global g_decArgo_delayedModeFlag;

% default values initialization
init_default_values;


% configuration parameters
configVar = [];
configVar{end+1} = 'FLOAT_LIST_FILE_NAME';
configVar{end+1} = 'FLOAT_INFORMATION_FILE_NAME';

% get configuration parameters
g_decArgo_realtimeFlag = 0;
g_decArgo_delayedModeFlag = 0;
[configVal, unusedVarargin, inputError] = get_config_dec_argo(configVar, []);
floatListFileName = configVal{1};
floatInformationFileName = configVal{2};

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

logFile = [DIR_LOG_FILE '/' 'check_argos_raw_files' name '_' datestr(now, 'yyyymmddTHHMMSS') '.log'];
diary(logFile);
tic;

% create the CSV output file
outputFileName = [DIR_LOG_FILE '/' 'check_argos_raw_files' name '_' datestr(now, 'yyyymmddTHHMMSS') '.csv'];
fidOut = fopen(outputFileName, 'wt');
if (fidOut == -1)
   return;
end
header = ['Line; WMO; File; ' ...
   'JulD first; JulD last; Trans dur; Nb ghost del; ' ...
   'Max non-trans time; JulD before; JulD after; Cor trans dur'];
fprintf(fidOut, '%s\n', header);
      
% get floats information
[listWmoNum, listDecId, listArgosId, listFrameLen, ...
   listCycleTime, listDriftSamplingPeriod, listDelay, ...
   listLaunchDate, listLaunchLon, listLaunchLat, ...
   listRefDay, listEndDate, listDmFlag] = get_floats_info(floatInformationFileName);

% process the floats
nbLine = 1;
nbFloats = length(floatList);
for idFloat = 1:nbFloats
   
   floatNum = floatList(idFloat);
   floatNumStr = num2str(floatNum);
   fprintf('%03d/%03d %s\n', idFloat, nbFloats, floatNumStr);
   
   % find current float Argos Id
   idF = find(listWmoNum == floatNum, 1);
   if (isempty(idF))
      fprintf('ERROR: No information on float #%d\n', floatNum);
      fprintf('(nothing done)\n');
      continue;
   end
   floatArgosId = str2num(listArgosId{idF});
   floatFrameLen = listFrameLen(idF);
   
   % select and sort the Argos files of the float
   dirInputFloat = [DIR_INPUT_ARGOS_FILES '/' sprintf('%06d', floatArgosId) '/'];
   argosFiles = dir([dirInputFloat '/' sprintf('*%d*%d*', floatArgosId, floatNum)]);
   for idFile = 1:length(argosFiles)
      
      argosFileName = argosFiles(idFile).name;
      argosFilePathName = [dirInputFloat '/' argosFileName];
      
      [argosLocDate, argosDataDate] = ...
         read_argos_file_fmt1_rough(argosFilePathName, floatArgosId);
      argosDate = [argosLocDate; argosDataDate];
      argosDate = sort(argosDate);
      
      [maxNonTransTime, idMax] = max(diff(argosDate)*24);
      juldLastBefore = julian_2_gregorian_dec_argo(argosDate(idMax));
      juldFirstAfter = julian_2_gregorian_dec_argo(argosDate(idMax+1));
      minDate = min(argosDate);
      maxDate = max(argosDate);
      juldFirst = julian_2_gregorian_dec_argo(minDate);
      juldLast = julian_2_gregorian_dec_argo(maxDate);
      
      ghostMsgNb = 0;
      if (maxNonTransTime >= MIN_NON_TRANS_DURATION_FOR_GHOST)
         stop = 0;
         while(~stop)
            if (strcmp(juldFirst, juldLastBefore) == 1)
               idDel = find(argosDate == argosDate(idMax));
               argosDate(idDel) = [];
               ghostMsgNb = ghostMsgNb + 1;
            elseif (strcmp(juldFirstAfter, juldLast) == 1)
               idDel = find(argosDate == argosDate(idMax+1));
               argosDate(idDel) = [];
               ghostMsgNb = ghostMsgNb + 1;
            else
               stop = 1;
            end
            
            if (stop == 0)
               [maxNonTransTime, idMax] = max(diff(argosDate)*24);
               juldLastBefore = julian_2_gregorian_dec_argo(argosDate(idMax));
               juldFirstAfter = julian_2_gregorian_dec_argo(argosDate(idMax+1));
               minDate = min(argosDate);
               maxDate = max(argosDate);
               juldFirst = julian_2_gregorian_dec_argo(minDate);
               juldLast = julian_2_gregorian_dec_argo(maxDate);
               if (maxNonTransTime < MIN_NON_TRANS_DURATION_FOR_GHOST)
                  stop = 1;
               end
            end
         end
      end
      
      fprintf(fidOut, '%d; %d; %s; %s; %s; %.1f; %d; %.1f; %s; %s; %.1f\n', ...
         nbLine, floatNum, argosFileName, ...
         juldFirst, juldLast, ...
         (maxDate-minDate)*24, ...
         ghostMsgNb, ...
         maxNonTransTime, ...
         juldLastBefore, juldFirstAfter, ...
         ((maxDate-minDate)*24)-maxNonTransTime);
      
      nbLine = nbLine + 1;

   end
   
   fprintf(fidOut, '%d\n', nbLine);
   nbLine = nbLine + 1;

end

fclose(fidOut);

ellapsedTime = toc;
fprintf('done (Elapsed time is %.1f seconds)\n', ellapsedTime);

diary off;

return;
