% ------------------------------------------------------------------------------
% Print technical message data in output CSV file.
%
% SYNTAX :
%  print_tech_data_in_csv_file_213(a_tabTech1, a_tabTech2, a_deepCycle)
%
% INPUT PARAMETERS :
%   a_tabTech1  : decoded data of technical msg #1
%   a_tabTech2  : decoded data of technical msg #2
%   a_deepCycle : deep cycle flag
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/07/2017 - RNU - creation
% ------------------------------------------------------------------------------
function print_tech_data_in_csv_file_213(a_tabTech1, a_tabTech2, a_deepCycle)

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% output CSV file Id
global g_decArgo_outputCsvFileId;

% default values
global g_decArgo_janFirst1950InMatlab;
global g_decArgo_dateDef;


if (isempty(a_tabTech1) && isempty(a_tabTech2))
   return
end

ID_OFFSET = 1;

cycleStartDateDay = g_decArgo_dateDef;

% technical message #1
idF1 = [];
if (~isempty(a_tabTech1))
   idF1 = find(a_tabTech1(:, 1) == 0);
end
if (length(idF1) > 1)
   fprintf('ERROR: Float #%d cycle #%d: BUFFER anomaly (%d tech message #1 in the buffer)\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, ...
      length(idF1));
elseif (length(idF1) == 1)
   id = idF1(1);
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; FIRST TECHNICAL PACKET CONTENTS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Transmission time of technical packet; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), julian_2_gregorian_dec_argo(a_tabTech1(id, end)));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: GENERAL INFORMATION\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Cycle number; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 1+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Iridium session indicator (0=first session, 1=second session); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Float firmware checksum; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 3+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Float serial number; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 4+ID_OFFSET));
   
   if (a_deepCycle == 1)
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: BUOYANCY REDUCTION\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Cycle start gregorian day; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 5+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Cycle start gregorian month; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 6+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Cycle start gregorian year; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 7+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Cycle start hour; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 9+ID_OFFSET), format_time_dec_argo(a_tabTech1(id, 9+ID_OFFSET)/60));
      cycleStartDateDay = datenum(sprintf('%02d%02d%02d', a_tabTech1(id, (5:7)+ID_OFFSET)), 'ddmmyy') - g_decArgo_janFirst1950InMatlab;
      cycleStartDate = cycleStartDateDay + a_tabTech1(id, 9+ID_OFFSET)/1440;
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; => Cycle start date; %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), julian_2_gregorian_dec_argo(cycleStartDate));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Cycle start float day; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 8+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; EV basic action duration; %d; seconds\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 10+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; EV nb actions at surface; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 11+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Grounded flag at surface flag; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 12+ID_OFFSET));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: DESCENT TO PARK PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Descent to park start hour; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 13+ID_OFFSET), format_time_dec_argo(a_tabTech1(id, 13+ID_OFFSET)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Initial stabilization hour; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 14+ID_OFFSET), format_time_dec_argo(a_tabTech1(id, 14+ID_OFFSET)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Initial stabilization pressure; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 18+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Descent to park end hour; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 15+ID_OFFSET), format_time_dec_argo(a_tabTech1(id, 15+ID_OFFSET)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Ev nb actions during descent to park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 16+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Pump nb actions during descent to park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 17+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Max P during descent to park; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 19+ID_OFFSET));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: DRIFT AT PARK PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Drift at park start gregorian day; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 20+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Nb entries in park margin; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 21+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Nb repositions during drift at park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 22+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Min P during drift at park; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 23+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Max P during drift at park; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 24+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Ev nb actions during drift at park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 25+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Pump nb actions during drift at park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 26+ID_OFFSET));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: DESCENT TO PROF PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Descent to prof start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 27+ID_OFFSET), format_time_dec_argo(a_tabTech1(id, 27+ID_OFFSET)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Descent to prof end time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 28+ID_OFFSET), format_time_dec_argo(a_tabTech1(id, 28+ID_OFFSET)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Ev nb actions during descent to prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 29+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Pump nb actions during descent to prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 30+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Max P during descent to prof; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 31+ID_OFFSET));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: DESCENT TO PROF PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Nb entries in prof margin; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 32+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Nb repositions during drift at prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 33+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Ev nb actions during drift at prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 34+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Pump nb actions during drift at prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 35+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Min P during drift at prof; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 36+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Max P during drift at prof; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 37+ID_OFFSET));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: ASCENT TO SURFACE\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Ascent to surface start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 38+ID_OFFSET), format_time_dec_argo(a_tabTech1(id, 38+ID_OFFSET)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Transmission start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 39+ID_OFFSET), format_time_dec_argo(a_tabTech1(id, 39+ID_OFFSET)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Pump nb actions during ascent to surface; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 40+ID_OFFSET));
   end
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: GENERAL INFORMATION\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Float time hour; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 41+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Float time minute; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 42+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Float time second; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 43+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Float time gregorian day; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 44+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Float time gregorian month; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 45+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Float time gregorian year; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 46+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; => Float time; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), julian_2_gregorian_dec_argo(a_tabTech1(id, end-3)));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Pressure offset; %.1f; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 47+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Internal vacuum (5 mbar resolution); %d; => %d mbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 48+ID_OFFSET), a_tabTech1(id, 48+ID_OFFSET)*5);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Battery voltage (voltage dropout from 15V, resolution 0.1V); %d; => %.1f; V\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 49+ID_OFFSET), 15-a_tabTech1(id, 49+ID_OFFSET)/10);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Real Time Clock error flag (normal=0, failure=1); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 50+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; CTD error counts; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 51+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Oxygen sensor status (0=ok, 1=problem, 2=none); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 52+ID_OFFSET));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: GPS DATA\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS latitude in degrees; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 53+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS latitude in minutes; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 54+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS latitude in fractions of minutes (4th decimal); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 55+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS latitude direction (0=North 1=South); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 56+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS longitude in degrees; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 57+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS longitude in minutes; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 58+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS longitude in fractions of minutes (4th decimal); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 59+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS longitude direction (0=East 1=West); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 60+ID_OFFSET));
   [lonStr, latStr] = format_position(a_tabTech1(id, end-2), a_tabTech1(id, end-1));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; => GPS position (lon, lat); %.4f; %.4f; =>; %s; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, end-2), a_tabTech1(id, end-1), lonStr, latStr);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS valid fix (1=valid, 0=not valid); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 61+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; GPS session duration; %d; seconds\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 62+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Nb retries during GPS session; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 63+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Additional Ev activation during GPS session; %d; seconds\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 64+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; Antenna status (0=unknown, 1=ok, 2=short, 3=open); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 65+ID_OFFSET));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; TECH: END OF LIFE\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; EOL flag; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 66+ID_OFFSET));
   if (a_tabTech1(id, 66+ID_OFFSET) == 1)
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; EOL start hour; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 67+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; EOL start minute; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 68+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; EOL start second; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 69+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; EOL start gregorian day; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 70+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; EOL start gregorian month; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 71+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; EOL start gregorian year; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), a_tabTech1(id, 72+ID_OFFSET));
      eolStartTime = datenum(sprintf('%02d%02d%02d', a_tabTech1(id, (67:72)+ID_OFFSET)), 'HHMMSSddmmyy') - g_decArgo_janFirst1950InMatlab;
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1_%d; => EOL start date; %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech1(id, 2+ID_OFFSET), julian_2_gregorian_dec_argo(eolStartTime));
   end
end

% technical message #2
idF2 = [];
if (~isempty(a_tabTech2))
   idF2 = find(a_tabTech2(:, 1) == 4);
end
if (length(idF2) > 1)
   fprintf('ERROR: Float #%d cycle #%d: BUFFER anomaly (%d tech message #2 in the buffer)\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, ...
      length(idF2));
elseif (length(idF2) == 1)
   id = idF2(1);
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; SECOND TECHNICAL PACKET CONTENTS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Transmission time of technical packet; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), julian_2_gregorian_dec_argo(a_tabTech2(id, end)));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; TECH: GENERAL INFORMATION\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Cycle number; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 1+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Iridium session indicator (0=first session, 1=second session); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; TECH: INFORMATION ON COLLECTED DATA\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET));
   
   if (a_deepCycle == 1)
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb CTD packets for descent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 3+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb CTD packets for drift; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 4+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb CTD packets for ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 5+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb CTD packets for "near surface"; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 6+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb CTD packets for "in air"; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 7+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb meas in surface zone for descent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 8+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb meas in deep zone for descent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 9+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb meas during drift park phase; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 10+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb meas in surface zone for ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 11+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb meas in deep zone for ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 12+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb meas during during "near surface" phase; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 13+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb meas during during "in air" phase; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 14+ID_OFFSET));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; TECH: LAST PUMPED ASCENT RAW MEAS\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; "Subsurface" meas PRES; %d; => %.1f; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 15+ID_OFFSET), sensor_2_value_for_pressure_202_210_to_214_217_222_to_225(a_tabTech2(id, 15+ID_OFFSET)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; "Subsurface" meas TEMP; %d; => %.3f; degC\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 16+ID_OFFSET), sensor_2_value_for_temp_204_to_214_217_219_220_222_to_225(a_tabTech2(id, 16+ID_OFFSET)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; "Subsurface" meas PSAL; %d; => %.3f; PSU\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 17+ID_OFFSET), sensor_2_value_for_salinity_210_to_214_217_220_222_to_225(a_tabTech2(id, 17+ID_OFFSET)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; "Subsurface" meas C1PHASE_DOXY; %d; => %.3f; degree\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 18+ID_OFFSET), sensor_2_value_for_C1C2phase_ir_sbd_2xx(a_tabTech2(id, 18+ID_OFFSET)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; "Subsurface" meas C2PHASE_DOXY; %d; => %.3f; degree\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 19+ID_OFFSET), sensor_2_value_for_C1C2phase_ir_sbd_2xx(a_tabTech2(id, 19+ID_OFFSET)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; "Subsurface" meas TEMP_DOXY; %d; => %.3f; degC\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 20+ID_OFFSET), sensor_2_value_for_temp_doxy_ir_sbd_2xx(a_tabTech2(id, 20+ID_OFFSET)));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; TECH: GROUNDING\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Total number of groundings; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 21+ID_OFFSET));
      if (a_tabTech2(id, 21+ID_OFFSET) > 0)
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; First grounding pressure; %d; dbar\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 22+ID_OFFSET));
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; First grounding day (relative to the beginning of current cycle); %d\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 23+ID_OFFSET));
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; First grounding minute; %d; => %s\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 24+ID_OFFSET), format_time_dec_argo(a_tabTech2(id, 24+ID_OFFSET)/60));
         firstGroundingTime = a_tabTech2(id, 23+ID_OFFSET) + a_tabTech2(id, 24+ID_OFFSET)/1440;
         if (cycleStartDateDay ~= g_decArgo_dateDef)
            fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; => first grounding date; %s\n', ...
               g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), julian_2_gregorian_dec_argo(firstGroundingTime + cycleStartDateDay));
         end
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; First grounding phase; %d\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 25+ID_OFFSET));
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb EV actions to set first grounding; %d\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 26+ID_OFFSET));
      end
      if (a_tabTech2(id, 21+ID_OFFSET) > 1)
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Second grounding pressure; %d; dbar\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 27+ID_OFFSET));
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Second grounding day (relative to the beginning of current cycle); %d\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 28+ID_OFFSET));
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Second grounding minute; %d; => %s\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 29+ID_OFFSET), format_time_dec_argo(a_tabTech2(id, 29+ID_OFFSET)/60));
         secondGroundingTime = a_tabTech2(id, 28+ID_OFFSET) + a_tabTech2(id, 29+ID_OFFSET)/1440;
         if (cycleStartDateDay ~= g_decArgo_dateDef)
            fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; => second grounding date; %s\n', ...
               g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), julian_2_gregorian_dec_argo(secondGroundingTime + cycleStartDateDay));
         end
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Second grounding phase; %d\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 30+ID_OFFSET));
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb EV actions to set second grounding; %d\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 31+ID_OFFSET));
      end
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; TECH: EMERGENCY ASCENT\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Number of emergency ascents; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 32+ID_OFFSET));
      if (a_tabTech2(id, 32+ID_OFFSET) > 0)
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; First emergency ascent day (relative to the beginning of current cycle); %d\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 36+ID_OFFSET));
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; First emergency ascent minute; %d; => %s\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 33+ID_OFFSET), format_time_dec_argo(a_tabTech2(id, 33+ID_OFFSET)/60));
         firstEmergencyTime = a_tabTech2(id, 36+ID_OFFSET) + a_tabTech2(id, 33+ID_OFFSET)/1440;
         if (cycleStartDateDay ~= g_decArgo_dateDef)
            fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; => first emergency date; %s\n', ...
               g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), julian_2_gregorian_dec_argo(firstEmergencyTime + cycleStartDateDay));
         end
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; First emergency ascent pressure; %d; dbar\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 34+ID_OFFSET));
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb pump actions for first emergency ascent; %d\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 35+ID_OFFSET));
      end
   else
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb CTD packets for "in air"; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 7+ID_OFFSET));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb meas during during "in air" phase; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 14+ID_OFFSET));
   end
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; TECH: IRIDIUM REMOTE CONTROL\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Number of received remote files; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 37+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Number of rejected remote files; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 38+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Number of received remote controls; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 39+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Number of rejected remote controls; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 40+ID_OFFSET));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; TECH: PREVIOUS IRIDIUM SESSION\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Previous Iridium session duration; %d; seconds\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 41+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Number of SBD received; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 42+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Number of SBD sent; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 43+ID_OFFSET));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; TECH: MISCELLANEOUS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Nb pump actions to start ascent; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 44+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Internal vacuum (5 mbar resolution) before ascent; %d; => %d mbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 45+ID_OFFSET), a_tabTech2(id, 45+ID_OFFSET)*5);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Float last reset hour; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 46+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Float last reset minute; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 47+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Float last reset second; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 48+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Float last reset gregorian day; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 49+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Float last reset gregorian month; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 50+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Float last reset gregorian year; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 51+ID_OFFSET));
   floatLastResetTime = datenum(sprintf('%02d%02d%02d', a_tabTech2(id, (46:51)+ID_OFFSET)), 'HHMMSSddmmyy') - g_decArgo_janFirst1950InMatlab;
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; => Float last reset date; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), julian_2_gregorian_dec_argo(floatLastResetTime));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Auto test flag (0=problem, 1=ok); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 52+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Auto test detail; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 53+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Software integrity test flag; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 54+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Positive buoyancy at deployment flag; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 55+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; CTD status (0=ok, 1=FP time-out, 2=FP broken frame, 16=CTD time-out, 32=CTD broken frame); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 56+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Phase during CTD default detection; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 57+ID_OFFSET));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2_%d; Software hydraulic type (0=Arvor, 1=Provor); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech2(id, 2+ID_OFFSET), a_tabTech2(id, 58+ID_OFFSET));
end

return
