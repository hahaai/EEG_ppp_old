function [subject_count, file_count] = ...
    get_preprocessed_numbers(data_folder, project_folder, ext)
subject_count = 0;
file_count = 0;

subjects = list_subjects(data_folder);
for i = 1:length(subjects)
   subject = subjects{i};
   
   if exist([project_folder subject], 'dir')
        raw_files = dir([data_folder subject '/*' ext]);
        temp = 0;
        for j = 1:length(raw_files)
            file = raw_files(j);
            name = file.name;
            splits = strsplit(name, ext);
            name = splits{1};
            if exist(strcat(project_folder, subject, '/full_', name, ...
            '.mat'), 'file')
                file_count = file_count + 1;
                temp = temp + 1;
            end
        end
        if (temp == length(raw_files))
           subject_count = subject_count + 1; 
        end
   end
end