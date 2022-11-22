% ------------------------------------------------------------------------------
% Create and add the vertical sampling scheme information to the profiles.
%
% SYNTAX :
%  [o_tabProfiles] = add_vertical_sampling_scheme_ir_rudics(a_tabProfiles)
%
% INPUT PARAMETERS :
%   a_tabProfiles   : input profile structures
%
% OUTPUT PARAMETERS :
%   o_tabProfiles : output profile structures
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   07/16/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_tabProfiles] = add_vertical_sampling_scheme_ir_rudics(a_tabProfiles)

% output parameters initialization
o_tabProfiles = [];

% global default values
global g_decArgo_presDef;


% add the vertical sampling scheme for each profile
for idP = 1:length(a_tabProfiles)
   prof = a_tabProfiles(idP);
   
   [configNames, configValues] = get_float_config_ir_rudics_sbd2(prof.cycleNumber, prof.profileNumber);
   if (~isempty(configNames))
      
      vssText = '';
      vssTextSecondary = '';
      vssTextPrimary = '';
      vssTextNearSurface = '';
      if (prof.primarySamplingProfileFlag == 0)
         vssText = 'Secondary sampling:';
         vssTextSecondary = 'Secondary sampling:';
      else
         vssText = 'Primary sampling:';
         vssTextPrimary = 'Primary sampling:';
         vssTextNearSurface = 'Near-surface sampling:';
      end
      
      if (prof.direction == 'A')
         
         % ascending profile
         profPres = get_config_value(sprintf('CONFIG_PM_%d', ...
            6+prof.profileNumber*5), configNames, configValues);
         threshold = ones(4, 1)*-1;
         
         for id = 1:4
            threshold(id) = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
               prof.sensorNumber, ...
               45+id-1), configNames, configValues);
         end
         
         text3 = [];
         text4 = [];
         
         flagAvgSecondary = 0;
         flagDiscreteSecondary = 0;
         flagAvgPrimary = 0;
         flagDiscretePrimary = 0;
         flagAvgNearSurface = 0;
         flagDiscreteNearSurface = 0;
         surfSliceDonePrimary = 0;
         surfSliceDoneNearSurface = 0;
         
         if (~any(isnan(threshold)))
            
            idStart = find(threshold < profPres);
            idStart = idStart(end) + 1;
            threshold(idStart) = profPres;
            
            for id = idStart:-1:1
               sampPeriod = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
                  prof.sensorNumber, ...
                  4+(id-1)*9), configNames, configValues);
               acqMode = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
                  prof.sensorNumber, ...
                  5+(id-1)*9), configNames, configValues);
               treatType = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
                  prof.sensorNumber, ...
                  6+(id-1)*9), configNames, configValues);
               slicesThick = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
                  prof.sensorNumber, ...
                  8+(id-1)*9), configNames, configValues);
               
               if (prof.primarySamplingProfileFlag == 0)
                  
                  % secondary samplings
                  if ((sampPeriod ~= 0) && (acqMode ~= 0))
                     if (treatType == 0)
                        if (id == idStart)
                           text1 = sprintf('%ds sampling in ', ...
                              sampPeriod);
                        else
                           text1 = sprintf('%ds samp. in ', ...
                              sampPeriod);
                        end
                        flagDiscreteSecondary = 1;
                     else
                        if (id == idStart)
                           text1 = sprintf('%ds sampling,%ddbar average in ', ...
                              sampPeriod, slicesThick);
                        else
                           text1 = sprintf('%ds samp.,%ddbar avg in ', ...
                              sampPeriod, slicesThick);
                        end
                        flagAvgSecondary = 2;
                     end
                     
                     if (id > 1)
                        text2 = sprintf('[%d-%d]dbar', ...
                           threshold(id), threshold(id-1));
                     else
                        text2 = sprintf('[%ddbar-surface]', ...
                           threshold(1));
                     end
                     
                     text3{end+1} = [text1 text2];
                  end
                  
               else
                  
                  % primary sampling
                  if (prof.presCutOffProf ~= g_decArgo_presDef)
                     if (id > 1)
                        if ((sampPeriod ~= 0) && (acqMode ~= 0))
                           if (treatType == 0)
                              if (id == idStart)
                                 text1 = sprintf('%ds sampling in ', ...
                                    sampPeriod);
                              else
                                 text1 = sprintf('%ds samp. in ', ...
                                    sampPeriod);
                              end
                              flagDiscretePrimary = 1;
                           else
                              if (id == idStart)
                                 text1 = sprintf('%ds sampling,%ddbar average in ', ...
                                    sampPeriod, slicesThick);
                              else
                                 text1 = sprintf('%ds samp.,%ddbar avg in ', ...
                                    sampPeriod, slicesThick);
                              end
                              flagAvgPrimary = 2;
                           end
                           
                           text2 = '';
                           if (threshold(id-1) > prof.presCutOffProf)
                              text2 = sprintf('[%d-%d]dbar', ...
                                 threshold(id), threshold(id-1));
                           elseif (surfSliceDonePrimary == 0)
                              text2 = sprintf('[%d-%.1f]dbar', ...
                                 threshold(id), prof.presCutOffProf);
                              surfSliceDonePrimary = 1;
                           end
                           
                           if (~isempty(text2))
                              text3{end+1} = [text1 text2];
                           end
                        end
                     elseif (threshold(1) > prof.presCutOffProf)
                        if ((sampPeriod ~= 0) && (acqMode ~= 0))
                           if (treatType == 0)
                              if (id == idStart)
                                 text1 = sprintf('%ds sampling in ', ...
                                    sampPeriod);
                              else
                                 text1 = sprintf('%ds samp. in ', ...
                                    sampPeriod);
                              end
                              flagDiscretePrimary = 1;
                           else
                              if (id == idStart)
                                 text1 = sprintf('%ds sampling,%ddbar average in ', ...
                                    sampPeriod, slicesThick);
                              else
                                 text1 = sprintf('%ds samp.,%ddbar avg in ', ...
                                    sampPeriod, slicesThick);
                              end
                              flagAvgPrimary = 2;
                           end
                           
                           text2 = sprintf('[%d-%.1f]dbar', ...
                              threshold(1), prof.presCutOffProf);
                           
                           text3{end+1} = [text1 text2];
                        end
                     end
                  else
                     if ((sampPeriod ~= 0) && (acqMode ~= 0))
                        if (treatType == 0)
                           if (id == idStart)
                              text1 = sprintf('%ds sampling in ', ...
                                 sampPeriod);
                           else
                              text1 = sprintf('%ds samp. in ', ...
                                 sampPeriod);
                           end
                           flagDiscretePrimary = 1;
                        else
                           if (id == idStart)
                              text1 = sprintf('%ds sampling,%ddbar average in ', ...
                                 sampPeriod, slicesThick);
                           else
                              text1 = sprintf('%ds samp.,%ddbar avg in ', ...
                                 sampPeriod, slicesThick);
                           end
                           flagAvgPrimary = 2;
                        end
                        
                        if (id > 1)
                           text2 = sprintf('[%d-%d]dbar', ...
                              threshold(id), threshold(id-1));
                        else
                           text2 = sprintf('[%ddbar-surface]', ...
                              threshold(1));
                        end
                        
                        text3{end+1} = [text1 text2];
                     end
                  end
                  
                  % near-surface sampling
                  if (prof.presCutOffProf ~= g_decArgo_presDef)
                     if (id > 1)
                        if ((sampPeriod ~= 0) && (acqMode ~= 0))
                           if (treatType == 0)
                              if (id == idStart)
                                 text1 = sprintf('%ds sampling in ', ...
                                    sampPeriod);
                              else
                                 text1 = sprintf('%ds samp. in ', ...
                                    sampPeriod);
                              end
                           else
                              if (id == idStart)
                                 text1 = sprintf('%ds sampling,%ddbar average in ', ...
                                    sampPeriod, slicesThick);
                              else
                                 text1 = sprintf('%ds samp.,%ddbar avg in ', ...
                                    sampPeriod, slicesThick);
                              end
                           end
                           
                           text2 = '';
                           if (threshold(id-1) <= prof.presCutOffProf)
                              if (surfSliceDoneNearSurface == 0)
                                 text2 = sprintf('[%.1f-%d]dbar', ...
                                    prof.presCutOffProf, threshold(id-1));
                                 surfSliceDoneNearSurface = 1;
                              else
                                 text2 = sprintf('[%d-%d]dbar', ...
                                    threshold(id), threshold(id-1));
                              end
                           end
                           
                           if (~isempty(text2))
                              if (treatType == 0)
                                 flagDiscreteNearSurface = 1;
                              else
                                 flagAvgNearSurface = 2;
                              end
                              text4{end+1} = [text1 text2];
                           end
                        end
                     else
                        if (threshold(1) > prof.presCutOffProf)
                           if ((sampPeriod ~= 0) && (acqMode ~= 0))
                              if (treatType == 0)
                                 if (id == idStart)
                                    text1 = sprintf('%ds sampling in ', ...
                                       sampPeriod);
                                 else
                                    text1 = sprintf('%ds samp. in ', ...
                                       sampPeriod);
                                 end
                                 flagDiscreteNearSurface = 1;
                              else
                                 if (id == idStart)
                                    text1 = sprintf('%ds sampling,%ddbar average in ', ...
                                       sampPeriod, slicesThick);
                                 else
                                    text1 = sprintf('%ds samp.,%ddbar avg in ', ...
                                       sampPeriod, slicesThick);
                                 end
                                 flagAvgNearSurface = 2;
                              end
                              
                              text2 = sprintf('[%.1fdbar-surface]', ...
                                 prof.presCutOffProf);
                              
                              text4{end+1} = [text1 text2];
                           end
                        else
                           if ((sampPeriod ~= 0) && (acqMode ~= 0))
                              if (treatType == 0)
                                 if (id == idStart)
                                    text1 = sprintf('%ds sampling in ', ...
                                       sampPeriod);
                                 else
                                    text1 = sprintf('%ds samp. in ', ...
                                       sampPeriod);
                                 end
                                 flagDiscreteNearSurface = 1;
                              else
                                 if (id == idStart)
                                    text1 = sprintf('%ds sampling,%ddbar average in ', ...
                                       sampPeriod, slicesThick);
                                 else
                                    text1 = sprintf('%ds samp.,%ddbar avg in ', ...
                                       sampPeriod, slicesThick);
                                 end
                                 flagAvgNearSurface = 2;
                              end
                              
                              text2 = sprintf('[%ddbar-surface]', ...
                                 threshold(1));
                              
                              text4{end+1} = [text1 text2];
                           end
                        end
                     end
                  end
               end
            end
         end
            
         descriptionSecondary = '';
         descriptionPrimary = '';
         descriptionNearSurface = '';
         if (prof.primarySamplingProfileFlag == 0)
            
            % secondary sampling
            if (~isempty(text3))
               descriptionSecondary = [sprintf('%s;', text3{1:end-1}) sprintf('%s', text3{end})];
            end
            switch flagAvgSecondary+flagDiscreteSecondary
               case 0
                  vssTextSecondary = [vssTextSecondary ' averaged [unreliable nominal measurement type (missing configuration information)]'];
               case 1
                  vssTextSecondary = [vssTextSecondary ' discrete [' descriptionSecondary ']'];
               case 2
                  vssTextSecondary = [vssTextSecondary ' averaged [' descriptionSecondary ']'];
               case 3
                  vssTextSecondary = [vssTextSecondary ' mixed [' descriptionSecondary ']'];
            end
            
            a_tabProfiles(idP).vertSamplingScheme = vssTextSecondary;
            
         else
            
            % primary sampling
            if (~isempty(text3))
               descriptionPrimary = [sprintf('%s;', text3{1:end-1}) sprintf('%s', text3{end})];
            end
            switch flagAvgPrimary+flagDiscretePrimary
               case 0
                  vssTextPrimary = [vssTextPrimary ' averaged [unreliable nominal measurement type (missing configuration information)]'];
               case 1
                  vssTextPrimary = [vssTextPrimary ' discrete [' descriptionPrimary ']'];
               case 2
                  vssTextPrimary = [vssTextPrimary ' averaged [' descriptionPrimary ']'];
               case 3
                  vssTextPrimary = [vssTextPrimary ' mixed [' descriptionPrimary ']'];
            end
            
            % near-surface sampling
            if (~isempty(text4))
               descriptionNearSurface = [sprintf('%s;', text4{1:end-1}) sprintf('%s', text4{end})];
            end
            switch flagAvgNearSurface+flagDiscreteNearSurface
               case 0
                  vssTextNearSurface = [vssTextNearSurface ' averaged, unpumped [unreliable nominal measurement type (missing configuration information)]'];
               case 1
                  vssTextNearSurface = [vssTextNearSurface ' discrete, unpumped [' descriptionNearSurface ']'];
               case 2
                  vssTextNearSurface = [vssTextNearSurface ' averaged, unpumped [' descriptionNearSurface ']'];
               case 3
                  vssTextNearSurface = [vssTextNearSurface ' mixed, unpumped [' descriptionNearSurface ']'];
            end
            
            if (prof.sensorNumber == 0)
               % CTD profile
               a_tabProfiles(idP).vertSamplingScheme = [{vssTextPrimary} {vssTextNearSurface}];
               %             elseif (prof.sensorNumber == 1)
               %                % DOXY profile
               %                vssTextSecondary = regexprep(vssTextPrimary, 'Primary sampling:', 'Secondary sampling:');
               %                a_tabProfiles(idP).vertSamplingScheme = [{vssTextSecondary} {vssTextNearSurface}];
            end
         end
            
      else
         
         % descending profile
         parkPres = get_config_value(sprintf('CONFIG_PM_%d', ...
            5+prof.profileNumber*5), configNames, configValues);
         threshold = ones(4, 1)*-1;
         
         for id = 1:4
            threshold(id) = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
               prof.sensorNumber, ...
               45+id-1), configNames, configValues);
         end
         
         flagAvg = 0;
         flagDiscrete = 0;
         text3 = [];

         if (~any(isnan(threshold)))
            
            idEnd = find(threshold < parkPres);
            idEnd = idEnd(end) + 1;
            threshold(idEnd) = parkPres;
            
            for id = 1:idEnd
               sampPeriod = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
                  prof.sensorNumber, ...
                  0+(id-1)*9), configNames, configValues);
               acqMode = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
                  prof.sensorNumber, ...
                  5+(id-1)*9), configNames, configValues);
               treatType = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
                  prof.sensorNumber, ...
                  6+(id-1)*9), configNames, configValues);
               slicesThick = get_config_value(sprintf('CONFIG_PC_%d_0_%d', ...
                  prof.sensorNumber, ...
                  8+(id-1)*9), configNames, configValues);
               
               if ((sampPeriod ~= 0) && (acqMode ~= 0))
                  if (treatType == 0)
                     text1 = sprintf('%dsec sampling in ', ...
                        sampPeriod);
                     flagDiscrete = 1;
                  else
                     text1 = sprintf('%dsec sampling, %ddbar average in ', ...
                        sampPeriod, slicesThick);
                     flagAvg = 2;
                  end
                  
                  if (id == 1)
                     text2 = sprintf('[surface-%ddbar]', ...
                        threshold(1));
                  else
                     text2 = sprintf('[%d-%d]dbar', ...
                        threshold(id-1), threshold(id));
                  end
                  
                  text3{end+1} = [text1 text2];
               end
            end
         end
         
         description = '';
         if (~isempty(text3))
            description = [sprintf('%s;', text3{1:end-1}) sprintf('%s', text3{end})];
         end
         switch flagAvg+flagDiscrete
            case 0
               vssText = [vssText ' averaged [unreliable nominal measurement type (missing configuration information)]'];
            case 1
               vssText = [vssText ' discrete [' description ']'];
            case 2
               vssText = [vssText ' averaged [' description ']'];
            case 3
               vssText = [vssText ' mixed [' description ']'];
         end
         
         %          if (prof.sensorNumber == 1)
         %             % DOXY profile
         %             vssTextSecondary = regexprep(vssText, 'Primary sampling:', 'Secondary sampling:');
         %             a_tabProfiles(idP).vertSamplingScheme = vssTextSecondary;
         %          else
         a_tabProfiles(idP).vertSamplingScheme = vssText;
         %          end
      end
   end
end

o_tabProfiles = a_tabProfiles;

return

% ------------------------------------------------------------------------------
% Get a config value from a given configuration.
%
% SYNTAX :
%  [o_configValue] = get_config_value(a_configName, a_configNames, a_configValues)
%
% INPUT PARAMETERS :
%   a_configName   : name of the wanted config parameter
%   a_configNames  : configuration names
%   a_configValues : configuration values
%
% OUTPUT PARAMETERS :
%   o_configValue : retrieved configuration value
%
% EXAMPLES :
%
% SEE ALSO :
% AUTHORS  : Jean-Philippe Rannou (Altran)(jean-philippe.rannou@altran.com)
% ------------------------------------------------------------------------------
% RELEASES :
%   07/16/2013 - RNU - creation
% ------------------------------------------------------------------------------
function [o_configValue] = get_config_value(a_configName, a_configNames, a_configValues)

% output parameters initialization
o_configValue = [];

% retrieve the configuration value
idPos = find(strcmp(a_configName, a_configNames) == 1, 1);
o_configValue = a_configValues(idPos);

return
