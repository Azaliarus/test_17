% ------------------------------------------------------------------------------
% Retrieve nominal resolution value and specific comment on unusual resolution
% for a given parameter of a decoder.
%
% SYNTAX :
%  [o_resolution, o_comment] = get_param_comment_on_resolution(a_paramName, a_decoderId)
%
% INPUT PARAMETERS :
%   a_paramName : parameter name
%   a_decoderId : float decoder Id
%
% OUTPUT PARAMETERS :
%   o_resolution : nominal resolution value
%   o_comment    : specific comment on unusual resolutions
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   07/18/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_resolution, o_comment] = get_param_comment_on_resolution(a_paramName, a_decoderId)

% output parameter initialization
o_resolution = [];
o_comment = [];

% current float WMO number
global g_decArgo_floatNum;

% global measurement codes
global g_MC_CycleStart;
global g_MC_DST;
global g_MC_FST;
global g_MC_SpyInDescToPark;
global g_MC_DescProf;
global g_MC_MaxPresInDescToPark;
global g_MC_DescProfDeepestBin;
global g_MC_PST;
global g_MC_SpyAtPark;
global g_MC_DriftAtPark;
global g_MC_MinPresInDriftAtPark;
global g_MC_MaxPresInDriftAtPark;
global g_MC_PET;
global g_MC_SpyInDescToProf;
global g_MC_MaxPresInDescToProf;
global g_MC_DPST;
global g_MC_SpyAtProf;
global g_MC_MinPresInDriftAtProf;
global g_MC_MaxPresInDriftAtProf;
global g_MC_AST;
global g_MC_AST_Float;
global g_MC_AscProfDeepestBin;
global g_MC_SpyInAscProf;
global g_MC_AscProf;
global g_MC_AET;
global g_MC_AET_Float;
global g_MC_TST;
global g_MC_TST_Float;
global g_MC_TET;
global g_MC_Grounded;
global g_MC_InAirSeriesOfMeas;


switch (a_decoderId)
   case {1, 4, 11, 12, 19, 24, 25, 27, 28, 29, 3, 17, 31}
      % PROVOR Argos
      % ARVOR Argos
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(1);
            
            listMc = [ ...
               g_MC_FST; ...
               g_MC_MaxPresInDescToPark; ...
               g_MC_MinPresInDriftAtPark; g_MC_MaxPresInDriftAtPark; ...
               g_MC_MaxPresInDescToProf];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 dbar, except for measurement codes [%s] for which %s resolution is 10 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(1);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
            if (ismember(a_decoderId, [4 19 25 27 28 29])) % DO floats
               listMc = [ ...
                  g_MC_DST; ...
                  g_MC_FST; ...
                  g_MC_DescProf; ...
                  g_MC_DescProfDeepestBin; ...
                  g_MC_PST; ...
                  g_MC_DriftAtPark; ...
                  g_MC_PET; ...
                  g_MC_DPST; ...
                  g_MC_AST; ...
                  g_MC_AscProfDeepestBin; ...
                  g_MC_AscProf; ...
                  g_MC_AET; ...
                  g_MC_InAirSeriesOfMeas; ...
                  g_MC_TST];
            else
               listMc = [ ...
                  g_MC_DST; ...
                  g_MC_FST; ...
                  g_MC_DescProf; ...
                  g_MC_DescProfDeepestBin; ...
                  g_MC_PST; ...
                  g_MC_DriftAtPark; ...
                  g_MC_PET; ...
                  g_MC_DPST; ...
                  g_MC_AST; ...
                  g_MC_AscProfDeepestBin; ...
                  g_MC_AscProf; ...
                  g_MC_AET; ...
                  g_MC_TST];
            end
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 second, except for measurement codes [%s] for which %s resolution is 6 minutes', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(6/1440); % 6 minutes
            
         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {30, 32}
      % ARVOR Argos ARN
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(1);
            
            listMc = [ ...
               g_MC_FST; ...
               g_MC_MaxPresInDescToPark; ...
               g_MC_MaxPresInDescToProf; ...
               g_MC_MinPresInDriftAtProf; g_MC_MaxPresInDriftAtProf; ...
               g_MC_Grounded];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 dbar, except for measurement codes [%s] for which %s resolution is 10 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(1);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
            listMc1 = [ ...
               g_MC_CycleStart; ...
               g_MC_DST; ...
               g_MC_DescProf; ...
               g_MC_DescProfDeepestBin; ...
               g_MC_PST; ...
               g_MC_DriftAtPark; ...
               g_MC_PET; ...
               g_MC_AST; ...
               g_MC_AscProfDeepestBin; ...
               g_MC_AscProf; ...
               g_MC_AET; ...
               g_MC_TST
               g_MC_TET];
            listMc6 = [ ...
               g_MC_FST; ...
               g_MC_DPST; ...
               g_MC_Grounded];
            listMc1Str = sprintf('%d ', listMc1);
            listMc6Str = sprintf('%d ', listMc6);
            o_comment = sprintf('%s resolution is 1 second, except for measurement codes [%s] for which %s resolution is 1 minute and for measurement codes [%s] for which %s resolution is 6 minutes', ...
               a_paramName, listMc1Str(1:end-1), a_paramName, listMc6Str(1:end-1), a_paramName);
            
         case {'JULD_DESCENT_START', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/1440); % 1 minute
            
         case {'JULD_FIRST_STABILIZATION', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START'}
            
            o_resolution = double(6/1440); % 6 minutes
            
         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end      
      
   case {105, 106, 107, 108, 109, 110, 301, 302, 303}
      % PROVOR REMOCEAN & ARVOR CM
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.1);
            
            listMc = [ ...
               g_MC_FST; ...
               g_MC_SpyInDescToPark; ...
               g_MC_MaxPresInDescToPark; ...
               g_MC_SpyAtPark; ...
               g_MC_MinPresInDriftAtPark; g_MC_MaxPresInDriftAtPark; ...
               g_MC_SpyInDescToProf; ...
               g_MC_MaxPresInDescToProf; ...
               g_MC_SpyAtProf; ...
               g_MC_MinPresInDriftAtProf; g_MC_MaxPresInDriftAtProf; ...
               g_MC_SpyInAscProf; ...
               g_MC_Grounded];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 0.1 dbar, except for measurement codes [%s] for which %s resolution is 10 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.1);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
            if (ismember(a_decoderId, [106 107 109 301 302 303])) % DO floats
               listMc = [ ...
                  g_MC_DST; ...
                  g_MC_FST; ...
                  g_MC_SpyInDescToPark; ...
                  g_MC_DescProf; ...
                  g_MC_DescProfDeepestBin; ...
                  g_MC_PST; ...
                  g_MC_SpyAtPark; ...
                  g_MC_DriftAtPark; ...
                  g_MC_PET; ...
                  g_MC_SpyInDescToProf; ...
                  g_MC_DPST; ...
                  g_MC_SpyAtProf; ...
                  g_MC_AST; ...
                  g_MC_AscProfDeepestBin; ...
                  g_MC_SpyInAscProf; ...
                  g_MC_AscProf; ...
                  g_MC_AET; ...
                  g_MC_InAirSeriesOfMeas; ...
                  g_MC_TST; ...
                  g_MC_Grounded];
            else
               listMc = [ ...
                  g_MC_DST; ...
                  g_MC_FST; ...
                  g_MC_SpyInDescToPark; ...
                  g_MC_DescProf; ...
                  g_MC_DescProfDeepestBin; ...
                  g_MC_PST; ...
                  g_MC_SpyAtPark; ...
                  g_MC_DriftAtPark; ...
                  g_MC_PET; ...
                  g_MC_SpyInDescToProf; ...
                  g_MC_DPST; ...
                  g_MC_SpyAtProf; ...
                  g_MC_AST; ...
                  g_MC_AscProfDeepestBin; ...
                  g_MC_SpyInAscProf; ...
                  g_MC_AscProf; ...
                  g_MC_AET; ...
                  g_MC_TST; ...
                  g_MC_Grounded];
            end
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 second, except for measurement codes [%s] for which %s resolution is 1 minute', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/1440); % 1 minute
            
         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {121, 122, 123}
      % PROVOR CTS5
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.01);
            
            listMc = [ ...
               g_MC_SpyInDescToPark; ...
               g_MC_FST; ...
               g_MC_PST; ...
               g_MC_SpyAtPark; ...
               g_MC_MinPresInDriftAtPark; ...
               g_MC_MaxPresInDriftAtPark; ...
               g_MC_SpyInDescToProf; ...
               g_MC_MaxPresInDescToProf; ...
               g_MC_SpyAtProf; ...
               g_MC_SpyInAscProf; ...
               g_MC_Grounded ...
               ];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 0.01 dbar, except for measurement codes [%s] for which %s resolution is 1 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.01);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second

         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE', ...
               'JULD_TRANSMISSION_END'}
                        
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {201, 202, 203, 215, 216}
      % ARVOR DEEP 4000
      % ARVOR DEEP 3500
      % ARVOR DEEP 4000 with "Near Surface" & "In Air" measurements
      % Arvor-Deep-Ice Iridium 5.65
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.1);
                        
            listMc = [ ...
               g_MC_FST; ...
               g_MC_SpyInDescToPark; ...
               g_MC_MaxPresInDescToPark; ...
               g_MC_SpyAtPark; ...
               g_MC_MinPresInDriftAtPark; ...
               g_MC_MaxPresInDriftAtPark; ...
               g_MC_SpyInDescToProf; ...
               g_MC_MaxPresInDescToProf; ...
               g_MC_SpyAtProf; ...
               g_MC_MinPresInDriftAtProf; ...
               g_MC_MaxPresInDriftAtProf; ...
               g_MC_SpyInAscProf; ...
               g_MC_Grounded];

            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 0.1 dbar, except for measurement codes [%s] for which %s resolution is 1 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.1);

         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
            listMc = [ ...
               g_MC_CycleStart; ...
               g_MC_DST; ...
               g_MC_FST; ...
               g_MC_SpyInDescToPark; ...
               g_MC_PST; ...
               g_MC_SpyAtPark; ...
               g_MC_PET; ...
               g_MC_SpyInDescToProf; ...
               g_MC_DPST; ...
               g_MC_SpyAtProf; ...
               g_MC_AST; ...
               g_MC_SpyInAscProf; ...
               g_MC_AET; ...
               g_MC_TST; ...
               g_MC_TET; ...
               g_MC_Grounded];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 second, except for measurement codes [%s] for which %s resolution is 1 minute', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/1440); % 1 minute
            
         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {204, 205, 206, 207, 208, 209}
      % ARVOR Iridium
      % Provor-DO Iridium
      % Arvor-2DO Iridium
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.1);
                        
            listMc = [ ...
               g_MC_FST; ...
               g_MC_MaxPresInDescToPark; ...
               g_MC_MinPresInDriftAtPark; ...
               g_MC_MaxPresInDriftAtPark; ...
               g_MC_MaxPresInDescToProf; ...
               g_MC_MinPresInDriftAtProf; ...
               g_MC_MaxPresInDriftAtProf; ...
               g_MC_Grounded];

            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 0.1 dbar, except for measurement codes [%s] for which %s resolution is 10 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.1);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second

            listMc = [ ...
               g_MC_CycleStart; ...
               g_MC_DST; ...
               g_MC_FST; ...
               g_MC_PST; ...
               g_MC_PET; ...
               g_MC_DPST; ...
               g_MC_AST; ...
               g_MC_AET; ...
               g_MC_TST; ...
               g_MC_TET; ...
               g_MC_Grounded];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 second, except for measurement codes [%s] for which %s resolution is 1 minute', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/1440); % 1 minute
            
         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {210, 211, 212, 213, 214}
      % ARVOR ARN Iridium
      % PROVOR ARN DO Iridium
      % Provor-ARN-DO-Ice Iridium
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.1);
                        
            listMc = [ ...
               g_MC_FST; ...
               g_MC_SpyInDescToPark; ...
               g_MC_MaxPresInDescToPark; ...
               g_MC_SpyAtPark; ...
               g_MC_MinPresInDriftAtPark; ...
               g_MC_MaxPresInDriftAtPark; ...
               g_MC_SpyInDescToProf; ...
               g_MC_MaxPresInDescToProf; ...
               g_MC_SpyAtProf; ...
               g_MC_MinPresInDriftAtProf; ...
               g_MC_MaxPresInDriftAtProf; ...
               g_MC_SpyInAscProf; ...
               g_MC_Grounded];

            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 0.1 dbar, except for measurement codes [%s] for which %s resolution is 1 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.1);

         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
            listMc = [ ...
               g_MC_CycleStart; ...
               g_MC_DST; ...
               g_MC_FST; ...
               g_MC_SpyInDescToPark; ...
               g_MC_PST; ...
               g_MC_SpyAtPark; ...
               g_MC_PET; ...
               g_MC_SpyInDescToProf; ...
               g_MC_DPST; ...
               g_MC_SpyAtProf; ...
               g_MC_AST; ...
               g_MC_SpyInAscProf; ...
               g_MC_AET; ...
               g_MC_TST; ...
               g_MC_TET; ...
               g_MC_Grounded];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 second, except for measurement codes [%s] for which %s resolution is 1 minute', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/1440); % 1 minute
            
         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {1001, 1002, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, ...
         1014, 1015, 1016}
      % Apex Argos
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.1);
            
            listMc = [ ...
               g_MC_DescProf];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 0.1 dbar, except for measurement codes [%s] for which %s resolution is 10 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.1);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
            listMc = [ ...
               g_MC_AST_Float; ...
               g_MC_AET_Float; ...
               g_MC_TST_Float];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 second, except for measurement codes [%s] for which %s resolution is 1 minute', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/86400); % 1 second

         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {1003}
      % Apex Argos
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.1);
            
            listMc = [ ...
               g_MC_DescProf];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 0.1 dbar, except for measurement codes [%s] for which %s resolution is 10 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.1);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
            listMc = [ ...
               g_MC_AST_Float];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 second, except for measurement codes [%s] for which %s resolution is 1 minute', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/86400); % 1 second

         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {1004}
      % Apex Argos
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.1);
            
            listMc = [ ...
               g_MC_DescProf];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 0.1 dbar, except for measurement codes [%s] for which %s resolution is 10 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.1);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
                        
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/86400); % 1 second

         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1314}
      % Apex Iridium Rudics & Sbd
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.01);
            
            listMc1 = [ ...
               g_MC_AST
               g_MC_AscProfDeepestBin
               g_MC_AET
               g_MC_InAirSeriesOfMeas];
            listMc1Str = sprintf('%d ', listMc1);
            listMc2 = [ ...
               g_MC_DescProf];
            listMc2Str = sprintf('%d ', listMc2);
            o_comment = sprintf('%s resolution is 0.01 dbar, except for measurement codes [%s] for which %s resolution is 0.1 dbar and for measurement codes [%s] for which %s resolution is 0.1 dbar or 10 dbar', ...
               a_paramName, listMc1Str(1:end-1), a_paramName, listMc2Str(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.01);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/86400); % 1 second
      end
      
   case {1201}
      % Navis
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.01);
            
            listMc1 = [ ...
               g_MC_AST
               g_MC_AscProfDeepestBin
               g_MC_AET
               g_MC_InAirSeriesOfMeas];
            listMc1Str = sprintf('%d ', listMc1);
            listMc2 = [ ...
               g_MC_DescProf];
            listMc2Str = sprintf('%d ', listMc2);
            o_comment = sprintf('%s resolution is 0.01 dbar, except for measurement codes [%s] for which %s resolution is 0.1 dbar and for measurement codes [%s] for which %s resolution is 0.1 dbar or 10 dbar', ...
               a_paramName, listMc1Str(1:end-1), a_paramName, listMc2Str(1:end-1));
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.01);
            
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/86400); % 1 second
            
      end
      
   case {2001, 2002}
      % Nova, Dova
      switch (a_paramName)
         case {'PRES', 'PRES_ADJUSTED'}
            
            o_resolution = single(0.1);
                        
            listMc = [ ...
               g_MC_SpyInDescToPark; ...
               g_MC_FST; ...
               g_MC_SpyAtPark; ...
               g_MC_MinPresInDriftAtPark; ...
               g_MC_MaxPresInDriftAtPark; ...
               g_MC_SpyInDescToProf; ...
               g_MC_MaxPresInDescToProf; ...
               g_MC_SpyAtProf; ...
               g_MC_SpyInAscProf];

            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 0.1 dbar, except for measurement codes [%s] for which %s resolution is 10 dbar', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'PRES_ADJUSTED_ERROR'}
            
            o_resolution = single(0.1);
                        
         case {'JULD', 'JULD_ADJUSTED'}
            
            o_resolution = double(1/86400); % 1 second
            
            listMc = [ ...
               g_MC_SpyInDescToPark; ...
               g_MC_DescProf; ...
               g_MC_DriftAtPark; ...
               g_MC_SpyAtPark; ...
               g_MC_SpyInDescToProf; ...
               g_MC_SpyInAscProf; ...
               g_MC_AscProf];
            listMcStr = sprintf('%d ', listMc);
            o_comment = sprintf('%s resolution is 1 second, except for measurement codes [%s] for which %s resolution is 6 minutes', ...
               a_paramName, listMcStr(1:end-1), a_paramName);
            
         case {'JULD_DESCENT_START', ...
               'JULD_FIRST_STABILIZATION', ...
               'JULD_DESCENT_END', ...
               'JULD_PARK_START', ...
               'JULD_PARK_END', ...
               'JULD_DEEP_DESCENT_END', ...
               'JULD_DEEP_PARK_START', ...
               'JULD_ASCENT_START', ...
               'JULD_DEEP_ASCENT_START', ...
               'JULD_ASCENT_END', ...
               'JULD_TRANSMISSION_START', ...
               'JULD_TRANSMISSION_END'}
            
            o_resolution = double(1/86400); % 1 second
            
         case {'JULD_FIRST_MESSAGE', ...
               'JULD_FIRST_LOCATION', ...
               'JULD_LAST_LOCATION', ...
               'JULD_LAST_MESSAGE'}
            
            o_resolution = double(1/86400); % 1 second
            
      end      
      
   otherwise
      o_comment = ' ';
      fprintf('WARNING: Float #%d: No param comment on resolution defined yet for decoderId #%d\n', ...
         g_decArgo_floatNum, ...
         a_decoderId);
end

return;
