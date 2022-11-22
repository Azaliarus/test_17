% ------------------------------------------------------------------------------
% Get the float WMO instrument type
%
% SYNTAX :
%  [o_wmoInstType] = get_wmo_instrument_type(a_decoderId)
%
% INPUT PARAMETERS :
%   a_decoderId : float decoder Id
%
% OUTPUT PARAMETERS :
%   o_wmoInstType : WMO instrument type
%
% EXAMPLES :
%
% SEE ALSO : 
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   07/16/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_wmoInstType] = get_wmo_instrument_type(a_decoderId)

% output parameters initialization
o_wmoInstType = [];

% current float WMO number
global g_decArgo_floatNum;


switch (a_decoderId)
   
   case {1, 4, 11, 12, 19, 24, 25, 27, 28, 29, 206, 207, 208, 213, 214}
      % Provor, Seabird conductivity sensor
      o_wmoInstType = '841';
      
   case {3, 17, 30, 31, 32, 205, 204, 209, 210, 211, 212, 217}
      % Arvor, Seabird conductivity sensor
      o_wmoInstType = '844';
      
   case {105, 106, 107, 108, 109, 110, 111, 112, 301}
      % PROVOR_III float
      o_wmoInstType = '836';
      
   case {121, 122, 123, 124}
      % PROVOR_IV float
      o_wmoInstType = '835';
      
   case {201, 202, 203, 215, 216}
      % Arvor-D float
      o_wmoInstType = '838';
      
   case {302, 303}
      % Arvor-C float
      o_wmoInstType = '837';
      
   case {1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, ...
         1012, 1013, 1014, 1015, 1016, 1021, 1022, ...
         1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, ...
         1112, 1113, ...
         1314, ...
         1121, ...
         1321, 1322}
      % Webb Research, Seabird sensor
      o_wmoInstType = '846';
      
   case {1201}
      % Navis-A Float
      o_wmoInstType = '863';
      
   case {2001, 2002, 2003}
      % Nova & Dova float
      o_wmoInstType = '865';
      
      %    case {2002}
      %       % Dova float
      %       o_wmoInstType = '869';
      
   otherwise
      o_wmoInstType = '';
      fprintf('WARNING: Float #%d: No instrument reference assigned to decoderId #%d\n', ...
         g_decArgo_floatNum, ...
         a_decoderId);
      
end

return;
