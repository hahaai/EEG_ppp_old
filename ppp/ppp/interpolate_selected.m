function interpolate_selected(varargin)

if (nargin == 1 && isa(varargin{1},'char'))
    handle.project_name = varargin{1};
    handle.fileName = strcat(handle.project_name,'_state.mat');
    if(~ exist(handle.fileName, 'file') )
        waitfor(msgbox(['The project you chose does not exist. Either create '...
                'it or use arguments.'],'Error','error'));
        return;
    end
    handle = load_project_state(handle, 'project_folder', ...
        'downsampling_rate', 'interpolate_list', ...
        'rating', 'data_folder');
    
elseif(nargin == 5)
    
    handle.project_folder = varargin{1};
    handle.downsampling_rate = varargin{2};
    handle.interpolate_list = varargin{3};
    handle.rating = varargin{4};
    
else
    waitfor(msgbox('Wrong arguments.', 'Error','error'));
    return;
end

addpath(genpath('../matlab_scripts')); % project code

addpath('src/')
subjects = list_subjects(handle.project_folder);

if(isempty(subjects))
    waitfor(msgbox('No subjects exist. Please first run preprocessing.',...
        'Error','error'));
    return;
end

done = 0;
start_time = cputime;
for i = 1:length(subjects)
    subject = subjects{i};
    raw_files = dir([handle.project_folder subject '/full','_*.mat']);
    for j = 1:length(raw_files)
       preprocessed_name = raw_files(j).name;
       split = strsplit(preprocessed_name,'_');
       name_with_ext = split{2};
       split = strsplit(name_with_ext,'.');
       name = split{1};
       reduced_name = strcat('reduced',int2str(handle.downsampling_rate),'_',name);
       [~ , ~, preprocessed_address, interpolated_name] = ...
            get_adresses(subject, name_with_ext, handle);
        
        
       if(strcmp(handle.rating(reduced_name), 'Interpolate'))
           done = 1;
           load(preprocessed_address);
           EEG = result;
           clear result;
           badchans = handle.interpolate_list(reduced_name);
           
           if ~isempty(badchans)
                interpolated = eeg_interp(EEG ,badchans ,'spherical');
           else
               waitfor(msgbox('File is corrputed.', 'Error','error'));
           end
           
           % Save results
           interpolated.manual_badchans = badchans;
           save(interpolated_name, 'interpolated', '-v7.3');
       end
       
    end
end
end_time = cputime - start_time;
disp(['Interpolation finished. Total elapsed time: ', num2str(end_time)])

if(done == 0)
       waitfor(msgbox(['No files for interpolation exists. Please first choose'...
               'which channels to interpolate.']));
end