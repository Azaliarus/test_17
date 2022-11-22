% ------------------------------------------------------------------------------
% Launch the RT Matlab decoder on a list of float WMO numbers.
%
% SYNTAX :
%   start_decode_bis
%
% INPUT PARAMETERS :
%
% OUTPUT PARAMETERS :
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   12/14/2017 - RNU - creation
% ------------------------------------------------------------------------------
function start_decode_bis

% Remoceans au 14/12/2017
wmoList = [ ...
%    6901475 ...
%    6901511 ...
%    6901516 ...
%    6901518 ...
%    6901520 ...
%    6901517 ...
%    6901513 ...
%    6901527 ...
%    6901524 ...
%    6901525 ...
%    6901526 ...
%    6901529 ...
%    6901491 ...
%    6901489 ...
%    6901480 ...
%    6901481 ...
%    6901482 ...
%    6901495 ...
%    6901494 ...
%    6901492 ...
%    6901493 ...
%    6901605 ...
%    6901860 ...
%    6901861 ...
%    6901647 ...
%    6901653 ...
%    6901655 ...
%    6901600 ...
%    6901651 ...
%    6901576 ...
%    6901574 ...
%    6901650 ...
%    6901654 ...
%    6901575 ...
%    6901660 ...
%    6901687 ...
%    6901862 ...
%    6901863 ...
%    6901864 ...
%    6902732 ...
%    6902827 ...
%    6902826 ...
%    6901032 ...
%    6901519 ...
%    6901483 ...
%    6901473 ...
%    6901474 ...
%    6901472 ...
%    6901440 ...
%    6901437 ...
%    6901438 ...
%    6901439 ...
%    6901512 ...
%    6901514 ...
%    6901515 ...
%    6901522 ...
%    6901523 ...
%    6901521 ...
%    6901528 ...
%    6901510 ...
%    6901490 ...
%    6901485 ...
%    6901486 ...
%    6901484 ...
%    6901496 ...
%    6901865 ...
%    6901776 ...
%    6901646 ...
%    6901648 ...
%    6901649 ...
%    6900807 ...
%    6901582 ...
%    6901688 ...
%    6901585 ...
%    6901579 ...
%    6901581 ...
%    6901689 ...
%    6901004 ...
%    6901580 ...
%    6901578 ...
%    6901584 ...
%    6901764 ...
%    6901765 ...
%    6901766 ...
%    6901767 ...
%    6901768 ...
%    6901583 ...
%    6901656 ...
%    6901658 ...
%    6901769 ...
%    6901770 ...
%    6901771 ...
%    6901773 ...
%    6901577 ...
%    6902700 ...
%    6901573 ...
%    6901659 ...
%    6902701 ...
%    6902733 ...
%    6903197 ...
%    6902734 ...
%    6902737 ...
%    6902738 ...
%    6902736 ...
%    6902740 ...
%    6902735 ...
%    6902739 ...
%    6902741 ...
%    6902828 ...
%    7900592 ...
%    7900591 ...
%    6902546 ...
%    6902547 ...
%    6901152 ...
%    3901496 ...
   3901497 ...
   3901498 ...
   3901530 ...
   3901531 ...
   6901151 ...
   6901174 ...
   6901175 ...
   6901180 ...
   6901181 ...
   6901182 ...
   6901183 ...
   6901866 ...
   % a refaire car rest�s en mode DM
   %    6901475 ...
   %    6901518 ...
   %    6901520 ...
   %    6901517 ...
   %    6901526 ...
   %    6901481 ...
   %    6901495 ...
   %    6901605 ...
   %    6901032 ...
   %    6901483 ...
   %    6901440 ...
   %    6901438 ...
   %    6901512 ...
   %    6901514 ...
   %    6901515 ...
   %    6901522 ...
   %    6901521 ...
   %    6901490 ...
   %    6901484 ...
   %    6901496 ...
   %    7900592 ...
   %    6902546 ...
   % incois
   %    2902089 ...
   %    2902090 ...
   %    2902091 ...
   %    2902113 ...
   %    2902129 ...
   ];

nbFloats = length(wmoList);
for idFloat = 1:nbFloats
   floatNumStr = num2str(wmoList(idFloat));
   fprintf('%d/%d : %s\n', idFloat, nbFloats, floatNumStr);
   
   cmd = ['matlab -nodesktop -nosplash -r "decode_provor_2_csv(' floatNumStr ');exit"'];
   tic;
   system(cmd);
   ellapsedTime = toc;
   fprintf('Done (%.1f min)\n', ellapsedTime/60);
end

return;
