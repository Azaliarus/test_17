% ------------------------------------------------------------------------------
% Create configuration from JSON information and from decoded configuration
% information.
%
% SYNTAX :
%  create_float_config_apx_argos(a_decMetaData, a_decoderId)
%
% INPUT PARAMETERS :
%    a_decMetaData : decoded configuration information
%    a_decoderId   : float decoder Id
%
% OUTPUT PARAMETERS :.
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   09/22/2015 - RNU - creation
% ------------------------------------------------------------------------------
function create_float_config_apx_argos(a_decMetaData, a_decoderId)

% current float WMO number
global g_decArgo_floatNum;

% directory of json meta-data files
global g_decArgo_dirInputJsonFloatMetaDataFile;

% structure to store miscellaneous meta-data
global g_decArgo_jsonMetaData;
g_decArgo_jsonMetaData = [];

% float configuration
global g_decArgo_floatConfig;

% configuration creation flag
global g_decArgo_configDone;

% output CSV file Id
global g_decArgo_outputCsvFileId;

% configuration values
global g_decArgo_dirOutputCsvFile;

% file to store BDD update
global g_decArgo_bddUpdateCsvFileName;
global g_decArgo_bddUpdateCsvFileId;

% cycle timings storage
global g_decArgo_timeData;

% mode processing flags
global g_decArgo_realtimeFlag;


if (~isempty(g_decArgo_outputCsvFileId))
   VERBOSE = 1;
else
   VERBOSE = 0;
end
ONLY_DIFF = 0;

% json meta-data file for this float
jsonInputFileName = [g_decArgo_dirInputJsonFloatMetaDataFile '/' sprintf('%d_meta.json', g_decArgo_floatNum)];

if ~(exist(jsonInputFileName, 'file') == 2)
   g_decArgo_calibInfo = [];
   fprintf('ERROR: Json meta-data file not found: %s\n', jsonInputFileName);
   return;
end

% read meta-data file
jsonMetaData = loadjson(jsonInputFileName);

if (g_decArgo_realtimeFlag == 0)
   
   if (~isempty(a_decMetaData))
      
      % check meta-data consistency
      idMeta = find([a_decMetaData.metaFlag] == 1);
      for idM = 1:length(idMeta)
         dataStruct = a_decMetaData(idMeta(idM));
         if (isfield(jsonMetaData, dataStruct.metaConfigLabel))
            if (~strcmp(dataStruct.metaConfigLabel, 'SENSOR_SERIAL_NO'))
               if (~strcmp(jsonMetaData.(dataStruct.metaConfigLabel), dataStruct.techParamValue))
                  if (VERBOSE == 1)
                     if (g_decArgo_bddUpdateCsvFileId == -1)
                        % output CSV file creation
                        g_decArgo_bddUpdateCsvFileName = [g_decArgo_dirOutputCsvFile '/data_to_update_bdd_' datestr(now, 'yyyymmddTHHMMSS') '.csv'];
                        g_decArgo_bddUpdateCsvFileId = fopen(g_decArgo_bddUpdateCsvFileName, 'wt');
                        if (g_decArgo_bddUpdateCsvFileId == -1)
                           fprintf('ERROR: Unable to create CSV output file: %s\n', g_decArgo_bddUpdateCsvFileName);
                           return;
                        end
                        
                        header = 'PLATFORM_CODE;TECH_PARAMETER_ID;DIM_LEVEL;CORIOLIS_TECH_METADATA.PARAMETER_VALUE;TECH_PARAMETER_CODE';
                        fprintf(g_decArgo_bddUpdateCsvFileId, '%s\n', header);
                     end
                     
                     if (strcmp(dataStruct.techParamCode, 'STARTUP_DATE'))
                        fprintf(g_decArgo_bddUpdateCsvFileId, '%d;%d;%d; %s;%s\n', ...
                           g_decArgo_floatNum, ...
                           dataStruct.techParamId, 1, dataStruct.techParamValue, dataStruct.techParamCode);
                     elseif (strcmp(dataStruct.techParamCode, 'FIRMWARE_VERSION'))
                        fprintf(g_decArgo_bddUpdateCsvFileId, '%d;%d;%d;''%s;%s\n', ...
                           g_decArgo_floatNum, ...
                           dataStruct.techParamId, 1, dataStruct.techParamValue, dataStruct.techParamCode);
                     else
                        fprintf(g_decArgo_bddUpdateCsvFileId, '%d;%d;%d;%s;%s\n', ...
                           g_decArgo_floatNum, ...
                           dataStruct.techParamId, 1, dataStruct.techParamValue, dataStruct.techParamCode);
                     end
                     
                     fprintf('WARNING: Float #%d: Meta-data ''%s'': decoder value (''%s'') and configuration value (''%s'') differ => BDD contents should be updated (see %s)\n', ...
                        g_decArgo_floatNum, ...
                        dataStruct.metaConfigLabel, ...
                        dataStruct.techParamValue, ...
                        jsonMetaData.(dataStruct.metaConfigLabel), ...
                        g_decArgo_bddUpdateCsvFileName);
                  end
               else
                  if (VERBOSE == 1)
                     if (ONLY_DIFF == 1)
                        fprintf('INFO: Float #%d: Meta-data ''%s'': decoder value (''%s'') and configuration value (''%s'')\n', ...
                           g_decArgo_floatNum, ...
                           dataStruct.metaConfigLabel, ...
                           dataStruct.techParamValue, ...
                           jsonMetaData.(dataStruct.metaConfigLabel));
                     end
                  end
               end
            else
               switch (a_decoderId)
                  
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  case {1001, 1002, 1003, 1004, 1005, 1007, 1010, 1011, 1012}
                     % 071412, 062608, 061609, 021009, 061810, 082213,
                     % 110613&090413, 121512, 110813
                     % only one sensor (SBE41)
                     fieldNames = fields(jsonMetaData.(dataStruct.metaConfigLabel));
                     for idF = 1:length(fieldNames)
                        if (~strcmp(jsonMetaData.(dataStruct.metaConfigLabel).(fieldNames{idF}), dataStruct.techParamValue))
                           if (VERBOSE == 1)
                              if (g_decArgo_bddUpdateCsvFileId == -1)
                                 % output CSV file creation
                                 g_decArgo_bddUpdateCsvFileName = [g_decArgo_dirOutputCsvFile '/data_to_update_bdd_' datestr(now, 'yyyymmddTHHMMSS') '.csv'];
                                 g_decArgo_bddUpdateCsvFileId = fopen(g_decArgo_bddUpdateCsvFileName, 'wt');
                                 if (g_decArgo_bddUpdateCsvFileId == -1)
                                    fprintf('ERROR: Unable to create CSV output file: %s\n', g_decArgo_bddUpdateCsvFileName);
                                    return;
                                 end
                                 
                                 header = 'PLATFORM_CODE;TECH_PARAMETER_ID;DIM_LEVEL;CORIOLIS_TECH_METADATA.PARAMETER_VALUE;TECH_PARAMETER_CODE';
                                 fprintf(g_decArgo_bddUpdateCsvFileId, '%s\n', header);
                              end
                              
                              fprintf(g_decArgo_bddUpdateCsvFileId, '%d;%d;%d;%s;%s\n', ...
                                 g_decArgo_floatNum, ...
                                 dataStruct.techParamId, idF, dataStruct.techParamValue, dataStruct.techParamCode);
                              
                              fprintf('WARNING: Float #%d: Meta-data ''%s.%s'': decoder value (''%s'') and configuration value (''%s'') differ => BDD contents should be updated (see %s)\n', ...
                                 g_decArgo_floatNum, ...
                                 dataStruct.metaConfigLabel, ...
                                 fieldNames{idF}, ...
                                 dataStruct.techParamValue, ...
                                 jsonMetaData.(dataStruct.metaConfigLabel).(fieldNames{idF}), ...
                                 g_decArgo_bddUpdateCsvFileName);
                           end
                        else
                           if (VERBOSE == 1)
                              if (ONLY_DIFF == 1)
                                 fprintf('INFO: Float #%d: Meta-data ''%s.%s'': decoder value (''%s'') and configuration value (''%s'')\n', ...
                                    g_decArgo_floatNum, ...
                                    dataStruct.metaConfigLabel, ...
                                    fieldNames{idF}, ...
                                    dataStruct.techParamValue, ...
                                    jsonMetaData.(dataStruct.metaConfigLabel).(fieldNames{idF}));
                              end
                           end
                        end
                     end
                     
                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  case {1006, 1008, 1009} % 093008, 021208, 032213
                     % two sensors (SBE41 and Aanderaa 3830/4330)
                     fieldNames = fields(jsonMetaData.(dataStruct.metaConfigLabel));
                     for idF = 1:length(fieldNames)
                        if (((strcmp(fieldNames{idF}, 'SENSOR_SERIAL_NO_1') || ...
                              strcmp(fieldNames{idF}, 'SENSOR_SERIAL_NO_2') || ...
                              strcmp(fieldNames{idF}, 'SENSOR_SERIAL_NO_3')) && ...
                              strcmp(dataStruct.techParamCode, 'SENSOR_SERIAL_NO_1')) || ...
                              ((strcmp(fieldNames{idF}, 'SENSOR_SERIAL_NO_4')) && ...
                              strcmp(dataStruct.techParamCode, 'SENSOR_SERIAL_NO_2')))
                           if (~strcmp(jsonMetaData.(dataStruct.metaConfigLabel).(fieldNames{idF}), dataStruct.techParamValue))
                              if (VERBOSE == 1)
                                 if (g_decArgo_bddUpdateCsvFileId == -1)
                                    % output CSV file creation
                                    g_decArgo_bddUpdateCsvFileName = [g_decArgo_dirOutputCsvFile '/data_to_update_bdd_' datestr(now, 'yyyymmddTHHMMSS') '.csv'];
                                    g_decArgo_bddUpdateCsvFileId = fopen(g_decArgo_bddUpdateCsvFileName, 'wt');
                                    if (g_decArgo_bddUpdateCsvFileId == -1)
                                       fprintf('ERROR: Unable to create CSV output file: %s\n', g_decArgo_bddUpdateCsvFileName);
                                       return;
                                    end
                                    
                                    header = 'PLATFORM_CODE;TECH_PARAMETER_ID;DIM_LEVEL;CORIOLIS_TECH_METADATA.PARAMETER_VALUE;TECH_PARAMETER_CODE';
                                    fprintf(g_decArgo_bddUpdateCsvFileId, '%s\n', header);
                                 end
                                 
                                 fprintf(g_decArgo_bddUpdateCsvFileId, '%d;%d;%d;%s;%s\n', ...
                                    g_decArgo_floatNum, ...
                                    dataStruct.techParamId, idF, dataStruct.techParamValue, 'SENSOR_SERIAL_NO');
                                 
                                 fprintf('WARNING: Float #%d: Meta-data ''%s.%s'': decoder value (''%s'') and configuration value (''%s'') differ => BDD contents should be updated (see %s)\n', ...
                                    g_decArgo_floatNum, ...
                                    dataStruct.metaConfigLabel, ...
                                    fieldNames{idF}, ...
                                    dataStruct.techParamValue, ...
                                    jsonMetaData.(dataStruct.metaConfigLabel).(fieldNames{idF}), ...
                                    g_decArgo_bddUpdateCsvFileName);
                              end
                           else
                              if (VERBOSE == 1)
                                 if (ONLY_DIFF == 1)
                                    fprintf('INFO: Float #%d: Meta-data ''%s.%s'': decoder value (''%s'') and configuration value (''%s'')\n', ...
                                       g_decArgo_floatNum, ...
                                       dataStruct.metaConfigLabel, ...
                                       fieldNames{idF}, ...
                                       dataStruct.techParamValue, ...
                                       jsonMetaData.(dataStruct.metaConfigLabel).(fieldNames{idF}));
                                 end
                              end
                           end
                        end
                     end
                     
                  otherwise
                     fprintf('WARNING: Float #%d: Nothing done yet in create_float_config_apx_argos for decoderId #%d\n', ...
                        g_decArgo_floatNum, ...
                        a_decoderId);
               end
            end
         else
            fprintf('WARNING: Float #%d: Field ''%s'' is not in the meta-data configuration\n', ...
               g_decArgo_floatNum, dataStruct.metaConfigLabel);
         end
      end
   end
end

% create the configuration from JSON data
configNames = [];
configValues = [];
if ((isfield(jsonMetaData, 'CONFIG_PARAMETER_NAME')) && ...
      (isfield(jsonMetaData, 'CONFIG_PARAMETER_VALUE')))
   configNames = struct2cell(jsonMetaData.CONFIG_PARAMETER_NAME);
   cellConfigValues = struct2cell(jsonMetaData.CONFIG_PARAMETER_VALUE);
   configValues = nan(size(configNames));
   for id = 1:size(configNames, 1)
      if (~isempty(cellConfigValues{id}))
         configValues(id) = str2num(cellConfigValues{id});
      end
   end
end

if (g_decArgo_realtimeFlag == 0)
   
   if (~isempty(a_decMetaData))
      % check configuration data consistency
      idConfig = find([a_decMetaData.configFlag] == 1);
      for idM = 1:length(idConfig)
         dataStruct = a_decMetaData(idConfig(idM));
         idF = find(strcmp(configNames, dataStruct.metaConfigLabel));
         if (~isempty(idF))
            if (~strcmp(num2str(configValues(idF)), dataStruct.value))
               if (VERBOSE == 1)
                  if (g_decArgo_bddUpdateCsvFileId == -1)
                     % output CSV file creation
                     g_decArgo_bddUpdateCsvFileName = [g_decArgo_dirOutputCsvFile '/data_to_update_bdd_' datestr(now, 'yyyymmddTHHMMSS') '.csv'];
                     g_decArgo_bddUpdateCsvFileId = fopen(g_decArgo_bddUpdateCsvFileName, 'wt');
                     if (g_decArgo_bddUpdateCsvFileId == -1)
                        fprintf('ERROR: Unable to create CSV output file: %s\n', g_decArgo_bddUpdateCsvFileName);
                        return;
                     end
                     
                     header = 'PLATFORM_CODE;TECH_PARAMETER_ID;DIM_LEVEL;CORIOLIS_TECH_METADATA.PARAMETER_VALUE;TECH_PARAMETER_CODE';
                     fprintf(g_decArgo_bddUpdateCsvFileId, '%s\n', header);
                  end
                  
                  if (strcmp(dataStruct.techParamCode, 'STARTUP_DATE'))
                     fprintf(g_decArgo_bddUpdateCsvFileId, '%d;%d;%d; %s;%s\n', ...
                        g_decArgo_floatNum, ...
                        dataStruct.techParamId, 1, dataStruct.techParamValue, dataStruct.techParamCode);
                  elseif (strcmp(dataStruct.techParamCode, 'FIRMWARE_VERSION'))
                     fprintf(g_decArgo_bddUpdateCsvFileId, '%d;%d;%d;''%s;%s\n', ...
                        g_decArgo_floatNum, ...
                        dataStruct.techParamId, 1, dataStruct.techParamValue, dataStruct.techParamCode);
                  else
                     fprintf(g_decArgo_bddUpdateCsvFileId, '%d;%d;%d;%s;%s\n', ...
                        g_decArgo_floatNum, ...
                        dataStruct.techParamId, 1, dataStruct.techParamValue, dataStruct.techParamCode);
                  end
                  
                  fprintf('WARNING: Float #%d: Configuration ''%s'': decoder value (''%s'') and configuration value (''%s'') differ => BDD contents should be updated (see %s)\n', ...
                     g_decArgo_floatNum, ...
                     dataStruct.metaConfigLabel, ...
                     dataStruct.value, ...
                     num2str(configValues(idF)), ...
                     g_decArgo_bddUpdateCsvFileName);
               end
            else
               if (VERBOSE == 1)
                  if (ONLY_DIFF == 1)
                     fprintf('INFO: Float #%d: Configuration ''%s'': decoder value (''%s'') and configuration value (''%s'')\n', ...
                        g_decArgo_floatNum, ...
                        dataStruct.metaConfigLabel, ...
                        dataStruct.value, ...
                        num2str(configValues(idF)));
                  end
               end
            end
         else
            fprintf('WARNING: Float #%d: Field ''%s'' is not in the float configuration\n', ...
               g_decArgo_floatNum, dataStruct.metaConfigLabel);
         end
      end
   end
end

% create the float configurations
floatConfigValues = [];
floatConfigNumbers = 0;

% is it a DPF float ?
idF = find(strcmp(configNames, 'CONFIG_DPF_DeepProfileFirstFloat'));
if (isnan(configValues(idF)))
   fprintf('ERROR: Float #%d: Configuration parameter ''%s'' is mandatory => temporarily set to 0 for this run\n', ...
      g_decArgo_floatNum, 'CONFIG_DPF_DeepProfileFirstFloat');
   configValues(idF) = 0;
end
if (configValues(idF) == 1)
   idF2 = find(strcmp(configNames, 'CONFIG_CT_CycleTime'));
   newCycleTime = nan;
   idF3 = find(strcmp(configNames, 'CONFIG_UP_UpTime'));
   idF4 = find(strcmp(configNames, 'CONFIG_TP_ProfilePressure'));
   if (~isnan(configValues(idF3)) && ~isnan(configValues(idF4)))
      % estimated descent speed : 4 cm/s (determined from Argos data)
      newCycleTime = configValues(idF3) + configValues(idF4)*100/(4*3600);
      %       fprintf('DPF cycle duration : %.1f hours)\n', newCycleTime);
   end
   newConfigValues = configValues;
   newConfigValues(idF2) = newCycleTime;
   floatConfigValues = [floatConfigValues newConfigValues];
   floatConfigNumbers(end+1) = max(floatConfigNumbers) + 1;
end

% is it always profiling from the same depth ?
idF = find(strcmp(configNames, 'CONFIG_N_ParkAndProfileCycleLength'));
if (isnan(configValues(idF)))
   if (isempty(a_decMetaData))
      fprintf('ERROR: Float #%d: Configuration parameter ''%s'' is mandatory => temporarily set to 1 for this run\n', ...
         g_decArgo_floatNum, 'CONFIG_N_ParkAndProfileCycleLength');
   end
   configValues(idF) = 1;
end
if (configValues(idF) > 1)
   idF2 = find(strcmp(configNames, 'CONFIG_PRKP_ParkPressure'));
   idF3 = find(strcmp(configNames, 'CONFIG_TP_ProfilePressure'));
   if ((~isnan(configValues(idF2)) || ~isnan(configValues(idF3))) && ...
         (configValues(idF2) ~= configValues(idF3)))
      newConfigValues = configValues;
      newConfigValues(idF3) = newConfigValues(idF2);
      floatConfigValues = [floatConfigValues newConfigValues];
      floatConfigNumbers(end+1) = max(floatConfigNumbers) + 1;
   end
end

% base configuration
idF = find(strcmp(configNames, 'CONFIG_N_ParkAndProfileCycleLength'));
if (isnan(configValues(idF)))
   if (isempty(a_decMetaData))
      fprintf('ERROR: Float #%d: Configuration parameter ''%s'' is mandatory => temporarily set to 1 for this run\n', ...
         g_decArgo_floatNum, 'CONFIG_N_ParkAndProfileCycleLength');
   end
   configValues(idF) = 1;
end
if (configValues(idF) ~= 234)
   floatConfigValues = [floatConfigValues configValues];
   floatConfigNumbers(end+1) = max(floatConfigNumbers) + 1;
end

% the possible cases are:
% 1 - DPF = yes and N = 1 (2 configurations):
%     - config #1: cycle duration reduced, profile pres = TP
%     - config #2: cycle duration = CT, profile pres = TP
% 2 - DPF = yes and N > 1 and N ~= 234/254 (3 configurations):
%     - config #1: cycle duration reduced, profile pres = TP
%     - config #2: cycle duration = CT, profile pres = PRKP
%     - config #3: cycle duration = CT, profile pres = TP
% 3 - DPF = yes and N = 234/254 (2 configurations):
%     - config #1: cycle duration reduced, profile pres = TP
%     - config #2: cycle duration = CT, profile pres = PRKP
% 4 - DPF = no and N = 1 (1 configuration):
%     - config #1: cycle duration = CT, profile pres = TP
% 5 - DPF = no and N > 1 and N ~= 234/254 (2 configurations):
%     - config #1: cycle duration = CT, profile pres = PRKP
%     - config #2: cycle duration = CT, profile pres = TP
% 6 - DPF = no and N = 234/254 (1 configuration):
%     - config #1: cycle duration = CT, profile pres = PRKP

% store the configuration
g_decArgo_floatConfig = [];
g_decArgo_floatConfig.NAMES = configNames;
g_decArgo_floatConfig.VALUES = floatConfigValues;
g_decArgo_floatConfig.NUMBER = floatConfigNumbers;
g_decArgo_floatConfig.USE.CYCLE = [];
g_decArgo_floatConfig.USE.CONFIG = [];
g_decArgo_configDone = 1;

% store configuration parameters for cycle timings determination
dpfFloatFlag = get_float_config_argos_3('CONFIG_DPF_');
if (~isempty(dpfFloatFlag))
   g_decArgo_timeData.configParam.dpfFloatFlag = dpfFloatFlag;
end
cycleTime = get_float_config_argos_3('CONFIG_CT_');
if (~isempty(cycleTime))
   g_decArgo_timeData.configParam.cycleTime = cycleTime;
end
downTime = get_float_config_argos_3('CONFIG_DOWN_');
if (~isempty(downTime))
   g_decArgo_timeData.configParam.downTime = downTime;
end
upTime = get_float_config_argos_3('CONFIG_UP_');
if (~isempty(upTime))
   g_decArgo_timeData.configParam.upTime = upTime;
end
parkingPres = get_float_config_argos_3('CONFIG_PRKP_');
if (~isempty(parkingPres))
   g_decArgo_timeData.configParam.parkingPres = parkingPres;
end
profilePres = get_float_config_argos_3('CONFIG_TP_');
if (~isempty(profilePres))
   g_decArgo_timeData.configParam.profilePres = profilePres;
end
parkAndProfileCycleLength = get_float_config_argos_3('CONFIG_N_');
if (~isempty(parkAndProfileCycleLength))
   g_decArgo_timeData.configParam.parkAndProfileCycleLength = parkAndProfileCycleLength;
end
deepProfileDescentPeriod = get_float_config_argos_3('CONFIG_DPDP_');
if (~isempty(deepProfileDescentPeriod))
   g_decArgo_timeData.configParam.deepProfileDescentPeriod = deepProfileDescentPeriod;
end
transRepPeriod = get_float_config_argos_3('CONFIG_REP_');
if (~isempty(transRepPeriod))
   g_decArgo_timeData.configParam.transRepPeriod = transRepPeriod;
end

return;
