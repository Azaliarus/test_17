% ------------------------------------------------------------------------------
% Print float programmed rudics parameter data in output CSV file.
%
% SYNTAX :
%  print_float_prog_rudics_data_in_csv_file_ir_rudics( ...
%    a_cyProfPhaseList, a_cyProfPhaseIndexList, ...
%    a_floatProgRudics)
%
% INPUT PARAMETERS :
%   a_cyProfPhaseList      : information (cycle #, prof #, phase #) on each
%                            received packet
%   a_cyProfPhaseIndexList : index list of the data to print
%   a_floatProgRudics      : float programmed rudics parameter data
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   03/19/2018 - RNU - creation
% ------------------------------------------------------------------------------
function print_float_prog_rudics_data_in_csv_file_ir_rudics( ...
   a_cyProfPhaseList, a_cyProfPhaseIndexList, ...
   a_floatProgRudics)

% current float WMO number
global g_decArgo_floatNum;

% current cycle number
global g_decArgo_cycleNum;

% packet type 248
dataCyProfPhaseList = a_cyProfPhaseList(a_cyProfPhaseIndexList, :);
cyleList = unique(dataCyProfPhaseList(:, 3));
profList = unique(dataCyProfPhaseList(:, 4));

if (~isempty(cyleList))
   if (length(cyleList) > 1)
      fprintf('WARNING: Float #%d Cycle #%d: more than one cycle data in the float programmed RUDICS data SBD files\n', ...
         g_decArgo_floatNum, g_decArgo_cycleNum);
   else
      if (cyleList(1) ~= g_decArgo_cycleNum)
         fprintf('DEC_WARNING: Float #%d Cycle #%d: data cycle number (%d) differs from float programmed RUDICS data SBD file name cycle number (%d)\n', ...
            g_decArgo_floatNum, g_decArgo_cycleNum, ...
            cyleList(1), g_decArgo_cycleNum);
      end
   end
end

% print the float programmed RUDICS data
for idCy = 1:length(cyleList)
   cycleNum = cyleList(idCy);
   for idProf = 1:length(profList)
      profNum = profList(idProf);
      
      idPack = find((dataCyProfPhaseList(:, 3) == cycleNum) & ...
         (dataCyProfPhaseList(:, 4) == profNum));
      
      if (~isempty(idPack))
         % index list of the data
         typeDataList = find((a_cyProfPhaseList(:, 1) == 248));
         dataIndexList = [];
         for id = 1:length(idPack)
            dataIndexList = [dataIndexList; find(typeDataList == a_cyProfPhaseIndexList(idPack(id)))];
         end
         if (~isempty(dataIndexList))
            for idP = 1:length(dataIndexList)
               print_float_prog_rudics_data_in_csv_file_ir_rudics_one( ...
                  cycleNum, profNum, dataIndexList(idP), ...
                  a_floatProgRudics);
            end
         end
         
      end
   end
end

return;
