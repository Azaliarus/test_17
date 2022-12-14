% ------------------------------------------------------------------------------
% Initialize the float configurations and store the configuration at launch.
%
% SYNTAX :
%  init_float_config_ir_sbd_210_211(a_launchDate)
%
% INPUT PARAMETERS :
%   a_launchDate : launch date of the float
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO : 
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   07/04/2016 - RNU - creation
% ------------------------------------------------------------------------------
function init_float_config_ir_sbd_210_211(a_launchDate)

% float configuration structures:

% configuration used to store static configuration values (not received through
% messages)
% g_decArgo_floatConfig.STATIC.NAMES
% g_decArgo_floatConfig.STATIC.VALUES

% configuration used to store parameter message contents
% g_decArgo_floatConfig.DYNAMIC_TMP.DATES
% g_decArgo_floatConfig.DYNAMIC_TMP.NAMES
% g_decArgo_floatConfig.DYNAMIC_TMP.VALUES

% configuration used to store configuration per cycle(used by the
% decoder)
% g_decArgo_floatConfig.DYNAMIC.NUMBER
% g_decArgo_floatConfig.DYNAMIC.NAMES
% g_decArgo_floatConfig.DYNAMIC.VALUES
% g_decArgo_floatConfig.USE.CYCLE
% g_decArgo_floatConfig.USE.CONFIG

% final configuration (1 configuration per cycle) (stored in the meta.nc file)
% g_decArgo_floatConfig.STATIC.NAMES
% g_decArgo_floatConfig.STATIC.VALUES
% g_decArgo_floatConfig.DYNAMIC_old.NUMBER
% g_decArgo_floatConfig.DYNAMIC_old.NAMES
% g_decArgo_floatConfig.DYNAMIC_old.VALUES
% g_decArgo_floatConfig.USE_old.CYCLE
% g_decArgo_floatConfig.USE_old.CONFIG


% float configuration
global g_decArgo_floatConfig;

% current float WMO number
global g_decArgo_floatNum;

% directory of json meta-data files
global g_decArgo_dirInputJsonFloatMetaDataFile;

% arrays to store RT offset information
global g_decArgo_rtOffsetInfo;
g_decArgo_rtOffsetInfo = [];

% default values
global g_decArgo_janFirst1950InMatlab;


% create static configuration names
configNames1 = [];

% create dynamic configuration names
configNames2 = [];
for id = [2 11 12]
   configNames2{end+1} = sprintf('CONFIG_MC%03d_', id);
end
for id = 0:31
   configNames2{end+1} = sprintf('CONFIG_MC%02d_', id);
end
for id = 0:24
   configNames2{end+1} = sprintf('CONFIG_TC%02d_', id);
end
for id = 0:2
   configNames2{end+1} = sprintf('CONFIG_PX%02d_', id);
end

% initialize the configuration values with the json meta-data file

% json meta-data file for this float
jsonInputFileName = [g_decArgo_dirInputJsonFloatMetaDataFile '/' sprintf('%d_meta.json', g_decArgo_floatNum)];

if ~(exist(jsonInputFileName, 'file') == 2)
   g_decArgo_floatConfig = [];
   fprintf('ERROR: Json meta-data file not found: %s\n', jsonInputFileName);
   return;
end

% read meta-data file
metaData = loadjson(jsonInputFileName);

% fill the configuration values
configValues1 = [];
configValues2 = nan(length(configNames2), 1);

if (~isempty(metaData.CONFIG_PARAMETER_NAME) && ~isempty(metaData.CONFIG_PARAMETER_VALUE))
   jConfNames = struct2cell(metaData.CONFIG_PARAMETER_NAME);
   jConfValues = struct2cell(metaData.CONFIG_PARAMETER_VALUE);
   for id = 1:length(jConfNames)
      idFUs = strfind(jConfNames{id}, '_');
      idPos = find(strncmp(jConfNames{id}, configNames2, idFUs(2)) == 1, 1);
      if (~isempty(idPos))
         if (~isempty(jConfValues{id}))
            configValues2(idPos) = str2num(jConfValues{id});
         end
      else
         idPos = find(strncmp(jConfNames{id}, configNames1, idFUs(2)) == 1, 1);
         if (~isempty(idPos))
            if (~isempty(jConfValues{id}))
               configValues1{end+1} = jConfValues{id};
            end
         end
      end
   end
end

% create launch configuration

% compute the cycle #1 duration
confName = 'CONFIG_MC04_';
idPosMc04 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
refDay = configValues2(idPosMc04);
confName = 'CONFIG_MC05_';
idPosMc05 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
timeAtSurf = configValues2(idPosMc05);
confName = 'CONFIG_MC06_';
idPosMc06 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
delayBeforeMission = configValues2(idPosMc06);
if (~isnan(refDay) && ~isnan(timeAtSurf) && ~isnan(delayBeforeMission))
   confName = 'CONFIG_MC002_';
   idPosMc002 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
   % refDay start when the magnet is removed, the float start to dive after
   % delayBeforeMission
   configValues2(idPosMc002) = (refDay + timeAtSurf/24 - delayBeforeMission/1440)*24;
end

% update MC010 and MC011 for the cycle #1
confName = 'CONFIG_MC01_';
idPosMc01 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
if (configValues2(idPosMc01) > 0)
   % copy MC11 in MC011
   confName = 'CONFIG_MC11_';
   idPosMc11 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
   confName = 'CONFIG_MC011_';
   idPosMc011 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
   configValues2(idPosMc011) = configValues2(idPosMc11);
   % copy MC12 in MC012
   confName = 'CONFIG_MC12_';
   idPosMc12 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
   confName = 'CONFIG_MC012_';
   idPosMc012 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
   configValues2(idPosMc012) = configValues2(idPosMc12);
elseif (configValues2(idPosMc01) == 0)
   % copy MC13 in MC011
   confName = 'CONFIG_MC13_';
   idPosMc13 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
   confName = 'CONFIG_MC011_';
   idPosMc011 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
   configValues2(idPosMc011) = configValues2(idPosMc13);
   % copy MC14 in MC012
   confName = 'CONFIG_MC14_';
   idPosMc14 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
   confName = 'CONFIG_MC012_';
   idPosMc012 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
   configValues2(idPosMc012) = configValues2(idPosMc14);
end

% as the float always profiles during the first descent (at a 10 sec period)
% when CONFIG_MC08 = 0 in the starting configuration, set it to 10 sec
confName = 'CONFIG_MC08_';
idPosMc08 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
if (~isempty(idPosMc08))
   if (configValues2(idPosMc08) == 0)
      configValues2(idPosMc08) = 10;
   end
end
confName = 'CONFIG_PX00_';
idPosPx00 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
if (~isempty(idPosPx00))
   configValues2(idPosPx00) = 3;
end

% CTD and profile cut-off pressure
confName = 'CONFIG_MC28_';
idPosMc28 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
if (~isnan(configValues2(idPosMc28)))
   ctdPumpSwitchOffPres = configValues2(idPosMc28);
else
   ctdPumpSwitchOffPres = 5;
   fprintf('INFO: Float #%d: CTD switch off pressure parameter is missing in the Json meta-data file => using default value (%d dbars)\n', ...
      g_decArgo_floatNum, ctdPumpSwitchOffPres);
end

confName = 'CONFIG_PX01_';
idPosPx01 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
configValues2(idPosPx01) = ctdPumpSwitchOffPres;
confName = 'CONFIG_PX02_';
idPosPx02 = find(strncmp(confName, configNames2, length(confName)) == 1, 1);
configValues2(idPosPx02) = ctdPumpSwitchOffPres + 0.5;

% store the configuration
g_decArgo_floatConfig = [];
g_decArgo_floatConfig.STATIC.NAMES = configNames1';
g_decArgo_floatConfig.STATIC.VALUES = configValues1';
g_decArgo_floatConfig.DYNAMIC.NUMBER = 0;
g_decArgo_floatConfig.DYNAMIC.NAMES = configNames2';
g_decArgo_floatConfig.DYNAMIC.VALUES = configValues2;
g_decArgo_floatConfig.USE.CYCLE = [];
g_decArgo_floatConfig.USE.CONFIG = [];
g_decArgo_floatConfig.DYNAMIC_TMP.DATES = a_launchDate;
g_decArgo_floatConfig.DYNAMIC_TMP.NAMES = configNames2';
g_decArgo_floatConfig.DYNAMIC_TMP.VALUES = configValues2;

% print_config_in_csv_file_ir_sbd('init_', 0, g_decArgo_floatConfig);

% retrieve the RT offsets
if (isfield(metaData, 'RT_OFFSET'))
   g_decArgo_rtOffsetInfo.param = [];
   g_decArgo_rtOffsetInfo.value = [];
   g_decArgo_rtOffsetInfo.date = [];

   rtData = metaData.RT_OFFSET;
   params = unique(struct2cell(rtData.PARAM));
   for idParam = 1:length(params)
      param = params{idParam};
      fieldNames = fields(rtData.PARAM);
      tabValue = [];
      tabDate = [];
      for idF = 1:length(fieldNames)
         fieldName = fieldNames{idF};
         if (strcmp(rtData.PARAM.(fieldName), param) == 1)
            idPos = strfind(fieldName, '_');
            paramNum = fieldName(idPos+1:end);
            value = str2num(rtData.VALUE.(['VALUE_' paramNum]));
            tabValue = [tabValue value];
            date = rtData.DATE.(['DATE_' paramNum]);
            date = datenum(date, 'yyyymmddHHMMSS') - g_decArgo_janFirst1950InMatlab;
            tabDate = [tabDate date];
         end
      end
      [tabDate, idSorted] = sort(tabDate);
      tabValue = tabValue(idSorted);
      
      % store the RT offsets
      g_decArgo_rtOffsetInfo.param{end+1} = param;
      g_decArgo_rtOffsetInfo.value{end+1} = tabValue;
      g_decArgo_rtOffsetInfo.date{end+1} = tabDate;
   end
end

return;
