% ------------------------------------------------------------------------------
% Print parameter message data in output CSV file.
%
% SYNTAX :
%  print_float_prog_param_in_csv_file_206_to_209(a_floatParam)
%
% INPUT PARAMETERS :
%   a_floatParam : parameter message data
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   04/03/2015 - RNU - creation
% ------------------------------------------------------------------------------
function print_float_prog_param_in_csv_file_206_to_209(a_floatParam)

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% output CSV file Id
global g_decArgo_outputCsvFileId;


if (isempty(a_floatParam))
   return
end

if (size(a_floatParam, 1) > 1)
   fprintf('ERROR: Float #%d cycle #%d: BUFFER anomaly (%d param messages in the buffer)\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, ...
      size(a_floatParam, 1));
elseif (size(a_floatParam, 1) == 1)
   id = 1;
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PARAMETERS PACKET (#%d)\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, id);
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; Transmission time of parameters packet; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(a_floatParam(id, end)));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PARAM: MISCELLANEOUS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; Float time hour; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 2));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; Float time minute; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 3));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; Float time second; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 4));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; Float time gregorian day; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 5));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; Float time gregorian month; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 6));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; Float time gregorian year; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 7));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; => Float time; %s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, julian_2_gregorian_dec_argo(a_floatParam(id, end-1)));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; Float serial number ; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 8));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; Cycle number (that will use these parameters); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 9));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PARAM: MISSION PARAMETERS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM0: Number of cycles; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 10));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM1: Cycle duration; %d; days\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 11));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM2: Float reference day; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 12));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM3: Expected surface time (hour); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 13));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM5: Descent to park sampling time; %d; seconds\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 14));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM6: Drift at park sampling time; %d; hours\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 15));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM7: Ascent sampling time; %d; seconds\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 16));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM8: Park pressure; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 17));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM9: Profile pressure; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 18));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM10: Threshold for shallow to intermediate depth zone; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 19));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM11: Threshold for intermediate to deep depth zone; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 20));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM12: Slice thickness in surface depth zone; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 21));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM13: Slice thickness in intermediate depth zone; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 22));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM14: Slice thickness in deep depth zone; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 23));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM15: Iridium EOL transmission period; %d; minutes\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 24));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM16: Iridium second session waiting time; %d; minutes\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 25));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PM17: Optode type (0: Aanderaa 3830, 1: Aanderaa 4330, 2: none, 3: external, 4: SBE 63, 5: Aanderaa 4330 & SBE 63); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 26));
   
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PARAM: TECHNICAL PARAMETERS\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT0: EV max duration on surface; %d; dsec\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 27));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT1: EV max volume during descent and repositioning; %d; cm3\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 28));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT2: Pump max duration during repositioning; %d; dsec\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 29));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT3: Pump max duration during ascent; %d; dsec\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 30));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT4: Pump duration during buoyancy acquisition; %d; sec\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 31)*10);
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT5: Pressure target tolerance for stabilization; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 32));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT6: Max pressure before emergency ascent; %d; bar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 33));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT7: Buoyancy reduction first threshold; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 34));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT8: Buoyancy reduction second threshold; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 35));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT9: Number of out of tolerance pressures before repositioning; %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 36));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT10: Grounding mode (1 = stay grounded, 0 = pressure switch); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 37));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT11: Min oil volume for grounding detection; %d; cm3\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 38));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT12: Min pressure threshold to switch pressure (in grounding mode 0); %d; bar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 39));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT13: Grounding switch pressure adjustment; %d; bar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 40));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT14: Pressure target tolerance during drift; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 41));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT15: Sensor power acquisition mode (1 = continuous, 2 = pulsed); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 42));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT16: Second profile pressure repetition rate (not used if = 1); %d\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 43));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT17: Second profile pressure; %d; bar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 44));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT18: Average descent speed; %d; mm/s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 45));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT19: Park pressure increment between cycles; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 46));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT20: CTD pump cut-off pressure; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 47));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT21: Iridium timeout; %d; minutes\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 48));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT22: Ascent end threshold; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 49));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT23: Average ascent speed; %d; mm/s\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 50));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT24: Pressure check time ascent; %d; minutes\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 51));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT25: Ascent vertical threshold for buoyancy action; %d; dbar\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 52));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT26: Internal pressure calibration coeficient #1; %.3f\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 53));
   fprintf(g_decArgo_outputCsvFileId, '%d; %d; Prog; PT27: Internal pressure calibration coeficient #2; %f\n', ...
      g_decArgo_floatNum, g_decArgo_cycleNum, a_floatParam(id, 54));
end

return
