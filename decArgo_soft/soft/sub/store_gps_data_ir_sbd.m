% ------------------------------------------------------------------------------
% Store GPS data in a cell array.
%
% SYNTAX :
% store_gps_data_ir_sbd(a_tabTech, a_decoderId)
%
% INPUT PARAMETERS :
%   a_tabTech   : float technical data
%   a_decoderId : float decoder Id
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   10/14/2014 - RNU - creation
% ------------------------------------------------------------------------------
function store_gps_data_ir_sbd(a_tabTech, a_decoderId)

% current float WMO number
global g_decArgo_floatNum;

% default values
global g_decArgo_dateDef;
global g_decArgo_argosLonDef;
global g_decArgo_argosLatDef;

% array to store GPS data
global g_decArgo_gpsData;


if (~isempty(a_tabTech))
   
   idPos = find(a_tabTech(:, 1) == 0);
   if (~isempty(idPos))
      
      % unpack the GPS data
      if (~isempty(g_decArgo_gpsData))
         gpsLocCycleNum = g_decArgo_gpsData{1};
         gpsLocProfNum = g_decArgo_gpsData{2};
         gpsLocPhase = g_decArgo_gpsData{3};
         gpsLocDate = g_decArgo_gpsData{4};
         gpsLocLon = g_decArgo_gpsData{5};
         gpsLocLat = g_decArgo_gpsData{6};
         gpsLocQc = g_decArgo_gpsData{7};
         gpsLocAccuracy = g_decArgo_gpsData{8};
         gpsLocSbdFileDate = g_decArgo_gpsData{9};
      else
         gpsLocCycleNum = [];
         gpsLocProfNum = [];
         gpsLocPhase = [];
         gpsLocDate = [];
         gpsLocLon = [];
         gpsLocLat = [];
         gpsLocQc = [];
         gpsLocAccuracy = [];
         gpsLocSbdFileDate = [];
      end
      
      for idP = 1:length(idPos)
      switch (a_decoderId)
         
         case {201, 202, 203} % Arvor-deep 4000, Arvor-deep 3500
            gpsValidFlagFromTech = a_tabTech(idPos(idP), 59);
            cycleNumberFromTech = a_tabTech(idPos(idP), 2);
            
         case {205, 204, 206, 207, 208, 209}
            % Arvor Iridium 5.41 & 5.42 & 5.4
            % Provor-DO Iridium 5.71 & 5.7 & 5.72
            % Arvor-2DO Iridium 5.73
            gpsValidFlagFromTech = a_tabTech(idPos(idP), 74);
            cycleNumberFromTech = a_tabTech(idPos(idP), 3);
            
         case {210, 211}
            % Arvor-ARN Iridium
            gpsValidFlagFromTech = a_tabTech(idPos(idP), 62);
            cycleNumberFromTech = a_tabTech(idPos(idP), 2);
            
         otherwise
            fprintf('ERROR: Float #%d: Nothing implemented yet to retrieve tech info for decoderId #%d\n', ...
               g_decArgo_floatNum, ...
               a_decoderId);
            return;
      end
      
      % GPS data (consider only 'valid' GPS locations)
      if (gpsValidFlagFromTech == 1)
         gpsLocCycleNum = [gpsLocCycleNum; cycleNumberFromTech];
         gpsLocProfNum = [gpsLocProfNum; -1];
         gpsLocPhase = [gpsLocPhase; -1];
         gpsLocDate = [gpsLocDate; a_tabTech(idPos(idP), end-3)];
         gpsLocLon = [gpsLocLon; a_tabTech(idPos(idP), end-2)];
         gpsLocLat = [gpsLocLat; a_tabTech(idPos(idP), end-1)];
         gpsLocQc = [gpsLocQc; 0];
         gpsLocAccuracy = [gpsLocAccuracy; 'G'];
         gpsLocSbdFileDate = [gpsLocSbdFileDate; a_tabTech(idPos(idP), end)];
         
         % compute the JAMSTEC QC for the GPS locations of the current cycle

         lastLocDateOfPrevCycle = g_decArgo_dateDef;
         lastLocLonOfPrevCycle = g_decArgo_argosLonDef;
         lastLocLatOfPrevCycle = g_decArgo_argosLatDef;
                  
         % retrieve the last good GPS location of the previous cycle
         % (cycleNumber-1)
         idF = find(gpsLocCycleNum == cycleNumberFromTech-1);
         if (~isempty(idF))
            prevLocDate = gpsLocDate(idF);
            prevLocLon = gpsLocLon(idF);
            prevLocLat = gpsLocLat(idF);
            prevLocQc = gpsLocQc(idF);
               
            idGoodLoc = find(prevLocQc == 1);
            if (~isempty(idGoodLoc))
               lastLocDateOfPrevCycle = prevLocDate(idGoodLoc(end));
               lastLocLonOfPrevCycle = prevLocLon(idGoodLoc(end));
               lastLocLatOfPrevCycle = prevLocLat(idGoodLoc(end));
            end
         end
         
         idF = find(gpsLocCycleNum == cycleNumberFromTech);
         locDate = gpsLocDate(idF);
         locLon = gpsLocLon(idF);
         locLat = gpsLocLat(idF);
         locAcc = gpsLocAccuracy(idF);
         
         [locQc] = compute_jamstec_qc( ...
            locDate, locLon, locLat, locAcc, ...
            lastLocDateOfPrevCycle, lastLocLonOfPrevCycle, lastLocLatOfPrevCycle, []);
         
         gpsLocQc(idF) = str2num(locQc')';
      end
      end
      
      % update GPS data global variable
      g_decArgo_gpsData{1} = gpsLocCycleNum;
      g_decArgo_gpsData{2} = gpsLocProfNum;
      g_decArgo_gpsData{3} = gpsLocPhase;
      g_decArgo_gpsData{4} = gpsLocDate;
      g_decArgo_gpsData{5} = gpsLocLon;
      g_decArgo_gpsData{6} = gpsLocLat;
      g_decArgo_gpsData{7} = gpsLocQc;
      g_decArgo_gpsData{8} = gpsLocAccuracy;
      g_decArgo_gpsData{9} = gpsLocSbdFileDate;
   end
end

return;
