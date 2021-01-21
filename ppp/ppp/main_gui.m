function varargout = main_gui(varargin)
% MAIN_GUI MATLAB code for main_gui.fig
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_gui

% Last Modified by GUIDE v2.5 22-Sep-2016 12:56:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @main_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main_gui is made visible.
function main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_gui (see VARARGIN)

% Choose default command line output for main_gui
handles.output = hObject;

set(handles.figure1, 'units', 'normalized', 'position', [0.05 0.3 0.7 0.6])

% Set constant values
handles.NEW_PROJECT = 'Create New Project...';
handles.NEW_PROJECT_NAME = 'Type the name of your new project...';
handles.NEW_PROJECT_DATA_FOLDER = 'Choose where your raw data is...';
handles.NEW_PROJECT_FOLDER = 'Choose where you want the results to be saved...'; 

% Load the state and then the current project
handles = load_state(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Load the current state of the main gui and then calls the
% load_project
function handles = load_state(handles)
% handles       main handle of this gui
fileName = 'state.mat';
if exist(fileName, 'file') % Load main state file
    load(fileName);
    handles.project_list = state.project_list;
    handles.current_project = state.current_project;
else % initialise everything
   handles.project_list = {handles.NEW_PROJECT};
   handles.current_project = 1;
end

set(handles.existingpopupmenu,'String',handles.project_list, 'Value', ...
    handles.current_project);
handles = update_and_load(handles);

function save_state(handles)
if(isa(handles, 'struct'))
    state.project_list = handles.project_list;
    state.current_project = handles.current_project;
    save('state.mat', 'state')
end

function handles = update_and_load(handles)
set(handles.figure1, 'pointer', 'watch')
drawnow;
handles = update_project(handles);
set(handles.figure1, 'pointer', 'arrow')
handles = load_project(handles);

% --- Loads the current project selected by gui and set the gui accordingly
function handles = load_project(handles)
% handles           main handle of this gui

% Find the selected project
idx = get(handles.existingpopupmenu, 'Value');
name = handles.project_list{idx};
handles.current_project = idx;

%% Special case of new project
if(strcmp(name, handles.NEW_PROJECT))
    set(handles.projectname, 'String', handles.NEW_PROJECT_NAME);
    set(handles.datafoldershow, 'String', handles.NEW_PROJECT_DATA_FOLDER);
    set(handles.projectfoldershow, 'String', handles.NEW_PROJECT_FOLDER);
    set(handles.subjectnumber, 'String', '')
    set(handles.filenumber, 'String', '')
    set(handles.preprocessednumber, 'String', '')
    set(handles.fpreprocessednumber, 'String', '')
    set(handles.ratednumber, 'String', '')
    set(handles.interpolatenumber, 'String', '')
    
    % Enable modifications
    set(handles.projectname, 'enable', 'on');
    set(handles.datafoldershow, 'enable', 'on');
    set(handles.projectfoldershow, 'enable', 'on');
    set(handles.fileextension, 'enable', 'on');
    set(handles.dsrate, 'enable', 'on');
    set(handles.choosedata, 'enable', 'on');
    set(handles.chooseproject, 'enable', 'on');
    set(handles.createbutton, 'visible','on')
    set(handles.deleteprojectbutton, 'visible','off')
    return;
end

%% Load the project:
% Load the project from the file
p_handle.fileName = strcat(name,'_state.mat');
if exist(p_handle.fileName, 'file')
    p_handle = load_project_state(p_handle);
    handles.p_handle = p_handle;
else
   error('The state file does not exist anymore. You must delete this project.')
end


% Disable modifications from gui
set(handles.projectname, 'enable', 'off');
set(handles.datafoldershow, 'enable', 'off');
set(handles.projectfoldershow, 'enable', 'off');
set(handles.fileextension, 'enable', 'off');
set(handles.dsrate, 'enable', 'off');
set(handles.choosedata, 'enable', 'off');
set(handles.chooseproject, 'enable', 'off');
set(handles.createbutton, 'visible','off')
set(handles.deleteprojectbutton, 'visible','on')

%Set properties of the project:
set(handles.projectname, 'String', name);
set(handles.datafoldershow, 'String', p_handle.data_folder);
set(handles.projectfoldershow, 'String', p_handle.project_folder);
set(handles.subjectnumber, 'String', [num2str(p_handle.subject_count) ' subjects...'])
set(handles.filenumber, 'String', [num2str(p_handle.file_count) ' files...'])        
set(handles.preprocessednumber, 'String', ...
    [num2str(p_handle.processed_subjects), ' subjects already done'])
set(handles.fpreprocessednumber, 'String', ...
    [num2str(p_handle.processed_files), ' files already done'])

% Set the file extension
IndexC = strfind(handles.fileextension.String, p_handle.file_extension);
index = find(not(cellfun('isempty', IndexC)));
set(handles.fileextension, 'Value', index);

% Set the downsampling rate
IndexC = strfind(handles.dsrate.String, int2str(handles.dsrate.Value));
index = find(not(cellfun('isempty', IndexC)));
set(handles.dsrate, 'Value', index);


% Set number of rated files
rated_count = get_rated_numbers(handles);
set(handles.ratednumber, 'String', ...
    [num2str(rated_count), ' files already rated'])

% Set number of files to be interpolated
interpolate_count = to_be_interpolated_count(handles);
set(handles.interpolatenumber, 'String', ...
    [num2str(interpolate_count), ' subjects to interpolate'])

save_state(handles);

% --- Check if data structures are changed since last time and updates the
% structure accordingly
function handles = update_project(handles)
% handles           main handle of this gui

% Find the selected project
idx = get(handles.existingpopupmenu, 'Value');
name = handles.project_list{idx};

% Load the project from the file
p_handle.fileName = strcat(name,'_state.mat');
if ~ exist(p_handle.fileName, 'file')
    return;
end
p_handle = load_project_state(p_handle);
if( exist( p_handle.project_folder, 'dir') )
    update_rating_structures(p_handle);
else
    waitfor(msgbox('The project folder does not exists or is not reachable.', 'Error', 'error'));
end

% --- Count the number of subjects and files in the folder given by
% argument
function [subject_count, file_count] = get_subject_and_file_numbers(folder, ext)
% folder    the folder to look into
% ext       determines the extension of files
subjects = list_subjects(folder);
subject_count = length(subjects);
file_count = 0;
for i = 1:subject_count
    subject = subjects{i};
    raw_files = dir([folder subject '/*' ext]);
    file_count = file_count + length(raw_files);
end

% --- Count number of files that has been already rated
function rated_count = get_rated_numbers(handles)
% handles       main handle of this gui
rated_count = 0;
name = handles.project_list{handles.current_project};
p_handle.fileName = strcat(name,'_state.mat');
p_handle = load_project_state(p_handle, 'rating');

if( isfield(p_handle, 'rating') && ...
        isa(p_handle.rating, 'containers.Map'))
    list = p_handle.rating.values;
    rated_count = sum(~ismember(list, 'NotRated'));
end

% --- Count the number of files that are rated as interpolate
function count = to_be_interpolated_count(handles)
% handles       main handle of this gui
count = 0;
name = handles.project_list{handles.current_project};
p_handle.fileName = strcat(name,'_state.mat');
p_handle = load_project_state(p_handle, 'interpolate_list');

if(isfield(p_handle, 'interpolate_list') && ...
    isa(p_handle.interpolate_list, 'containers.Map'))
    
    list = p_handle.interpolate_list.values;
    count = sum((~cellfun(@isempty,list))); 
end

function projectname_Callback(hObject, eventdata, handles)
% hObject    handle to projectname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectname as text
%        str2double(get(hObject,'String')) returns contents of projectname as a double


% --- Executes during object creation, after setting all properties.
function projectname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Get the file extension from the gui and calculate number of files and
% subjects in the datafolder with this extension and set the gui
function fileextension_Callback(hObject, eventdata, handles)
% hObject    handle to fileextension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fileextension contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileextension
if( strcmp(get(handles.datafoldershow, 'String'), handles.NEW_PROJECT_DATA_FOLDER))
    return
end

folder = get(handles.datafoldershow, 'String');
idx = get(handles.fileextension, 'Value');
exts = get(handles.fileextension, 'String');
ext = exts{idx};
[subject_count, file_count] = ...
    get_subject_and_file_numbers(folder, ext);

set(handles.subjectnumber, 'String', ...
    [num2str(subject_count) ' subjects...'])
set(handles.filenumber, 'String', [num2str(file_count) ' files...'])

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fileextension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileextension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dsrate.
function dsrate_Callback(hObject, eventdata, handles)
% hObject    handle to dsrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dsrate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dsrate


% --- Executes during object creation, after setting all properties.
function dsrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dsrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Get the adress of the data folder from the gui, suggest a default
% project folder and set both to on the gui. Set the number of existing
% subjects and files as well
function choosedata_Callback(hObject, eventdata, handles)
% hObject    handle to choosedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir();
if(folder ~= 0)
    folder = strcat(folder,'/');
    set(handles.datafoldershow, 'String', folder)
    
    split = strsplit(folder, '/');
    parent_folder = split(1:end - 2);
    data_folder = split{end - 1};
    parent_folder = strjoin(parent_folder, '/');
    project_folder = strcat(parent_folder, '/' ,data_folder ,'_results/');
    set(handles.projectfoldershow, 'String', project_folder)
    
    idx = get(handles.fileextension, 'Value');
    exts = get(handles.fileextension, 'String');
    ext = exts{idx};
    [subject_count, file_count] = ...
        get_subject_and_file_numbers(folder, ext);
    
    set(handles.subjectnumber, 'String', ...
        [num2str(subject_count) ' subjects...'])
    set(handles.filenumber, 'String', [num2str(file_count) ' files...'])
end


% Update handles structure
guidata(hObject, handles);


% --- Get the adress of project folder and set the gui
function chooseproject_Callback(hObject, eventdata, handles)
% hObject    handle to chooseproject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir();
if(folder ~= 0)
    folder = strcat(folder,'/');
    set(handles.projectfoldershow, 'String', folder)
end
% Update handles structure
guidata(hObject, handles);

% --- Start the rating gui on the current project
function manualratingbutton_Callback(hObject, eventdata, handles)
% hObject    handle to manualratingbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(handles.existingpopupmenu, 'Value');
projects = get(handles.existingpopupmenu, 'String');
name = projects{idx};

state_name = strcat(name,'_state.mat');

if ~ exist(state_name, 'file')
    waitfor(msgbox('The project you chose does not exist.', 'Error', 'error'));
    return;
end
p_handle.fileName = strcat(name,'_state.mat');
p_handle = load_project_state(p_handle);
if( ~ isfield(p_handle, 'rating') || ~ isfield(p_handle, 'interpolate_list') || ...
    ~ isfield(p_handle, 'files') || ~ isfield(p_handle, 'maxX'))
    create_rating_structures(p_handle); 
end

rating_gui(name);

% --- Start interpolation on selected files
function interpolatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to interpolatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(handles.existingpopupmenu, 'Value');
projects = get(handles.existingpopupmenu, 'String');
name = projects{idx};

interpolate_selected(name);


% --- Run preprocessing on all subjects
function runpreprocessbutton_Callback(hObject, eventdata, handles)
% hObject    handle to runpreprocessbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('./src');
idx = get(handles.existingpopupmenu, 'Value');
projects = get(handles.existingpopupmenu, 'String');
name = projects{idx};
pre_process_all(name)


function datafoldershow_Callback(hObject, eventdata, handles)
% hObject    handle to datafoldershow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datafoldershow as text
%        str2double(get(hObject,'String')) returns contents of datafoldershow as a double


% --- Executes during object creation, after setting all properties.
function datafoldershow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datafoldershow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function projectfoldershow_Callback(hObject, eventdata, handles)
% hObject    handle to projectfoldershow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectfoldershow as text
%        str2double(get(hObject,'String')) returns contents of projectfoldershow as a double


% --- Executes during object creation, after setting all properties.
function projectfoldershow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectfoldershow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Load the selected project by gui
function existingpopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to existingpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns existingpopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from existingpopupmenu
handles = update_and_load(handles);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function existingpopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to existingpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Get the selected info and create a new project with them
function createbutton_Callback(hObject, eventdata, handles)
% hObject    handle to createbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(handles.existingpopupmenu, 'Value');
project = handles.project_list{idx};

% It must be on NEW PROJECT (This case must never happen, create button 
% is disabled for other projects)
if(~ strcmp(project, handles.NEW_PROJECT))
    waitfor(msgbox(['You can not modify the project ', project, '.'],...
        'Error','error'));
    return;
end

name = get(handles.projectname, 'String');
% Name must be a valid file name
if (~isempty(regexp(name, '[/\*:?"<>|]', 'once')))
    waitfor(msgbox(['Please enter a valid name not containing any of the following: '...
           '/ \ * : ? " < > |'], 'Error','error'));
    return;
end

state.fileName = strcat(name,'_state.mat');
% The project name must be different than existing ones
if exist(state.fileName, 'file')
    waitfor(msgbox(['This project already exists ! Please remove it or name a new '...
            'project with a different name.'], 'Error','error'));
    return;
end

% Save the project to the file and load it
state.project_name = name;
state.project_folder = get(handles.projectfoldershow, 'String');
state.data_folder = get(handles.datafoldershow, 'String');
state.processed_subjects = 0;
state.processed_files = 0;

% Data folder and project folder must be at least modified !
if( strcmp(state.data_folder, handles.NEW_PROJECT_DATA_FOLDER) || ...
        strcmp(state.project_folder, handles.NEW_PROJECT_FOLDER) || ...
        strcmp(state.project_name, handles.NEW_PROJECT_NAME))
    waitfor(msgbox('You must choose a name, project folder and data folder.',...
        'Error','error'));
    return;
end

% Add "\" is not exists already
if( isempty(regexp( state.data_folder ,'\/$','match')))
    state.data_folder = strcat(state.data_folder,'/');
    set(handles.datafoldershow, 'String', state.data_folder)
end

% Add "\" is not exists already
if( isempty(regexp( state.project_folder ,'\/$','match')))
    state.project_folder = strcat(state.project_folder,'/');
    set(handles.projectfoldershow, 'String', state.project_folder)
end

if(~ exist(state.data_folder, 'dir'))
    waitfor(msgbox('This data folder does not exist.',...
        'Error','error'));
end

if(~ exist(state.project_folder, 'dir'))
    mkdir(state.project_folder);
end

% Get the file extension
idx = get(handles.fileextension, 'Value');
exts = get(handles.fileextension, 'String');
state.file_extension = exts{idx};

% Get the downsampling rate
idx = get(handles.dsrate, 'Value');
dsrates = get(handles.dsrate, 'String');
state.downsampling_rate = str2double(dsrates{idx});

[state.subject_count, state.file_count] = ...
    get_subject_and_file_numbers(state.data_folder, state.file_extension);

% Get filtering mode
state.filter_mode = handles.filteringbuttongroup.SelectedObject.String;
save_project_state(state);

% Set the gui to this project and load this project
handles.project_list{end + 1} = name;
handles.current_project = length(handles.project_list);
set(handles.existingpopupmenu,'String',handles.project_list, 'Value', ...
    handles.current_project);

load_project(handles);
save_state(handles);

waitfor(msgbox({'Bravo ! This project is successfully created.' ...
    'Now you can start pre-processing.'}));
% Update handles structure
guidata(hObject, handles);

function handles = create_rating_structures(handles)
% Load subject folders
addpath('src/')
subjects = list_subjects(handles.data_folder);

% Initialise all structures
handles.rating = containers.Map;
handles.interpolate_list = containers.Map;
handles.maxX = 0;

downsampling_rate = handles.downsampling_rate;
ext = handles.file_extension;
files = {};
for i = 1:length(subjects)
    subject = subjects{i};
    raw_files = dir([handles.data_folder subject '/*' ext]);

    for j = 1:length(raw_files)
        file = raw_files(j);
        name = file.name;
        splits = strsplit(name, ext);
        name = splits{1};
        if exist(strcat(handles.project_folder, subject, '/full_', name, ...
        '.mat'), 'file')

           red_address = strcat(handles.project_folder, subject, ...
               '/reduced', int2str(downsampling_rate),'_' , name, '.mat');
           red_name = strcat('reduced', int2str(downsampling_rate),'_' , name);
           files{end + 1} = red_address;
           handles.rating(get_name(red_name)) = 'Not Rated';
           handles.interpolate_list(get_name(red_name)) = [];
        end
    end
end
handles.files = files;

% Assign current index
if( ~ isempty(handles.files))
    handles.current = 1;
else
    handles.current = -1;
end
save_project_state(handles, 'files', 'current', 'rating',...
    'interpolate_list','downsampling_rate','maxX');

function p_handle = update_rating_structures(p_handle)

if( ~ isfield(p_handle, 'rating') || ~ isfield(p_handle, 'interpolate_list') || ...
    ~ isfield(p_handle, 'files') || ~ isfield(p_handle, 'maxX'))
    % Nothing to update, rating has not been started yet
    return;
end

% Load subject folders
addpath('src/')
subjects = list_subjects(p_handle.data_folder);
subject_count = length(subjects);
preprocessed_subject_count = 0;

downsampling_rate = p_handle.downsampling_rate;
ext = p_handle.file_extension;
rating = containers.Map;
interpolate_list = containers.Map;

files = {};
file_count = 0;
preprocessed_file_count = 0;
for i = 1:length(subjects)
    subject = subjects{i};
    raw_files = dir([p_handle.data_folder subject '/*' ext]);
    temp = 0;
    for j = 1:length(raw_files)
        file_count = file_count + 1;
        file = raw_files(j);
        name = file.name;
        splits = strsplit(name, ext);
        name = splits{1};
        if exist(strcat(p_handle.project_folder, subject, ...
                '/full_', name, '.mat'), 'file')
           red_address = strcat(p_handle.project_folder, subject, ...
               '/reduced', int2str(downsampling_rate),'_' , name, '.mat');
           red_name = strcat('reduced', int2str(downsampling_rate),'_' , name);
           files{end + 1} = red_address;
           % Merging (both data folder and results are added):
           % If a new file has been added to data folder 
           if ~ isKey(p_handle.rating, red_name) 
               rating(get_name(red_name)) = 'Not Rated';
               interpolate_list(get_name(red_name)) = [];
           else
               % Some files removed from data folder:
               % Here the previous rating results should be copied to the 
               % new one. The reason that the original one is not kept, is
               % that maybe some original files from data folder are
               % deleted, and thus we should get rid of the corresponding
               % rating results as well, by not copying them into the new
               % rating results.
               rating(get_name(red_name)) = p_handle.rating(get_name(red_name));
               interpolate_list(get_name(red_name)) = p_handle.interpolate_list(get_name(red_name));
           end
           
           preprocessed_file_count = preprocessed_file_count + 1;
           temp = temp + 1;
        else
            % WRONG:
%             % Some results are removed but original is kept:
%             % Check if the rating exist, if yes, remove it, cause there is
%             % no result file anymore
%             red_address = strcat(p_handle.project_folder, subject, ...
%                '/reduced', int2str(downsampling_rate),'_' , name, '.mat');
%             if(isKey(p_handle.rating, red_address))
%                 remove(handles.rating, red_address);
%                 remove(handles.interpolate_list, red_address);
%             end
        end
    end
    if (temp == length(raw_files))
        preprocessed_subject_count = preprocessed_subject_count + 1; 
    end
end

% Inform user if result folder has been modified
if( preprocessed_file_count > p_handle.processed_files || preprocessed_subject_count > p_handle.processed_subjects)
    if( preprocessed_subject_count > p_handle.processed_subjects)
        waitfor(msgbox('Seems you already added some results manually :)'));
    else
        waitfor(msgbox('Seems you already added some results manually :)'));
    end
end

if( preprocessed_file_count < p_handle.processed_files || preprocessed_subject_count < p_handle.processed_subjects)
    if( preprocessed_subject_count < p_handle.processed_subjects)
        waitfor(msgbox('Seems some preprocessed results are deleted from the folder. :('));
    else
        waitfor(msgbox('Seems some preprocessed results are deleted from the folder. :('));
    end
end

% Inform user if data folder has been modified
if( file_count > p_handle.file_count || subject_count > p_handle.subject_count)
    if( subject_count > p_handle.subject_count)
        waitfor(msgbox('New subjects are added to the project :)'));
    else
        waitfor(msgbox('New files are added to some subjects :)'));
    end
end

if( file_count < p_handle.file_count || subject_count < p_handle.subject_count)
    if( subject_count < p_handle.subject_count)
        waitfor(msgbox('Seems you have lost some files :('));
    else
        waitfor(msgbox('Seems you have lost some subjects :)'));
    end
end


    
% Assign current index
if( isempty(p_handle.files))
    p_handle.current = -1;
end

p_handle.processed_files = preprocessed_file_count;
p_handle.processed_subjects = preprocessed_subject_count;   
p_handle.files = files;
p_handle.rating = rating;
p_handle.interpolate_list = interpolate_list;
p_handle.file_count = file_count;
p_handle.subject_count = subject_count;
    
save_project_state(p_handle, 'files', 'current', 'rating',...
    'interpolate_list','processed_files', 'processed_subjects','file_count','subject_count');

% --- Save the main gui's state and close the gui
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_state(handles);
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Delete the selected project by gui
function deleteprojectbutton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteprojectbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(handles.existingpopupmenu, 'Value');
name = get(handles.projectname, 'String');
fileName = strcat(name,'_state.mat');
delete(fileName);

handles.project_list(idx) = [];
handles.current_project = 1;
set(handles.existingpopupmenu,'String',handles.project_list, 'Value', ...
    handles.current_project);
update_and_load(handles);
save_state(handles);
% Update handles structure
guidata(hObject, handles);

% --- return the list of subjects in the folder
function subjects = list_subjects(root_folder)
% root_folder       the folder in which subjects are looked for
    subs = dir(root_folder);
    isub = [subs(:).isdir];
    subjects = {subs(isub).name}';
    subjects(ismember(subjects,{'.','..'})) = [];


% --- Get the filtering mode (US or EU) and save it to the project state
function filteringbuttongroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in filteringbuttongroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name = get(handles.projectname, 'String');
fileName = strcat(name,'_state.mat');
if( exist(fileName, 'file') )
    state.fileName = fileName;
    state.filter_mode = handles.filteringbuttongroup.SelectedObject.String;
    save_project_state(state, 'filter_mode')
end
