% ------------------------------------------------------------------------------
% Use the JAVA format checker on a set of floats.
%
% SYNTAX :
%   nc_check_file_format or nc_check_file_format(6900189, 7900118)
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
%   06/26/2014 - RNU - creation
% ------------------------------------------------------------------------------
function nc_check_file_format(varargin)

% directory of the JAVA checker
% DIR_JAVA_CHECKER = 'C:\Users\jprannou\_RNU\Argo\checker_US\javaChecker\_BETA_FOR_TRAJ\file_checker_v2.6.01_exec_2020-10-01_spec_2020-10-07\';
DIR_JAVA_CHECKER = 'C:\Users\jprannou\_RNU\Argo\checker_US\javaChecker\file_checker_java_v2.6_2020-10-23_spec_2021-01-12\';

% DIR_JAVA_CHECKER = 'C:\Users\jprannou\_RNU\Argo\checker_US\TRAJ_CHECKED\javaChecker\file_checker_exec_2017-03-13_beta_spec_2017-04-24\';

% top directory of the NetCDF files to check
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\OUT\nc_output_decArgo_checkTraj\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_RNU\DecArgo_soft\work\test\output\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\201809-ArgoData\coriolis\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\Conversion_en_3.1\OUT_from_DEP_v1\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\Conversion_en_3.1\OUT_from_DEP\';
DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\Conversion_en_3.1\OUT\';
DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\Conversion_en_3.1_20200103\OUT\';
DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\OUT\nc_output_decArgo\';
DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\OUT\nc_output_decArgo\COURANT\Coriolis_deep_floats_20210205\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\OUT\nc_output_decArgo_rt\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\Conversion_en_3.1\OUT_36\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\Conversion_en_3.1\OUT_tmp\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\OUT\nc_output_decArgo\selected_nke_prv_ir\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_RNU\DecArgo_soft\work\TEST_20201104\WORK\';
DIR_INPUT_NC_FILES = 'C:\Users\jprannou\Contacts\Desktop\TEST_NR\TEST_NR_APRES\Nke_2xx\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\Contacts\Desktop\TEST_NR\TEST_NR_APRES\Apex_APF9_ir_sbd\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\Contacts\Desktop\TEST_NR\TEST_NR_APRES\Apex_APF11_argos\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\Contacts\Desktop\TEST_NR\TEST_NR_APRES\Apex_APF11_ir_rudics\';
% DIR_INPUT_NC_FILES = 'C:\Users\jprannou\Contacts\Desktop\TEST_NR\TEST_NR_APRES\Apex_APF11_ir_sbd\';
DIR_INPUT_NC_FILES = 'C:\Users\jprannou\Contacts\Desktop\TEST_NR\TEST_NR_APRES\Apex_APF9_ir_rudics\';
DIR_INPUT_NC_FILES = 'C:\Users\jprannou\Contacts\Desktop\TEST_NR\TEST_NR_APRES\Apex_APF9_argos\';
DIR_INPUT_NC_FILES = 'C:\Users\jprannou\Contacts\Desktop\TEST_NR\TEST_NR_APRES\Nemo\';
DIR_INPUT_NC_FILES = 'C:\Users\jprannou\_DATA\OUT\nc_output_decArgo\';

% directory to store checker reports
DIR_OUTPUT_REPORT_FILES = 'C:\Users\jprannou\_DATA\OUT\checker_reports\';

% default list of floats to check
FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\tmp.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_pts_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_11.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_4.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_1.2.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_24.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_19.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_25.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_1.02.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_1.01.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_6.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_1.4.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_1.1.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_28.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_1.3.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_1.03.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_13.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_23.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_1.04.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_46.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_11.1.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_new_pts_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_1.5.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_17.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_36.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_29.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_27.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_34.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_41.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_9.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\Argo\ActionsCoriolis\ConvertApexOldVersionsTo3.1\list\Apex_11_a_refaire_20200103.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_nemo_collecte_v2.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_apf11_iridium-rudics_2.13.1.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\tmpAll_nke_cts5.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\tmpAll_apx_rudics.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\tmpAll_apx_argos.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\tmpAll_nova.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\tmpAll_nke_atlantos.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\tmpAll_nke_rem.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_nova_dova_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\arvor_rbr_5.49.txt';
FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_nemo_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_apf11_iridium-rudics_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_apf11_iridium-sbd_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_ir_rudics_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_ir_sbd_090215.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_apf11_argos_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_argos_all.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_argos_all2.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_argos_all3.txt';
% FLOAT_LIST_FILE_NAME = 'C:\Users\jprannou\_RNU\DecArgo_soft\lists\_apex_ir_rudics_all.txt';


% meta-data file exported from Coriolis data base
% dataBaseFileName = 'C:\Users\jprannou\_RNU\DecPrv_info\_configParamNames\meta_PRV_from_VB_REFERENCE_20150217.txt';
% dataBaseFileName = 'C:\Users\jprannou\_RNU\DecApx_info\_configParamNames\export_meta_APEX_from_VB_20150703.txt';

% directory to store the log file
DIR_LOG_FILE = 'C:\Users\jprannou\_RNU\DecArgo_soft\work\log\'; 

% directory to store the csv file
DIR_CSV_FILE = 'C:\Users\jprannou\_RNU\DecArgo_soft\work\csv\'; 

% nc file types to check
CHECK_NC_TRAJ = 1;
CHECK_NC_MULTI_PROF = 0;
CHECK_NC_MONO_PROF = 1;
CHECK_NC_TECH = 1;
CHECK_NC_META = 1;
% CHECK_NC_TRAJ = 1;
% CHECK_NC_MULTI_PROF = 0;
% CHECK_NC_MONO_PROF = 0;
% CHECK_NC_TECH = 0;
% CHECK_NC_META = 0;


if (nargin == 0)
   floatListFileName = FLOAT_LIST_FILE_NAME;
   
   % floats to process come from floatListFileName
   if ~(exist(floatListFileName, 'file') == 2)
      fprintf('ERROR: File not found: %s\n', floatListFileName);
      return
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

logFile = [DIR_LOG_FILE '/' 'nc_check_file_format' name '_' datestr(now, 'yyyymmddTHHMMSS') '.log'];
diary(logFile);
tic;

% create the CSV output file
outputFileName = [DIR_CSV_FILE '/' 'nc_check_file_format' name '_' datestr(now, 'yyyymmddTHHMMSS') '.csv'];
fidOut = fopen(outputFileName, 'wt');
if (fidOut == -1)
   return
end
header = ['Line #; WMO; File type; File name; Status; Error numbers; Warning numbers'];
fprintf(fidOut, '%s\n', header);

% read meta file
% fprintf('Processing file: %s\n', dataBaseFileName);
% fId = fopen(dataBaseFileName, 'r');
% if (fId == -1)
%    fprintf('ERROR: Unable to open file: %s\n', dataBaseFileName);
%    return
% end
% metaFileContents = textscan(fId, '%s', 'delimiter', '\t');
% metaFileContents = metaFileContents{:};
% fclose(fId);
% 
% metaFileContents = regexprep(metaFileContents, '"', '');
% 
% metaData = reshape(metaFileContents, 5, size(metaFileContents, 1)/5)';

% metaWmoList = metaData(:, 1);
% S = sprintf('%s*', metaWmoList{:});
% metaWmoList = sscanf(S, '%f*');

% process the floats
lineNum = 1;
nbFloats = length(floatList);
for idFloat = 1:nbFloats
   
   floatNum = floatList(idFloat);
   floatNumStr = num2str(floatNum);
   fprintf('%03d/%03d %s\n', idFloat, nbFloats, floatNumStr);
   
   %    [floatDac] = get_float_dac(floatNum, metaWmoList, metaData);
   %    floatDac = 'incois';
   %    floatDac = 'aoml';
   %    floatDac = 'csio';
   %    floatDac = 'bodc';
   floatDac = 'coriolis';
   
   for idType = 1:5
      
      if ((idType == 1) && (CHECK_NC_TRAJ == 1))
         % check trajectory files
         ncFileDir = [DIR_INPUT_NC_FILES '/' num2str(floatNum) '/'];
         ncFiles = dir([ncFileDir sprintf('%d_*traj.nc', floatNum)]);
         pattern = 'TRAJ';
      elseif ((idType == 2) && (CHECK_NC_MULTI_PROF == 1))
         % check multi-prof files
         ncFileDir = [DIR_INPUT_NC_FILES '/' num2str(floatNum) '/'];
         ncFiles = dir([ncFileDir sprintf('%d_*prof.nc', floatNum)]);
         pattern = 'MULTI_PROF';
      elseif ((idType == 3) && (CHECK_NC_MONO_PROF == 1))
         % check mono-prof files
         ncFileDir = [DIR_INPUT_NC_FILES '/' num2str(floatNum) '/profiles/'];
         ncFiles = dir([ncFileDir sprintf('*%d*.nc', floatNum)]);
         pattern = 'MONO_PROF';
      elseif ((idType == 4) && (CHECK_NC_TECH == 1))
         % check tech file
         ncFileDir = [DIR_INPUT_NC_FILES '/' num2str(floatNum) '/'];
         ncFiles = dir([ncFileDir sprintf('%d_tech.nc', floatNum)]);
         pattern = 'TECH';
      elseif ((idType == 5) && (CHECK_NC_META == 1))
         % check meat files
         ncFileDir = [DIR_INPUT_NC_FILES '/' num2str(floatNum) '/'];
         ncFiles = dir([ncFileDir sprintf('%d_meta.nc', floatNum)]);
         pattern = 'META';
      else
         continue
      end

      if (exist(ncFileDir, 'dir') == 7)
         
         for idFile = 1:length(ncFiles)
            
            ncFileName = ncFiles(idFile).name;
            [~, name, ~] = fileparts(ncFileName);
            if (strcmp(name(end-3:end), '_aux'))
               continue
            end
            ncFilePathName = [ncFileDir '/' ncFileName];
            
            cmd = '';
            %             if (ispc)
            %                cmd = ['cd ' DIR_JAVA_CHECKER ' & ' ...
            %                   'java -classpath ' DIR_JAVA_CHECKER ' ' ...
            %                   '-jar ' DIR_JAVA_CHECKER '/ValidateSubmit.jar ' ...
            %                   '-full-traj-checks ' ...
            %                   lower(floatDac) ' ' ...
            %                   DIR_JAVA_CHECKER '/spec ' ...
            %                   DIR_OUTPUT_REPORT_FILES ' ' ...
            %                   ncFileDir ' ' ...
            %                   ncFileName];
            %             elseif (isunix)
            %                cmd = ['cd ' DIR_JAVA_CHECKER ' & ' ...
            %                   DIR_JAVA_CHECKER '/ArgoFileChecker.csh ' ...
            %                   '-full-traj-checks ' ...
            %                   lower(floatDac) ' ' ...
            %                   DIR_OUTPUT_REPORT_FILES ' ' ...
            %                   ncFileDir ' ' ...
            %                   ncFileName];
            %             else
            %                fprintf('Cannot determine operating system\n');
            %                return
            %             end
            
            if (ispc)
               cmd = ['cd ' DIR_JAVA_CHECKER ' & ' ...
                  'java -classpath ' DIR_JAVA_CHECKER ' ' ...
                  '-jar ' DIR_JAVA_CHECKER '/ValidateSubmit.jar ' ...
                  lower(floatDac) ' ' ...
                  DIR_JAVA_CHECKER '/spec ' ...
                  DIR_OUTPUT_REPORT_FILES ' ' ...
                  ncFileDir ' ' ...
                  ncFileName];
            elseif (isunix)
               cmd = ['cd ' DIR_JAVA_CHECKER ' & ' ...
                  DIR_JAVA_CHECKER '/ArgoFileChecker.csh ' ...
                  lower(floatDac) ' ' ...
                  DIR_OUTPUT_REPORT_FILES ' ' ...
                  ncFileDir ' ' ...
                  ncFileName];
            else
               fprintf('Cannot determine operating system\n');
               return
            end            
            
            [status, cmdOut] = system(cmd);
            if (status == 0)
               
               reportFilePathName = [DIR_OUTPUT_REPORT_FILES '/' ncFileName '.filecheck'];
               if ~(exist(reportFilePathName, 'file') == 2)
                  fprintf('ERROR: Report file not found: %s\n', reportFilePathName);
                  continue
               end
               
               fId = fopen(reportFilePathName, 'r');
               if (fId == -1)
                  fprintf('ERROR: Unable to open file: %s\n', reportFilePathName);
                  continue
               end

               status = '';
               errorNum = -1;
               warningNum = -1;
               while 1
                  line = fgetl(fId);
                  if (line == -1)
                     break
                  end
                  
                  % collect information
                  if (~isempty(strfind(line, '<status>')))
                     idFStatus1 = strfind(line, '<status>');
                     idFStatus2 = strfind(line, '</status>');
                     if (~isempty(idFStatus1) && ~isempty(idFStatus2))
                        idFStatus1 = idFStatus1 + length('<status>');
                        status = line(idFStatus1:idFStatus2-1);
                     end
                  end
                  if (~isempty(strfind(line, '<errors number="')))
                     idFError1 = strfind(line, '<errors number="');
                     idFError2 = strfind(line, '">');
                     if (isempty(idFError2))
                        idFError2 = strfind(line, '"/>');
                     end
                     if (~isempty(idFError1) && ~isempty(idFError2))
                        idFError1 = idFError1 + length('<errors number="');
                        errorNum = str2num(line(idFError1:idFError2-1));
                     end
                  end
                  if (~isempty(strfind(line, '<warnings number="')))
                     idFWarning1 = strfind(line, '<warnings number="');
                     idFWarning2 = strfind(line, '">');
                     if (isempty(idFWarning2))
                        idFWarning2 = strfind(line, '"/>');
                     end
                     if (~isempty(idFWarning1) && ~isempty(idFWarning2))
                        idFWarning1 = idFWarning1 + length('<warnings number="');
                        warningNum = str2num(line(idFWarning1:idFWarning2-1));
                     end
                     break,
                  end
               end
               
               fclose(fId);
               
               % edit report
%                if ((errorNum > 0) || (warningNum > 0))
%                   edit(reportFilePathName);
%                end
               
               % print collected information in the output CSV file
               fprintf(fidOut, '%d; %d; %s; %s; %s; %d; %d\n', ...
                  lineNum, floatNum, pattern, ncFileName, status, errorNum, warningNum);
               lineNum = lineNum + 1;
               
            else
               fprintf('ERROR: Status %d returned by system cmd ''%s''\n', status, cmd);
            end
         end
      else
         fprintf('WARNING: Directory not found: %s\n', ncFileDir);
      end
   end
end
   
ellapsedTime = toc;
fprintf('done (Elapsed time is %.1f seconds)\n', ellapsedTime);

fclose(fidOut);

diary off;

return

% ------------------------------------------------------------------------------
function [o_floatDac] = get_float_dac(a_floatNum, a_metaWmoList, a_metaData)

o_floatDac = [];

idForWmo = find(a_metaWmoList == a_floatNum);

idF = find(strcmp(a_metaData(idForWmo, 5), 'DATA_CENTRE'));
if (~isempty(idF))
   floatDac = a_metaData{idForWmo(idF), 4};
   [o_floatDac] = get_institution_from_data_centre(floatDac, 1);
else
   o_floatDac = 'CORIOLIS';
end

return

