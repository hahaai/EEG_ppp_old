function [raw_file_address, reduced_address, preprocessed_address, interpolated_name] = ...
    get_adresses(subject_name, file_name, handle)

split = strsplit(file_name,'.');
name = split{1};

raw_file_address = [handle.data_folder subject_name '/' file_name];

reduced_address = strcat(handle.project_folder, subject_name, '/reduced', ...
    int2str(handle.downsampling_rate) ,'_', name, '.mat');

preprocessed_address = strcat(handle.project_folder, subject_name, '/full_', ...
    name, '.mat');

interpolated_name = strcat(handle.project_folder, subject_name, '/', ...
    'interpolated_', name, '.mat');

end