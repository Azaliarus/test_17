% ------------------------------------------------------------------------------
% Read Apex Iridium Sbd log file.
%
% SYNTAX :
%  [o_error, o_events] = read_apx_ir_sbd_log_file(a_logFileName)
%
% INPUT PARAMETERS :
%   a_logFileName : log file name
%
% OUTPUT PARAMETERS :
%   o_error  : parsing error flag
%   o_events : linput log file event data
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   11/03/2017 - RNU - creation
% ------------------------------------------------------------------------------
function [o_error, o_events] = read_apx_ir_sbd_log_file(a_logFileName)

% output parameters initialization
o_error = 0;
o_events = [];

% default values
global g_decArgo_janFirst1950InMatlab;


VERBOSE = 0;

if ~(exist(a_logFileName, 'file') == 2)
   fprintf('ERROR: File not found: %s\n', a_logFileName);
   return
end

% open the file and read the data
fId = fopen(a_logFileName, 'r');
if (fId == -1)
   fprintf('ERROR: Unable to open file: %s\n', a_logFileName);
   return
end

END = '<EOT>';

endFlag = 0;

lineNum = 0;
eventNum = 1;
while 1
   line = fgetl(fId);
   
   if (line == -1)
      if (endFlag ~= 1)
         %          fprintf('WARNING: End of file without ''<EOT>'' in file: %s\n', a_logFileName);
      end
      break
   end
   
   lineNum = lineNum + 1;
   line = strtrim(line);
   if (isempty(line))
      continue
   end
   
   if (any(strfind(line, END)))
      endFlag = 1;
   else
      endFlag = 0;
      done = 0;
      if (line(1) == '(')
         idF1 = strfind(line, ')');
         if (~isempty(idF1))
            
            [val, count, errmsg, nextIndex] = sscanf(line(2:idF1(1)-1), '%3c %d %d %d:%d:%d, %d sec');
            if (isempty(errmsg) && (count == 7))
            
               idF2 = strfind(line, ',');
               evtDate = datenum(line(2:idF2(1)-1), 'mmm dd yyyy HH:MM:SS') - g_decArgo_janFirst1950InMatlab;
               evtMtime = val(9);
               line2 = strtrim(line(idF1(1)+1:end));
               idF3 = strfind(line2, ' ');
               if (~isempty(idF3))
                  evtCmd = line2(1:idF3(1)-1);
                  evtInfo = strtrim(line2(idF3(1)+1:end));
               else
                  evtCmd = line2(1:end);
                  evtInfo = '';
               end
               
               newEvent = [];
               newEvent.number = eventNum;
               newEvent.time = evtDate;
               newEvent.mTime = evtMtime;
               newEvent.cmd = evtCmd;
               newEvent.info = evtInfo;
               newEvent.line = lineNum;
               o_events = [o_events newEvent];
               done = 1;
               eventNum = eventNum + 1;
            end
         end
      end
      
      if (~done)
         if (VERBOSE == 1)
            fprintf('PARSE_INFO: Line #%d : ''%s'' ignored in file: %s\n', lineNum, line, a_logFileName);
         end
      end
   end
end

fclose(fId);

if (isempty(o_events))
   o_error = 1;
end

return
