% ------------------------------------------------------------------------------
% Print technical message #1 data in output CSV file.
%
% SYNTAX :
%  print_tech1_data_in_csv_30_32(a_tabTech)
%
% INPUT PARAMETERS :
%   a_tabTech : decoded technical msg #1 data
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   05/10/2015 - RNU - creation
% ------------------------------------------------------------------------------
function print_tech1_data_in_csv_30_32(a_tabTech)

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% output CSV file Id
global g_decArgo_outputCsvFileId;

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; TECHNICAL MESSAGE #1 CONTENTS\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum);

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Cycle number; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(1));

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; External bladder state at deployment (0: float stay at surface, 1: heavy float at deployment); %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(2));

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Real valve opening time at surface; %d; =>; %d; seconds\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(3), a_tabTech(3)*10);
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Additional valve actions at surface; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(4));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Grounding at surface (0 : no grounding, 1 : grounding); %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(5));

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Nb of valve actions in descent to parking depth; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(6));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Nb of pump actions in descent to parking depth; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(7));

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Nb of entrance in drift target range; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(8));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Nb of repositionning in parking stand-by; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(9));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of valve actions during drift at parking depth; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(10));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of pump actions during drift at parking depth; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(11));

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Nb of valve actions in descent to profile depth; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(12));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Nb of pump actions in descent to profile depth; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(13));

if (a_tabTech(18) > 0)
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; First Grounding pressure (1 bar res.); %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(14));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; First Grounding day relative to cycle start; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(15));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; First Grounding hour; %d; =>; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(16), format_time_dec_argo(a_tabTech(16)*6/60));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; First Grounding phase; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(17));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Total Grounding number; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(18));
end

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of entrance in profile target range; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(19));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of repositionning in profile stand-by; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(20));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of valve actions during drift at profile depth; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(21));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of pump actions during drift at profile depth; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(22));

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of pump actions in ascent; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(23));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of pump actions in ascent for float lift-up; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(24));

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of descent CTD messages; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(25));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of drift CTD messages; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(26));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of ascent CTD messages; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(27));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of descent slices in shallow zone; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(28));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of descent slices in deep zone; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(29));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of CTD measurements in drift; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(30));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of ascent slices in shallow zone; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(31));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of ascent slices in deep zone; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(32));

fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Internal vacuum; %d; =>; %s\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(33), decode_internal_pressure(a_tabTech(33)));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Internal vacuum at profile start; %d; =>; %s\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(34), decode_internal_pressure(a_tabTech(34)));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Battery voltage drop at Pmax, pump ON (with regards to Unom = 15.0 V, in dV); %d; =>; %.1f; V\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(35), 15-(a_tabTech(35)/10));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; RTC error (0: normal, 1: failure); %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(36));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; CTD error (0: no error, 1: time-out, 2: incomplete or broken frame, 3: fast pressure default); %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(37));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; CTD default phase; %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(38));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Oxygen sensor status (0: OK, 1: problem); %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(39));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Auto-test flag (0: problem, 1: OK); %d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(40));
fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Last reset date (DD/MM); %02d/%02d\n', ...
   g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(41), a_tabTech(42));

if (a_tabTech(43) > 0)
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Number of emergency ascent; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(43));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; First emergency ascent hour; %d; =>; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(44), format_time_dec_argo(a_tabTech(44)*6/60));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; First emergency ascent pressure (1 bar res.); %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(45));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; Pump actions during emergency ascent; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(46));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Tech1; First emergency ascent day relative to cycle start; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_tabTech(47));
end

return;
