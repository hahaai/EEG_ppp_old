function pre_process_all(varargin)

if (nargin == 1 && isa(varargin{1},'char')) % called from the gui
    handle.project_name = varargin{1};
    handle.fileName = strcat(handle.project_name,'_state.mat');
    if(~ exist(handle.fileName, 'file') )
        waitfor(msgbox(['The project you chose does not exist. Either create '...
                'it or use arguments.'],'Error','error'));
        return;
    end
    
    handle = load_project_state(handle, 'data_folder', 'project_folder', ...
        'file_extension', 'downsampling_rate', 'processed_subjects', ...
        'processed_files','filter_mode');
    
elseif(nargin == 4) % Not from the gui
    handle.data_folder = varargin{1};
    handle.project_folder = varargin{2};
    handle.file_extension = varargin{3};
    handle.downsampling_rate = varargin{4};
    handle.filter_mode = varargin{5};
else
    waitfor(msgbox('Wrong arguments.', 'Error','error'));
    return;
end


% Load subject folders                                      
subjects = list_subjects(handle.data_folder);

if isempty(subjects)
    waitfor(msgbox('No file to preprocess. Please check your data folder', ...
        'Error','error'));
    return;
end

addpath(genpath('../matlab_scripts')); % project code
if( strcmp(handle.file_extension, '.fif'))
   addpath('../fieldtrip-20160630/'); 
end

if(~ exist(handle.project_folder, 'dir'))
    waitfor(msgbox('The project folder does not exist or is not reachable.'...
        ,'Error','error'));
end
skip = check_existings(handle);

display('*******Start preprocessing all dataset**************');
start_time = cputime;
% Iterate on all subjects
for i = 1:length(subjects)
    subject = subjects{i};
    display(['Processing subject ', subject,' ...', '(subject ', int2str(i), ' out of ', int2str(length(subjects)), ')']);
    
    raw_files = dir([handle.data_folder subject '/*' handle.file_extension]);
    if(~ exist([handle.project_folder subject], 'dir'))
        mkdir([handle.project_folder subject]);
    end
    % Iterate on raw files of each subject
    for j = 1:length(raw_files)
        % Extract names and create adresses to save
        name_with_ext = raw_files(j).name;
        [raw_file_address, reduced_address, full_address, ~] = ...
            get_adresses(subject, name_with_ext, handle);
        
        % If already preprocessed, just load it, otherwise preprocess
        if skip && exist(full_address, 'file')
            break;
        else
            % Load and preprocess
            [~ ,data] = evalc('pop_fileio(raw_file_address)');
            result = pre_process(data, raw_file_address, handle.filter_mode);
        end
        
        % save results
        reduced.data = downsample(result.data,handle.downsampling_rate);
        reduced.auto_badchans = result.auto_badchans;
        save(reduced_address, 'reduced', '-v6');
        save(full_address, 'result', '-v7.3');
        
        % Update the state
        if(nargin == 1)
            handle.processed_files = handle.processed_files + 1;
            save_project_state(handle,'processed_files');
        end
    end
    
    % Update the state
    if(nargin == 1 && ~ isempty(raw_files) && ~ (skip && exist(full_address, 'file')))
        handle.processed_subjects = handle.processed_subjects + 1;
        save_project_state(handle,'processed_subjects');
    end
end
end_time = cputime - start_time;
disp(['*********Pre-processing finished. Total elapsed time: ', num2str(end_time),'***************'])

end
function skip = check_existings(handle)


[~ , file_count] = ...
    get_preprocessed_numbers(handle.data_folder, handle.project_folder, ...
    handle.file_extension);

skip = 1;
if( file_count > 0)
    choice = questdlg(['Some files are already processed. Would ',... 
                       'you like to overwrite them or skip them ?'], ...
                       'Pre-existing files in the project folder.',...
                       'Over Write', 'Skip','Over Write');
    switch choice
        case 'Over Write'
            skip = 0;
        case 'Skip'
            skip = 1;
    end
end

end


