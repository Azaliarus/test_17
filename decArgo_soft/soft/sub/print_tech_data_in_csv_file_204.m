% ------------------------------------------------------------------------------
% Print technical message data in output CSV file.
%
% SYNTAX :
%  print_tech_data_in_csv_file_204(a_tabTech)
%
% INPUT PARAMETERS :
%   a_tabTech : decoded technical data
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   03/11/2015 - RNU - creation
% ------------------------------------------------------------------------------
function print_tech_data_in_csv_file_204(a_tabTech)

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% output CSV file Id
global g_decArgo_outputCsvFileId;


if (isempty(a_tabTech))
   return
end

if (size(a_tabTech, 1) > 1)
   fprintf('ERROR: Float #%d cycle #%d: BUFFER anomaly (%d tech message in the buffer)\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, ...
      size(a_tabTech, 1));
elseif (size(a_tabTech, 1) == 1)
   id = 1;
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECHNICAL PACKET CONTENTS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Transmission time of technical packet; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(a_tabTech(id, end)));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: GENERAL INFORMATION\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Float serial number; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 2));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Cycle number; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 3));
   
   if ~((length(unique(a_tabTech(id, 4:43))) == 1) && (unique(a_tabTech(id, 4:43)) == 0))
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: BUOYANCY REDUCTION\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Cycle start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 4), format_time_dec_argo(a_tabTech(id, 4)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; EV nb actions at surface; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 5));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: DESCENT TO PARK PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Descent to park start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 6), format_time_dec_argo(a_tabTech(id, 6)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Initial stabilization time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 7), format_time_dec_argo(a_tabTech(id, 7)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Initial stabilization pressure; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 11));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Descent to park end time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 8), format_time_dec_argo(a_tabTech(id, 8)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Ev nb actions during descent to park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 9));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Pump nb actions during descent to park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 10));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Max P during descent to park; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 12));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: DRIFT AT PARK PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb entries in park margin; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 13));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb repositions during drift at park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 14));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Min P during drift at park; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 15));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Max P during drift at park; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 16));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Ev nb actions during drift at park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 17));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Pump nb actions during drift at park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 18));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: DESCENT TO PROF PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Descent to prof start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 19), format_time_dec_argo(a_tabTech(id, 19)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Descent to prof end time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 20), format_time_dec_argo(a_tabTech(id, 20)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Ev nb actions during descent to prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 21));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Pump nb actions during descent to prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 22));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Max P during descent to prof; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 23));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: DESCENT TO PROF PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb entries in prof margin; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 24));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb repositions during drift at prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 25));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Ev nb actions during drift at prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 26));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Pump nb actions during drift at prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 27));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Min P during drift at prof; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 28));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Max P during drift at prof; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 29));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: ASCENT TO SURFACE\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Ascent to surface start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 30), format_time_dec_argo(a_tabTech(id, 30)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Transmission start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 31), format_time_dec_argo(a_tabTech(id, 31)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Pump nb actions during ascent to surface; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 32));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: INFORMATION ON COLLECTED DATA\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb CTD packets for descent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 33));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb CTD packets for drift; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 34));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb CTD packets for ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 35));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb meas in surface zone for descent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 36));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb meas in deep zone for descent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 37));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb meas during drift park phase; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 38));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb meas in surface zone for ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 39));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb meas in deep zone for ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 40));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: LAST PUMPED ASCENT RAW MEAS\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; "Subsurface" meas PRES; %d; => %.1f; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 41), sensor_2_value_for_pressure_204_to_209_219_220(a_tabTech(id, 41)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; "Subsurface" meas TEMP; %d; => %.3f; �C\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 42), sensor_2_value_for_temperature_204_to_214_217_219_220_222_223(a_tabTech(id, 42)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; "Subsurface" meas PSAL; %d; => %.3f; PSU\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 43), a_tabTech(id, 43)/1000);
   end
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: MISCELLANEOUS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Float time hour; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 44));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Float time minute; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 45));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Float time second; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 46));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Float time gregorian day; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 47));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Float time gregorian month; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 48));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Float time gregorian year; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 49));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; => Float time; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(a_tabTech(id, end-3)));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Pressure offset; %.1f; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 50));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Internal vacuum (5 mbar resolution); %d; => %d mbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 51), a_tabTech(id, 51)*5);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Battery voltage (voltage dropout from 10V, resolution 0.1V); %d; => %.1f; V\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 52), 10-a_tabTech(id, 52)/10);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Real Time Clock error flag; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 53));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; CTD error counts; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 54));
   
   if (a_tabTech(id, 55) == 1)
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: GROUNDING\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Grounding detected (1: grounding, 0: no grounding); %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 55));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; First grounding pressure; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 56));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; First grounding day (relative to the beginning of current cycle); %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 57));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; First grounding minute; %d; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 58), format_time_dec_argo(a_tabTech(id, 58)/60));
   end
   
   if (a_tabTech(id, 59) > 0)
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: EMERGENCY ASCENT\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Number of emergency ascents; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 59));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; First emergency ascent day (relative to the beginning of current cycle); %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 63));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; First emergency ascent minute; %d; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 60), format_time_dec_argo(a_tabTech(id, 60)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; First emergency ascent pressure; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 61));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Nb pump actions for first emergency ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 62));
   end
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: RECEIVED REMOTE CONTROL\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Number of received remote control; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 64));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; Number of rejected remote control; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 65));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; TECH: GPS DATA\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; GPS latitude in degrees; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 66));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; GPS latitude in minutes; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 67));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; GPS latitude in fractions of minutes (4th decimal); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 68));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; GPS latitude direction (0=North 1=South); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 69));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; GPS longitude in degrees; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 70));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; GPS longitude in minutes; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 71));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; GPS longitude in fractions of minutes (4th decimal); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 72));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; GPS longitude direction (0=East 1=West); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 73));
   [lonStr, latStr] = format_position(a_tabTech(id, end-2), a_tabTech(id, end-1));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; => GPS position (lon, lat); %.4f; %.4f; =>; %s; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, end-2), a_tabTech(id, end-1), lonStr, latStr);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech; GPS valid fix (1=Valid, 0=Not valid); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 74));
end

return
