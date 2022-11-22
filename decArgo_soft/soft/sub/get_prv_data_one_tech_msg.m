% ------------------------------------------------------------------------------
% Read a PROVOR Argos file and select the data to decode.
%
% SYNTAX :
%  [o_argosLocDate, o_argosLocLon, o_argosLocLat, o_argosLocAcc, o_argosLocSat, ...
%    o_argosDataDate, o_argosDataData, o_sensors, o_sensorDates, ...
%    o_lastArgosCtdMsgDate, ...
%    o_surfTempDate, o_surfTempVal] = ...
%    get_prv_data_one_tech_msg(a_argosFileName, a_argosId, a_frameLength, a_bitsToFreeze, a_decoderId)
%
% INPUT PARAMETERS :
%   a_argosFileName : Argos file name
%   a_argosId       : Argos Id
%   a_frameLength   : Argos data frame length
%   a_bitsToFreeze  : bits to freeze for each message type before the
%                     redundancy step
%                     contents of "a_bitsToFreeze" array:
%                     column #1: concerned message type
%                     column #2: first bit to freeze
%                     column #3: number of bits to freeze
%   a_decoderId     : float decoder Id
%
% OUTPUT PARAMETERS :
%   o_argosLocDate        : Argos location dates
%   o_argosLocLon         : Argos location longitudes
%   o_argosLocDate        : Argos location latitudes
%   o_argosDataDate       : Argos message dates
%   o_argosDataData       : original Argos data
%   o_argosLocAcc         : Argos location classes
%   o_argosLocSat         : Argos location satellite names
%   o_sensors             : selected data
%                           contents of "o_sensors" array:
%                           column #1                      : message type
%                           column #2                      : message redundancy
%                           column #3 to #(a_frameLength+2): message data frame
%   o_sensorDates         : Argos message dates of selected data
%   o_lastArgosCtdMsgDate : date of the last Argos CTD message received
%   o_surfTempDate        : dates of surface temperature measurements
%   o_surfTempVal         : surface temperature measurements
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   01/02/2010 - RNU - creation
% ------------------------------------------------------------------------------
function [o_argosLocDate, o_argosLocLon, o_argosLocLat, o_argosLocAcc, o_argosLocSat, ...
   o_argosDataDate, o_argosDataData, o_sensors, o_sensorDates, ...
   o_lastArgosCtdMsgDate, ...
   o_surfTempDate, o_surfTempVal] = ...
   get_prv_data_one_tech_msg(a_argosFileName, a_argosId, a_frameLength, a_bitsToFreeze, a_decoderId)

% output parameters initialization
o_argosLocDate = [];
o_argosLocLon = [];
o_argosLocLat = [];
o_argosLocAcc = [];
o_argosLocSat = [];
o_sensors = [];
o_sensorDates = [];
o_lastArgosCtdMsgDate = [];
o_surfTempDate = [];
o_surfTempVal = [];

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

% configuration values
global g_decArgo_generateNcTech;

% default values
global g_decArgo_dateDef;

% criteria for Life Expiry Message detection
NUMBER_OF_SUCCESSIVE_TECH_MSG = 15;


for id = 1:length(a_argosFileName)
   if ~(exist(char(a_argosFileName{id}), 'file') == 2)
      fprintf('ERROR: Argos file not found: %s\n', char(a_argosFileName{id}));
      return;
   end
end

% read Argos file
[o_argosLocDate, o_argosLocLon, o_argosLocLat, o_argosLocAcc, o_argosLocSat, ...
   o_argosDataDate, o_argosDataData] = read_argos_file(a_argosFileName, a_argosId, a_frameLength);

% for CTS3 V4.21
if (a_decoderId == 11)
   o_argosDataData(:, 1) = [];
end

nbMesTot = size(o_argosDataData, 1);
firstArgosMsgDate = min([o_argosLocDate; o_argosDataDate]);
lastArgosMsgDate = max([o_argosLocDate; o_argosDataDate]);

% select Argos data

% for the technical message :
% 1 - we consider all the messages with a good CRC
% 2 - we select the most redundant one
% 3 - if there is no message with a good CRC we try to combine the received ones

% select only the Argos messages with a good CRC
idMsgCrcOk = 0;
tabSensors = [];
tabDates = [];
nbMesCrcKo = 0;
for idMsg = 1:size(o_argosDataData, 1)
   sensor = o_argosDataData(idMsg, :);
   
   if (check_crc_prv(sensor, a_decoderId) == 1)
      % CRC check succeeded
      idMsgCrcOk = idMsgCrcOk + 1;
      tabSensors(idMsgCrcOk, :) = sensor';
      tabDates(idMsgCrcOk) = o_argosDataDate(idMsg);
   else
      % CRC check failed
      nbMesCrcKo = nbMesCrcKo + 1;
   end
end
if (~isempty(o_argosDataData) && (idMsgCrcOk == 0))
   fprintf('WARNING: Float #%d: The CRC check failed for all of the %d received Argos float messages\n', ...
      g_decArgo_floatNum, ...
      size(o_argosDataData, 1));
end

% try to detect a Life Expiry Message sequence (i.e. a End Of Life phase)
% the Life Expiry Messages should be removed from the data to process because
% only one technical message (the "moste redundant" one) is selected for each
% cycle and this should not be a Life Expiry Message sequence (if we have
% received at least a copy of the "nominal" technical message)
eol_detected = 0;
if (~isempty(tabSensors))
   
   % during cycle #0, ARVOR and PROVOR CTS3.1 floats stay a the surface and emit technical
   % message, this prelude phase should not be taken as an End Of Life phase
   floatWithPreludeList = [3 17 24 25 27 28 29 31];
   if (~ismember(a_decoderId, floatWithPreludeList) || ...
         (ismember(a_decoderId, floatWithPreludeList) && (g_decArgo_cycleNum >= 0)))

      % get the types of the received messages
      tabType = get_message_type(tabSensors, a_decoderId);
      
      nbTechMsg = length(find(tabType == 0));
      if (nbTechMsg >= NUMBER_OF_SUCCESSIVE_TECH_MSG)
         % compute the number of consecutive technical messages received at the end
         % of the transmission
         lastDataMsg = find(flipud(tabType) ~= 0, 1);
         if (~isempty(lastDataMsg))
            nbFinalTechMsg = lastDataMsg - 1;
            % preserve only one technical message in the received messages
            if (isempty(find(tabType(1:end-nbFinalTechMsg) == 0)))
               nbTechToDel = nbFinalTechMsg - 1;
            else
               nbTechToDel = nbFinalTechMsg;
            end
         else
            % all the received messages are technical ones
            nbFinalTechMsg = length(tabType);
            nbTechToDel = nbFinalTechMsg;
         end
         if (nbFinalTechMsg >= NUMBER_OF_SUCCESSIVE_TECH_MSG)
            firstToDel = length(tabType) - nbTechToDel + 1;
            
            %             fprintf('INFO: Float #%d Cycle #%d: End Of Life cycle detected %d Life Expiry Messages ignored (from %s to %s)\n', ...
            fprintf('DEC_INFO: Float #%d Cycle #%d: PRELUDE or EOL cycle detected %d Life Expiry Messages ignored (from %s to %s)\n', ...
               g_decArgo_floatNum, g_decArgo_cycleNum, ...
               nbTechToDel, ...
               julian_2_gregorian_dec_argo(tabDates(firstToDel)), ...
               julian_2_gregorian_dec_argo(tabDates(end)));
            
            tabSensors(firstToDel:end, :) = [];
            tabDates(firstToDel:end) = [];
            eol_detected = 1;
         end
      end
   end
end

% select the "most redundant " technical message (only one technical message is
% transmitted)
if (~isempty(tabSensors))
   
   tabData = [];
   tabDate = [];
   tabOcc = [];
   tabFrozenValues = [];
   
   % retrieve bits to freeze for the technical message
   idBitsToFreeze = find(a_bitsToFreeze(:, 1) == 0);
   firstBitToFreeze = a_bitsToFreeze(idBitsToFreeze, 2);
   nbBitsToFreeze = a_bitsToFreeze(idBitsToFreeze, 3);
   
   % select and process the technical messages received
   idForType = find(get_message_type(tabSensors, a_decoderId) == 0);
   for id = 1:length(idForType)
      currentData = tabSensors(idForType(id), :);
      
      % freeze bits for the redundancy step
      [currentData, frozenValues] = ...
         set_bits(zeros(1, length(firstBitToFreeze)), ...
         firstBitToFreeze, nbBitsToFreeze, currentData);
      
      % don't take NULL data message into account
      if (unique(currentData) == 0)
         continue;
      end
      
      % compute the redundancy of the messages
      ok = 0;
      for idData = 1:size(tabData, 1)
         comp = (tabData(idData, :) == currentData);
         if (isempty(find(comp == 0, 1)))
            % already received message, update the redundancy
            % counter
            tabOcc(idData) = tabOcc(idData) + 1;
            ok = 1;
            break;
         end
      end
      
      if (ok == 0)
         % never received message, initialize the redundancy counter
         tabData = [tabData; currentData];
         tabDate = [tabDate; tabDates(idForType(id))];
         tabOcc = [tabOcc; 1];
         tabFrozenValues = [tabFrozenValues; frozenValues];
      end
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % SPECIFIC TO 6900139 & 6900235 FLOATS : BEGIN
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % floats 6900139 & 6900235 have emitted at the same time with the same Argos
   % Id, we try to select the technical message of each float using its RTC
   % clock drift
   
   % for float 6900139, clock drift is less than 10 minutes
   % for float 6900235, clock drift is around 1 hour
   if ((g_decArgo_floatNum == 6900139) || (g_decArgo_floatNum == 6900235))
      dontStop = 1;
      while (dontStop)
         % select the "most redundant" technical message
         [valMax, idMax] = max(tabOcc);
         
         % replace the original frozen values
         data = tabData(idMax, :);
         [data, unused] = ...
            set_bits(tabFrozenValues(idMax, :), ...
            firstBitToFreeze, nbBitsToFreeze, data);
         
         % compute clock float drift
         firstBit = 183;
         tabNbBits = [5 6 6];
         floatTimeParts = get_bits(firstBit, tabNbBits, data);
         floatTimeHour = floatTimeParts(1) + floatTimeParts(2)/60 + floatTimeParts(3)/3600;
         utcTimeJuld = tabDate(idMax);
         floatTimeJuld = fix(utcTimeJuld)+floatTimeHour/24;
         tabFloatTimeJuld = [floatTimeJuld-1 floatTimeJuld floatTimeJuld+1];
         [unused, idMin] = min(abs(tabFloatTimeJuld-utcTimeJuld));
         floatTimeJuld = tabFloatTimeJuld(idMin);
         floatClockDrift = floatTimeJuld - utcTimeJuld;
         
         if (g_decArgo_floatNum == 6900139)
            if (floatClockDrift > 30/1440)
               tabData(idMax, :) = [];
               tabDate(idMax) = [];
               tabOcc(idMax) = [];
               tabFrozenValues(idMax, :) = [];
            else
               dontStop = 0;
            end
         else
            if (floatClockDrift > 30/1440)
               tabData(idMax, :) = [];
               tabDate(idMax) = [];
               tabOcc(idMax) = [];
               tabFrozenValues(idMax, :) = [];
            else
               dontStop = 0;
            end
         end
      end
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % SPECIFIC TO 6900139 & 6900235 FLOATS : END
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % select the "most redundant" technical message
   if (~isempty(tabOcc))
      
      [valMax, idMax] = max(tabOcc);
      
      % output NetCDF files
      if (g_decArgo_generateNcTech ~= 0)
         g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
            g_decArgo_cycleNum 22];
         g_decArgo_outputNcParamValue{end+1} = valMax;
      end
      
      % replace the original frozen values
      data = tabData(idMax, :);
      [data, unused] = ...
         set_bits(tabFrozenValues(idMax, :), ...
         firstBitToFreeze, nbBitsToFreeze, data);
      
      % store the data
      o_sensors = [o_sensors; 0 valMax data];
      o_sensorDates = [o_sensorDates; tabDate(idMax)];
      
   end
else
   
   % there is no technical message with a good CRC
   
   % to be sure that all the received technical messages are not Life Expiry
   % Messages (and thus previously removed)
   if (eol_detected == 0)
      
      % process all the received technical messages
      idForTechMsg = find(get_message_type(o_argosDataData, a_decoderId) == 0);
      
      tabSensors = o_argosDataData(idForTechMsg, :);
      tabDates = o_argosDataDate(idForTechMsg);
      
      if (length(idForTechMsg) > 1)
         
         tabData = [];
         tabDate = [];
         tabFrozenValues = [];
         
         % retrieve bits to freeze for the technical message
         idBitsToFreeze = find(a_bitsToFreeze(:, 1) == 0);
         firstBitToFreeze = a_bitsToFreeze(idBitsToFreeze, 2);
         nbBitsToFreeze = a_bitsToFreeze(idBitsToFreeze, 3);
         
         % freeze the bits of the received messages
         for id = 1:length(idForTechMsg)
            currentData = tabSensors(id, :);
            
            % freeze the bits
            [currentData, frozenValues] = ...
               set_bits(zeros(1, length(firstBitToFreeze)), ...
               firstBitToFreeze, nbBitsToFreeze, currentData);
            
            % store the data
            tabData = [tabData; currentData];
            tabDate = [tabDate; tabDates(id)];
            tabFrozenValues = [tabFrozenValues; frozenValues];
         end
         
         % create a new message by combining the bits of the received ones
         [combinedData] = combine_bits_prv(tabData);
         
         % replace the frozen values in the combined message and check the
         % CRC of the created message
         combinedOk = 0;
         for id = 1:length(idForTechMsg)
            
            % replace the original frozen values
            [combinedMsg, unused] = ...
               set_bits(tabFrozenValues(id, :), ...
               firstBitToFreeze, nbBitsToFreeze, combinedData);
            
            % check the CRC of the message
            if (check_crc_prv(combinedMsg, a_decoderId) == 1)
               % store the data
               o_sensors = [o_sensors; 0 0 combinedMsg];
               o_sensorDates = [o_sensorDates; tabDate(id)];
               
               %                fprintf('@#@ float %d : cycle #%d : technical msg sucessfully combined (%d copies)\n', ...
               %                   g_decArgo_floatNum, g_decArgo_cycleNum, length(idForTechMsg));
               combinedOk = 1;
               
               break;
            end
         end
         
         if (combinedOk == 0)
            %             fprintf('@#@ float %d : cycle #%d : technical msg unsucessfully combined (%d copies)\n', ...
            %                g_decArgo_floatNum, g_decArgo_cycleNum, length(idForTechMsg));
         end
      end
   end
   
end

% for the data messages :
% 1 - we consider all the received messages
% 2 - we compute an Id for each message
% 3 - we try to select at most one message for each Id

% retrieve the types of all the received messages (only the types 4, 5 and 6
% will be processed)
tabType = get_message_type(o_argosDataData, a_decoderId);

% process all the received data messages
tabArgosCtdMsgDates = [];
typeNum = [4 5 6];
for idType = 1:length(typeNum)
   
   idForType = find(tabType == typeNum(idType));
   if (~isempty(idForType))
      
      tabSensors = o_argosDataData(idForType, :);
      tabDates = o_argosDataDate(idForType);
      tabIds = ones(length(tabDates), 1)*-1;
      
      % Id creation
      switch (a_decoderId)
         case {1, 3, 4, 11, 12, 17, 19, 24, 25, 27, 28, 29, 31}
            if (typeNum(idType) ~= 5)
               % for profile CTD messages, Id is the time and the pressure
               % of the first CTD measurement
               firstBit = 21;
               tabNbBits = [9 11];
               coef = 2^11;
            else
               % for drift messages, Id is the date and time of the first
               % CTD measurement
               firstBit = 21;
               tabNbBits = [6 5];
               coef = 2^5;
            end
         otherwise
            fprintf('WARNING: Nothing done yet in get_prv_data_one_tech_msg for decoderId #%d\n', ...
               a_decoderId);
      end
      % compute the Id of each message
      for idMsg = 1:length(idForType)
         msgData = tabSensors(idMsg, :);
         values = get_bits(firstBit, tabNbBits, msgData);
         tabIds(idMsg) = values(1)*coef+values(2);
      end
      
      % data selection (select at most one message per Id)
      uniqueIds = unique(tabIds);
      for idId = 1:length(uniqueIds)
         
         idForId = find(tabIds == uniqueIds(idId));
         
         idForIdCrcOk = [];
         for id = 1:length(idForId)
            if (check_crc_prv(tabSensors(idForId(id), :), a_decoderId) == 1)
               idForIdCrcOk = [idForIdCrcOk idForId(id)];
            end
         end
         
         % there are messages with good CRC
         if (~isempty(idForIdCrcOk))
            
            % select the "most redundant" message with a good CRC
            tabData = [];
            tabDate = [];
            tabOcc = [];
            tabFrozenValues = [];
            
            % retrieve bits to freeze for this message type
            idBitsToFreeze = find(a_bitsToFreeze(:, 1) == typeNum(idType));
            firstBitToFreeze = a_bitsToFreeze(idBitsToFreeze, 2);
            nbBitsToFreeze = a_bitsToFreeze(idBitsToFreeze, 3);
            
            % select and process the messages
            for id = 1:length(idForIdCrcOk)
               currentData = tabSensors(idForIdCrcOk(id), :);
               
               % freeze bits for the redundancy step
               [currentData, frozenValues] = ...
                  set_bits(zeros(1, length(firstBitToFreeze)), ...
                  firstBitToFreeze, nbBitsToFreeze, currentData);
               
               % don't take NULL data message into account
               if (unique(currentData) == 0)
                  continue;
               end
               
               % compute the redundancy of the messages
               ok = 0;
               for idData = 1:size(tabData, 1)
                  comp = (tabData(idData, :) == currentData);
                  if (isempty(find(comp == 0, 1)))
                     % already received message, update the redundancy
                     % counter
                     tabOcc(idData) = tabOcc(idData) + 1;
                     ok = 1;
                     break;
                  end
               end
               
               if (ok == 0)
                  % never received message, initialize the redundancy counter
                  tabData = [tabData; currentData];
                  tabDate = [tabDate; tabDates(idForIdCrcOk(id))];
                  tabOcc = [tabOcc; 1];
                  tabFrozenValues = [tabFrozenValues; frozenValues];
               end
            end
            
            % select the "most redundant" message
            if (~isempty(tabOcc))
               
               [valMax, idMax] = max(tabOcc);
               
               % replace the original frozen values
               data = tabData(idMax, :);
               [data, unused] = ...
                  set_bits(tabFrozenValues(idMax, :), ...
                  firstBitToFreeze, nbBitsToFreeze, data);
               
               % store the data
               o_sensors = [o_sensors; typeNum(idType) valMax data];
               o_sensorDates = [o_sensorDates; tabDate(idMax)];
               tabArgosCtdMsgDates = [tabArgosCtdMsgDates; tabDate(idMax)];
            end
            
         else
            
            % no message has been received with a good CRC for this Id
            if (length(idForId) > 1)
               
               tabData = [];
               tabDate = [];
               tabFrozenValues = [];
               
               % retrieve bits to freeze for this message type
               idBitsToFreeze = find(a_bitsToFreeze(:, 1) == typeNum(idType));
               firstBitToFreeze = a_bitsToFreeze(idBitsToFreeze, 2);
               nbBitsToFreeze = a_bitsToFreeze(idBitsToFreeze, 3);
               
               % freeze the bits of the received messages
               for id = 1:length(idForId)
                  currentData = tabSensors(idForId(id), :);
                  
                  % freeze the bits
                  [currentData, frozenValues] = ...
                     set_bits(zeros(1, length(firstBitToFreeze)), ...
                     firstBitToFreeze, nbBitsToFreeze, currentData);
                  
                  % store the data
                  tabData = [tabData; currentData];
                  tabDate = [tabDate; tabDates(idForId(id))];
                  tabFrozenValues = [tabFrozenValues; frozenValues];
               end
               
               % create a new message by combining the bits of the received ones
               [combinedData] = combine_bits_prv(tabData);

               % replace the frozen values in the combined message and check the
               % CRC of the created message
               combinedOk = 0;
               for id = 1:length(idForId)
                  
                  % replace the original frozen values
                  [combinedMsg, unused] = ...
                     set_bits(tabFrozenValues(id, :), ...
                     firstBitToFreeze, nbBitsToFreeze, combinedData);
                  
                  % check the CRC of the message
                  if (check_crc_prv(combinedMsg, a_decoderId) == 1)
                     % store the data
                     o_sensors = [o_sensors; typeNum(idType) 0 combinedMsg];
                     o_sensorDates = [o_sensorDates; tabDate(id)];
                     tabArgosCtdMsgDates = [tabArgosCtdMsgDates; tabDate(id)];
                     
                     %                      fprintf('@#@ float %d : cycle #%d : data msg of type %d sucessfully combined (%d copies)\n', ...
                     %                         g_decArgo_floatNum, g_decArgo_cycleNum, ...
                     %                         typeNum(idType), length(idForId));
                     
                     combinedOk = 1;
                     
                     break;
                  end
               end
               
               if (combinedOk == 0)
                  %                   fprintf('@#@ float %d : cycle #%d : data msg of type %d unsucessfully combined (%d copies)\n', ...
                  %                      g_decArgo_floatNum, g_decArgo_cycleNum, ...
                  %                      typeNum(idType), length(idForId));
               end
            end
         end
      end
   end
end

o_lastArgosCtdMsgDate = g_decArgo_dateDef;
if (~isempty(tabArgosCtdMsgDates))
   o_lastArgosCtdMsgDate = max(tabArgosCtdMsgDates);
end

% output CSV file
if (~isempty(g_decArgo_outputCsvFileId))
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; ARGOS DATA FILE CONTENTS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   
   for id = 1:length(a_argosFileName)
      [pathstr, fileName, ext] = fileparts(char(a_argosFileName{id}));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; Argos data file name; %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, [fileName ext]);
   end
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; Argos data file time span; %s (%s to %s)\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, format_time_dec_argo((lastArgosMsgDate-firstArgosMsgDate)*24), ...
      julian_2_gregorian_dec_argo(firstArgosMsgDate), julian_2_gregorian_dec_argo(lastArgosMsgDate));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; Number of locations received; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, length(o_argosLocDate));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; Number of messages received; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, nbMesTot);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; Number of messages with good CRC; %d; %.f %%\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, nbMesTot-nbMesCrcKo, (nbMesTot-nbMesCrcKo)*100/nbMesTot);
   
   if (~isempty(o_sensors))
      nbDescProf = length(find(o_sensors(:, 1) == 4));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; Number of Descent profile CTD messages received; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, nbDescProf);
      
      nbDrift = length(find(o_sensors(:, 1) == 5));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; Number of Submerged drift CTD messages received; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, nbDrift);
      
      nbAscProf = length(find(o_sensors(:, 1) == 6));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; Number of Ascent profile CTD messages received; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, nbAscProf);
      
      nbTech = length(find(o_sensors(:, 1) == 0));
      if (nbTech > 0)
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; The Technical message has been received\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum);
         idTech = find(o_sensors(:, 1) == 0);
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; Technical message redundancy; %d\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, o_sensors(idTech, 2));
      else
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Info; THE TECHNICAL MESSAGE HAS NOT BEEN RECEIVED\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum);
      end
   end
end

% output NetCDF files
if (g_decArgo_generateNcTech ~= 0)
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 10];
   g_decArgo_outputNcParamValue{end+1} = length(o_argosLocAcc);
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 11];
   g_decArgo_outputNcParamValue{end+1} = sum(char(o_argosLocAcc) == '0');
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 12];
   g_decArgo_outputNcParamValue{end+1} = sum(char(o_argosLocAcc) == '1');
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 13];
   g_decArgo_outputNcParamValue{end+1} = sum(char(o_argosLocAcc) == '2');
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 14];
   g_decArgo_outputNcParamValue{end+1} = sum(char(o_argosLocAcc) == '3');
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 15];
   g_decArgo_outputNcParamValue{end+1} = sum(char(o_argosLocAcc) == 'A');
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 16];
   g_decArgo_outputNcParamValue{end+1} = sum(char(o_argosLocAcc) == 'B');
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 17];
   g_decArgo_outputNcParamValue{end+1} = sum(char(o_argosLocAcc) == 'Z');
   
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 20];
   g_decArgo_outputNcParamValue{end+1} = nbMesTot;
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 21];
   g_decArgo_outputNcParamValue{end+1} = nbMesTot-nbMesCrcKo;
   
   if (~isempty(o_sensors))
      idTech = find(o_sensors(:, 1) == 0);
      if (~isempty(idTech))
         g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
            g_decArgo_cycleNum 22];
         g_decArgo_outputNcParamValue{end+1} = o_sensors(idTech, 2);
      else
         g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
            g_decArgo_cycleNum 22];
         g_decArgo_outputNcParamValue{end+1} = 0;
      end
   else
      g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
         g_decArgo_cycleNum 22];
      g_decArgo_outputNcParamValue{end+1} = 0;
   end
   
   g_decArgo_outputNcParamIndex = [g_decArgo_outputNcParamIndex;
      g_decArgo_cycleNum 1001];
   g_decArgo_outputNcParamValue{end+1} = format_time_hhmmss_dec_argo((lastArgosMsgDate-firstArgosMsgDate)*24);
end

return;
