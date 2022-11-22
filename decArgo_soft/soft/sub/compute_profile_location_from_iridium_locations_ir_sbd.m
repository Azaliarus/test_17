% ------------------------------------------------------------------------------
% Compute the profile location of a given cycle from Iridium locations (used
% only when no GPS fixes are available), as specifieed in the trajectory DAC
% cookbook.
%
% SYNTAX :
%  [o_locDate, o_locLon, o_locLat, o_locQc] = ...
%    compute_profile_location_from_iridium_locations_ir_sbd(a_iridiumMailData, a_cycleNumber)
%
% INPUT PARAMETERS :
%   a_iridiumMailData : Iridium mail contents
%   a_cycleNumber     : concerned cycle number
%
% OUTPUT PARAMETERS :
%   o_locDate : profile location date
%   o_locLon  : profile location longitude
%   o_locLat  : profile location latitude
%   o_locQc  : profile location Qc
%
% EXAMPLES :
%
% SEE ALSO : 
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   10/15/2014 - RNU - creation
% ------------------------------------------------------------------------------
function [o_locDate, o_locLon, o_locLat, o_locQc] = ...
   compute_profile_location_from_iridium_locations_ir_sbd(a_iridiumMailData, a_cycleNumber)

% output parameters initialization
o_locDate = [];
o_locLon = [];
o_locLat = [];
o_locQc = [];


% process the contents of the Iridium mail associated to the current cycle
idFCyNum = find([a_iridiumMailData.cycleNumber] == a_cycleNumber);
if (~isempty(idFCyNum))
   timeList = [a_iridiumMailData(idFCyNum).timeOfSessionJuld];
   latList = [a_iridiumMailData(idFCyNum).unitLocationLat];
   lonList = [a_iridiumMailData(idFCyNum).unitLocationLon];
   radiusList = [a_iridiumMailData(idFCyNum).cepRadius];
   
   weight = 1./(radiusList.*radiusList);
   o_locDate = mean(timeList);
   o_locLon = sum(lonList.*weight)/sum(weight);
   o_locLat = sum(latList.*weight)/sum(weight);
   if (mean(radiusList) < 5)
      o_locQc = '1';
   else
      o_locQc = '2';
   end
end

return;
