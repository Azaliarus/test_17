% ------------------------------------------------------------------------------
% G�n�ration du code kml permettant de cr�er une ligne.
%
% SYNTAX :
%   [o_kmlStr] = ge_create_line(a_lon, a_lat, a_description, a_name, a_style,
%                               a_timeSpanStart, a_timeSpanEnd)
%
% INPUT PARAMETERS :
%   a_lon, a_lat    : coordonn�es de la ligne
%   a_description   : contenu du champ 'description'
%   a_name          : contenu du champ 'name'
%   a_style         : style (pr�d�fini) utilis� pour la ligne
%   a_timeSpanStart : date de d�but d'affichage de la ligne
%   a_timeSpanEnd   : date de fin d'affichage de la ligne
%
% OUTPUT PARAMETERS :
%   o_kmlStr : code kml g�n�r�
%
% EXAMPLES :
%
% SEE ALSO : 
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   01/01/2009 - RNU - creation
% ------------------------------------------------------------------------------
function [o_kmlStr] = ge_create_line(a_lon, a_lat, a_description, a_name, ...
   a_style, a_timeSpanStart, a_timeSpanEnd)

o_kmlStr = [];

timeSpanStartStr = [];
timeSpanEndStr = [];
if (~isempty(a_timeSpanStart))
   timeSpanStartStr = [ ...
      9, 9, 9, '<begin>', a_timeSpanStart, '</begin>', 10, ...
      ];
end
if (~isempty(a_timeSpanEnd))
   timeSpanEndStr = [ ...
      9, 9, 9, '<end>', a_timeSpanEnd, '</end>', 10, ...
      ];
end
timeSpanStr = [ ...
   9, 9, '<TimeSpan>', 10, ...
   timeSpanStartStr, ...
   timeSpanEndStr, ...
   9, 9, '</TimeSpan>', 10, ...
   ];

coordinatesLine = [];
for idPos = 1:length(a_lon)
   coordinatesLine = [ coordinatesLine ...
      sprintf('%.3f,%.3f,0 ', a_lon(idPos), a_lat(idPos))];
end

o_kmlStr = [ ...
   9, '<Placemark>', 10, ...
   9, 9, '<description>', 10, ...
   9, 9, 9, '<![CDATA[' a_description ']]>', 10, ...
   9, 9, '</description>', 10, ...
   9, 9, '<name>', a_name, '</name>', 10, ...
   9, 9, '<styleUrl>', a_style, '</styleUrl>', 10, ...
   timeSpanStr, ...
   9, 9, '<LineString>', 10, ...
   9, 9, 9, '<coordinates>', 10, ...
   9, 9, 9, 9, coordinatesLine, 10, ...
   9, 9, 9, '</coordinates>', 10, ...
   9, 9, '</LineString>', 10, ...
   9, '</Placemark>', 10, ...
   ];

return;
