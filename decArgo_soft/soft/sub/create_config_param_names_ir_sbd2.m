% ------------------------------------------------------------------------------
% Create configuration parameter lists of decoder names and NetCDF names.
%
% SYNTAX :
%  [o_decArgoConfParamNames, o_ncConfParamNames] = create_config_param_names_ir_sbd2(a_decoderId)
%
% INPUT PARAMETERS :
%   a_decoderId : float decoder Id
%
% OUTPUT PARAMETERS :
%   o_decArgoConfParamNames : internal configuration parameter names
%   o_ncConfParamNames      : NetCDF configuration parameter names
%
% EXAMPLES :
%
% SEE ALSO : 
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   12/01/2014 - RNU - creation
% ------------------------------------------------------------------------------
function [o_decArgoConfParamNames, o_ncConfParamNames] = create_config_param_names_ir_sbd2(a_decoderId)

% output parameters initialization
o_decArgoConfParamNames = [];
o_ncConfParamNames = [];

% current float WMO number
global g_decArgo_floatNum;


switch (a_decoderId)
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   case {301} % Remocean FLBB
      
      [o_decArgoConfParamNames, o_ncConfParamNames] = create_config_param_names_ir_sbd2_301;
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
   case {302, 303} % Arvor CM
      
      [o_decArgoConfParamNames, o_ncConfParamNames] = create_config_param_names_ir_sbd2_302_303(a_decoderId);
      
   otherwise
      fprintf('WARNING: Float #%d: Nothing implemented yet to create configuration parameter names for decoderId #%d\n', ...
         g_decArgo_floatNum, ...
         a_decoderId);
end

return;
