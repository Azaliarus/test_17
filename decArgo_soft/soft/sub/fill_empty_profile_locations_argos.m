% ------------------------------------------------------------------------------
% Use interpolations of surface locations to fill empty profile locations.
%
% SYNTAX :
%  [o_tabProfiles] = fill_empty_profile_locations_argos(...
%    a_floatSurfData, a_tabProfiles)
%
% INPUT PARAMETERS :
%   a_floatSurfData : float surface data structure
%   a_tabProfiles   : input profiles to check
%
% OUTPUT PARAMETERS :
%   o_tabProfiles : checked output profiles
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/16/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_tabProfiles] = fill_empty_profile_locations_argos(...
   a_floatSurfData, a_tabProfiles)

% output parameters initialization
o_tabProfiles = [];

% current float WMO number
global g_decArgo_floatNum;

% QC flag values (char)
global g_decArgo_qcStrGood;
global g_decArgo_qcStrCorrectable;
global g_decArgo_qcStrInterpolated;

% global default values
global g_decArgo_dateDef;
global g_decArgo_argosLonDef;
global g_decArgo_argosLatDef;


for idProf = 1:length(a_tabProfiles)
   profile = a_tabProfiles(idProf);

   if ((profile.date ~= g_decArgo_dateDef) && ...
         (profile.locationDate == g_decArgo_dateDef))
      
      % find a good location before and after the current profile
      
      % find a good location in the previous cycles
      prevLocDate = g_decArgo_dateDef;
      prevLocLon = g_decArgo_argosLonDef;
      prevLocLat = g_decArgo_argosLatDef;

      % get the existing previous cycles
      idPrevCycles = find(a_floatSurfData.cycleNumbers < profile.cycleNumber);
      if (~isempty(idPrevCycles))
         prevCycles = sort(a_floatSurfData.cycleNumbers(idPrevCycles), 'descend');
         for id = 1:length(prevCycles)
            
            idCy = find(a_floatSurfData.cycleNumbers == prevCycles(id));
            
            if (~isempty(a_floatSurfData.cycleData(idCy).argosLocDate))
               locDate = a_floatSurfData.cycleData(idCy).argosLocDate;
               locLon = a_floatSurfData.cycleData(idCy).argosLocLon;
               locLat = a_floatSurfData.cycleData(idCy).argosLocLat;
               locQc = a_floatSurfData.cycleData(idCy).argosLocQc;
               
               idGoodLoc = find(locQc == g_decArgo_qcStrGood);
               if (~isempty(idGoodLoc))
                  prevLocDate = locDate(idGoodLoc(end));
                  prevLocLon = locLon(idGoodLoc(end));
                  prevLocLat = locLat(idGoodLoc(end));
               end
            end
            
            if (prevLocDate ~= g_decArgo_dateDef)
               break
            end
         end
      end
      
      if (prevLocDate == g_decArgo_dateDef)
         % use the launch date and location
         prevLocDate = a_floatSurfData.launchDate;
         prevLocLon = a_floatSurfData.launchLon;
         prevLocLat = a_floatSurfData.launchLat;

         % positioning system
         a_tabProfiles(idProf).posSystem = 'NONE';
      end
      
      if (prevLocDate ~= g_decArgo_dateDef)
         
         % find a good location in the next cycles
         nextLocDate = g_decArgo_dateDef;
         nextLocLon = g_decArgo_argosLonDef;
         nextLocLat = g_decArgo_argosLatDef;
         
         idNextCycles = find(a_floatSurfData.cycleNumbers >= profile.cycleNumber);
         if (~isempty(idNextCycles))
            nextCycles = sort(a_floatSurfData.cycleNumbers(idNextCycles));
            for id = 1:length(nextCycles)
               
               idCy = find(a_floatSurfData.cycleNumbers == nextCycles(id));
               
               if (~isempty(a_floatSurfData.cycleData(idCy).argosLocDate))
                  locDate = a_floatSurfData.cycleData(idCy).argosLocDate;
                  locLon = a_floatSurfData.cycleData(idCy).argosLocLon;
                  locLat = a_floatSurfData.cycleData(idCy).argosLocLat;
                  locQc = a_floatSurfData.cycleData(idCy).argosLocQc;
                  
                  idGoodLoc = find(locQc == g_decArgo_qcStrGood);
                  if (~isempty(idGoodLoc))
                     nextLocDate = locDate(idGoodLoc(1));
                     nextLocLon = locLon(idGoodLoc(1));
                     nextLocLat = locLat(idGoodLoc(1));
                  end
               end
               
               if (nextLocDate ~= g_decArgo_dateDef)
                  break
               end
            end
         end
         
         if (nextLocDate ~= g_decArgo_dateDef)
            % interpolate the locations
            [interpLocLon, interpLocLat] = interpolate_between_2_locations(...
               prevLocDate, prevLocLon, prevLocLat, ...
               nextLocDate, nextLocLon, nextLocLat, ...
               profile.date);

            if (~isnan(interpLocLon))
               % assign the interpolated location to the profile
               a_tabProfiles(idProf).locationDate = profile.date;
               a_tabProfiles(idProf).locationLon = interpLocLon;
               a_tabProfiles(idProf).locationLat = interpLocLat;
               a_tabProfiles(idProf).locationQc = g_decArgo_qcStrInterpolated;
            else
               fprintf('WARNING: Float #%d Cycle #%d: time inconsistency detected while interpolating for profile location processing - profile not located\n', ...
                  g_decArgo_floatNum, ...
                  profile.cycleNumber);
            end
         else
            % retrieve 2 previous profile locations
            idF1 = find([a_tabProfiles.date] < profile.date);

            % be sure of the chronological order
            [~, idSort] = sort([a_tabProfiles(idF1).cycleNumber]);
            idF1 = idSort(idF1);

            % look for the previous cycles
            cyDateList = [a_tabProfiles(idF1).locationDate];
            cyLonList = [a_tabProfiles(idF1).locationLon];
            cyLatList = [a_tabProfiles(idF1).locationLat];
            [~, idUnique, ~] = unique(cyDateList);
            cyDateList = cyDateList(idUnique);
            cyLonList = cyLonList(idUnique);
            cyLatList = cyLatList(idUnique);

            if (length(cyDateList) > 1)

               % extrapolate the locations
               [extrapLocLon, extrapLocLat] = extrapolate_locations(...
                  cyDateList(end-1), ...
                  cyLonList(end-1), ...
                  cyLatList(end-1), ...
                  cyDateList(end), ...
                  cyLonList(end), ...
                  cyLatList(end), ...
                  profile.date);

               if (~isnan(extrapLocLon))
                  % assign the extrapolated location to the profile
                  a_tabProfiles(idProf).locationDate = profile.date;
                  a_tabProfiles(idProf).locationLon = extrapLocLon;
                  a_tabProfiles(idProf).locationLat = extrapLocLat;
                  a_tabProfiles(idProf).locationQc = g_decArgo_qcStrInterpolated;
               else
                  fprintf('WARNING: Float #%d Cycle #%d: time inconsistency detected while extrapolating for profile location processing - profile not located\n', ...
                     g_decArgo_floatNum, ...
                     profile.cycleNumber);
               end
            else

               % use the launch location with a POSITION_QC=3
               a_tabProfiles(idProf).locationDate = profile.date;
               a_tabProfiles(idProf).locationLon = a_floatSurfData.launchLon;
               a_tabProfiles(idProf).locationLat = a_floatSurfData.launchLat;
               a_tabProfiles(idProf).locationQc = g_decArgo_qcStrCorrectable;
            end
         end
      end
   end
end

% output data
o_tabProfiles = a_tabProfiles;

return
