% ------------------------------------------------------------------------------
% Initialize the float configurations and store the configuration at launch.
%
% SYNTAX :
%  init_float_config_ir_sbd_206_to_209(a_launchDate, a_decoderId)
%
% INPUT PARAMETERS :
%   a_launchDate : launch date of the float
%   a_decoderId  : float decoder Id
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/03/2015 - RNU - creation
% ------------------------------------------------------------------------------
function init_float_config_ir_sbd_206_to_209(a_launchDate, a_decoderId)

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

% arrays to store decoded calibration coefficient
global g_decArgo_calibInfo;

% arrays to store RT offset information
global g_decArgo_rtOffsetInfo;
g_decArgo_rtOffsetInfo = [];

% default values
global g_decArgo_janFirst1950InMatlab;


% create static configuration names
configNames1 = [];
configNames1{end+1} = 'CONFIG_PM04';

% create dynamic configuration names
configNames2 = [];
for id = [0:3 5:16]
   configNames2{end+1} = sprintf('CONFIG_PM%02d', id);
end
for id = [0:15 18 20:27]
   configNames2{end+1} = sprintf('CONFIG_PT%02d', id);
end
for id = [0 2]
   configNames2{end+1} = sprintf('CONFIG_PX%02d', id);
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
      idPos = find(strncmp(jConfNames{id}, configNames2, 11) == 1, 1);
      if (~isempty(idPos))
         if (~isempty(jConfValues{id}))
            configValues2(idPos) = str2num(jConfValues{id});
         end
      else
         idPos = find(strncmp(jConfNames{id}, configNames1, 11) == 1, 1);
         if (~isempty(idPos))
            if (~isempty(jConfValues{id}))
               configValues1{end+1} = jConfValues{id};
            end
         end
      end
   end
end

% as the float always profiles during the first descent (at a 10 sec period)
% when CONFIG_PM05 = 0 in the starting configuration, set it to 10 sec
idPos = find(strcmp(configNames2, 'CONFIG_PM05') == 1, 1);
if (~isempty(idPos))
   if (configValues2(idPos) == 0)
      configValues2(idPos) = 10;
   end
end
idPos = find(strcmp(configNames2, 'CONFIG_PX00') == 1, 1);
if (~isempty(idPos))
   configValues2(idPos) = 3;
end

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

% add DO calibration coefficients
% read the calibration coefficients in the json meta-data file

% fill the calibration coefficients
if (isfield(metaData, 'CALIBRATION_COEFFICIENT'))
   if (~isempty(metaData.CALIBRATION_COEFFICIENT))
      fieldNames = fields(metaData.CALIBRATION_COEFFICIENT);
      for idF = 1:length(fieldNames)
         g_decArgo_calibInfo.(fieldNames{idF}) = metaData.CALIBRATION_COEFFICIENT.(fieldNames{idF});
      end
   end
end

% create the tabDoxyCoef array
switch (a_decoderId)
   
   case {206}
      if (isfield(g_decArgo_calibInfo, 'OPTODE'))
         calibData = g_decArgo_calibInfo.OPTODE;
         tabDoxyCoef = [];
         for id = 0:3
            fieldName = ['PhaseCoef' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(1, id+1) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         for id = 0:6
            fieldName = ['SVUFoilCoef' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(2, id+1) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         g_decArgo_calibInfo.OPTODE.TabDoxyCoef = tabDoxyCoef;
      else
         fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
      end
      
   case {209}
      if (isfield(g_decArgo_calibInfo, 'OPTODE'))
         calibData = g_decArgo_calibInfo.OPTODE;
         
         % for the AAnderaa optode
         tabDoxyCoef = [];
         for id = 0:3
            fieldName = ['PhaseCoef' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(1, id+1) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         for id = 0:6
            fieldName = ['SVUFoilCoef' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(2, id+1) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         g_decArgo_calibInfo.OPTODE.TabDoxyCoef = tabDoxyCoef;
         
         % for the SBE optode
         tabDoxyCoef = [];
         coefNameList = [{'A0'} {'A1'} {'A2'} {'B0'} {'B1'} {'C0'} {'C1'} {'C2'} {'E'}];
         for id = 1:length(coefNameList)
            fieldName = ['SBEOptode' coefNameList{id}];
            if (isfield(calibData, fieldName))
               tabDoxyCoef = [tabDoxyCoef calibData.(fieldName)];
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         g_decArgo_calibInfo.OPTODE.SbeTabDoxyCoef = tabDoxyCoef;
      else
         fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
      end

   case {207, 208}
      if (isfield(g_decArgo_calibInfo, 'OPTODE'))
         calibData = g_decArgo_calibInfo.OPTODE;
         tabDoxyCoef = [];
         for id = 0:3
            fieldName = ['PhaseCoef' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(1, id+1) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         for id = 0:5
            fieldName = ['TempCoef' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(2, id+1) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         for id = 0:13
            fieldName = ['FoilCoefA' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(3, id+1) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         for id = 0:13
            fieldName = ['FoilCoefB' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(3, id+15) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         for id = 0:27
            fieldName = ['FoilPolyDegT' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(4, id+1) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         for id = 0:27
            fieldName = ['FoilPolyDegO' num2str(id)];
            if (isfield(calibData, fieldName))
               tabDoxyCoef(5, id+1) = calibData.(fieldName);
            else
               fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
               return;
            end
         end
         
         if (a_decoderId == 208)
            for id = 0:1
               fieldName = ['ConcCoef' num2str(id)];
               if (isfield(calibData, fieldName))
                  tabDoxyCoef(6, id+1) = calibData.(fieldName);
               else
                  fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
                  return;
               end
            end
         end
         
         g_decArgo_calibInfo.OPTODE.TabDoxyCoef = tabDoxyCoef;
      else
         fprintf('ERROR: Float #%d: inconsistent CALIBRATION_COEFFICIENT information\n', g_decArgo_floatNum);
      end

end

return;
