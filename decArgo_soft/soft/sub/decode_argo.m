% ------------------------------------------------------------------------------
% Use the correct float decoder in RT mode.
%
% SYNTAX :
%  decode_argo(a_floatList)
%
% INPUT PARAMETERS :
%   a_floatList : list of floats to decode
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   11/05/2015 - RNU - creation
% ------------------------------------------------------------------------------
function decode_argo(a_floatList)

% decode the floats of the "a_floatList" list
nbFloats = length(a_floatList);
for idFloat = 1:nbFloats
   floatNum = a_floatList(idFloat);
   fprintf('\n%03d/%03d %d\n', idFloat, nbFloats, floatNum);
   
   [floatNum, floatArgosId, ...
      floatDecVersion, floatDecId, ...
      floatFrameLen, ...
      floatCycleTime, floatDriftSamplingPeriod, floatDelay, ...
      floatLaunchDate, floatLaunchLon, floatLaunchLat, ...
      floatRefDay, floatEndDate, floatDmFlag] = get_one_float_info(floatNum, []);
   
   if (isempty(floatArgosId))
      fprintf('ERROR: No information on float #%d => nothing done\n', floatNum);
      continue;
   end
   
   if (floatDecId < 1000)
      decode_provor(floatNum);
   else
      decode_apex(floatNum);
   end
end

return;
