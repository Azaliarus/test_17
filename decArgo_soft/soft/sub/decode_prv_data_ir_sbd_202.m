% ------------------------------------------------------------------------------
% Decode PROVOR packet data.
%
% SYNTAX :
%  [o_tabTech, ...
%    o_dataCTD, o_dataCTDO, ...
%    o_evAct, o_pumpAct, o_floatParam, o_deepCycle] = ...
%    decode_prv_data_ir_sbd_202(a_tabData, a_tabDataDates, a_procLevel, a_firstDeepCycleDone)
%
% INPUT PARAMETERS :
%   a_tabData            : data frame to decode
%   a_tabDataDates       : corresponding dates of Iridium SBD
%   a_procLevel          : processing level (0: collect only rough information, 1:
%                          decode the data)
%   a_firstDeepCycleDone : 1 if the first deep cycle has been done, 0 otherwise
%
% OUTPUT PARAMETERS :
%   o_tabTech     : decoded technical data
%   o_dataCTD     : decoded data from CTD
%   o_dataCTDO    : decoded data from CTD + Optode
%   o_evAct       : decoded hydraulic (EV) data
%   o_pumpAct     : decoded hydraulic (pump) data
%   o_floatParam  : decoded parameter data
%   o_deepCycle   : deep cycle flag (1 if it is a deep cycle 0 otherwise
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   12/03/2014 - RNU - creation
% ------------------------------------------------------------------------------
function [o_tabTech, ...
   o_dataCTD, o_dataCTDO, ...
   o_evAct, o_pumpAct, o_floatParam, o_deepCycle] = ...
   decode_prv_data_ir_sbd_202(a_tabData, a_tabDataDates, a_procLevel, a_firstDeepCycleDone)

% output parameters initialization
o_tabTech = [];
o_dataCTD = [];
o_dataCTDO = [];
o_evAct = [];
o_pumpAct = [];
o_floatParam = [];
o_deepCycle = [];

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% default values
global g_decArgo_janFirst1950InMatlab;
global g_decArgo_dateDef;
global g_decArgo_presCountsDef;
global g_decArgo_tempCountsDef;
global g_decArgo_salCountsDef;
global g_decArgo_c1C2PhaseDoxyCountsDef;
global g_decArgo_tempDoxyCountsDef;
global g_decArgo_durationDef;

% arrays to store rough information on received data
global g_decArgo_0TypePacketReceivedFlag;
global g_decArgo_4TypePacketReceivedFlag;
global g_decArgo_5TypePacketReceivedFlag;
global g_decArgo_nbOf1Or8Or11Or14TypePacketExpected;
global g_decArgo_nbOf1Or8Or11Or14TypePacketReceived;
global g_decArgo_nbOf2Or9Or12Or15TypePacketExpected;
global g_decArgo_nbOf2Or9Or12Or15TypePacketReceived;
global g_decArgo_nbOf3Or10Or13Or16TypePacketExpected;
global g_decArgo_nbOf3Or10Or13Or16TypePacketReceived;

% offset between float days and julian days
global g_decArgo_julD2FloatDayOffset;

% decoder configuration values
global g_decArgo_generateNcTech;


% if it is the first deep cycle or if the first deep cycle already occured, we
% add 1 to cycle numbers
if (a_procLevel ~= 0)
   if (a_firstDeepCycleDone == 0)
      
      % we try to find if it is the first deep cycle
      idTech1Packet = find(a_tabData(:, 1) == 0);
      for idMes = 1:length(idTech1Packet)

         % message data frame
         msgData = a_tabData(idTech1Packet(idMes), 2:end);
         
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            16 ...
            8 8 8 16 16 16 8 8 ...
            16 16 16 8 8 16 16 ...
            8 8 8 16 16 8 8 ...
            16 16 8 8 16 ...
            8 8 8 8 16 16 ...
            16 16 8 ...
            8 8 8  repmat(8, 1, 9) ...
            8 8 16 8 8 8 16 8 8 16 8 ...
            repmat(8, 1, 2) ...
            repmat(8, 1, 7) ...
            16 8 16 ...
            repmat(8, 1, 4) ...
            ];
         % get item bits
         tabTech = get_bits(firstBit, tabNbBits, msgData);
         
         % if the cycle start time is present, it is a deep cycle
         startDateInfo = [tabTech(2:4); tabTech(6)];
         if ~((length(unique(startDateInfo)) == 1) && (unique(startDateInfo) == 0))
            a_firstDeepCycleDone = 1;
            break;
         end         
      end
   end
end

% decode packet data
for idMes = 1:size(a_tabData, 1)
   % packet type
   packType = a_tabData(idMes, 1);
   
   % date of the SBD file
   sbdFileDate = a_tabDataDates(idMes);
   
   tabDate = [];
   tabPres = [];
   tabTemp = [];
   tabPsal = [];
   tabC1Phase = [];
   tabC2Phase = [];
   tabTempDoxy = [];
   tabDuration = [];
   switch (packType)
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case 0
         % float technical #1 packet
         
         if (a_procLevel == 0)
            g_decArgo_0TypePacketReceivedFlag = 1;
            continue;
         end
         
         % message data frame
         msgData = a_tabData(idMes, 2:end);
         
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            16 ...
            8 8 8 16 16 16 8 8 ...
            16 16 16 8 8 16 16 ...
            8 8 8 16 16 8 8 ...
            16 16 8 8 16 ...
            8 8 8 8 16 16 ...
            16 16 8 ...
            8 8 8  repmat(8, 1, 9) ...
            8 8 16 8 8 8 16 8 8 16 8 ...
            repmat(8, 1, 2) ...
            repmat(8, 1, 7) ...
            16 8 16 ...
            repmat(8, 1, 4) ...
            ];
         % get item bits
         tabTech = get_bits(firstBit, tabNbBits, msgData);
         tabTech(1) = tabTech(1) + a_firstDeepCycleDone;
         
         % set cycle number
         g_decArgo_cycleNum = tabTech(1);
         fprintf('cyle #%d\n', g_decArgo_cycleNum);

         % compute the offset between float days and julian days
         startDateInfo = [tabTech(2:4); tabTech(6)];
         if ~((length(unique(startDateInfo)) == 1) && (unique(startDateInfo) == 0))
            cycleStartDateDay = datenum(sprintf('%02d%02d%02d', tabTech(2:4)), 'ddmmyy') - g_decArgo_janFirst1950InMatlab;
            if (~isempty(g_decArgo_julD2FloatDayOffset))
               if (g_decArgo_julD2FloatDayOffset ~= cycleStartDateDay - tabTech(5))
                  fprintf('ERROR: Float #%d: Shift in float day (previous offset = %d, new offset = %d)\n', ...
                     g_decArgo_floatNum, ...
                     g_decArgo_julD2FloatDayOffset, ...
                     cycleStartDateDay - tabTech(5));
               end
            end
            g_decArgo_julD2FloatDayOffset = cycleStartDateDay - tabTech(5);
            
            % if the cycle start time is present, it is a deep cycle
            o_deepCycle = 1;
         else
            % if the cycle start time is not present, the transmission has been
            % done during the prelude or a second Iridium session or in EOL mode
            o_deepCycle = 0;
         end
         
         % compute float time
         floatTime = datenum(sprintf('%02d%02d%02d%02d%02d%02d', tabTech(38:43)), 'HHMMSSddmmyy') - g_decArgo_janFirst1950InMatlab;
                  
         % compute GPS location
         if (tabTech(53) == 0)
            signLat = 1;
         else
            signLat = -1;
         end
         gpsLocLat = signLat*(tabTech(50) + (tabTech(51) + ...
            tabTech(52)/10000)/60);
         if (tabTech(57) == 0)
            signLon = 1;
         else
            signLon = -1;
         end
         gpsLocLon = signLon*(tabTech(54) + (tabTech(55) + ...
            tabTech(56)/10000)/60);
         
         tabTech = [packType tabTech(1:76)' ones(1, 4)*-1 floatTime gpsLocLon gpsLocLat sbdFileDate];
         
         o_tabTech = [o_tabTech; tabTech];
         
         % output NetCDF files
         if (g_decArgo_generateNcTech ~= 0)
            store_tech1_data_for_nc_201_202_203(o_tabTech, o_deepCycle);
         end

         %          fprintf('Packet type : %d\n', packType);
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case 4
         % float technical #2 packet
         
         % message data frame
         msgData = a_tabData(idMes, 2:end);
         
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            8 8 8 16 16 8 16 16 ...
            repmat(16, 1, 6) ...
            8 16 8 16 8 8 16 8 16 8 8 ...
            8 16 16 8 8 ...
            repmat(8, 1, 9) ...
            repmat(8, 1, 44) ...
            ];
         % get item bits
         tabTech = get_bits(firstBit, tabNbBits, msgData);
         
         if (a_procLevel == 0)
            g_decArgo_4TypePacketReceivedFlag = 1;
            g_decArgo_nbOf1Or8Or11Or14TypePacketExpected = tabTech(1);
            g_decArgo_nbOf2Or9Or12Or15TypePacketExpected = tabTech(2);
            g_decArgo_nbOf3Or10Or13Or16TypePacketExpected = tabTech(3);
            continue;
         end
                  
         tabTech = [packType tabTech(1:83)' sbdFileDate];
         
         o_tabTech = [o_tabTech; tabTech];
         
         % output NetCDF files
         if (g_decArgo_generateNcTech ~= 0)
            store_tech2_data_for_nc_202(o_tabTech, o_deepCycle);
         end
         
         %          fprintf('Packet type : %d\n', packType);
         %          fprintf('- nb packets CTDO desc. : %d\n', tabTech(2));
         %          fprintf('- nb packets CTDO drift : %d\n', tabTech(3));
         %          fprintf('- nb packets CTDO asc. : %d\n', tabTech(4));
         %          fprintf('- nb meas CTDO desc. : %d\n', tabTech(5)+tabTech(6));
         %          fprintf('- nb meas CTDO drift : %d\n', tabTech(7));
         %          fprintf('- nb meas CTDO asc. : %d\n', tabTech(8)+tabTech(9));
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case {1, 2, 3}
         % CTD packets
         
         if (a_procLevel == 0)
            if (packType == 1)
               g_decArgo_nbOf1Or8Or11Or14TypePacketReceived = g_decArgo_nbOf1Or8Or11Or14TypePacketReceived + 1;
            elseif (packType == 2)
               g_decArgo_nbOf2Or9Or12Or15TypePacketReceived = g_decArgo_nbOf2Or9Or12Or15TypePacketReceived + 1;
            elseif (packType == 3)
               g_decArgo_nbOf3Or10Or13Or16TypePacketReceived = g_decArgo_nbOf3Or10Or13Or16TypePacketReceived + 1;
            end
            continue;
         end
         
         % message data frame
         msgData = a_tabData(idMes, 2:end);
         
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            16 8 8 ...
            repmat(16, 1, 48) ...
            repmat(8, 1, 5) ...
            ];
         % get item bits
         ctdValues = get_bits(firstBit, tabNbBits, msgData);
         
         % there are 15 PTS measurements per packet
         
         % store raw data values
         nbMeas = 0;
         for idBin = 1:15
            if (idBin > 1)
               measDate = g_decArgo_dateDef;
            else
               measDate = ctdValues(1)/24 + ...
                  ctdValues(2)/1440 + ctdValues(3)/86400;
            end
            
            pres = ctdValues(3*(idBin-1)+4);
            temp = ctdValues(3*(idBin-1)+5);
            psal = ctdValues(3*(idBin-1)+6);
            
            if ~((pres == 0) && (temp == 0) && (psal == 0))
               tabDate = [tabDate; measDate];
               tabPres = [tabPres; pres];
               tabTemp = [tabTemp; temp];
               tabPsal = [tabPsal; psal];
               nbMeas = nbMeas + 1;
            else
               tabDate = [tabDate; g_decArgo_dateDef];
               tabPres = [tabPres; g_decArgo_presCountsDef];
               tabTemp = [tabTemp; g_decArgo_tempCountsDef];
               tabPsal = [tabPsal; g_decArgo_salCountsDef];
            end
         end
         
         o_dataCTD = [o_dataCTD; ...
            packType tabDate' ones(1, length(tabDate))*-1 tabPres' tabTemp' tabPsal'];
         
         %          fprintf('Packet type : %d\n', packType);
         %          fprintf('- nb meas CTD : %d\n', nbMeas);
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case {8, 9, 10}
         % CTDO packets
         
         if (a_procLevel == 0)
            if (packType == 8)
               g_decArgo_nbOf1Or8Or11Or14TypePacketReceived = g_decArgo_nbOf1Or8Or11Or14TypePacketReceived + 1;
            elseif (packType == 9)
               g_decArgo_nbOf2Or9Or12Or15TypePacketReceived = g_decArgo_nbOf2Or9Or12Or15TypePacketReceived + 1;
            elseif (packType == 10)
               g_decArgo_nbOf3Or10Or13Or16TypePacketReceived = g_decArgo_nbOf3Or10Or13Or16TypePacketReceived + 1;
            end
            continue;
         end
         
         % message data frame
         msgData = a_tabData(idMes, 2:end);
         
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            16 8 8 ...
            repmat(16, 1, 42) ...
            repmat(8, 1, 11) ...
            ];
         % get item bits
         ctdoValues = get_bits(firstBit, tabNbBits, msgData);
         
         % there are 7 PTSO measurements per packet
         
         % store raw data values
         nbMeas = 0;
         for idBin = 1:7
            if (idBin > 1)
               measDate = g_decArgo_dateDef;
            else
               measDate = ctdoValues(1)/24 + ...
                  ctdoValues(2)/1440 + ctdoValues(3)/86400;
            end
            
            pres = ctdoValues(6*(idBin-1)+4);
            temp = ctdoValues(6*(idBin-1)+5);
            psal = ctdoValues(6*(idBin-1)+6);
            c1Phase = ctdoValues(6*(idBin-1)+7);
            c2Phase = ctdoValues(6*(idBin-1)+8);
            tempDoxy = ctdoValues(6*(idBin-1)+9);
            
            if ~((pres == 0) && (temp == 0) && (psal == 0) && (c1Phase == 0) && (c2Phase == 0) && (tempDoxy == 0))
               tabDate = [tabDate; measDate];
               tabPres = [tabPres; pres];
               tabTemp = [tabTemp; temp];
               tabPsal = [tabPsal; psal];
               tabC1Phase = [tabC1Phase; c1Phase];
               tabC2Phase = [tabC2Phase; c2Phase];
               tabTempDoxy = [tabTempDoxy; tempDoxy];
               nbMeas = nbMeas + 1;
            else
               tabDate = [tabDate; g_decArgo_dateDef];
               tabPres = [tabPres; g_decArgo_presCountsDef];
               tabTemp = [tabTemp; g_decArgo_tempCountsDef];
               tabPsal = [tabPsal; g_decArgo_salCountsDef];
               tabC1Phase = [tabC1Phase; g_decArgo_c1C2PhaseDoxyCountsDef];
               tabC2Phase = [tabC2Phase; g_decArgo_c1C2PhaseDoxyCountsDef];
               tabTempDoxy = [tabTempDoxy; g_decArgo_tempDoxyCountsDef];
            end
         end
         
         o_dataCTDO = [o_dataCTDO; ...
            packType tabDate' ones(1, length(tabDate))*-1 tabPres' tabTemp' tabPsal' tabC1Phase' tabC2Phase' tabTempDoxy'];
         
         %          fprintf('Packet type : %d\n', packType);
         %          fprintf('- nb meas CTDO : %d\n', nbMeas);
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case {6, 7}
         % EV or pump packet
         
         if (a_procLevel == 0)
            continue;
         end
         
         % message data frame
         msgData = a_tabData(idMes, 2:end);
         
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            16 16 ...
            repmat(16, 1, 45) ...
            repmat(8, 1, 5) ...
            ];
         % get item bits
         tabHy = get_bits(firstBit, tabNbBits, msgData);
         
         % there are 15 EV actions per packet
         
         % store data values
         nbAct = 0;
         for idBin = 1:15
            if (idBin == 1)
               refDate = tabHy(1) + tabHy(2)/1440;
            end
            
            refTime = tabHy(3*(idBin-1)+3);
            pres = tabHy(3*(idBin-1)+4);
            duration = tabHy(3*(idBin-1)+5);
            
            if ~((refTime == 0) && (pres == 0) && (duration == 0))
               tabDate = [tabDate; refDate+refTime/1440];
               tabPres = [tabPres; pres];
               tabDuration = [tabDuration; duration];
               nbAct = nbAct + 1;
            else
               tabDate = [tabDate; g_decArgo_dateDef];
               tabPres = [tabPres; g_decArgo_presCountsDef];
               tabDuration = [tabDuration; g_decArgo_durationDef];
            end
         end
         
         if (packType == 6)
            o_evAct = [o_evAct; ...
               packType tabDate' tabPres' tabDuration'];
         else
            o_pumpAct = [o_pumpAct; ...
               packType tabDate' tabPres' tabDuration'];
         end
         
         %          fprintf('Packet type : %d\n', packType);
         %          fprintf('- nb act Hydrau : %d\n', nbAct);
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case 5
         % parameter packet
         
         if (a_procLevel == 0)
            g_decArgo_5TypePacketReceivedFlag = 1;
            continue;
         end
         
         % message data frame
         msgData = a_tabData(idMes, 2:end);
         
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            repmat(8, 1, 6) 16 ...
            16 repmat(8, 1, 6) 16 16 8 16 8 8 8 16 16 8 ...
            repmat(8, 1, 6) 16 repmat(8, 1, 5) 16 repmat(8, 1, 4) 16 repmat(8, 1, 6) 16 16 ...
            repmat(8, 1, 37) ...
            ];
         % get item bits
         tabParam = get_bits(firstBit, tabNbBits, msgData);
         tabParam(7) = tabParam(7) + 1; % because it is the next deep cycle (thus +1)
         
         % compute float time
         floatTime = datenum(sprintf('%02d%02d%02d%02d%02d%02d', tabParam(1:6)), 'HHMMSSddmmyy') - g_decArgo_janFirst1950InMatlab;
         
         % calibration coefficients
         tabParam(49) = tabParam(49)/1000;
         tabParam(50) = -tabParam(50);
         
         o_floatParam = [o_floatParam; ...
            packType tabParam' floatTime sbdFileDate];
         
         %          fprintf('Packet type : %d\n', packType);
         
      otherwise
         fprintf('WARNING: Float #%d: Nothing done yet for packet type #%d\n', ...
            g_decArgo_floatNum, ...
            packType);
   end
end

return;
