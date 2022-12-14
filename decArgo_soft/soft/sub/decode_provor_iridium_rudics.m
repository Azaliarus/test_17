% ------------------------------------------------------------------------------
% Decode PROVOR Iridium float with RUDICS SBD files.
%
% SYNTAX :
%  [o_tabProfiles, ...
%    o_tabTrajNMeas, o_tabTrajNCycle, ...
%    o_tabNcTechIndex, o_tabNcTechVal, ...
%    o_structConfig] = ...
%    decode_provor_iridium_rudics( ...
%    a_floatNum, a_cycleList, a_decoderId, a_floatLoginName, ...
%    a_launchDate, a_refDay, a_floatSoftVersion, a_floatDmFlag)
%
% INPUT PARAMETERS :
%   a_floatNum         : float WMO number
%   a_cycleList        : list of cycles to be decoded
%   a_decoderId        : float decoder Id
%   a_floatLoginName   : float name
%   a_launchDate       : launch date
%   a_refDay           : reference day (day of the first descent)
%   a_floatSoftVersion : version of the float's software
%   a_floatDmFlag      : float DM flag
%
% OUTPUT PARAMETERS :
%   o_tabProfiles    : decoded profiles
%   o_tabTrajNMeas   : decoded trajectory N_MEASUREMENT data
%   o_tabTrajNCycle  : decoded trajectory N_CYCLE data
%   o_tabNcTechIndex : decoded technical index information
%   o_tabNcTechVal   : decoded technical data
%   o_structConfig   : NetCDF float configuration
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   02/25/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_tabProfiles, ...
   o_tabTrajNMeas, o_tabTrajNCycle, ...
   o_tabNcTechIndex, o_tabNcTechVal, ...
   o_structConfig] = ...
   decode_provor_iridium_rudics( ...
   a_floatNum, a_cycleList, a_decoderId, a_floatLoginName, ...
   a_launchDate, a_refDay, a_floatSoftVersion, a_floatDmFlag)

% output parameters initialization
o_tabProfiles = [];
o_tabTrajNMeas = [];
o_tabTrajNCycle = [];
o_tabNcTechIndex = [];
o_tabNcTechVal = [];
o_structConfig = [];

% current float WMO number
global g_decArgo_floatNum;
g_decArgo_floatNum = a_floatNum;

% output CSV file Id
global g_decArgo_outputCsvFileId;

% output NetCDF technical parameter index information
global g_decArgo_outputNcParamIndex;

% output NetCDF technical parameter values
global g_decArgo_outputNcParamValue;

% output NetCDF technical parameter labels
global g_decArgo_outputNcParamLabelBis;

% default values
global g_decArgo_janFirst1950InMatlab;
global g_decArgo_dateDef;

% decoder configuration values
global g_decArgo_iridiumDataDirectory;

% SBD sub-directories
global g_decArgo_spoolDirectory;
global g_decArgo_bufferDirectory;
global g_decArgo_archiveDirectory;
global g_decArgo_archiveDmDirectory;
global g_decArgo_tmpDirectory;

% arrays to store rough information on received data
global g_decArgo_0TypeReceivedData;
global g_decArgo_250TypeReceivedData;
global g_decArgo_253TypeReceivedData;

% arrays to store decoded calibration coefficient
global g_decArgo_calibInfo;
g_decArgo_calibInfo = [];

% decoder configuration values
global g_decArgo_generateNcTraj;
global g_decArgo_generateNcMeta;
global g_decArgo_dirInputRsyncData;

% float configuration
global g_decArgo_floatConfig;

% rsync information
global g_decArgo_rsyncFloatWmoList;
global g_decArgo_rsyncFloatLoginNameList;
global g_decArgo_rsyncFloatSbdFileList;

% mode processing flags
global g_decArgo_realtimeFlag;
global g_decArgo_delayedModeFlag;

% processed data loaded flag
global g_decArgo_processedDataLoadedFlag;
g_decArgo_processedDataLoadedFlag = 0;

% report information structure
global g_decArgo_reportStruct;

% already processed rsync log information
global g_decArgo_floatWmoUnderProcessList;
global g_decArgo_rsyncLogFileUnderProcessList;

% generate nc flag
global g_decArgo_generateNcFlag;
g_decArgo_generateNcFlag = 0;

% array to store GPS data
global g_decArgo_gpsData;

% no sampled data mode
global g_decArgo_noDataFlag;
g_decArgo_noDataFlag = 0;

% array to store ko sensor states
global g_decArgo_koSensorState;
g_decArgo_koSensorState = [];

% configuration values
global g_decArgo_applyRtqc;


% global g_decArgo_nbBuffToProcess;
% g_decArgo_nbBuffToProcess = 5;


% verbose mode flag
VERBOSE_MODE_BUFF = 1;

% minimum duration of a subsurface period
global g_decArgo_minSubSurfaceCycleDuration;
MIN_SUB_CYCLE_DURATION_IN_DAYS = g_decArgo_minSubSurfaceCycleDuration/24;

% create the float directory
floatIriDirName = [g_decArgo_iridiumDataDirectory '/' a_floatLoginName '/'];
if ~(exist(floatIriDirName, 'dir') == 7)
   mkdir(floatIriDirName);
end

% create sub-directories:
% - a 'spool' directory used to select the SBD files that will be processed
% during the current session of the decoder
% - a 'buffer' directory used to gather the SBD files expected for a given cycle
% - a 'archive' directory used to store the processed SBD files
% - a 'archive_dm' directory used to store the DM processed SBD files
% - a 'mat' directory used to store information between sessions of the decoder
% (RT version only)
g_decArgo_spoolDirectory = [floatIriDirName 'spool/'];
if ~(exist(g_decArgo_spoolDirectory, 'dir') == 7)
   mkdir(g_decArgo_spoolDirectory);
end
g_decArgo_bufferDirectory = [floatIriDirName 'buffer/'];
if ~(exist(g_decArgo_bufferDirectory, 'dir') == 7)
   mkdir(g_decArgo_bufferDirectory);
end
g_decArgo_archiveDirectory = [floatIriDirName 'archive/'];
if ~(exist(g_decArgo_archiveDirectory, 'dir') == 7)
   mkdir(g_decArgo_archiveDirectory);
end
g_decArgo_archiveDmDirectory = [floatIriDirName 'archive_dm/'];
if ~(exist(g_decArgo_archiveDmDirectory, 'dir') == 7)
   mkdir(g_decArgo_archiveDmDirectory);
end
g_decArgo_tmpDirectory = [floatIriDirName 'mat/'];
if ~(exist(g_decArgo_tmpDirectory, 'dir') == 7)
   mkdir(g_decArgo_tmpDirectory);
end

% inits for output NetCDF file
decArgoConfParamNames = [];
ncConfParamNames = [];
if (isempty(g_decArgo_outputCsvFileId))
   g_decArgo_outputNcParamIndex = [];
   g_decArgo_outputNcParamValue = [];
   g_decArgo_outputNcParamLabelBis = [];
   
   if (g_decArgo_generateNcMeta ~= 0)
      % create the configuration parameter names for the META NetCDF file
      [decArgoConfParamNames, ncConfParamNames] = create_config_param_names_ir_rudics;
   end
   
   % in RT load the processed data stored in the temp directory of the float
   if (g_decArgo_realtimeFlag == 1)
      [o_tabProfiles, ...
         o_tabTrajNMeas, o_tabTrajNCycle, ...
         o_tabNcTechIndex, o_tabNcTechVal] = load_processed_data_ir_rudics_sbd2;
   end
end

% inits for output CSV file
if (~isempty(g_decArgo_outputCsvFileId))
   header = ['WMO #; Cycle #; Profil #; Phase; Info type'];
   fprintf(g_decArgo_outputCsvFileId, '%s\n', header);
   print_phase_help_ir_rudics;
end

% initialize float configuration
if (g_decArgo_processedDataLoadedFlag == 0)
   % initialize float parameter configuration
   init_float_config_ir_rudics(a_launchDate, a_decoderId);
end

% add launch position and time in the TRAJ NetCDF file
if (g_decArgo_processedDataLoadedFlag == 0)
   if (isempty(g_decArgo_outputCsvFileId) && (g_decArgo_generateNcTraj ~= 0))
      o_tabTrajNMeas = add_launch_data_ir_rudics;
   end
end

if (a_floatDmFlag == 0)
   
   if (g_decArgo_delayedModeFlag == 1)
      
      fprintf('WARNING: Float #%d is expected to be processed in Real Time Mode\n', ...
         a_floatNum);
      o_tabProfiles = [];
      o_tabTrajNMeas = [];
      o_tabTrajNCycle = [];
      o_tabNcTechIndex = [];
      o_tabNcTechVal = [];
      o_structConfig = [];
      return;
      
   else
      
      if (g_decArgo_realtimeFlag == 0)
         
         % move the SBD files associated with the a_cycleList cycles into the spool
         % directory
         for idCy = 1:length(a_cycleList)
            
            cycleNum = a_cycleList(idCy);
            sbdCyFiles = dir([g_decArgo_archiveDirectory '/' sprintf('*_%s_%05d.b*.sbd', ...
               a_floatLoginName, cycleNum)]);
            for idFile = 1:length(sbdCyFiles)
               
               sbdCyFileName = sbdCyFiles(idFile).name;
               
               cyIrJulD = datenum(sbdCyFileName(1:13), 'yymmdd_HHMMSS') - g_decArgo_janFirst1950InMatlab;
               
               if (cyIrJulD < a_launchDate)
                  fprintf('BUFF_WARNING: Float #%d: SBD file "%s" ignored because dated before float launch date (%s)\n', ...
                     g_decArgo_floatNum, ...
                     sbdCyFileName, julian_2_gregorian_dec_argo(a_launchDate));
                  continue
               end
               
               move_files_ir_rudics({sbdCyFileName}, g_decArgo_archiveDirectory, g_decArgo_spoolDirectory, 0);
            end
         end
         
      else
         
         % duplicate the SBD files colleted with rsync into the spool directory
         fileIdList = find(g_decArgo_rsyncFloatWmoList == a_floatNum);
         fprintf('RSYNC_INFO: Duplicating %d SBD files from rsync dir to float spool dir\n', ...
            length(fileIdList));
         for idF = 1:length(fileIdList)
            
            sbdFilePathName = [g_decArgo_dirInputRsyncData '/' ...
               g_decArgo_rsyncFloatSbdFileList{fileIdList(idF)}];
            
            [pathstr, sbdFileName, ext] = fileparts(sbdFilePathName);
            cyIrJulD = datenum(sbdFileName(1:13), 'yymmdd_HHMMSS') - g_decArgo_janFirst1950InMatlab;
            
            if (cyIrJulD < a_launchDate)
               fprintf('BUFF_WARNING: Float #%d: SBD file "%s" ignored because dated before float launch date (%s)\n', ...
                  g_decArgo_floatNum, ...
                  sbdFileName, julian_2_gregorian_dec_argo(a_launchDate));
               continue
            end
            
            copy_files_ir({[sbdFileName ext]}, pathstr, g_decArgo_spoolDirectory);
         end
         
         fprintf('RSYNC_INFO: duplication done ...\n');
      end
      
      % scan spool and buffer directories to create list of cycles to decode
      [floatCycleList, floatExcludedCycleList] = ...
         get_float_cycle_list(a_floatNum, a_floatLoginName);
      
      if ((g_decArgo_realtimeFlag == 1) || (g_decArgo_delayedModeFlag == 1) || ...
            (isempty(g_decArgo_outputCsvFileId) && (g_decArgo_applyRtqc == 1)))
         % initialize data structure to store report information
         g_decArgo_reportStruct = get_report_init_struct(a_floatNum, '');
      end
      
      % retrieve information on spool directory contents
      [tabAllFileNames, tabAllFileCycles, tabAllFileDates, tabAllFileSizes] = get_dir_files_info_ir_rudics( ...
         g_decArgo_spoolDirectory, a_floatLoginName, '');
      
      % initialize information arrays
      g_decArgo_0TypeReceivedData = [];
      g_decArgo_250TypeReceivedData = [];
      g_decArgo_253TypeReceivedData = [];
      
      % initialize file list
      tabNewFileNames = [];
      tabNewFileDates = [];
      tabNewFileSizes = [];

      % process the SBD files of the spool directory in chronological order
      for idSpoolFile = 1:length(tabAllFileNames)
         
         % move the next file into the buffer directory
         move_files_ir_rudics(tabAllFileNames(idSpoolFile), g_decArgo_spoolDirectory, g_decArgo_bufferDirectory, 0);
         
         % process the files of the buffer directory
         
         % retrieve information on the files in the buffer
         [tabFileNames, tabFileCycles, tabFileDates, tabFileSizes] = get_dir_files_info_ir_rudics( ...
            g_decArgo_bufferDirectory, a_floatLoginName, '');
         
         % create the 'old' and 'new' file lists
         % test 1
         %       idOld = find(tabFileDates < tabAllFileDates(idSpoolFile)-MIN_SUB_CYCLE_DURATION_IN_DAYS);
         idOld = [];
         if (~isempty(find(tabFileDates < tabAllFileDates(idSpoolFile)-MIN_SUB_CYCLE_DURATION_IN_DAYS, 1)))
            idOld = find((tabFileDates < tabFileDates(1)+MIN_SUB_CYCLE_DURATION_IN_DAYS) & ...
               tabFileCycles == tabFileCycles(1));
         end
         
         if (~isempty(idOld))
            
            tabOldFileNames = tabFileNames(idOld);
            tabOldFileDates = tabFileDates(idOld);
            tabOldFileSizes = tabFileSizes(idOld);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % process the 'old' files
            if (VERBOSE_MODE_BUFF == 1)
               for iFile = 1:length(tabOldFileNames)
                  fprintf('BUFF_WARNING: Float #%d: processing ''old'' file %s (#%d of the %d files in the set)\n', ...
                     g_decArgo_floatNum, ...
                     tabOldFileNames{iFile}, iFile, length(tabOldFileNames));
               end
            end
            
            [tabProfiles, ...
               tabTrajNMeas, tabTrajNCycle, ...
               tabNcTechIndex, tabNcTechVal] = ...
               decode_sbd_files( ...
               tabOldFileNames, tabOldFileDates, tabOldFileSizes, ...
               a_decoderId, a_launchDate, a_refDay, a_floatSoftVersion, a_floatDmFlag);
            
            if (~isempty(tabProfiles))
               o_tabProfiles = [o_tabProfiles tabProfiles];
            end
            if (~isempty(tabTrajNMeas))
               o_tabTrajNMeas = [o_tabTrajNMeas tabTrajNMeas];
            end
            if (~isempty(tabTrajNCycle))
               o_tabTrajNCycle = [o_tabTrajNCycle tabTrajNCycle];
            end
            if (~isempty(tabNcTechIndex))
               o_tabNcTechIndex = [o_tabNcTechIndex; tabNcTechIndex];
            end
            if (~isempty(tabNcTechVal))
               o_tabNcTechVal = [o_tabNcTechVal; tabNcTechVal'];
            end
            
            % move the processed 'old' files into the archive directory
            move_files_ir_rudics(tabOldFileNames, g_decArgo_bufferDirectory, g_decArgo_archiveDirectory, 1);
            
         end
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % check if the 'new' files can be processed
         
         % store the SBD data
         if (~isempty(idOld))
            
            % initialize information arrays
            g_decArgo_0TypeReceivedData = [];
            g_decArgo_250TypeReceivedData = [];
            g_decArgo_253TypeReceivedData = [];
            
            % create the 'new' file lists
            idNew = setdiff([1:length(tabFileNames)], idOld);
            tabNewFileNames = tabFileNames(idNew);
            tabNewFileDates = tabFileDates(idNew);
            tabNewFileSizes = tabFileSizes(idNew);

            fileNameList = tabNewFileNames;
            fileDateList = tabNewFileDates;
            fileSizeList = tabNewFileSizes;
         else
            
            % retrieve information on the new file in the buffer
            [fileNameList, ~, fileDateList, fileSizeList] = get_dir_files_info_ir_rudics( ...
               g_decArgo_bufferDirectory, '', tabAllFileNames{idSpoolFile});
            
            tabNewFileNames{end+1} = fileNameList{:};
            tabNewFileDates(end+1) = fileDateList;
            tabNewFileSizes(end+1) = fileSizeList;
         end
         
         % initialize SBD data
         sbdDataDate = [];
         sbdDataData = [];
         for idBufFile = 1:length(fileNameList)
            
            sbdFileName = fileNameList{idBufFile};
            sbdFilePathName = [g_decArgo_bufferDirectory '/' sbdFileName];
            sbdFileDate = fileDateList(idBufFile);
            sbdFileSize = fileSizeList(idBufFile);
            
            if (sbdFileSize > 0)
               
               if (rem(sbdFileSize, 140) == 0)
                  fId = fopen(sbdFilePathName, 'r');
                  if (fId == -1)
                     fprintf('ERROR: Float #%d: Error while opening file : %s\n', ...
                        g_decArgo_floatNum, ...
                        sbdFilePathName);
                  end
                  
                  [sbdData, sbdDataCount] = fread(fId);
                  
                  fclose(fId);
                  
                  sbdData = reshape(sbdData, 140, size(sbdData, 1)/140)';
                  for idMsg = 1:size(sbdData, 1)
                     data = sbdData(idMsg, :);
                     if ~((isempty(find(data ~= 0, 1)) || isempty(find(data ~= 26, 1))))
                        sbdDataData = [sbdDataData; data];
                        sbdDataDate = [sbdDataDate; sbdFileDate];
                     end
                  end
               else
                  fprintf('DEC_WARNING: Float #%d: SBD file ignored because of unexpected size (%d bytes)  : %s\n', ...
                     g_decArgo_floatNum, ...
                     sbdFileSize, ...
                     sbdFilePathName);
               end
               
            end
         end
         
         % roughly check the received data
         if (~isempty(sbdDataData))
            
            switch (a_decoderId)
               
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               
               case {105, 106, 107, 108, 109} % Remocean A
                  
                  % decode transmitted data
                  [cyProfPhaseList, ...
                     dataCTD, dataOXY, dataOCR, ...
                     dataECO3, dataFLNTU, ...
                     dataCROVER, dataSUNA, ...
                     sensorTechCTD, sensorTechOPTODE, ...
                     sensorTechOCR, sensorTechECO3, ...
                     sensorTechFLNTU, sensorTechCROVER, sensorTechSUNA, ...
                     sensorParam, ...
                     floatPres, ...
                     tabTech, floatProgTech, floatProgParam] = ...
                     decode_prv_data_ir_rudics(sbdDataData, sbdDataDate, 0);
                  
               otherwise
                  fprintf('WARNING: Float #%d: Nothing implemented yet for decoderId #%d\n', ...
                     g_decArgo_floatNum, ...
                     a_decoderId);
            end
            
            % check if the buffer contents can be processed
            [okToProcess, cycleProfToProcess] = is_buffer_completed_ir_rudics;
            
            %             if (okToProcess == 1)
            %                g_decArgo_nbBuffToProcess = g_decArgo_nbBuffToProcess - 1;
            %                if (g_decArgo_nbBuffToProcess < 0)
            %                   return;
            %                end
            %             end
            
            if ((okToProcess == 1) || ...
                  ((idSpoolFile == length(tabAllFileDates) && (g_decArgo_realtimeFlag == 0))))
               
               % process the 'new' files
               if (VERBOSE_MODE_BUFF == 1)
                  if ((okToProcess == 1) || (idSpoolFile < length(tabAllFileDates)))
                     fprintf('BUFF_INFO: Float #%d: Processing %d SBD files:\n', ...
                        g_decArgo_floatNum, ...
                        length(tabNewFileNames));
                  else
                     fprintf('BUFF_INFO: Float #%d: Last step => processing buffer contents, %d SBD files\n', ...
                        g_decArgo_floatNum, ...
                        length(tabNewFileNames));
                  end
                  for idM = 1:size(cycleProfToProcess, 1)
                     cycle = cycleProfToProcess(idM, 1);
                     profile = cycleProfToProcess(idM, 2);
                     fprintf('BUFF_INFO:    -> Float #%d: Processing cycle #%d profile #%d\n', ...
                        g_decArgo_floatNum, ...
                        cycle, profile);
                  end
               end
               
               [tabProfiles, ...
                  tabTrajNMeas, tabTrajNCycle, ...
                  tabNcTechIndex, tabNcTechVal] = ...
                  decode_sbd_files( ...
                  tabNewFileNames, tabNewFileDates, tabNewFileSizes, ...
                  a_decoderId, a_launchDate, a_refDay, a_floatSoftVersion, a_floatDmFlag);
               
               if (~isempty(tabProfiles))
                  o_tabProfiles = [o_tabProfiles tabProfiles];
               end
               if (~isempty(tabTrajNMeas))
                  o_tabTrajNMeas = [o_tabTrajNMeas tabTrajNMeas];
               end
               if (~isempty(tabTrajNCycle))
                  o_tabTrajNCycle = [o_tabTrajNCycle tabTrajNCycle];
               end
               if (~isempty(tabNcTechIndex))
                  o_tabNcTechIndex = [o_tabNcTechIndex; tabNcTechIndex];
               end
               if (~isempty(tabNcTechVal))
                  o_tabNcTechVal = [o_tabNcTechVal; tabNcTechVal'];
               end
               
               % move the processed 'new' files into the archive directory
               move_files_ir_rudics(tabNewFileNames, g_decArgo_bufferDirectory, g_decArgo_archiveDirectory, 1);
               
               % initialize information arrays
               g_decArgo_0TypeReceivedData = [];
               g_decArgo_250TypeReceivedData = [];
               g_decArgo_253TypeReceivedData = [];
               
               % initialize file list
               tabNewFileNames = [];
               tabNewFileDates = [];
               tabNewFileSizes = [];
            end
            
         end
      end
   end
else
   
   % this float must be processed in DM
   
   if (g_decArgo_realtimeFlag == 1)
      
      fprintf('WARNING: Float #%d is expected to be processed in Delayed Mode\n', ...
         a_floatNum);
      o_tabProfiles = [];
      o_tabTrajNMeas = [];
      o_tabTrajNCycle = [];
      o_tabNcTechIndex = [];
      o_tabNcTechVal = [];
      o_structConfig = [];
      return;
      
   else
      
      fprintf('INFO: Float #%d processed in Delayed Mode\n', ...
         a_floatNum);
      
      if (g_decArgo_delayedModeFlag == 1)
         
         sbdFiles = dir([g_decArgo_archiveDirectory '/' sprintf('*_%s_*.b*.sbd', ...
            a_floatLoginName)]);
         
         if (isempty(sbdFiles))
            
            % duplicate the SBD files colleted with rsync into the archive directory
            fileIdList = find(g_decArgo_rsyncFloatWmoList == a_floatNum);
            fprintf('RSYNC_INFO: Duplicating %d SBD files from rsync dir to float archive dir\n', ...
               length(fileIdList));
            for idF = 1:length(fileIdList)
               
               sbdFilePathName = [g_decArgo_dirInputRsyncData '/' ...
                  g_decArgo_rsyncFloatSbdFileList{fileIdList(idF)}];
               
               [pathstr, sbdFileName, ext] = fileparts(sbdFilePathName);
               
               copy_files_ir({[sbdFileName ext]}, pathstr, g_decArgo_archiveDirectory);
            end
            
            fprintf('RSYNC_INFO: duplication done ...\n');
            
            % split archive directory sbd files
            split_rudics_sbd_files(g_decArgo_archiveDirectory, g_decArgo_archiveDmDirectory)
         end
      else
         
         sbdFiles = dir([g_decArgo_archiveDmDirectory '/' sprintf('%s_*.sbd', ...
            a_floatLoginName)]);
         
         if (isempty(sbdFiles))
            
            % split archive directory sbd files
            split_rudics_sbd_files(g_decArgo_archiveDirectory, g_decArgo_archiveDmDirectory)
         end
      end
      
      % read the buffer list file
      [sbdFileNameList, sbdFileRank, sbdFileDate, sbdFileCyNum, sbdFileProfNum] = ...
         read_buffer_list(a_floatNum, g_decArgo_archiveDmDirectory);
      
      if (isempty(sbdFileNameList))
         
         [sbdFileNameList, sbdFileRank, sbdFileDate, sbdFileCyNum, sbdFileProfNum] = ...
            create_buffers(g_decArgo_archiveDmDirectory, a_launchDate, g_decArgo_dateDef, '', '');
      end
      
      if ((g_decArgo_realtimeFlag == 1) || (g_decArgo_delayedModeFlag == 1) || ...
            (isempty(g_decArgo_outputCsvFileId) && (g_decArgo_applyRtqc == 1)))
         % initialize data structure to store report information
         g_decArgo_reportStruct = get_report_init_struct(a_floatNum, '');
      end
      
      uRank = sort(unique(sbdFileRank));
      uRank = uRank(find(uRank > 0));
      for idRk = 1:length(uRank)
         rankNum = uRank(idRk);
         idFile = find(sbdFileRank == rankNum);
         
         fprintf('BUFFER #%d: processing %d sbd files\n', rankNum, length(idFile));
         
         cyNum = sbdFileCyNum(idFile);
         profNum = sbdFileProfNum(idFile);
         idDel = find(cyNum == -1);
         cyNum(idDel) = [];
         profNum(idDel) = [];
         cyProfNum = [cyNum' profNum'];
         uCyProfNum = unique(cyProfNum, 'rows');
         for id = 1:size(uCyProfNum, 1)
            cy = uCyProfNum(id, 1);
            prof = uCyProfNum(id, 2);
            fprintf('   -> Float #%d: Processing cycle #%d profile #%d\n', ...
               g_decArgo_floatNum, ...
               cy, prof);
         end
         
         [tabProfiles, ...
            tabTrajNMeas, tabTrajNCycle, ...
            tabNcTechIndex, tabNcTechVal] = ...
            decode_sbd_files( ...
            sbdFileNameList(idFile), sbdFileDate(idFile), sbdFileCyNum(idFile), ...
            a_decoderId, a_launchDate, a_refDay, a_floatSoftVersion, a_floatDmFlag);
         
         %          g_decArgo_nbBuffToProcess = g_decArgo_nbBuffToProcess - 1;
         %          if (g_decArgo_nbBuffToProcess < 0)
         %             return;
         %          end
         
         if (~isempty(tabProfiles))
            o_tabProfiles = [o_tabProfiles tabProfiles];
         end
         if (~isempty(tabTrajNMeas))
            o_tabTrajNMeas = [o_tabTrajNMeas tabTrajNMeas];
         end
         if (~isempty(tabTrajNCycle))
            o_tabTrajNCycle = [o_tabTrajNCycle tabTrajNCycle];
         end
         if (~isempty(tabNcTechIndex))
            o_tabNcTechIndex = [o_tabNcTechIndex; tabNcTechIndex];
         end
         if (~isempty(tabNcTechVal))
            o_tabNcTechVal = [o_tabNcTechVal; tabNcTechVal'];
         end
         
      end
   end
end

if (isempty(g_decArgo_outputCsvFileId))
   
   % output NetCDF files
   
   % assign second Iridium session to end of previous cycle and merge first/last
   % msg and location times
   if (isempty(g_decArgo_outputCsvFileId) && (g_decArgo_generateNcTraj ~= 0))
      [o_tabTrajNMeas, o_tabTrajNCycle] = merge_first_last_msg_time_ir_rudics_sbd2( ...
         o_tabTrajNMeas, o_tabTrajNCycle);
   end
   
   % add interpolated profile locations
   [o_tabProfiles] = fill_empty_profile_locations_ir_rudics(o_tabProfiles, g_decArgo_gpsData, ...
      o_tabTrajNMeas, o_tabTrajNCycle);
   
   % cut CTD profile at the cut-off pressure of the CTD pump
   [o_tabProfiles] = cut_ctd_profile_ir_rudics(o_tabProfiles);
   
   % create output float configuration
   [o_structConfig] = create_output_float_config_ir_rudics(decArgoConfParamNames, ncConfParamNames);
   
   % add configuration number and output cycle number
   [o_tabProfiles, o_tabTrajNMeas, o_tabTrajNCycle] = add_configuration_number_ir_rudics_sbd2( ...
      o_tabProfiles, o_tabTrajNMeas, o_tabTrajNCycle);
   
   % set QC parameters to '3' when the sensor state is ko
   [o_tabProfiles, o_tabTrajNMeas] = update_qc_from_sensor_state_ir_rudics_sbd2( ...
      o_tabProfiles, o_tabTrajNMeas);
   
   % set JULD_QC and POSITION_QC to '3' when the profile has been created after
   % a buffer anomaly (more than one profile for a given profile number)
   [o_tabProfiles] = check_profile_ir_rudics_sbd2(o_tabProfiles);
   
   if (g_decArgo_realtimeFlag == 1)
      
      % in RT save the processed data in the temp directory of the float
      save_processed_data_ir_rudics_sbd2(o_tabProfiles, ...
         o_tabTrajNMeas, o_tabTrajNCycle, ...
         o_tabNcTechIndex, o_tabNcTechVal);
      
      % in RT save the list of already processed rsync lo files in the temp
      % directory of the float
      idEq = find(g_decArgo_floatWmoUnderProcessList == a_floatNum);
      write_processed_rsync_log_file_ir_rudics_sbd_sbd2(a_floatNum, ...
         g_decArgo_rsyncLogFileUnderProcessList{idEq});
   end
   
   % update NetCDF technical data (add a column to store output cycle numbers)
   o_tabNcTechIndex = update_technical_data_iridium_rudics_sbd2(o_tabNcTechIndex);
end

return;

% ------------------------------------------------------------------------------
% Decode one set of RUDICS SBD files.
%
% SYNTAX :
%  [o_tabProfiles, ...
%    o_tabTrajNMeas, o_tabTrajNCycle, ...
%    o_tabNcTechIndex, o_tabNcTechVal] = ...
%    decode_sbd_files( ...
%    a_sbdFileNameList, a_sbdFileDateList, a_sbdFileSizeList, ...
%    a_decoderId, a_launchDate, a_refDay, a_floatSoftVersion, a_floatDmFlag)
%
% INPUT PARAMETERS :
%   a_sbdFileNameList  : list of SBD file names
%   a_sbdFileNameList  : list of SBD file dates
%   a_sbdFileNameList  : list of SBD file sizes
%   a_decoderId        : float decoder Id
%   a_launchDate       : launch date
%   a_refDay           : reference day (day of the first descent)
%   a_floatSoftVersion : version of the float's software
%   a_floatDmFlag      : float DM flag
%
% OUTPUT PARAMETERS :
%   o_tabProfiles        : decoded profiles
%   o_tabTrajNMeas       : decoded trajectory N_MEASUREMENT data
%   o_tabTrajNCycle      : decoded trajectory N_CYCLE data
%   o_tabNcTechIndex     : decoded technical index information
%   o_tabNcTechVal       : decoded technical data
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   02/25/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_tabProfiles, ...
   o_tabTrajNMeas, o_tabTrajNCycle, ...
   o_tabNcTechIndex, o_tabNcTechVal] = ...
   decode_sbd_files( ...
   a_sbdFileNameList, a_sbdFileDateList, a_sbdFileSizeList, ...
   a_decoderId, a_launchDate, a_refDay, a_floatSoftVersion, a_floatDmFlag)

% output parameters initialization
o_tabProfiles = [];
o_tabTrajNMeas = [];
o_tabTrajNCycle = [];
o_tabNcTechIndex = [];
o_tabNcTechVal = [];

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% output CSV file Id
global g_decArgo_outputCsvFileId;

% output NetCDF technical parameter index information
global g_decArgo_outputNcParamIndex;

% output NetCDF technical parameter values
global g_decArgo_outputNcParamValue;

% output NetCDF technical parameter names additional information
global g_decArgo_outputNcParamLabelInfo;

% SBD sub-directories
global g_decArgo_bufferDirectory;

% array to store GPS data
global g_decArgo_gpsData;

% generate nc flag
global g_decArgo_generateNcFlag;
g_decArgo_generateNcFlag = 1;


if (a_floatDmFlag == 1)
   sbdFileCycleNum = a_sbdFileSizeList;
   a_sbdFileSizeList = ones(1, length(sbdFileCycleNum))*140;
else
   % extract the cycle numbers of the SBD files
   [sbdFileCycleNum] = get_cycle_num_from_sbd_name_ir_rudics(a_sbdFileNameList);
end

% processed file flags
sbdFileProcessed = zeros(length(a_sbdFileNameList), 1);

% process the files of the list
procDone = 0;
while (procDone == 0)
   
   idToProcess = find(sbdFileProcessed == 0);
   if (~isempty(idToProcess))
      
      % process all the files of a given cycle
      cycleNum = sbdFileCycleNum(idToProcess(1));
      g_decArgo_cycleNum = cycleNum;
      
      idCyFiles = find(sbdFileCycleNum(idToProcess) == cycleNum);
      sbdCyFileNameList = a_sbdFileNameList(idToProcess(idCyFiles));
      sbdCyFileDateList = a_sbdFileDateList(idToProcess(idCyFiles));
      sbdCyFileSizeList = a_sbdFileSizeList(idToProcess(idCyFiles));
      
      sbdFileProcessed(idToProcess(idCyFiles)) = 1;
      
      % read the SBD file data
      sbdDataDate = [];
      sbdDataData = [];
      sbdDataFileName = [];
      sbdDataFileDate = [];
      sbdDataFileSize = [];
      for idFile = 1:length(sbdCyFileNameList)
         
         sbdCyFileName = sbdCyFileNameList{idFile};
         if (a_floatDmFlag == 1)
            sbdCyFilePathName = sbdCyFileName;
         else
            sbdCyFilePathName = [g_decArgo_bufferDirectory '/' sbdCyFileName];
         end
         sbdCyFileDate = sbdCyFileDateList(idFile);
         sbdCyFileSize = sbdCyFileSizeList(idFile);
         
         sbdDataFileName = [sbdDataFileName; {sbdCyFileName}];
         sbdDataFileDate = [sbdDataFileDate; sbdCyFileDate];
         sbdDataFileSize = [sbdDataFileSize; sbdCyFileSize];
         
         if (sbdCyFileSize > 0)
            
            if (rem(sbdCyFileSize, 140) == 0)
               fId = fopen(sbdCyFilePathName, 'r');
               if (fId == -1)
                  fprintf('ERROR: Float #%d: Error while opening file : %s\n', ...
                     g_decArgo_floatNum, ...
                     sbdCyFilePathName);
               end
               
               [sbdData, sbdDataCount] = fread(fId);
               
               fclose(fId);
               
               sbdData = reshape(sbdData, 140, size(sbdData, 1)/140)';
               for idMsg = 1:size(sbdData, 1)
                  data = sbdData(idMsg, :);
                  if ~((isempty(find(data ~= 0, 1)) || isempty(find(data ~= 26, 1))))
                     sbdDataData = [sbdDataData; data];
                     sbdDataDate = [sbdDataDate; sbdCyFileDate];
                  end
               end
            else
               fprintf('DEC_WARNING: Float #%d: SBD file ignored because of unexpected size (%d bytes)  : %s\n', ...
                  g_decArgo_floatNum, ...
                  sbdCyFileSize, ...
                  sbdCyFilePathName);
            end
            
         end
      end
      
      % output CSV file
      if (~isempty(g_decArgo_outputCsvFileId))
         for idFile = 1:length(sbdDataFileName)
            fprintf(g_decArgo_outputCsvFileId, '%d; %d; -; %s; info SBD file; File #%03d:   %s; Size: %d bytes; Nb Packets: %d\n', ...
               g_decArgo_floatNum, g_decArgo_cycleNum, get_phase_name(-1), ...
               idFile, sbdDataFileName{idFile}, ...
               sbdDataFileSize(idFile), sbdDataFileSize(idFile)/140);
         end
      end
      
      % decode the data
      
      switch (a_decoderId)
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
         case {105, 106, 107, 108, 109} % Remocean A
            
            % decode sensor data and associated technical data (0, 250, 252 and
            % 253 msg types)
            [cyProfPhaseList, ...
               dataCTD, dataOXY, dataOCR, ...
               dataECO3, dataFLNTU, ...
               dataCROVER, dataSUNA, ...
               sensorTechCTD, sensorTechOPTODE, ...
               sensorTechOCR, sensorTechECO3, ...
               sensorTechFLNTU, sensorTechCROVER, sensorTechSUNA, ...
               sensorParamEmpty, ...
               floatPres, ...
               tabTech, floatProgTechEmpty, floatProgParamEmpty] = ...
               decode_prv_data_ir_rudics(sbdDataData, sbdDataDate, 1);
            
            % assign the current configuration to the decoded cycles and
            % profiles
            set_float_config_ir_rudics(cyProfPhaseList, a_floatSoftVersion);
            
            % keep only new GPS locations (acquired during a surface phase)
            [tabTech] = clean_gps_data_ir_rudics_sbd2(tabTech);
            
            % store GPS data
            store_gps_data_ir_rudics_sbd2(tabTech);
            
            % add dates to drift measurements
            [dataCTD, dataOXY, dataOCR, ...
               dataECO3, dataFLNTU, ...
               dataCROVER, dataSUNA] = ...
               add_drift_meas_dates_ir_rudics(dataCTD, dataOXY, dataOCR, ...
               dataECO3, dataFLNTU, ...
               dataCROVER, dataSUNA);
            
            % set drift of float RTC
            floatClockDrift = 0;
            
            % compute the main dates of the cycle
            [cycleStartDate, buoyancyRedStartDate, ...
               descentToParkStartDate, ...
               firstStabDate, firstStabPres, ...
               descentToParkEndDate, ...
               descentToProfStartDate, descentToProfEndDate, ...
               ascentStartDate, ascentEndDate, ...
               transStartDate, ...
               firstEmerAscentDate] = ...
               compute_prv_dates_ir_rudics_sbd2(tabTech, ...
               floatClockDrift, a_refDay);
            
            % decode configuration data (251, 254 and 255 msg types)
            [cyProfPhaseListConfig, ...
               dataCTDEmpty, dataOXYEmpty, dataOCREmpty, ...
               dataECO3Empty, dataFLNTUEmpty, ...
               dataCROVEREmpty, dataSUNAEmpty, ...
               sensorTechCTDEmpty, sensorTechOPTODEEmpty, ...
               sensorTechOCREmpty, sensorTechECO3Empty, ...
               sensorTechFLNTUEmpty, sensorTechCROVEREmpty, sensorTechSUNAEmpty, ...
               sensorParam, ...
               floatPresEmpty, ...
               tabTechEmpty, floatProgTech, floatProgParam] = ...
               decode_prv_data_ir_rudics(sbdDataData, sbdDataDate, 2);
            
            cyProfPhaseList = [cyProfPhaseList; cyProfPhaseListConfig];
            
            if (~isempty(g_decArgo_outputCsvFileId))
               
               % output CSV file
               
               % print decoded data in CSV file
               print_info_in_csv_file_ir_rudics( ...
                  a_decoderId, ...
                  cyProfPhaseList, ...
                  dataCTD, dataOXY, dataOCR, dataECO3, dataFLNTU, ...
                  dataCROVER, dataSUNA, ...
                  sensorTechCTD, sensorTechOPTODE, ...
                  sensorTechOCR, sensorTechECO3, ...
                  sensorTechFLNTU, sensorTechCROVER, sensorTechSUNA, ...
                  sensorParam, ...
                  floatPres, ...
                  tabTech, floatProgTech, floatProgParam);
               
               % print dated data in CSV file
               if (~isempty(tabTech))
                  print_dates_in_csv_file_ir_rudics( ...
                     cycleStartDate, buoyancyRedStartDate, ...
                     descentToParkStartDate, ...
                     firstStabDate, firstStabPres, ...
                     descentToParkEndDate, ...
                     descentToProfStartDate, descentToProfEndDate, ...
                     ascentStartDate, ascentEndDate, ...
                     transStartDate, ...
                     dataCTD, dataOXY, dataOCR, dataECO3, dataFLNTU, ...
                     dataCROVER, dataSUNA, ...
                     g_decArgo_gpsData);
               end
            else
            
               % output NetCDF files
               
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               % PROF NetCDF file
               
               % process profile data for PROF NetCDF file
               [tabProfiles, tabDrift] = process_profiles_ir_rudics( ...
                  a_decoderId, ...
                  cyProfPhaseList, ...
                  dataCTD, dataOXY, dataOCR, dataECO3, ...
                  dataFLNTU, dataCROVER, dataSUNA, ...
                  descentToParkStartDate, ascentEndDate, ...
                  g_decArgo_gpsData, ...
                  sensorTechCTD, sensorTechOPTODE, ...
                  sensorTechOCR, sensorTechECO3, ...
                  sensorTechFLNTU, sensorTechCROVER, sensorTechSUNA);
               
               % add the vertical sampling scheme from configuration
               % information
               [tabProfiles] = add_vertical_sampling_scheme_ir_rudics(tabProfiles);
               
               % merge profile measurements (raw and averaged measurements of
               % a given profile)
               [tabProfiles] = merge_profile_meas_ir_rudics_sbd2(tabProfiles);
               
               % compute derived parameters of the profiles
               [tabProfiles] = compute_profile_derived_parameters_ir_rudics(tabProfiles, a_decoderId);
               
               print = 0;
               if (print == 1)
                  if (~isempty(tabProfiles))
                     fprintf('DEC_INFO: Float #%d Cycle #%d: %d profiles for NetCDF file\n', ...
                        g_decArgo_floatNum, g_decArgo_cycleNum, length(tabProfiles));
                     for idP = 1:length(tabProfiles)
                        prof = tabProfiles(idP);
                        paramList = prof.paramList;
                        paramList = sprintf('%s ', paramList.name);
                        profLength = size(prof.data, 1);
                        fprintf('   ->%2d: Profile #%d dir=%c length=%d param=(%s)\n', ...
                           idP, prof.profileNumber, prof.direction, ...
                           profLength, paramList(1:end-1));
                     end
                  else
                     fprintf('DEC_INFO: Float #%d Cycle #%d: No profiles for NetCDF file\n', ...
                        g_decArgo_floatNum, g_decArgo_cycleNum);
                  end
               end
               
               o_tabProfiles = [o_tabProfiles tabProfiles];
               
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               % TRAJ NetCDF file
               
               % merge drift measurements (raw and averaged measurements of
               % the park phase)
               [tabDrift] = merge_profile_meas_ir_rudics_sbd2(tabDrift);
               
               % compute derived parameters of the park phase
               [tabDrift] = compute_drift_derived_parameters_ir_rudics(tabDrift, a_decoderId);
               
               % collect trajectory data for TRAJ NetCDF file
               [tabTrajIndex, tabTrajData] = collect_trajectory_data_ir_rudics_sbd2(a_decoderId, ...
                  tabProfiles, tabDrift, ...
                  floatProgTech, floatProgParam, ...
                  floatPres, tabTech, a_refDay, ...
                  cycleStartDate, buoyancyRedStartDate, ...
                  descentToParkStartDate, ...
                  descentToParkEndDate, ...
                  descentToProfStartDate, descentToProfEndDate, ...
                  ascentStartDate, ascentEndDate, ...
                  firstEmerAscentDate, ...
                  sensorTechCTD);
               
               % process trajectory data for TRAJ NetCDF file
               [tabTrajNMeas, tabTrajNCycle] = process_trajectory_data_ir_rudics_sbd2( ...
                  cyProfPhaseList, tabTrajIndex, tabTrajData);
               
               o_tabTrajNMeas = [o_tabTrajNMeas tabTrajNMeas];
               o_tabTrajNCycle = [o_tabTrajNCycle tabTrajNCycle];
               
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               % TECH NetCDF file
               
               % process technical data for TECH NetCDF file
               process_technical_data_ir_rudics( ...
                  a_decoderId, cyProfPhaseList, ...
                  sensorTechCTD, sensorTechOPTODE, ...
                  sensorTechOCR, sensorTechECO3, ...
                  sensorTechFLNTU, sensorTechCROVER, sensorTechSUNA, ...
                  floatPres, ...
                  tabTech, a_refDay, ...
                  cycleStartDate, buoyancyRedStartDate, ...
                  descentToParkStartDate, ...
                  descentToParkEndDate, ...
                  descentToProfStartDate, descentToProfEndDate, ...
                  ascentStartDate, ascentEndDate);
               
               % filter useless technical data
               filter_technical_data_ir_rudics_sbd2;
               
               if (~isempty(g_decArgo_outputNcParamIndex))
                  o_tabNcTechIndex = [o_tabNcTechIndex; g_decArgo_outputNcParamIndex];
                  o_tabNcTechVal = [o_tabNcTechVal g_decArgo_outputNcParamValue];
               end
               
               g_decArgo_outputNcParamIndex = [];
               g_decArgo_outputNcParamValue = [];
                  
            end
            
         otherwise
            fprintf('WARNING: Float #%d: Nothing implemented yet for decoderId #%d\n', ...
               g_decArgo_floatNum, ...
               a_decoderId);
      end
      
   else
      procDone = 1;
   end
end

return;

% TEMP START
% study SBD file times and size

% tabSbdFileName = [];
% tabSbdFileDate = [];
% tabSbdFileSize = [];
% tabSbdFileCycle = [];
% floatIriDirName = [g_decArgo_iridiumDataDirectory '/' a_floatLoginName '/'];
% sbdFiles = dir([floatIriDirName '/' sprintf('*_%s_*.b64.sbd', ...
%    a_floatLoginName)]);
% for idFile = 1:length(sbdFiles)
%
%    sbdFileName = sbdFiles(idFile).name;
%    sbdFileDate = datenum(sbdFileName(1:13), 'yymmdd_HHMMSS') - g_decArgo_janFirst1950InMatlab;
%    sbdFileSize = sbdFiles(idFile).bytes;
%
%    if (sbdFileDate < a_launchDate)
%       fprintf('WARNING: Float #%d: SBD file "%s" ignored because dated before float launch date (%s)\n', ...
%          g_decArgo_floatNum, ...
%          sbdFileName, julian_2_gregorian_dec_argo(a_launchDate));
%       continue
%    end
%
%    cycleNum = -1;
%    pos = strfind(sbdFileName, '_');
%    [id, count, errmsg, nextIndex] = sscanf(sbdFileName(pos(end)+1:end), '%d.b64.sbd');
%    if (isempty(errmsg))
%       cycleNum = id(1);
%    end
%
%    tabSbdFileName{end+1} = sbdFiles(idFile).name;
%    tabSbdFileDate(end+1) = sbdFileDate;
%    tabSbdFileSize(end+1) = sbdFileSize;
%    tabSbdFileCycle(end+1) = cycleNum;
% end
%
% % surface times
% tabSbdDiffDate = ones(length(tabSbdFileDate), 1)*-1;
% tabSbdDiffDate(2:end) = diff(tabSbdFileDate);
%
% tabSbdSurfTime = ones(length(tabSbdFileDate), 1)*-1;
% MIN_DEEP_CYCLE_DURATION_IN_HOUR = 2;
% idDeep = find(tabSbdDiffDate > MIN_DEEP_CYCLE_DURATION_IN_HOUR/24);
% if (~isempty(idDeep))
%    idStart = idDeep(1) + 1;
%    for id = 2:length(idDeep)
%       idStop = idDeep(id) - 1;
%       tabSbdSurfTime(idStop) = sum(tabSbdDiffDate(idStart:idStop));
%       idStart = idStop + 2;
%    end
% end
%
% % configuration values
% global g_decArgo_dirOutputCsvFile;
%
% % output CSV file creation
% outputFileName = [g_decArgo_dirOutputCsvFile '/provor_sbd_period_' num2str(a_floatNum) '_' datestr(now, 'yyyymmddTHHMMSS') '.csv'];
% fidOut = fopen(outputFileName, 'wt');
% if (fidOut == -1)
%    fprintf('ERROR: Unable to create CSV output file: %s\n', outputFileName);
%    return;
% end
%
% header = ['WMO #; Cycle #; Sbd file name; Sbd file date; Diff date; Surf time; Sbd file size (bytes); Sbd files nb packets'];
% fprintf(fidOut, '%s\n', header);
%
% for id = 1:length(tabSbdFileDate)
%    fprintf(fidOut, '%d; %d; %s; %s', ...
%       g_decArgo_floatNum, ...
%       tabSbdFileCycle(id), ...
%       char(tabSbdFileName(id)), ...
%       julian_2_gregorian_dec_argo(tabSbdFileDate(id)));
%    if (tabSbdDiffDate(id) ~= -1)
%       fprintf(fidOut, '; %s', ...
%          format_time_dec_argo(tabSbdDiffDate(id)*24));
%    else
%       fprintf(fidOut, ';');
%    end
%    if (tabSbdSurfTime(id) ~= -1)
%       fprintf(fidOut, '; %s', ...
%          format_time_dec_argo(tabSbdSurfTime(id)*24));
%    else
%       fprintf(fidOut, ';');
%    end
%    fprintf(fidOut, '; %d; %d\n', ...
%       tabSbdFileSize(id), tabSbdFileSize(id)/140);
% end
%
% fclose(fidOut);
%
% return;

% TEMP STOP

