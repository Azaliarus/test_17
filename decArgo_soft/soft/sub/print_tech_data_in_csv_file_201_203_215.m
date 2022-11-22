% ------------------------------------------------------------------------------
% Print technical message data in output CSV file.
%
% SYNTAX :
%  print_tech_data_in_csv_file_201_203_215(a_tabTech, a_decoderId)
%
% INPUT PARAMETERS :
%   a_tabTech   : decoded technical data
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
function print_tech_data_in_csv_file_201_203_215(a_tabTech, a_decoderId)

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% output CSV file Id
global g_decArgo_outputCsvFileId;

% default values
global g_decArgo_janFirst1950InMatlab;
global g_decArgo_dateDef;

% offset between float days and julian days
global g_decArgo_julD2FloatDayOffset;


if (isempty(a_tabTech))
   return;
end

cycleStartDateDay = g_decArgo_dateDef;

% technical message #1
idF1 = find(a_tabTech(:, 1) == 0);
if (length(idF1) > 1)
   fprintf('ERROR: Float #%d cycle #%d: BUFFER anomaly (%d tech message #1 in the buffer)\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, ...
      length(idF1));
elseif (length(idF1) == 1)
   id = idF1(1);

   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; FIRST TECHNICAL PACKET CONTENTS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Transmission time of technical packet; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(a_tabTech(id, end)));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: GENERAL INFORMATION\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Cycle number; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 2));
   
   startDateInfo = [a_tabTech(id, 3:5) a_tabTech(id, 7)];
   if ~((length(unique(startDateInfo)) == 1) && (unique(startDateInfo) == 0))
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: BUOYANCY REDUCTION\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Cycle start gregorian day; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 3));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Cycle start gregorian month; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 4));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Cycle start gregorian year; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 5));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Cycle start hour; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 7), format_time_dec_argo(a_tabTech(id, 7)/60));
      cycleStartDateDay = datenum(sprintf('%02d%02d%02d', a_tabTech(id, 3:5)), 'ddmmyy') - g_decArgo_janFirst1950InMatlab;
      cycleStartDate = cycleStartDateDay + a_tabTech(id, 7)/1440;
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; => Cycle start date; %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(cycleStartDate));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Cycle start float day; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 6));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; EV basic action duration; %d; seconds\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 8));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; EV nb actions at surface; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 9));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Grounded flag at surface flag; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 10));
   
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: DESCENT TO PARK PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Descent to park start hour; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 11), format_time_dec_argo(a_tabTech(id, 11)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Initial stabilization hour; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 12), format_time_dec_argo(a_tabTech(id, 12)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Initial stabilization pressure; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 16));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Descent to park end hour; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 13), format_time_dec_argo(a_tabTech(id, 13)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Ev nb actions during descent to park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 14));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Pump nb actions during descent to park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 15));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Max P during descent to park; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 17));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: DRIFT AT PARK PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Drift at park start gregorian day; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 18));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Nb entries in park margin; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 19));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Nb repositions during drift at park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 20));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Min P during drift at park; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 21));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Max P during drift at park; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 22));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Ev nb actions during drift at park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 23));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Pump nb actions during drift at park; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 24));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: DESCENT TO PROF PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Descent to prof start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 25), format_time_dec_argo(a_tabTech(id, 25)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Descent to prof end time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 26), format_time_dec_argo(a_tabTech(id, 26)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Ev nb actions during descent to prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 27));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Pump nb actions during descent to prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 28));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Max P during descent to prof; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 29));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: DESCENT TO PROF PRES\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Nb entries in prof margin; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 30));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Nb repositions during drift at prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 31));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Ev nb actions during drift at prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 32));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Pump nb actions during drift at prof; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 33));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Min P during drift at prof; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 34));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Max P during drift at prof; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 35));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: ASCENT TO SURFACE\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Ascent to surface start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 36), format_time_dec_argo(a_tabTech(id, 36)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Transmission start time; %d; minutes; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 37), format_time_dec_argo(a_tabTech(id, 37)/60));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Pump nb actions during ascent to surface; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 38));
   end
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: MISCELLANEOUS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Float time hour; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 39));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Float time minute; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 40));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Float time second; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 41));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Float time gregorian day; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 42));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Float time gregorian month; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 43));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Float time gregorian year; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 44));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; => Float time; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(a_tabTech(id, end-3)));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Pressure offset; %d; cbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, twos_complement_dec_argo(a_tabTech(id, 45), 8));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Internal vacuum (5 mbar resolution); %d; => %d mbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 46), a_tabTech(id, 46)*5);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Battery voltage (voltage dropout from 15V, resolution 0.1V); %d; => %.1f; V\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 47), 15-a_tabTech(id, 47)/10);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Real Time Clock error flag; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 48));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; CTD error counts; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 49));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; CTDO sensor state; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 50));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: GPS DATA\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS latitude in degrees; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 51));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS latitude in minutes; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 52));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS latitude in fractions of minutes (4th decimal); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 53));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS latitude direction (0=North 1=South); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 54));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS longitude in degrees; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 55));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS longitude in minutes; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 56));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS longitude in fractions of minutes (4th decimal); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 57));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS longitude direction (0=East 1=West); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 58));
   [lonStr, latStr] = format_position(a_tabTech(id, end-2), a_tabTech(id, end-1));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; => GPS position (lon, lat); %.4f; %.4f; =>; %s; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, end-2), a_tabTech(id, end-1), lonStr, latStr);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS valid fix (1=Valid, 0=Not valid); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 59));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; GPS session duration; %d; seconds\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 60));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Nb retries during GPS session; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 61));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: RECEIVED REMOTE CONTROL\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Number of received remote control; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 62));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Number of rejected remote control; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 63));

   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: END OF LIFE\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; EOL flag; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 64));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; EOL start hour; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 65));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; EOL start minute; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 66));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; EOL start second; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 67));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; EOL start gregorian day; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 68));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; EOL start gregorian month; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 69));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; EOL start gregorian year; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 70));
   if ~((length(unique(a_tabTech(id, 65:70))) == 1) && (unique(a_tabTech(id, 65:70)) == 0))
      eolStartTime = datenum(sprintf('%02d%02d%02d', a_tabTech(id, 65:70)), 'HHMMSSddmmyy') - g_decArgo_janFirst1950InMatlab;
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; => EOL start date; %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(eolStartTime));
   else
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; => EOL start date; UNDEFINED\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
   end
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; TECH: PREVIOUS IRIDIUM SESSION\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Previous Iridium session duration; %d; seconds\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 71));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Nb SBDI received; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 72));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #1; Nb SBDI sent; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 73));
end

% technical message #2
idF2 = find(a_tabTech(:, 1) == 4);
if (length(idF2) > 1)
   fprintf('ERROR: Float #%d cycle #%d: BUFFER anomaly (%d tech message #2 in the buffer)\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, ...
      length(idF2));
elseif (length(idF2) == 1)
   id = idF2(1);

   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; SECOND TECHNICAL PACKET CONTENTS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Transmission time of technical packet; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(a_tabTech(id, end)));
      
   if (cycleStartDateDay ~= g_decArgo_dateDef)
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; TECH: INFORMATION ON COLLECTED DATA\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb CTDO packets for descent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 2));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb CTDO packets for drift; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 3));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb CTDO packets for ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 4));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb meas in surface zone for descent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 5));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb meas in deep zone for descent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 6));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb meas during drift park phase; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 7));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb meas in surface zone for ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 8));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb meas in deep zone for ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 9));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; TECH: LAST PUMPED ASCENT RAW MEAS\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; "Subsurface" meas PRES; %d; => %.1f; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 10), sensor_2_value_for_pressure_201_203_215(a_tabTech(id, 10)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; "Subsurface" meas TEMP; %d; => %.3f; �C\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 11), sensor_2_value_for_temperature_201_to_203_215(a_tabTech(id, 11)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; "Subsurface" meas PSAL; %d; => %.3f; PSU\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 12), sensor_2_value_for_salinity_201_to_203_215(a_tabTech(id, 12)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; "Subsurface" meas C1PHASE_DOXY; %d; => %.3f; degree\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 13), sensor_2_value_C1C2Phase_doxy_201_to_203_206_to_209_213_to_215(a_tabTech(id, 13)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; "Subsurface" meas C2PHASE_DOXY; %d; => %.3f; degree\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 14), sensor_2_value_C1C2Phase_doxy_201_to_203_206_to_209_213_to_215(a_tabTech(id, 14)));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; "Subsurface" meas TEMP_DOXY; %d; => %.3f; �C\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 15), sensor_2_value_for_temp_doxy_201_to_203_206_to_209_213_to_215(a_tabTech(id, 15)));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; TECH: GROUNDING\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Total number of groundings; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 16));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; First grounding pressure; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 17));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; First grounding day (relative to the beginning of current cycle); %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 18));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; First grounding minute; %d; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 19), format_time_dec_argo(a_tabTech(id, 19)/60));
      if ~((length(unique(a_tabTech(id, 18:19))) == 1) && (unique(a_tabTech(id, 18:19)) == 0))
         firstGroundingTime = a_tabTech(id, 18) + a_tabTech(id, 19)/1440;
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; => first grounding date; %s\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(firstGroundingTime + g_decArgo_julD2FloatDayOffset));
      end
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; First grounding phase; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 20));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb EV actions to set first grounding; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 21));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Second grounding pressure; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 22));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Second grounding day (relative to the beginning of current cycle); %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 23));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Second grounding minute; %d; => %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 24), format_time_dec_argo(a_tabTech(id, 24)/60));
      if ~((length(unique(a_tabTech(id, 23:24))) == 1) && (unique(a_tabTech(id, 23:24)) == 0))
         secondGroundingTime = a_tabTech(id, 23) + a_tabTech(id, 24)/1440;
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; => second grounding date; %s\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(secondGroundingTime + g_decArgo_julD2FloatDayOffset));
      end
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Second grounding phase; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 25));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb EV actions to set second grounding; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 26));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; TECH: EMERGENCY ASCENT\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Number of emergency ascents; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 27));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; First emergency ascent day (relative to the beginning of current cycle); %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 31));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; First emergency ascent hour; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 28));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; First emergency ascent pressure; %d; dbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 29));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb pump actions for first emergency ascent; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 30));
      
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; TECH: MISCELLANEOUS\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Nb pump actions before leaving sea floor; %d\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 32));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Speed during grounding; %d; cm/s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 33));
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Internal vacuum (5 mbar resolution) before ascent; %d; => %d mbar\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 34), a_tabTech(id, 34)*5);
   end
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Float last reset hour; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 35));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Float last reset minute; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 36));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Float last reset second; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 37));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Float last reset gregorian day; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 38));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Float last reset gregorian month; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 39));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Float last reset gregorian year; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 40));
   if ~((length(unique(a_tabTech(id, 37:42))) == 1) && (unique(a_tabTech(id, 35:40)) == 0))
      floatLastResetTime = datenum(sprintf('%02d%02d%02d', a_tabTech(id, 35:40)), 'HHMMSSddmmyy') - g_decArgo_janFirst1950InMatlab;
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; => Float last reset date; %s\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(floatLastResetTime));
   else
      fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; => Float last reset date; UNDEFINED\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
   end
   
   if (cycleStartDateDay ~= g_decArgo_dateDef)
      if (a_decoderId == 203)
         fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech #2; Insulation voltage (20 mV resolution); %d; => %d mV\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(id, 41), a_tabTech(id, 41)*20);
      end
   end
end

return;
