% ------------------------------------------------------------------------------
% Print float pressure data in output CSV file.
%
% SYNTAX :
%  print_float_pressure_data_in_csv_file_ir_rudics( ...
%    a_cyProfPhaseList, a_cyProfPhaseIndexList, ...
%    a_floatPres)
%
% INPUT PARAMETERS :
%   a_cyProfPhaseList      : information (cycle #, prof #, phase #) on each
%                            received packet
%   a_cyProfPhaseIndexList : index list of the data to print
%   a_floatPres            : float pressure data
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   02/11/2013 - RNU - creation
% ------------------------------------------------------------------------------
function print_float_pressure_data_in_csv_file_ir_rudics( ...
   a_cyProfPhaseList, a_cyProfPhaseIndexList, ...
   a_floatPres)

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% output CSV file Id
global g_decArgo_outputCsvFileId;

% unpack the input data
a_floatPresPumpOrEv = a_floatPres{1};
a_floatPresActPres = a_floatPres{2};
a_floatPresTime = a_floatPres{3};

% packet type 252
dataCyProfPhaseList = a_cyProfPhaseList(a_cyProfPhaseIndexList, :);
cyleList = unique(dataCyProfPhaseList(:, 3));
profList = unique(dataCyProfPhaseList(:, 4));
phaseList = unique(dataCyProfPhaseList(:, 5));

if (~isempty(cyleList))
   if (length(cyleList) > 1)
      fprintf('WARNING: Float #%d Cycle #%d: more than one cycle data in the float pressure data SBD files\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
   else
      if (cyleList(1) ~= g_decArgo_cycleNum)
         fprintf('DEC_WARNING: Float #%d Cycle #%d: data cycle number (%d) differs from float pressure data SBD file name cycle number (%d)\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, ...
            cyleList(1), g_decArgo_cycleNum);
      end
   end
end

% index list of the data
typeDataList = find(a_cyProfPhaseList(:, 1) == 252);
dataIndexList = [];
for id = 1:length(a_cyProfPhaseIndexList)
   dataIndexList = [dataIndexList; find(typeDataList == a_cyProfPhaseIndexList(id))];
end

% print the float pressure data
for idCy = 1:length(cyleList)
   cycleNum = cyleList(idCy);
   for idProf = 1:length(profList)
      profNum = profList(idProf);
      for idPhase = 1:length(phaseList)
         phaseNum = phaseList(idPhase);

         idPack = find((a_floatPresPumpOrEv(dataIndexList, 1) == cycleNum) & ...
            (a_floatPresPumpOrEv(dataIndexList, 2) == profNum) & ...
            (a_floatPresPumpOrEv(dataIndexList, 3) == phaseNum));
         
         if (~isempty(idPack))
            fprintf(g_decArgo_outputCsvFileId, '%d; %d; %d; %s; Tech float pres; Pum(1)/Ev(0); Pres (bar); Rel. time (min)\n', ...
               g_decArgo_floatNum, cycleNum, profNum, get_phase_name(phaseNum));

            for id = 1:length(idPack)
               idP = dataIndexList(idPack(id));

               fprintf(g_decArgo_outputCsvFileId, '%d; %d; %d; %s; Tech float pres; %d; %d; %d\n', ...
                  g_decArgo_floatNum, cycleNum, profNum, get_phase_name(phaseNum), ...
                  a_floatPresPumpOrEv(idP, 4), a_floatPresActPres(idP, 4), a_floatPresTime(idP, 4));

            end
         end
      end
   end
end

return;
