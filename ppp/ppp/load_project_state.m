function handle = load_project_state(handle, varargin)

if(~ exist(handle.fileName, 'file') )
        msgbox(['The project you chose does not exist. Either create '...
                'it or use arguments.'], 'Error', 'error');
        return;
end

load(handle.fileName);
if (nargin == 1 )
    
    
    if( isfield(state, 'data_folder'))
        handle.data_folder = state.data_folder;
    end
    if( isfield(state, 'project_folder'))
        handle.project_folder = state.project_folder;
    end
    if( isfield(state, 'file_extension'))
        handle.file_extension = state.file_extension;
    end
    if( isfield(state, 'downsampling_rate'))
        handle.downsampling_rate = state.downsampling_rate;
    end
    if( isfield(state, 'processed_subjects'))
        handle.processed_subjects = state.processed_subjects;
    end
    if( isfield(state, 'processed_files'))
        handle.processed_files = state.processed_files;
    end
    if( isfield(state, 'rating'))
        handle.rating = state.rating;
    end
    if( isfield(state, 'interpolate_list'))
        handle.interpolate_list = state.interpolate_list;
    end
    if( isfield(state, 'maxX'))
        handle.maxX = state.maxX;
    end
    if( isfield(state, 'files'))
        handle.files = state.files;
    end
    if( isfield(state, 'current'))
        handle.current = state.current;
    end
    if( isfield(state, 'file_count'))
        handle.file_count = state.file_count;
    end
    if( isfield(state, 'subject_count'))
        handle.subject_count = state.subject_count;
    end
    if( isfield(state, 'filter_mode'))
        handle.filter_mode = state.filter_mode;
    end
    
elseif(nargin > 1)
    for i = 1:length(varargin)
       field = varargin{i};
       switch field
            case 'data_folder'
                if( isfield(state, 'data_folder'))
                    handle.data_folder = state.data_folder;
                end
            case 'project_folder'
                if( isfield(state, 'project_folder'))
                    handle.project_folder = state.project_folder;
                end
            case 'file_extension'
                if( isfield(state, 'file_extension'))
                    handle.file_extension = state.file_extension;
                end
            case 'downsampling_rate'
                if( isfield(state, 'downsampling_rate'))
                    handle.downsampling_rate = state.downsampling_rate;
                end
            case 'processed_subjects'
                if( isfield(state, 'processed_subjects'))
                    handle.processed_subjects = state.processed_subjects;
                end
            case 'processed_files'
                if( isfield(state, 'processed_files'))
                    handle.processed_files = state.processed_files;
                end
            case 'rating'
                if( isfield(state, 'rating'))
                    handle.rating = state.rating;
                end
            case 'interpolate_list'
                if( isfield(state, 'interpolate_list'))
                    handle.interpolate_list = state.interpolate_list;
                end
            case 'maxX'
                if( isfield(state, 'maxX'))
                    handle.maxX = state.maxX;
                end
            case 'files'
                if( isfield(state, 'files'))
                    handle.files = state.files;
                end
            case 'current'
                if( isfield(state, 'current'))
                    handle.current = state.current;
                end
            case 'file_count'
                if( isfield(state, 'file_count'))
                    handle.file_count = state.file_count;
                end
            case 'subject_count'
                if( isfield(state, 'subject_count'))
                    handle.subject_count = state.subject_count;
                end
           case 'filter_mode'
               if( isfield(state, 'filter_mode'))
                handle.filter_mode = state.filter_mode;
               end
       end 
    end
end
clear state;
end