% ------------------------------------------------------------------------------
% Decode NOVA packet data.
%
% SYNTAX :
%  [o_tabTech, o_dataCTDO, o_dataHydrau, o_dataAck, o_deepCycle] = ...
%    decode_nva_data_ir_sbd_2002(a_tabData, a_tabDataDates, a_procLevel, a_firstDeepCycleDone)
%
% INPUT PARAMETERS :
%   a_tabData            : data frame to decode
%   a_tabDataDates       : corresponding dates of Iridium SBD
%   a_procLevel          : processing level (0: collect only rough information,
%                          1: decode the data)
%   a_firstDeepCycleDone : first deep cycle done flag (1 if the first deep cycle
%                          has been done)
%
% OUTPUT PARAMETERS :
%   o_tabTech    : decoded housekeeping data
%   o_dataCTDO   : decoded sensor data
%   o_dataHydrau : decoded hydraulic data
%   o_dataAck    : decoded acknowledgment data
%   o_deepCycle  : deep cycle flag (1 if it is a deep cycle 0 otherwise)
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   03/04/2016 - RNU - creation
% ------------------------------------------------------------------------------
function [o_tabTech, o_dataCTDO, o_dataHydrau, o_dataAck, o_deepCycle] = ...
   decode_nva_data_ir_sbd_2002(a_tabData, a_tabDataDates, a_procLevel, a_firstDeepCycleDone)

% output parameters initialization
o_tabTech = [];
o_dataCTDO = [];
o_dataHydrau = [];
o_dataAck = [];
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
global g_decArgo_phaseDelayDoxyCountsDef;
global g_decArgo_tempDoxyCountsDef;

% arrays to store rough information on received data
global g_decArgo_1TypePacketReceived;
global g_decArgo_5TypePacketReceived;
global g_decArgo_nbOf2To4TypePacketExpected;
global g_decArgo_nbOf10To29TypePacketExpected;
global g_decArgo_nbOf30To49TypePacketExpected;
global g_decArgo_nbOf50To55TypePacketExpected;
global g_decArgo_nbOf2To4TypePacketReceived;
global g_decArgo_nbOf10To29TypePacketReceived;
global g_decArgo_nbOf30To49TypePacketReceived;
global g_decArgo_nbOf50To55TypePacketReceived;
global g_decArgo_ackPacket;

% decoder configuration values
global g_decArgo_generateNcTech;

% flag to detect a second Iridium session
global g_decArgo_secondIridiumSession;

% max number of CTDO samples in one DOVA sensor data packet
global g_decArgo_maxCTDOSampleInDovaDataPacket;
NB_MEAS_MAX_DOVA = g_decArgo_maxCTDOSampleInDovaDataPacket;


% decode packet data
tabCycleNum = [];
for idMes = 1:size(a_tabData, 1)
   % packet type
   packType = a_tabData(idMes, 1);
   
   % date of the SBD file
   sbdFileDate = a_tabDataDates(idMes);
   
   % message data frame
   msgData = a_tabData(idMes, 3:a_tabData(idMes, 2)+2);
   
   switch (packType)
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case 1
         % housekeeping packet
         
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            repmat(16, 1, 6) ...
            repmat(8, 1, 12) ...
            16 8 16 8 16 8 8 ...
            16 16 repmat(8, 1, 10) 32 32 8 16 8 8 8 16 8 8 8 16 8 8 8 ...
            ];
         % get item bits
         tabTech = get_bits(firstBit, tabNbBits, msgData);
         
         if (a_procLevel == 0)
            g_decArgo_1TypePacketReceived = 1;
            g_decArgo_nbOf2To4TypePacketExpected = tabTech(25);
            g_decArgo_nbOf10To29TypePacketExpected = tabTech(22);
            g_decArgo_nbOf30To49TypePacketExpected = tabTech(20);
            g_decArgo_nbOf50To55TypePacketExpected = tabTech(24);
            continue;
         end
         
         % store cycle number
         tabCycleNum = [tabCycleNum tabTech(30)];
         
         % determine if it is a deep cycle
         if ((length(unique(tabTech([2 7:15 19:20]))) == 1) && (unique(tabTech([2 7:15 19:20])) == 0))
            o_deepCycle = 0;
         else
            o_deepCycle = 1;
         end
         
         % decode the retrieved data
         tabTech([1:6 41 45]) = tabTech([1:6 41 45])*0.001;
         tabTech(26) = tabTech(26)*0.1 - 3276.8;
         tabTech(31) = tabTech(31)*0.1;
         tabTech(38:39) = tabTech(38:39)*1e-7 - 214.7483648;
         tabTech(48) = tabTech(48) + 2000;
         tabTech(50) = tabTech(50)*2;

         o_tabTech = [o_tabTech; ...
            tabTech(30) tabTech' sbdFileDate];
      
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case {2, 3, 4}
         % hydraulic packet
                 
         if (a_procLevel == 0)
            g_decArgo_nbOf2To4TypePacketReceived = g_decArgo_nbOf2To4TypePacketReceived + 1;
            continue;
         end
         
         % compute the number of pressure points in the hydraulic packet
         nbPresPoints = floor((a_tabData(idMes, 2) - 1)/7); % 7 bytes for each
                  
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            8 ...
            repmat([8 16 16 16], 1, nbPresPoints) ...
            ];
         % get item bits
         tabHydrau = get_bits(firstBit, tabNbBits, msgData);
         
         if (rem(a_tabData(idMes, 2) - 1, 7) ~= 0)
            fprintf('WARNING: Float #%d cycle #%d: Number of bytes of the hydraulic packet doesn''t fit a completed number of valve/pump activations\n', ...
               g_decArgo_floatNum, tabHydrau(1));
         end
         
         % store cycle number
         tabCycleNum = [tabCycleNum tabHydrau(1)];
         
         % decode the retrieved data
         tabHydrau((0:nbPresPoints-1)*4+3) = tabHydrau((0:nbPresPoints-1)*4+3)*0.1;
         for idH = 1:nbPresPoints
            o_dataHydrau = [o_dataHydrau; ...
               packType tabHydrau(1) tabHydrau((idH-1)*4+2:(idH-1)*4+5)' sbdFileDate];
         end
      
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case {5}
         % acknowledgment packet
                  
         if (a_procLevel == 0)
            g_decArgo_5TypePacketReceived = 1;
            continue;
         end
         
         % determine if it is a deep cycle
         o_deepCycle = 0;

         % compute the number of commands in the acknowledgment packet
         nbCmd = floor(a_tabData(idMes, 2)/5); % 5 bytes for each
         
         if (rem(a_tabData(idMes, 2), 5) ~= 0)
            fprintf('WARNING: Float #%d: Number of bytes of the acknowledgment packet doesn''t fit a completed number of commands\n', ...
               g_decArgo_floatNum);
         end
         
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            repmat([8 8 16 8], 1, nbCmd) ...
            ];
         % get item bits
         tabAck = get_bits(firstBit, tabNbBits, msgData);
         
         % decode the retrieved data
         for idC = 1:nbCmd
            o_dataAck = [o_dataAck; ...
               tabAck((idC-1)*4+1:(idC-1)*4+4)' sbdFileDate];
         end
      
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, ...
            30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, ...
            50, 51, 52, 53}
         % ascent data packet
         % descent data packet
         % drift data packet
                  
         if (a_procLevel == 0)
            if ((packType >= 10) && (packType <= 29))
               % ascent data packet
               g_decArgo_nbOf10To29TypePacketReceived = g_decArgo_nbOf10To29TypePacketReceived + 1;
            elseif ((packType >= 30) && (packType <= 49))
               % descent data packet
               g_decArgo_nbOf30To49TypePacketReceived = g_decArgo_nbOf30To49TypePacketReceived + 1;
            elseif ((packType >= 50) && (packType <= 53))
               % drift data packet
               g_decArgo_nbOf50To55TypePacketReceived = g_decArgo_nbOf50To55TypePacketReceived + 1;
            end
            continue;
         end
         
         % determine if it is a deep cycle
         o_deepCycle = 1;
         
         % compute the number Of CTD samples in the data packet
         nbMeas = floor((a_tabData(idMes, 2) - 2)/10); % 10 bytes for each
                  
         % first item bit number
         firstBit = 1;
         % item bit lengths
         tabNbBits = [ ...
            8 8 ...
            repmat([16 16 16 16 16], 1, nbMeas) ...
            ];
         % get item bits
         tabData = get_bits(firstBit, tabNbBits, msgData);
         
         if (nbMeas > NB_MEAS_MAX_DOVA)
            fprintf('ERROR: Float #%d cycle #%d: Number of CTDO samples in data packet (%d) exceeds the max expected one (%d)\n', ...
               g_decArgo_floatNum, tabData(1), ...
               nbMeas, NB_MEAS_MAX_DOVA);
         end
         
         if (rem(a_tabData(idMes, 2) - 2, 10) ~= 0)
            fprintf('WARNING: Float #%d cycle #%d: Number of bytes of the sensor data packet doesn''t fit a completed number of levels\n', ...
               g_decArgo_floatNum, tabData(1));
         end
         
         % store cycle number
         tabCycleNum = [tabCycleNum tabData(1)];

         % decode the retrieved data
         tabDate = ones(NB_MEAS_MAX_DOVA, 1)*g_decArgo_dateDef;
         tabPres = ones(NB_MEAS_MAX_DOVA, 1)*g_decArgo_presCountsDef;
         tabTemp = ones(NB_MEAS_MAX_DOVA, 1)*g_decArgo_tempCountsDef;
         tabPsal = ones(NB_MEAS_MAX_DOVA, 1)*g_decArgo_salCountsDef;
         tabTempDoxy = ones(NB_MEAS_MAX_DOVA, 1)*g_decArgo_tempDoxyCountsDef;
         tabPhaseDelayDoxy = ones(NB_MEAS_MAX_DOVA, 1)*g_decArgo_phaseDelayDoxyCountsDef;

         for idM = 1:nbMeas
            if (idM > 1)
               measDate = g_decArgo_dateDef;
            else
               measDate = tabData(2)*0.1;
            end
            
            tabDate(idM) = measDate;
            tabPres(idM) = tabData(5*(idM-1)+5);
            tabTemp(idM) = tabData(5*(idM-1)+4);
            tabPsal(idM) = tabData(5*(idM-1)+3);
            tabTempDoxy(idM) = tabData(5*(idM-1)+7);
            tabPhaseDelayDoxy(idM) = tabData(5*(idM-1)+6);
         end
         
         o_dataCTDO = [o_dataCTDO; ...
            packType tabData(1) nbMeas tabDate' tabPres' tabTemp' tabPsal' tabTempDoxy' tabPhaseDelayDoxy' sbdFileDate];

      otherwise
         fprintf('WARNING: Float #%d: Nothing done yet for packet type #%d\n', ...
            g_decArgo_floatNum, ...
            packType);
   end
end

% convert data counts to physical values
if (~isempty(o_dataCTDO))
   o_dataCTDO(:, 4+NB_MEAS_MAX_DOVA:4+2*NB_MEAS_MAX_DOVA-1) = sensor_2_value_for_pressure_nva_1_2(o_dataCTDO(:, 4+NB_MEAS_MAX_DOVA:4+2*NB_MEAS_MAX_DOVA-1));
   o_dataCTDO(:, 4+2*NB_MEAS_MAX_DOVA:4+3*NB_MEAS_MAX_DOVA-1) = sensor_2_value_for_temperature_nva_1_2(o_dataCTDO(:, 4+2*NB_MEAS_MAX_DOVA:4+3*NB_MEAS_MAX_DOVA-1));
   o_dataCTDO(:, 4+3*NB_MEAS_MAX_DOVA:4+4*NB_MEAS_MAX_DOVA-1) = sensor_2_value_for_salinity_nva_1_2(o_dataCTDO(:, 4+3*NB_MEAS_MAX_DOVA:4+4*NB_MEAS_MAX_DOVA-1));
   o_dataCTDO(:, 4+4*NB_MEAS_MAX_DOVA:4+5*NB_MEAS_MAX_DOVA-1) = sensor_2_value_for_temp_doxy_nva_2(o_dataCTDO(:, 4+4*NB_MEAS_MAX_DOVA:4+5*NB_MEAS_MAX_DOVA-1));
   o_dataCTDO(:, 4+5*NB_MEAS_MAX_DOVA:4+6*NB_MEAS_MAX_DOVA-1) = sensor_2_value_for_phase_delay_doxy_nva_2(o_dataCTDO(:, 4+5*NB_MEAS_MAX_DOVA:4+6*NB_MEAS_MAX_DOVA-1));
end

% set cycle number and store tech data for nc output
if (a_procLevel > 0)
   if (g_decArgo_ackPacket == 0)
      if (~isempty(tabCycleNum))
         if (length(unique(tabCycleNum)) == 1)
            g_decArgo_cycleNum = unique(tabCycleNum);
            
            % add 1 to cycle number except for PRELUDE cycle
            if (o_deepCycle == 0)
               if (a_firstDeepCycleDone == 0)
                  % PRELUDE cycle
                  if (g_decArgo_cycleNum == 255)
                     g_decArgo_cycleNum = 0;
                  end
               else
                  g_decArgo_cycleNum = g_decArgo_cycleNum + 1;
               end
            else
               g_decArgo_cycleNum = g_decArgo_cycleNum + 1;
            end
            
            % output NetCDF files
            if (g_decArgo_generateNcTech ~= 0)
               store_tech_data_for_nc_2002(o_tabTech, o_deepCycle);
            end
            
         else
            fprintf('ERROR: Float #%d: Multiple cycle numbers have been received\n', ...
               g_decArgo_floatNum);
         end
      else
         fprintf('WARNING: Float #%d: Cycle number cannot be determined\n', ...
            g_decArgo_floatNum);
      end
   end
end
         
return;
