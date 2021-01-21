function save_project_state(new_state, varargin)

if(exist(new_state.fileName, 'file') )
    load(new_state.fileName);
end

if (nargin == 1 )

    if( isfield(new_state, 'data_folder'))
        state.data_folder = new_state.data_folder;
    end
    if( isfield(new_state, 'project_folder'))
        state.project_folder = new_state.project_folder;
    end
    if( isfield(new_state, 'file_extension'))
        state.file_extension = new_state.file_extension;
    end
    if( isfield(new_state, 'downsampling_rate'))
        state.downsampling_rate = new_state.downsampling_rate;
    end
    if( isfield(new_state, 'processed_subjects'))
        state.processed_subjects = new_state.processed_subjects;
    end
    if( isfield(new_state, 'processed_files'))
        state.processed_files = new_state.processed_files;
    end
    if( isfield(new_state, 'rating'))
        state.rating = new_state.rating;
    end
    if( isfield(new_state, 'interpolate_list'))
        state.interpolate_list = new_state.interpolate_list;
    end
    if( isfield(new_state, 'maxX'))
        state.maxX = new_state.maxX;
    end
    if( isfield(new_state, 'files'))
        state.files = new_state.files;
    end
    if( isfield(new_state, 'current'))
        state.current = new_state.current;
    end
    if( isfield(new_state, 'file_count'))
        state.file_count = new_state.file_count;
    end
    if( isfield(new_state, 'subject_count'))
        state.subject_count = new_state.subject_count;
    end
    if( isfield(new_state, 'filter_mode'))
        state.filter_mode = new_state.filter_mode;
    end
    
elseif(nargin > 1)
    for i = 1:length(varargin)
       field = varargin{i};
       switch field
            case 'data_folder'
               state.data_folder = new_state.data_folder;
            case 'project_folder'
                state.project_folder = new_state.project_folder;
            case 'file_extension'
                state.file_extension = new_state.file_extension;
            case 'downsampling_rate'
                state.downsampling_rate = new_state.downsampling_rate;
            case 'processed_subjects'
                state.processed_subjects = new_state.processed_subjects;
            case 'processed_files'
                state.processed_files = new_state.processed_files;
            case 'rating'
                state.rating = new_state.rating;
            case 'interpolate_list'
                state.interpolate_list = new_state.interpolate_list;
            case 'maxX'
                state.maxX = new_state.maxX;
            case 'files'
                state.files = new_state.files;
            case 'current'
                state.current = new_state.current;
            case 'file_count'
                state.file_count = new_state.file_count;
            case 'subject_count'
                state.subject_count = new_state.subject_count;
            case 'filter_mode'
               state.filter_mode = new_state.filter_mode;
       end 
    end
end
save(new_state.fileName, 'state');
clear state;
end