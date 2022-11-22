% ------------------------------------------------------------------------------
% Read and decode SBD data file.
%
% SYNTAX :
%  [o_decodedData] = decode_sbd_file(a_sbdFileName, a_sbdFileDate, a_decoderId)
%
% INPUT PARAMETERS :
%   a_sbdFileName : SBD file name
%   a_sbdFileName : SBD file date
%   a_decoderId   : float decoder Id
%
% OUTPUT PARAMETERS :
%   o_decodedData : decoded data
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   12/17/2018 - RNU - creation
% ------------------------------------------------------------------------------
function [o_decodedData] = decode_sbd_file(a_sbdFileName, a_sbdFileDate, a_decoderId)

% output parameters initialization
o_decodedData = [];

% current float WMO number
global g_decArgo_floatNum;

% SBD sub-directories
global g_decArgo_archiveSbdDirectory;


% read SBD data
sbdFilePathName = [g_decArgo_archiveSbdDirectory '/' a_sbdFileName];
sbdDataTab = [];
file = dir(sbdFilePathName);
fileSize = file(1).bytes;
if (rem(fileSize, 100) == 0)
   fId = fopen(sbdFilePathName, 'r');
   if (fId == -1)
      fprintf('ERROR: Float #%d: Error while opening file : %s\n', ...
         g_decArgo_floatNum, ...
         sbdFilePathName);
      return
   end
   sbdData = fread(fId);
   fclose(fId);
   
   sbdData = reshape(sbdData, 100, size(sbdData, 1)/100)';
   for idMsg = 1:size(sbdData, 1)
      data = sbdData(idMsg, :);
      if (any(data ~= 0))
         sbdDataTab = [sbdDataTab; data];
      end
   end
   
else
   fprintf('DEC_WARNING: Float #%d: SBD file ignored because of unexpected size (%d bytes) : %s\n', ...
      g_decArgo_floatNum, ...
      fileSize, ...
      sbdFilePathName);
   return
end

% decode SBD data
for idMsg = 1:size(sbdDataTab, 1)
   
   switch (a_decoderId)
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case {212} % Arvor-ARN-Ice Iridium
         
         % decode the collected data
         decodedData = decode_prv_data_ir_sbd_212(sbdDataTab(idMsg, :), ...
            a_sbdFileName, a_sbdFileDate);
         o_decodedData = [o_decodedData decodedData];
         
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   case {214, 217}
      % Provor-ARN-DO-Ice Iridium 5.75
      % Arvor-ARN-DO-Ice Iridium 5.46
         
         % decode the collected data
         decodedData = decode_prv_data_ir_sbd_214_217(sbdDataTab(idMsg, :), ...
            a_sbdFileName, a_sbdFileDate);
         o_decodedData = [o_decodedData decodedData];         
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      case {216} % Arvor-Deep-Ice Iridium 5.65
         
         % decode the collected data
         decodedData = decode_prv_data_ir_sbd_216(sbdDataTab(idMsg, :), ...
            a_sbdFileName, a_sbdFileDate);
         o_decodedData = [o_decodedData decodedData];
            
      otherwise
         fprintf('WARNING: Float #%d: Nothing implemented yet in decode_sbd_file for decoderId #%d\n', ...
            g_decArgo_floatNum, ...
            a_decoderId);
   end
end

return