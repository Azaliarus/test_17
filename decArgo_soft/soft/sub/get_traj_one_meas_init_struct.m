% ------------------------------------------------------------------------------
% Get the basic structure to store one N_MEASUREMENT trajectory information.
%
% SYNTAX :
%  [o_trajOneMeasStruct] = get_traj_one_meas_init_struct()
%
% INPUT PARAMETERS :
%
% OUTPUT PARAMETERS :
%   o_trajOneMeasStruct : one N_MEASUREMENT trajectory initialized structure
%
% EXAMPLES :
%
% SEE ALSO : 
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   03/07/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_trajOneMeasStruct] = get_traj_one_meas_init_struct()

% output parameters initialization
o_trajOneMeasStruct = struct( ...
   'measCode', '', ...
   'juld', '', ...
   'juldStatus', '', ...
   'juldQc', '', ...
   'juldAdj', '', ...
   'juldAdjStatus', '', ...
   'juldAdjQc', '', ...
   'latitude', '', ...
   'longitude', '', ...
   'posAccuracy', '', ...
   'posQc', '', ...
   'posAxErrEllMajor', '', ...
   'posAxErrEllMinor', '', ...
   'posAxErrEllAngle', '', ...
   'satelliteName', '', ...
   'paramList', '', ...
   'paramNumberWithSubLevels', '', ... % position, in the paramList of the parameters with a sublevel
   'paramNumberOfSubLevels', '', ... % number of sublevels for the concerned parameter
   'paramData', [], ...
   'paramDataQc', '', ...
   'paramDataAdj', [], ...
   'paramDataAdjQc', '', ...
   'presOffset', '', ...
   'cyclePhase', -1, ...
   'sensorNumber', -1);

return
