% ------------------------------------------------------------------------------
% Launch the RT Matlab decoder on a list of float WMO numbers.
%
% SYNTAX :
%   start_decode
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
%   02/21/2017 - RNU - creation
% ------------------------------------------------------------------------------
function start_decode

wmoList = [ ...
   6901032 ...
   6901473 ...
   6901474 ...
   6901475 ...
   6901472 ...
   6901440 ...
   6901437 ...
   6901438 ...
   6901439 ...
   6901511 ...
%    6901512 ...
%    6901516 ...
%    6901518 ...
%    6901514 ...
%    6901515 ...
%    6901520 ...
%    6901519 ...
%    6901517 ...
%    6901513 ...
%    6901522 ...
%    6901527 ...
%    6901523 ...
%    6901524 ...
%    6901525 ...
%    6901526 ...
%    6901521 ...
%    6901528 ...
%    6901529 ...
%    6901510 ...
%    6901491 ...
%    6901490 ...
%    6901489 ...
%    6901480 ...
%    6901481 ...
%    6901485 ...
%    6901482 ...
%    6901486 ...
%    6901484 ...
%    6901496 ...
%    6901483 ...
%    6901495 ...
%    6901494 ...
%    6901492 ...
%    6901493 ...
%    7900592 ...
%    7900591 ...
%    6902546 ...
%    6902547 ...
%    6901605 ...
%    6901860 ...
%    6901865 ...
%    6901776 ...
%    6901861 ...
%    6901647 ...
%    6901646 ...
%    6901648 ...
%    6901653 ...
%    6901649 ...
%    6901655 ...
%    6901600 ...
%    6901651 ...
%    6900807 ...
%    6901582 ...
%    6901576 ...
%    6901688 ...
%    6901585 ...
%    6901574 ...
%    6901579 ...
%    6901581 ...
%    6901689 ...
%    6901004 ...
%    6901580 ...
%    6901578 ...
%    6901584 ...
%    6901650 ...
%    6901654 ...
%    6901764 ...
%    6901765 ...
%    6901766 ...
%    6901767 ...
%    6901768 ...
%    6901575 ...
%    6901583 ...
%    6901656 ...
%    6901658 ...
%    6901660 ...
%    6901687 ...
%    6901862 ...
%    6901769 ...
%    6901770 ...
%    6901771 ...
%    6901773 ...
%    6901577 ...
%    6902700 ...
%    6901573 ...
%    6901863 ...
%    6901864 ...
%    6901659 ...
%    6902701 ...
%    6902732 ...
%    6902733 ...
%    6903197 ...
%    6901866 ... % pas de fichier JSON
   ];

configFile = 'C:\Users\jprannou\_RNU\DecArgo_soft\soft\_argo_decoder_conf_REM_RUDICS.json';

nbFloats = 10;
floatNum = 0;
for idFloat = length(wmoList):-1:1
   floatNumStr = num2str(wmoList(idFloat));
   fprintf('%d/%d : %s\n', floatNum+1, nbFloats, floatNumStr);
   
   cmd = ['matlab -nodesktop -nosplash -r "decode_argo_2_nc_rt(''rsynclog'', ''all'', ''configfile'', ''' configFile ''', ''floatwmo'', ''' floatNumStr ''');exit"'];
   tic;
   system(cmd);
   ellapsedTime = toc;
   fprintf('Done (%.1f min)\n', ellapsedTime/60);

   floatNum = floatNum + 1;
   if (floatNum == nbFloats)
      break;
   end
end

return;
