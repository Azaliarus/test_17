% ------------------------------------------------------------------------------
% Apply clock offset adjustment to RTC times.
%
% SYNTAX :
%  [o_profCtdP, o_profCtdPt, o_profCtdPts, o_profCtdCp, ...
%    o_grounding, o_buoyancy, ...
%    o_vitalsData, ...
%    o_cycleClockOffset, o_cycleTimeData] = ...
%    adjust_clock_offset_apx_apf11_ir( ...
%    a_profCtdP, a_profCtdPt, a_profCtdPts, a_profCtdCp, ...
%    a_grounding, a_buoyancy, ...
%    a_vitalsData, ...
%    a_cycleTimeData, ...
%    a_clockOffsetData)
%
% INPUT PARAMETERS :
%   a_profCtdP        : input CTD_P data
%   a_profCtdPt       : input CTD_PT data
%   a_profCtdPts      : input CTD_PTS data
%   a_profCtdCp       : input CTD_CP data
%   a_grounding       : input grounding data
%   a_buoyancy        : input buoyancy data
%   a_vitalsData      : input vitals data
%   a_cycleTimeData   : input cycle timings data
%   a_clockOffsetData : clock offset information
%
% OUTPUT PARAMETERS :
%   o_profCtdP         : output CTD_P data
%   o_profCtdPt        : output CTD_PT data
%   o_profCtdPts       : output CTD_PTS data
%   o_profCtdCp        : output CTD_CP data
%   o_grounding        : output grounding data
%   o_buoyancy         : output buoyancy data
%   o_vitalsData       : output vitals data
%   o_cycleClockOffset : applied clock offset
%   o_cycleTimeData    : output cycle timings data
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/27/2018 - RNU - creation
% ------------------------------------------------------------------------------
function [o_profCtdP, o_profCtdPt, o_profCtdPts, o_profCtdCp, ...
   o_grounding, o_buoyancy, ...
   o_vitalsData, ...
   o_cycleClockOffset, o_cycleTimeData] = ...
   adjust_clock_offset_apx_apf11_ir( ...
   a_profCtdP, a_profCtdPt, a_profCtdPts, a_profCtdCp, ...
   a_grounding, a_buoyancy, ...
   a_vitalsData, ...
   a_cycleTimeData, ...
   a_clockOffsetData)

% output parameters initialization
o_profCtdP = a_profCtdP;
o_profCtdPt = a_profCtdPt;
o_profCtdPts = a_profCtdPts;
o_profCtdCp = a_profCtdCp;
o_grounding = a_grounding;
o_buoyancy = a_buoyancy;
o_vitalsData = a_vitalsData;
o_cycleClockOffset = 0;
o_cycleTimeData = a_cycleTimeData;


if (isempty(a_clockOffsetData.clockOffsetJuldUtc))
   return;
end

% clock adjustment of the current cycle
o_cycleClockOffset = get_clock_offset_value_apx_apf11_ir(a_clockOffsetData, a_cycleTimeData);

% clock adjustment of profile measurements
[o_profCtdP] = adjust_profile(o_profCtdP, o_cycleClockOffset);
[o_profCtdPt] = adjust_profile(o_profCtdPt, o_cycleClockOffset);
[o_profCtdPts] = adjust_profile(o_profCtdPts, o_cycleClockOffset);
[o_profCtdCp] = adjust_profile(o_profCtdCp, o_cycleClockOffset);

% clock adjustment of grounding information
for idG = 1:size(o_grounding, 1)
   o_grounding(idG, 2) = adjust_time(o_grounding(idG, 1), o_cycleClockOffset);
end

% clock adjustment of buoyancy information
for idB = 1:size(o_buoyancy, 1)
   o_buoyancy(idB, 2) = adjust_time(o_buoyancy(idB, 1), o_cycleClockOffset);
end

% clock adjustment of vitals information
fieldNames = fields(o_vitalsData);
for idF = 1:length(fieldNames)
   fieldName = fieldNames{idF};
   for idV = 1:size(o_vitalsData.(fieldName), 1)
      o_vitalsData.(fieldName)(idV, 2) = adjust_time(o_vitalsData.(fieldName)(idV, 1), o_cycleClockOffset);
   end
end

% clock adjustment of misc cycle times
if (~isempty(o_cycleTimeData))
   [o_cycleTimeData.preludeStartAdjDateSci] = adjust_time(o_cycleTimeData.preludeStartDateSci, o_cycleClockOffset);
   [o_cycleTimeData.preludeStartAdjDateSys] = adjust_time(o_cycleTimeData.preludeStartDateSys, o_cycleClockOffset);
   [o_cycleTimeData.descentStartAdjDateSci] = adjust_time(o_cycleTimeData.descentStartDateSci, o_cycleClockOffset);
   [o_cycleTimeData.descentStartAdjDateSys] = adjust_time(o_cycleTimeData.descentStartDateSys, o_cycleClockOffset);
   [o_cycleTimeData.descentEndAdjDate] = adjust_time(o_cycleTimeData.descentEndDate, o_cycleClockOffset);
   [o_cycleTimeData.parkStartAdjDateSci] = adjust_time(o_cycleTimeData.parkStartDateSci, o_cycleClockOffset);
   [o_cycleTimeData.parkStartAdjDateSys] = adjust_time(o_cycleTimeData.parkStartDateSys, o_cycleClockOffset);
   [o_cycleTimeData.parkEndAdjDateSci] = adjust_time(o_cycleTimeData.parkEndDateSci, o_cycleClockOffset);
   [o_cycleTimeData.parkEndAdjDateSys] = adjust_time(o_cycleTimeData.parkEndDateSys, o_cycleClockOffset);
   [o_cycleTimeData.deepDescentEndAdjDate] = adjust_time(o_cycleTimeData.deepDescentEndDate, o_cycleClockOffset);
   [o_cycleTimeData.ascentStartAdjDateSci] = adjust_time(o_cycleTimeData.ascentStartDateSci, o_cycleClockOffset);
   [o_cycleTimeData.ascentStartAdjDateSys] = adjust_time(o_cycleTimeData.ascentStartDateSys, o_cycleClockOffset);
   [o_cycleTimeData.continuousProfileStartAdjDateSci] = adjust_time(o_cycleTimeData.continuousProfileStartDateSci, o_cycleClockOffset);
   [o_cycleTimeData.continuousProfileEndAdjDateSci] = adjust_time(o_cycleTimeData.continuousProfileEndDateSci, o_cycleClockOffset);
   [o_cycleTimeData.ascentEndAdjDateSci] = adjust_time(o_cycleTimeData.ascentEndDateSci, o_cycleClockOffset);
   [o_cycleTimeData.ascentEndAdjDateSys] = adjust_time(o_cycleTimeData.ascentEndDateSys, o_cycleClockOffset);
   [o_cycleTimeData.transStartAdjDate] = adjust_time(o_cycleTimeData.transStartDate, o_cycleClockOffset);
   [o_cycleTimeData.transEndAdjDate] = adjust_time(o_cycleTimeData.transEndDate, o_cycleClockOffset);
end

return;

% ------------------------------------------------------------------------------
% Apply clock offset adjustment to times of a set of measurements.
%
% SYNTAX :
%  [o_profData] = adjust_profile(a_profData, a_clockOffset)
%
% INPUT PARAMETERS :
%   a_profData    : profile times to adjust
%   a_clockOffset : clock offset to apply
%
% OUTPUT PARAMETERS :
%   o_profData : adjusted profile times
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/27/2018 - RNU - creation
% ------------------------------------------------------------------------------
function [o_profData] = adjust_profile(a_profData, a_clockOffset)

% output parameters initialization
o_profData = a_profData;


if (~isempty(o_profData))
   profDate = o_profData.dates;
   
   if (~isempty(profDate))
      o_profData.datesAdj = ones(size(o_profData.dates))*o_profData.dateList.fillValue;
      idNoDef = find(profDate ~= o_profData.dateList.fillValue);
      o_profData.datesAdj(idNoDef) = profDate(idNoDef) - a_clockOffset/86400;
   end
end

return;

% ------------------------------------------------------------------------------
% Apply clock offset adjustment to a given time.
%
% SYNTAX :
%  [o_timeAdj] = adjust_time(a_time, a_clockOffset)
%
% INPUT PARAMETERS :
%   a_time        : time to adjust
%   a_clockOffset : clock offset to apply
%
% OUTPUT PARAMETERS :
%   o_timeAdj : adjusted time
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/27/2018 - RNU - creation
% ------------------------------------------------------------------------------
function [o_timeAdj] = adjust_time(a_time, a_clockOffset)

% output parameters initialization
o_timeAdj = [];


if (~isempty(a_time))
   o_timeAdj = a_time - a_clockOffset/86400;
end

return;
