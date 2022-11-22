% ------------------------------------------------------------------------------
% Process meta-data exported from Coriolis data base and save it in individual
% json files.
%
% SYNTAX :
%  generate_json_float_meta_nva_( ...
%    a_floatMetaFileName, a_floatListFileName, a_outputDirName)
%
% INPUT PARAMETERS :
%   a_floatMetaFileName : meta-data file exported from Coriolis data base
%   a_floatListFileName : list of concerned floats
%   a_outputDirName     : directory of individual json float meta-data files
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/26/2016 - RNU - creation
%   09/01/2017 - RNU - RT version added
% ------------------------------------------------------------------------------
function generate_json_float_meta_nva_( ...
   a_floatMetaFileName, a_floatListFileName, a_outputDirName)

% report information structure
global g_cogj_reportData;


% check inputs
fprintf('Generating json meta-data files from input file: %s\n', a_floatMetaFileName);

if ~(exist(a_floatMetaFileName, 'file') == 2)
   fprintf('ERROR: Meta-data file not found: %s\n', a_floatMetaFileName);
   return;
end

fprintf('Generating json meta-data files for floats of the list: %s\n', a_floatListFileName);

if ~(exist(a_floatListFileName, 'file') == 2)
   fprintf('ERROR: Float file list not found: %s\n', a_floatListFileName);
   return;
end

% lists of mandatory meta-data
mandatoryList1 = [ ...
   {'BATTERY_TYPE'} ...
   {'CONTROLLER_BOARD_SERIAL_NO_PRIMARY'} ...
   {'CONTROLLER_BOARD_TYPE_PRIMARY'} ...
   {'DAC_FORMAT_ID'} ...
   {'FIRMWARE_VERSION'} ...
   {'FLOAT_SERIAL_NO'} ...
   {'MANUAL_VERSION'} ...
   {'PI_NAME'} ...
   {'PREDEPLOYMENT_CALIB_COEFFICIENT'} ...
   {'PREDEPLOYMENT_CALIB_EQUATION'} ...
   {'PTT'} ...
   {'SENSOR_SERIAL_NO'} ...
   {'PARAMETER_UNITS'} ...
   {'PARAMETER_SENSOR'} ...
   {'STANDARD_FORMAT_ID'} ...
   {'TRANS_FREQUENCY'} ...
   {'TRANS_SYSTEM_ID'} ...
   {'WMO_INST_TYPE'} ...
   ];
mandatoryList2 = [ ...
   {'SENSOR_MAKER'} ...
   {'SENSOR_MODEL'} ...
   ];

% get DB meta-data
fId = fopen(a_floatMetaFileName, 'r');
if (fId == -1)
   fprintf('ERROR: Unable to open file: %s\n', a_floatMetaFileName);
   return;
end
fileContents = textscan(fId, '%s', 'delimiter', '\t');
fileContents = fileContents{:};
fclose(fId);

fileContents = regexprep(fileContents, '"', '');

metaData = reshape(fileContents, 5, size(fileContents, 1)/5)';

% get the mapping structure
metaBddStruct = get_meta_bdd_struct();
metaBddStructNames = fieldnames(metaBddStruct);

% process the meta-data to fill the structure
% wmoList = str2num(cell2mat(metaData(:, 1))); % works only if all raws have the sme number of digits
% dimLevlist = str2num(cell2mat(metaData(:, 3))); % works only if all raws have the sme number of digits
wmoList = metaData(:, 1);
for id = 1:length(wmoList)
   if (isempty(str2num(wmoList{id})))
      fprintf('%s is not a valid WMO number\n', wmoList{id});
      return;
   end
end
S = sprintf('%s*', wmoList{:});
wmoList = sscanf(S, '%f*');
dimLevlist = metaData(:, 3);
S = sprintf('%s*', dimLevlist{:});
dimLevlist = sscanf(S, '%f*');
floatList = unique(wmoList);

% check needed floats against DB contents
refFloatList = load(a_floatListFileName);

floatList = sort(intersect(floatList, refFloatList));
% floatList = [6903178];

notFoundFloat = setdiff(refFloatList, floatList);
if (~isempty(notFoundFloat))
   fprintf('WARNING: Meta-data not found for float: %d\n', notFoundFloat);
end

% process floats
for idFloat = 1:length(floatList)
   
   fprintf('%3d/%3d %d\n', idFloat, length(floatList), floatList(idFloat));
   
   % initialize the structure to be filled
   metaStruct = get_meta_init_struct();
   
   metaStruct.PLATFORM_NUMBER = num2str(floatList(idFloat));
   metaStruct.ARGO_USER_MANUAL_VERSION = '3.1';
   
   % direct conversion data
   idForWmo = find(wmoList == floatList(idFloat));
   for idBSN = 1:length(metaBddStructNames)
      metaBddStructField = char(metaBddStructNames(idBSN));
      metaBddStructValue = metaBddStruct.(metaBddStructField);
      if (~isempty(metaBddStructValue))
         idF = find(strcmp(metaData(idForWmo, 5), metaBddStructValue) == 1, 1);
         if (~isempty(idF))
            metaStruct.(metaBddStructField) = char(metaData(idForWmo(idF), 4));
         else
            if (~isempty(find(strcmp(mandatoryList1, metaBddStructField) == 1, 1)))
               metaStruct.(metaBddStructField) = 'n/a';
               %                fprintf('Empty mandatory meta-data ''%s'' set to ''n/a''\n', metaBddStructValue);
            elseif (~isempty(find(strcmp(mandatoryList2, metaBddStructField) == 1, 1)))
               metaStruct.(metaBddStructField) = 'UNKNOWN';
            end
         end
      end
   end
   
   % PTT / IMEI specific processing
   %    if (~isempty(metaStruct.IMEI))
   %       metaStruct.PTT = metaStruct.IMEI;
   %    end
   if (~isempty(metaStruct.PTT) && (length(metaStruct.PTT) >= 7))
      metaStruct.IMEI = metaStruct.PTT;
      metaStruct.PTT = metaStruct.IMEI(end-6:end-1);
   end
   
   % multi dim data
   itemList = [ ...
      {'TRANS_SYSTEM'} ...
      {'TRANS_SYSTEM_ID'} ...
      {'TRANS_FREQUENCY'} ...
      ];
   [metaStruct] = add_multi_dim_data( ...
      itemList, ...
      metaData, idForWmo, dimLevlist, ...
      metaStruct, mandatoryList1, mandatoryList2);
   
   [metaStruct] = add_multi_dim_data( ...
      {'POSITIONING_SYSTEM'}, ...
      metaData, idForWmo, dimLevlist, ...
      metaStruct, mandatoryList1, mandatoryList2);
   
   itemList = [ ...
      {'SENSOR'} ...
      {'SENSOR_MAKER'} ...
      {'SENSOR_MODEL'} ...
      {'SENSOR_SERIAL_NO'} ...
      ];
   [metaStruct] = add_multi_dim_data( ...
      itemList, ...
      metaData, idForWmo, dimLevlist, ...
      metaStruct, mandatoryList1, mandatoryList2);
   
   itemList = [ ...
      {'PARAMETER'} ...
      {'PARAMETER_SENSOR'} ...
      {'PARAMETER_UNITS'} ...
      {'PARAMETER_ACCURACY'} ...
      {'PARAMETER_RESOLUTION'} ...
      {'PREDEPLOYMENT_CALIB_EQUATION'} ...
      {'PREDEPLOYMENT_CALIB_COEFFICIENT'} ...
      {'PREDEPLOYMENT_CALIB_COMMENT'} ...
      ];
   [metaStruct] = add_multi_dim_data( ...
      itemList, ...
      metaData, idForWmo, dimLevlist, ...
      metaStruct, mandatoryList1, mandatoryList2);
   
   itemList = [ ...
      {'CALIB_RT_PARAMETER'} ...
      {'CALIB_RT_EQUATION'} ...
      {'CALIB_RT_COEFFICIENT'} ...
      {'CALIB_RT_COMMENT'} ...
      {'CALIB_RT_DATE'} ...
      ];
   [metaStruct] = add_multi_dim_data( ...
      itemList, ...
      metaData, idForWmo, dimLevlist, ...
      metaStruct, mandatoryList1, mandatoryList2);

   % configuration parameters
   
   % retrieve DAC_FORMAT_ID
   dacFormatId = getfield(metaStruct, 'DAC_FORMAT_ID');
   if (isempty(dacFormatId))
      fprintf('ERROR: DAC_FORMAT_ID (from PR_VERSION) is missing for float %d => no json file generated\n', ...
         floatList(idFloat));
      continue;
   end
   
   % CONFIG_PARAMETER_NAME
   configStruct = get_config_init_struct(dacFormatId);
   if (isempty(configStruct))
      continue;
   end
   configStructNames = fieldnames(configStruct);
   metaStruct.CONFIG_PARAMETER_NAME = configStructNames;
   
   % CONFIG_PARAMETER_VALUE
   configBddStruct = get_config_bdd_struct(dacFormatId);
   if (isempty(configBddStruct))
      continue;
   end
   configBddStructNames = fieldnames(configBddStruct);
   
   nbConfig = 1;
   configParamVal = cell(length(configStructNames), nbConfig);
   for idConf = 1:nbConfig
      for idBSN = 1:length(configBddStructNames)
         configBddStructName = configBddStructNames{idBSN};
         configBddStructValue = getfield(configBddStruct, configBddStructName);
         if (~isempty(configBddStructValue))
            idF = find(strcmp(metaData(idForWmo, 5), configBddStructValue) == 1);
            if (~isempty(idF))
               dimLev = dimLevlist(idForWmo(idF));
               idDim = find(dimLev == idConf, 1);
               if ((isempty(idDim)) && (idConf > 1))
                  idDim = 1;
               elseif ((isempty(idDim)) && (idConf == 1))
                  fprintf('ERROR\n');
               end
               
               if ((strcmp(configBddStructValue, 'DIRECTION') == 0) && ...
                     (strcmp(configBddStructValue, 'CYCLE_TIME') == 0) && ...
                     (strcmp(configBddStructValue, 'PR_IMMERSION_DRIFT_PERIOD') == 0) && ...
                     (strncmp(configBddStructValue, 'SBE_OPTODE_COEF_', length('SBE_OPTODE_COEF_')) == 0))
                  configParamVal{idBSN, idConf} = metaData{idForWmo(idF(idDim)), 4};
               else
                  if (strcmp(configBddStructValue, 'DIRECTION') == 1)
                     configParamVal{idBSN, idConf} = '1';
                  elseif (strcmp(configBddStructValue, 'CYCLE_TIME') == 1)
                     configParamVal{idBSN, idConf} = num2str(str2num(metaData{idForWmo(idF(idDim)), 4})/24);
                  elseif (strcmp(configBddStructValue, 'PR_IMMERSION_DRIFT_PERIOD') == 1)
                     configParamVal{idBSN, idConf} = num2str(str2num(metaData{idForWmo(idF(idDim)), 4})/60);
                  elseif (strncmp(configBddStructValue, 'SBE_OPTODE_COEF_', length('SBE_OPTODE_COEF_')) == 1)
                     % processed below
                  end
               end
            end
         else
            % if we want to use default values if the information is
            % missing in the database
            %                      configParamVal{idBSN, idConf} = getfield(configStruct, configBddStructName);
         end
         
      end
   end
   
   % CONFIG_PARAMETER_VALUE
   metaStruct.CONFIG_PARAMETER_VALUE = configParamVal;
   
   metaStruct.CONFIG_MISSION_NUMBER = {'0'};
   
   % CALIBRATION_COEFFICIENT
   switch (dacFormatId)
      case {'2.0'}
         calibData = [];
         idF = find(strncmp(metaData(idForWmo, 5), 'SBE_OPTODE_COEF_', length('SBE_OPTODE_COEF_')) == 1);
         for id = 1:length(idF)
            calibName = metaData{idForWmo(idF(id)), 5};
            idFUs = strfind(calibName, '_');
            if (length(idFUs) > 2)
               fieldName = ['SBEOptode' calibName(idFUs(3)+1:end)];
               calibData.(fieldName) = metaData{idForWmo(idF(id)), 4};
            end
         end
         if (~isempty(calibData))
            calibrationCoefficient = [];
            calibrationCoefficient.OPTODE = calibData;
            
            metaStruct.CALIBRATION_COEFFICIENT = calibrationCoefficient;
         else
            fprintf('WARNING: DOXY calibration information is missing for float %d\n', ...
               floatList(idFloat));
         end
   end
   
   % RT_OFFSET
   idF = find(strcmp(metaData(idForWmo, 5), 'CALIB_RT_PARAMETER') == 1);
   if (~isempty(idF))
      rtOffsetData = [];
      
      rtOffsetParam = [];
      for id = 1:length(idF)
         dimLevel = str2num(metaData{idForWmo(idF(id)), 3});
         fieldName = ['PARAM_' num2str(dimLevel)];
         rtOffsetParam.(fieldName) = metaData{idForWmo(idF(id)), 4};
      end
      rtOffsetSlope = [];
      rtOffsetValue = [];
      idF = find(strcmp(metaData(idForWmo, 5), 'CALIB_RT_COEFFICIENT') == 1);
      for id = 1:length(idF)
         dimLevel = str2num(metaData{idForWmo(idF(id)), 3});
         fieldNameValue = ['VALUE_' num2str(dimLevel)];
         fieldNameSlope = ['SLOPE_' num2str(dimLevel)];
         coefStrOri = metaData{idForWmo(idF(id)), 4};
         coefStr = regexprep(coefStrOri, ' ', '');
         idPos1 = strfind(coefStr, 'a1=');
         idPos2 = strfind(coefStr, ',a0=');
         if (~isempty(idPos1) && ~isempty(idPos2))
            rtOffsetSlope.(fieldNameSlope) = coefStr(idPos1+3:idPos2-1);
            rtOffsetValue.(fieldNameValue) = coefStr(idPos2+4:end);
            [~, statusSlope] = str2num(rtOffsetSlope.(fieldNameSlope));
            [~, statusValue] = str2num(rtOffsetValue.(fieldNameValue));
            if ((statusSlope == 0) || (statusValue == 0))
               fprintf('ERROR: non numerical CALIB_RT_COEFFICIENT for float %d (''%s'') => exit\n', ...
                  floatList(idFloat), coefStrOri);
               return;
            end
         else
            fprintf('ERROR: while parsing CALIB_RT_COEFFICIENT for float %d (found: ''%s'') => exit\n', ...
               floatList(idFloat), coefStrOri);
            return;
         end
      end
      rtOffsetDate = [];
      idF = find(strcmp(metaData(idForWmo, 5), 'CALIB_RT_DATE') == 1);
      for id = 1:length(idF)
         dimLevel = str2num(metaData{idForWmo(idF(id)), 3});
         fieldName = ['DATE_' num2str(dimLevel)];
         rtOffsetDate.(fieldName) = metaData{idForWmo(idF(id)), 4};
      end
      rtOffsetData.PARAM = rtOffsetParam;
      rtOffsetData.SLOPE = rtOffsetSlope;
      rtOffsetData.VALUE = rtOffsetValue;
      rtOffsetData.DATE = rtOffsetDate;
      
      metaStruct.RT_OFFSET = rtOffsetData;
   end
   
   % create the directory of json output files
   if ~(exist(a_outputDirName, 'dir') == 7)
      mkdir(a_outputDirName);
   end
   
   % create json output file
   outputFileName = [a_outputDirName '/' sprintf('%d_meta.json', floatList(idFloat))];
   ok = generate_json_file(outputFileName, metaStruct);
   if (~ok)
      return;
   end
   g_cogj_reportData{end+1} = outputFileName;

end

return;

% ------------------------------------------------------------------------------
% Get the list of configuration parameters for a given float version.
%
% SYNTAX :
%  [o_configStruct] = get_config_init_struct(a_dacFormatId)
%
% INPUT PARAMETERS :
%   a_dacFormatId : float DAC version
%
% OUTPUT PARAMETERS :
%   o_configStruct : list of configuration parameters
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/26/2016 - RNU - creation
%   09/01/2017 - RNU - RT version added
% ------------------------------------------------------------------------------
function [o_configStruct] = get_config_init_struct(a_dacFormatId)

% output parameters initialization
o_configStruct = [];

switch (a_dacFormatId)
   case {'1.0', '2.0'}
      o_configStruct = struct( ...
         'CONFIG_PM00_CyclePeriod', '10', ...
         'CONFIG_PM01_NumberOfCycles', '255', ...
         'CONFIG_PM02_AscentStartTime', '23', ...
         'CONFIG_PM03_AscentSamplingPeriod', '10', ...
         'CONFIG_PM04_DescentSamplingPeriod', '0', ...
         'CONFIG_PM05_DriftSamplingPeriod', '24', ...
         'CONFIG_PM06_DriftDepth', '1000', ...
         'CONFIG_PM07_ProfileDepth', '2000', ...
         'CONFIG_PM08_DelayBeforeProfile', '6', ...
         'CONFIG_PM09_DepthIntervalSpotSampling', '5', ...
         'CONFIG_PM12_DelayBeforeMission', '15', ...
         'CONFIG_PM13_IridiumEOLTransmissionPeriod', '30', ...
         'CONFIG_PM14_ReferenceDay', '0', ...
         'CONFIG_PH01_SurfaceValveMaxTimeAdditionalActions', '200', ...
         'CONFIG_PH02__OilVolumeMaxPerValveAction', '15', ...
         'CONFIG_PH03__OilVolumeMinPerValveAction', '1', ...
         'CONFIG_PH04_PumpActionMaxTimeReposition', '100', ...
         'CONFIG_PH05_PumpActionMaxTimeAscent', '200', ...
         'CONFIG_PH06_PumpActionTimeBuoyancyAcquisition', '600', ...
         'CONFIG_PH07_TimeDelayAfterEndOfAscentPressureThreshold', '3', ...
         'CONFIG_PH08_MaxPumpActionTimeBuoyancyAcquisition', '9000', ...
         'CONFIG_PH09_PressureCheckPeriodDuringAscent', '1', ...
         'CONFIG_PH10_PressureCheckTimeBuoyancyReductionPhase', '1', ...
         'CONFIG_PH11_PressureCheckPeriodDuringDescent', '5', ...
         'CONFIG_PH12_PressureCheckPeriodDuringParking', '10', ...
         'CONFIG_PH13_PressureCheckPeriodDuringStabilization', '0', ...
         'CONFIG_PH14_PressureTargetToleranceForStabAtParkingDepth', '25', ...
         'CONFIG_PH15_NumberOfOutOfTolerancePresBeforeReposition', '1', ...
         'CONFIG_PH16_PressureTargetToleranceDuringDriftAtParkingDepth', '100', ...
         'CONFIG_PH17_PressureMaxBeforeEmergencyAscent', '2100', ...
         'CONFIG_PH18_BuoyancyReductionSecondThreshold', '8', ...
         'CONFIG_PH19_GroundingMode', '0', ...
         'CONFIG_PH20_MinValveActionForSurfaceGroundingDetection', '300', ...
         'CONFIG_PH21_OilVolumeMinForGroundingDetection', '100', ...
         'CONFIG_PH22_GroundingModeMinPresThreshold', '200', ...
         'CONFIG_PH23_GroundingModePresAdjustment', '50', ...
         'CONFIG_PH25_GPSTimeout', '900', ...
         'CONFIG_PH26_PressureTargetToleranceForStabAtProfileDepth', '20', ...
         'CONFIG_PH27_PressureTargetToleranceDuringDriftAtProfileDepth', '20', ...
         'CONFIG_PH29_ProfileSurfaceBinInterval', '10', ...
         'CONFIG_PH30_ThicknessOfTheSurfaceSlices', '980', ...
         'CONFIG_PH31_ThresholdSurfaceMiddlePressure', '1000', ...
         'CONFIG_PH32_ProfileIntermediateBinInterval', '25', ...
         'CONFIG_PH33_ThicknessOfTheMiddleSlices', '3975', ...
         'CONFIG_PH34_ThresholdMiddleBottomPressure', '5000', ...
         'CONFIG_PH35_ProfileBottomBinInterval', '50', ...
         'CONFIG_PH36_ThicknessOfTheBottomSlices', '14950', ...
         'CONFIG_PH37_ProfileIncludeTransitionBin', '0', ...
         'CONFIG_PH38_ProfileSamplingMethod', '0', ...
         'CONFIG_PX00_Direction', '3');        
   otherwise
      fprintf('WARNING: Nothing done yet in generate_json_float_meta_nva_ for dacFormatId %s\n', a_dacFormatId);
end

return;

% ------------------------------------------------------------------------------
% Get the list of BDD variables associated to configuration parameters for a
% given float version.
%
% SYNTAX :
%  [o_configStruct] = get_config_bdd_struct(a_dacFormatId)
%
% INPUT PARAMETERS :
%   a_dacFormatId : float DAC version
%
% OUTPUT PARAMETERS :
%   o_configStruct : list of BDD variables
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/26/2016 - RNU - creation
%   09/01/2017 - RNU - RT version added
% ------------------------------------------------------------------------------
function [o_configStruct] = get_config_bdd_struct(a_dacFormatId)

% output parameters initialization
o_configStruct = [];

switch (a_dacFormatId)
   case {'1.0', '2.0'}
      o_configStruct = struct( ...
         'CONFIG_PM00_CyclePeriod', 'CYCLE_TIME', ...
         'CONFIG_PM01_NumberOfCycles', 'CONFIG_MaxCycles_NUMBER', ...
         'CONFIG_PM02_AscentStartTime', 'PRCFG_Start_time', ...
         'CONFIG_PM03_AscentSamplingPeriod', 'ASC_PROFILE_PERIOD', ...
         'CONFIG_PM04_DescentSamplingPeriod', 'DESC_PROFILE_PERIOD', ...
         'CONFIG_PM05_DriftSamplingPeriod', 'PR_IMMERSION_DRIFT_PERIOD', ...
         'CONFIG_PM06_DriftDepth', 'PARKING_PRESSURE', ...
         'CONFIG_PM07_ProfileDepth', 'DEEPEST_PRESSURE', ...
         'CONFIG_PM08_DelayBeforeProfile', 'DEEP_PROFILE_DESCENT_DELAY', ...
         'CONFIG_PM09_DepthIntervalSpotSampling', 'ProfileDepthInterval', ...
         'CONFIG_PM12_DelayBeforeMission', 'DELAY_BEFORE_MISSION', ...
         'CONFIG_PM13_IridiumEOLTransmissionPeriod', 'EndOfLifeTransPeriod', ...
         'CONFIG_PM14_ReferenceDay', 'PRCFG_Reference_day', ...
         'CONFIG_PH01_SurfaceValveMaxTimeAdditionalActions', 'PRCFG_Surf_valve_max_duration', ...
         'CONFIG_PH02_OilVolumeMaxPerValveAction', 'PRCFG_Depth_valve_max_volume', ...
         'CONFIG_PH03_OilVolumeMinPerValveAction', 'PRCFG_Depth_valve_min_volume', ...
         'CONFIG_PH04_PumpActionMaxTimeReposition', 'PRCFG_Depth_pump_max_duration', ...
         'CONFIG_PH05_PumpActionMaxTimeAscent', 'PRCFG_Asc_pump_max_duration', ...
         'CONFIG_PH06_PumpActionTimeBuoyancyAcquisition', 'PRCFG_Surf_pump_duration', ...
         'CONFIG_PH07_TimeDelayAfterEndOfAscentPressureThreshold', 'TimeDelayAfterAET', ...
         'CONFIG_PH08_MaxPumpActionTimeBuoyancyAcquisition', 'PumpActionTimeEmptyReservoir', ...
         'CONFIG_PH09_PressureCheckPeriodDuringAscent', 'VECTOR_ASCEND_SAMPLING_PERIOD', ...
         'CONFIG_PH10_PressureCheckTimeBuoyancyReductionPhase', 'VECTOR_SURFACE_SAMPLING_PERIOD', ...
         'CONFIG_PH11_PressureCheckPeriodDuringDescent', 'VECTOR_DESCEND_SAMPLING_PERIOD', ...
         'CONFIG_PH12_PressureCheckPeriodDuringParking', 'VECTOR_PARK_SAMPLING_PERIOD', ...
         'CONFIG_PH13_PressureCheckPeriodDuringStabilization', 'VECTOR_STAB_SAMPLING_PERIOD', ...
         'CONFIG_PH14_PressureTargetToleranceForStabAtParkingDepth', 'TargetToleranceForStabParkDepth', ...
         'CONFIG_PH15_NumberOfOutOfTolerancePresBeforeReposition', 'PRCFG_Gap_order_delta_position', ...
         'CONFIG_PH16_PressureTargetToleranceDuringDriftAtParkingDepth', 'TargetToleranceForDriftParkDepth', ...
         'CONFIG_PH17_PressureMaxBeforeEmergencyAscent', 'PRCFG_Max_pressure', ...
         'CONFIG_PH18_BuoyancyReductionSecondThreshold', 'PRCFG_Descent_start_pressure', ...
         'CONFIG_PH19_GroundingMode', 'PRCFG_Grounded_mode', ...
         'CONFIG_PH20_MinValveActionForSurfaceGroundingDetection', 'ValveActionsForSurfaceGrounding', ...
         'CONFIG_PH21_OilVolumeMinForGroundingDetection', 'PRCFG_Grounded_volume', ...
         'CONFIG_PH22_GroundingModeMinPresThreshold', 'PRCFG_Grounded_waiting_pres', ...
         'CONFIG_PH23_GroundingModePresAdjustment', 'PRCFG_Grounded_reduction_pres', ...
         'CONFIG_PH25_GPSTimeout', 'GPSTimeout', ...
         'CONFIG_PH26_PressureTargetToleranceForStabAtProfileDepth', 'TargetToleranceForStabProfDepth', ...
         'CONFIG_PH27_PressureTargetToleranceDuringDriftAtProfileDepth', 'TargetToleranceForDriftProfDepth', ...
         'CONFIG_PH29_ProfileSurfaceBinInterval', 'ProfileSurfaceBinInterval', ...
         'CONFIG_PH30_ThicknessOfTheSurfaceSlices', 'SURF_SLICE_THICKNESS', ...
         'CONFIG_PH31_ThresholdSurfaceMiddlePressure', 'INT_SURF_THRESHOLD', ...
         'CONFIG_PH32_ProfileIntermediateBinInterval', 'ProfileMiddleBinInterval', ...
         'CONFIG_PH33_ThicknessOfTheMiddleSlices', 'INT_SLICE_THICKNESS', ...
         'CONFIG_PH34_ThresholdMiddleBottomPressure', 'DEPTH_INT_THRESHOLD', ...
         'CONFIG_PH35_ProfileBottomBinInterval', 'ProfileBottomBinInterval', ...
         'CONFIG_PH36_ThicknessOfTheBottomSlices', 'DEPTH_SLICE_THICKNESS', ...
         'CONFIG_PH37_ProfileIncludeTransitionBin', 'ProfileIncludeTransitionBins', ...
         'CONFIG_PH38_ProfileSamplingMethod', 'ProfileSamplingMethod', ...
         'CONFIG_PX00_Direction', 'DIRECTION');      
   otherwise
      fprintf('WARNING: Nothing done yet in generate_json_float_meta_nva_ for dacFormatId %s\n', a_dacFormatId);
end

return;

% ------------------------------------------------------------------------------
% Get the list of BDD variables associated to float meta-data.
%
% SYNTAX :
%  [o_metaStruct] = get_meta_bdd_struct()
%
% INPUT PARAMETERS :
%
% OUTPUT PARAMETERS :
%   o_metaStruct : list of BDD variables
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/26/2016 - RNU - creation
%   09/01/2017 - RNU - RT version added
% ------------------------------------------------------------------------------
function [o_metaStruct] = get_meta_bdd_struct()

% output parameters initialization
o_metaStruct = struct( ...
   'ARGO_USER_MANUAL_VERSION', '', ...
   'PLATFORM_NUMBER', '', ...
   'PTT', 'PTT', ...
   'IMEI', 'IMEI', ...
   'TRANS_SYSTEM', 'TRANS_SYSTEM', ...
   'TRANS_SYSTEM_ID', 'TRANS_SYSTEM_ID', ...
   'TRANS_FREQUENCY', 'TRANS_FREQUENCY', ...
   'POSITIONING_SYSTEM', 'POSITIONING_SYSTEM', ...
   'PLATFORM_FAMILY', 'PLATFORM_FAMILY', ...
   'PLATFORM_TYPE', 'PLATFORM_TYPE', ...
   'PLATFORM_MAKER', 'PLATFORM_MAKER', ...
   'FIRMWARE_VERSION', 'FIRMWARE_VERSION', ...
   'MANUAL_VERSION', 'MANUAL_VERSION', ...
   'FLOAT_SERIAL_NO', 'INST_REFERENCE', ...
   'STANDARD_FORMAT_ID', 'STANDARD_FORMAT_ID', ...
   'DAC_FORMAT_ID', 'PR_VERSION', ...
   'WMO_INST_TYPE', 'PR_PROBE_CODE', ...
   'PROJECT_NAME', 'PR_EXPERIMENT_ID', ...
   'DATA_CENTRE', 'DATA_CENTRE', ...
   'PI_NAME', 'PI_NAME', ...
   'ANOMALY', 'ANOMALY', ...
   'BATTERY_TYPE', 'BATTERY_TYPE', ...
   'BATTERY_PACKS', 'BATTERY_PACKS', ...
   'CONTROLLER_BOARD_TYPE_PRIMARY', 'CONTROLLER_BOARD_TYPE_PRIMARY', ...
   'CONTROLLER_BOARD_TYPE_SECONDARY', 'CONTROLLER_BOARD_TYPE_SECONDARY', ...
   'CONTROLLER_BOARD_SERIAL_NO_PRIMARY', 'CONTROLLER_BOARD_SERIAL_NO_PRIMA', ...
   'CONTROLLER_BOARD_SERIAL_NO_SECONDARY', 'CONTROLLER_BOARD_SERIAL_NO_SECON', ...
   'SPECIAL_FEATURES', 'SPECIAL_FEATURES', ...
   'FLOAT_OWNER', 'FLOAT_OWNER', ...
   'OPERATING_INSTITUTION', 'OPERATING_INSTITUTION', ...
   'CUSTOMISATION', 'CUSTOMISATION', ...
   'LAUNCH_DATE', 'PR_LAUNCH_DATETIME', ...
   'LAUNCH_LATITUDE', 'PR_LAUNCH_LATITUDE', ...
   'LAUNCH_LONGITUDE', 'PR_LAUNCH_LONGITUDE', ...
   'LAUNCH_QC', 'LAUNCH_QC', ...
   'START_DATE', 'START_DATE', ...
   'START_DATE_QC', 'START_DATE_QC', ...
   'STARTUP_DATE', '', ...
   'STARTUP_DATE_QC', '', ...
   'DEPLOYMENT_PLATFORM', 'DEPLOY_PLATFORM', ...
   'DEPLOYMENT_CRUISE_ID', 'DEPLOY_MISSION', ...
   'DEPLOYMENT_REFERENCE_STATION_ID', 'DEPLOY_AVAILABLE_PROFILE_ID', ...
   'END_MISSION_DATE', 'END_MISSION_DATE', ...
   'END_MISSION_STATUS', 'END_MISSION_STATUS', ...
   'PREDEPLOYMENT_CALIB_EQUATION', 'PREDEPLOYMENT_CALIB_EQUATION', ...
   'PREDEPLOYMENT_CALIB_COEFFICIENT', 'PREDEPLOYMENT_CALIB_COEFFICIENT', ...
   'PREDEPLOYMENT_CALIB_COMMENT', 'PREDEPLOYMENT_CALIB_COMMENT', ...
   'CALIB_RT_PARAMETER', 'CALIB_RT_PARAMETER', ...
   'CALIB_RT_EQUATION', 'CALIB_RT_EQUATION', ...
   'CALIB_RT_COEFFICIENT', 'CALIB_RT_COEFFICIENT', ...
   'CALIB_RT_COMMENT', 'CALIB_RT_COMMENT', ...
   'CALIB_RT_DATE', 'CALIB_RT_DATE');

return;
