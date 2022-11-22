% ------------------------------------------------------------------------------
% Retrieve the list of sensors mounted on a given CTS5 float.
% 
% SYNTAX :
%  [o_sensorList] = get_sensor_list_cts5(a_floatNum)
% 
% INPUT PARAMETERS :
%   a_floatNum : WMO number of the concerned float
% 
% OUTPUT PARAMETERS :
%   o_sensorList : list of sensors mounted on the float
% 
% EXAMPLES :
% 
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   02/21/2017 - RNU - creation
% ------------------------------------------------------------------------------
function [o_sensorList] = get_sensor_list_cts5(a_floatNum)

o_sensorList = [];

% get the list of BGC sensors for this float
switch a_floatNum
   case { ...
         4901801, ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}];
   case { ...
         4901802, ...
         6902667, ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'OCR'}; {'ECO3'}; {'SUNA'}];
   case { ...
         4901803, ...
         6902668, ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'OCR'}; {'ECO3'}];
   otherwise
      fprintf('ERROR: Unknown sensor list for float #%d => nothing done for this float\n', a_floatNum);
end

% get the list of NOT BGC sensors for this float
switch a_floatNum
   case { ...
         4901802, ...
         4901803, ...
         6902667, ...
         }
      o_sensorList = [o_sensorList; {'PSA_916'}];
   case { ...
         6902668, ...
         }
      o_sensorList = [o_sensorList; {'PSA_916'}; {'OPT_TAK'}];
end

return;
