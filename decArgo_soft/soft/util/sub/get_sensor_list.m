% ------------------------------------------------------------------------------
% Retrieve the list of sensors mounted on a given float.
%
% SYNTAX :
%  [o_sensorList] = get_sensor_list(a_floatNum)
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
%   09/16/2015 - RNU - creation
% ------------------------------------------------------------------------------
function [o_sensorList] = get_sensor_list(a_floatNum)

o_sensorList = [];

% get the list of sensors for this float
switch a_floatNum
   case { ...
         3902120, ...
         3902121, ...
         3902122, ...
         3902123, ...
         3902124, ...
         3902125, ...
         6901032, ...
         6901437, ...
         6901472, ...
         6901483, ...
         6901484, ...
         6901485, ...
         6901490, ...
         6901510, ...
         6901512, ...
         6901514, ...
         6901515, ...
         6901521, ...
         6901522, ...
         6901528, ...
         6901580, ...
         6901648, ...
         6901689, ...
         6901764, ...
         6901765, ...
         6901766, ...
         6901767, ...
         6901768, ...
         6901769, ...
         6901770, ...
         6901771, ...
         6903197, ...
         6902733, ...
         6901659, ...
         6901773, ...
         6901865, ...
         6901866, ...
         6902701, ...
         6902741, ...
         6902700 ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'OCR'}; {'ECO3'}; {'SUNA'}];
   case { ...
         6901438, ...
         6901473, ...
         6901496, ...
         6901581, ...
         6901584, ...
         6901585, ...
         6901646, ...
         6902738, ...
         6902739, ...
         6901776 ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'OCR'}; {'ECO3'}; {'CROVER'}];
   case { ...
         6901439, ...
         6901486, ...
         6901519, ...
         6901523, ...
         6901573, ...
         6901577, ...
         6901578, ...
         6901579, ...
         6901649, ...
         6901656, ...
         6901658, ...
         6901688, ...
         6902546, ...
         6902547, ...
         7900591, ...
         6902734, ...
         6902737, ...
         6902735, ...
         6902736, ...
         6902740, ...
         6901152, ...
         3901496, ...
         3901497, ...
         3901498, ...
         3901530, ...
         3901531, ...
         6901151, ...
         6901174, ...
         6901175, ...
         6901180, ...
         6901181, ...
         6901182, ...
         6901183, ...
         7900592 ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'OCR'}; {'ECO3'}];
   case { ...
         6901004, ...
         6901440, ...
         6901474, ...
         6901582, ...
         6901583 ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'OCR'}; {'ECO3'}; {'CROVER'}; {'SUNA'}];
   case { ...
         6901475, ...
         6901480, ...
         6901481, ...
         6901482, ...
         6901489, ...
         6901491, ...
         6901492, ...
         6901493, ...
         6901494, ...
         6901495, ...
         6901511, ...
         6901513, ...
         6901516, ...
         6901517, ...
         6901518, ...
         6901520, ...
         6901524, ...
         6901525, ...
         6901526, ...
         6901527, ...
         6901529, ...
         6901574, ...
         6901575, ...
         6901576, ...
         6901600, ...
         6901605, ...
         6901647, ...
         6901650, ...
         6901651, ...
         6901653, ...
         6901655, ...
         6901660, ...
         6901687, ...
         6901860, ...
         6901861, ...
         6901862, ...
         6901863, ...
         6902732, ...
         6902827, ...
         6902826, ...
         6901864 ...
         }
      o_sensorList = [{'CTD'}; {'OCR'}; {'ECO3'}];
   case { ...
         6901654 ...
         }
      o_sensorList = [{'CTD'}; {'OCR'}; {'ECO3'}; {'SUNA'}];
   case { ...
         6900807 ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'ECO3'}];
   case { ...
         2902086, ...
         2902087, ...
         2902088, ...
         2902089, ...
         2902090, ...
         2902091, ...
         2902092, ...
         2902093, ...
         2902113, ...
         2902114, ...
         2902115, ...
         2902118, ...
         2902120, ...
         2902123, ...
         2902124, ...
         2902129, ...
         2902130, ...
         2902131 ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'FLBB'}];
   case { ...
         2902238, ...
         2902239, ...
         2902240, ...
         2902241, ...
         2902242, ...
         2902243, ...
         2902244, ...
         2902245 ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'ECO2'}];
   case { ...
         6901748, ...
         6902680 ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'FLNTU'}];
   case { ...
         6901749 ...
         }
      o_sensorList = [{'CTD'}; {'OPTODE'}; {'FLNTU'}; {'CYCLOPS'}; {'SEAPOINT'}];
   otherwise
      fprintf('ERROR: Unknown sensor list for float #%d => nothing done for this float\n', a_floatNum);
end

return;
