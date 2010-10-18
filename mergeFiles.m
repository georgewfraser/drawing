function data = mergeFiles(files)
    spikes = struct();
    trials = struct();
    kinematics = struct();
    
    timebase = 0;
    
    fprintf('Merging %d files\n', length(files));
    for i=1:length(files)
        fprintf('.');
        if(mod(i,20)==0)
            fprintf('%d \n',i);
        end
        data = load(files{i}); 
        
        if(isempty(data.trials.PlexonTrialTime))
            continue;
        end
        
        % Add a timebase offset when we jump across recording sessions:
        if(isfield(trials,'PlexonTrialTime')&&data.trials.PlexonTrialTime(1)+timebase<trials.PlexonTrialTime(trials.PlexonTrialTime(end)))
            timebase = trials.PlexonTrialTime(trials.PlexonTrialTime(end))-data.trials.PlexonTrialTime(1)+10;
        end
        
        % Append all spikes
        fields = fieldnames(data.spikes); 
        for j=1:length(fields)
            f = fields{j};
            if(~isfield(spikes,f))
                spikes.(f) = zeros(1000,1);
            end
            spikes.(f) = append(spikes.(f), timebase + data.spikes.(f)); 
        end
        
        % Append all trial data
        fields = fieldnames(data.trials); 
        for j=1:length(fields)
            f = fields{j};
            if(~isfield(trials,f))
                if(iscell(data.trials.(f)))
                    trials.(f) = {};
                else
                    trials.(f) = zeros(1000,size(data.trials.(f),2));
                end
            end
            if(strcmp(f,'ComputerTrialTime'))
            elseif(strcmp(f,'PlexonTrialTime'))
                trials.(f) = append(trials.(f), timebase + data.trials.(f));
            elseif(iscell(data.trials.(f)))
                trials.(f) = {trials.(f){:} data.trials.(f){:}};
            else
                trials.(f) = append(trials.(f), data.trials.(f));
            end
                
        end
        if(isempty(regexp(files{i},'.*Rate.*', 'once' )))
            kinematics_type = 'kinematics';
            if(~isfield(data,'kinematics'))
                kinematics_type = 'em_feedback';
            end
            datakin = data.(kinematics_type);
            if(~isfield(datakin,'PlexonTime'))
                datakin.PlexonTime = data.header.PlexonOffset+datakin.Time*data.header.PlexonSlew;
            end

            % Remove any redundant data from the beginning of the kinematics
            % (early VR-BC bug)
            if(isfield(kinematics,'PlexonTime'))
               timeslice = datakin.PlexonTime+timebase>kinematics.PlexonTime(kinematics.PlexonTime(end));
            else
               timeslice = 1:length(datakin.PlexonTime);
            end

            % Append all kinematics fields
            fields = fieldnames(datakin); 
            for j=1:length(fields)
                f = fields{j};
                if(~isfield(kinematics,f))
                    kinematics.(f) = zeros(1000,size(datakin.(f),2));
                end
                if(strcmp(f,'PlexonTime'))
                    kinematics.(f) = append(kinematics.(f), timebase + datakin.(f)(timeslice,:)); 
                elseif(length(datakin.(f))>=length(timeslice))
                    kinematics.(f) = append(kinematics.(f), datakin.(f)(timeslice,:)); 
                else
                    kinematics.(f) = append(kinematics.(f), datakin.(f));
                end
            end
        end
    end
    header = data.header;
    fprintf('\n');
    
    % Trim the append-created data matrices :
    spikes_fields = fieldnames(spikes); 
    trials_fields = fieldnames(trials);
    kinematics_fields = fieldnames(kinematics);
    for i=1:length(spikes_fields)
        f = spikes_fields{i};
        spikes.(f) = append_trim(spikes.(f));
        spikes.(f) = unique(spikes.(f));
    end
    for i=1:length(trials_fields)
        f = trials_fields{i};
        if(~iscell(trials.(f)))
            trials.(f) = append_trim(trials.(f));
        end
    end
    for i=1:length(kinematics_fields)
        f = kinematics_fields{i};
        kinematics.(f) = append_trim(kinematics.(f));
    end
    
    data = struct('header',header,'spikes',spikes,'trials',trials,'kinematics',kinematics);