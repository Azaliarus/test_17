% ------------------------------------------------------------------------------
% Compute the dates of drift measurements.
%
% SYNTAX :
%  [o_date] = compute_dates_ir_rudics( ...
%    a_sensorNum, a_cycleNum, a_profNum, a_date, a_pressure)
%
% INPUT PARAMETERS :
%   a_sensorNum : sensor number
%   a_cycleNum  : cycle number
%   a_profNum   : profile number
%   a_date      : input dates
%   a_pressure  : drift measurement pressures
%
% OUTPUT PARAMETERS :
%   o_date : output dates
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   07/16/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_date] = compute_dates_ir_rudics( ...
   a_sensorNum, a_cycleNum, a_profNum, a_date, a_pressure)

% output parameters initialization
o_date = a_date;

% default values
global g_decArgo_dateDef;


% retrieve the sampling periods and the corresponding thresholds from the
% configuration
[driftSampPeriod, zoneThreshold] = ...
   config_get_drift_sampling_periods_ir_rudics(a_sensorNum, a_cycleNum, a_profNum);

% add date to drift measurement
a_pressure = sensor_2_value_for_pressure_ir_rudics_sbd2(a_pressure);
for id = 1:length(a_pressure)-1
   
   press = a_pressure(id);
   idT = find(press > zoneThreshold);
   if (isempty(idT))
      zoneNum = 1;
   else
      zoneNum = idT(end) + 1;
   end
   
   if (driftSampPeriod(zoneNum) ~= -1)
      if (o_date(id) ~= g_decArgo_dateDef)
         o_date(id+1) = o_date(id) + driftSampPeriod(zoneNum);
      else
         break;
      end
   end
end

return;
