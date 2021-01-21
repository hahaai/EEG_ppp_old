function varargout = rating_gui(varargin)
% RATING_GUI MATLAB code for rating_gui.fig
%      RATING_GUI, by itself, creates a new RATING_GUI or raises the existing
%      singleton*.
%
%      H = RATING_GUI returns the handle to a new RATING_GUI or the handle to
%      the existing singleton*.
%
%      RATING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RATING_GUI.M with the given input arguments.
%
%      RATING_GUI('Property','Value',...) creates a new RATING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rating_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rating_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rating_gui

% Last Modified by GUIDE v2.5 13-Jun-2016 11:04:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rating_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @rating_gui_OutputFcn, ...
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


% --- Executes just before rating_gui is made visible.
function rating_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rating_gui (see VARARGIN)

if( nargin - 3 ~= 1 )
    error('wrong number of arguments. Project name must be chosen.')
end
set(handles.figure1, 'units', 'normalized', 'position', [0.05 0.3 0.8 0.8])
handles = load_state(handles, varargin);

% Choose default command line output for rating_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rating_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rating_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in turnonbutton.
function turnonbutton_Callback(hObject, eventdata, handles)
% hObject    handle to turnonbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if( handles.current == -1)
    return;
end
addr = handles.files(handles.current);
addr = addr{1};
name = get_name(addr);
if( strcmp(handles.rating(name), 'Interpolate') )
   handles = turn_on_selection(handles);
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in turnoffbutton.
function turnoffbutton_Callback(hObject, eventdata, handles)
% hObject    handle to turnoffbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if( handles.current == -1)
    return;
end
addr = handles.files(handles.current);
addr = addr{1};
name = get_name(addr);
if( strcmp(handles.rating(name), 'Interpolate') )
   handles = turn_off_selection(handles);
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in goodcheckbox.
function goodcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to goodcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if( handles.current ~= -1 )
    val = get(handles.goodcheckbox, 'Value');
    addr = handles.files(handles.current);
    addr = addr{1};
    name = get_name(addr);
    if( ~val && strcmp( handles.rating(name), 'Good'))
        old_current = handles.current;
        handles = next(handles);
        if(handles.current == old_current)
            handles = previous(handles);
        end
    end

    handles = set_subjects_list(handles);

    if((val && is_filtered(handles, handles.current)) || ...
            (val && strcmp(handles.rating(name), 'Good')))
        if(strcmp(handles.rating(name), 'Good') && ...
                ~ is_filtered(handles, handles.current))
            handles = current(handles);
        else
            old_current = handles.current;
            handles = next(handles);
            if(handles.current == old_current)
                handles = previous(handles);
            end
        end
    end
end

% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of goodcheckbox


% --- Executes on button press in okcheckbox.
function okcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to okcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if( handles.current ~= -1 )
    val = get(handles.okcheckbox, 'Value');
    addr = handles.files(handles.current);
    addr = addr{1};
    name = get_name(addr);
    if( ~val && strcmp( handles.rating(name), 'OK'))
        old_current = handles.current;
        handles = next(handles);
        if(handles.current == old_current)
            handles = previous(handles);
        end
    end

    if((val && is_filtered(handles, handles.current)) || ...
            (val && strcmp(handles.rating(name), 'OK')))
        if(strcmp(handles.rating(name), 'OK') && ...
                ~ is_filtered(handles, handles.current))
            handles = current(handles);
            else
            old_current = handles.current;
            handles = next(handles);
            if(handles.current == old_current)
                handles = previous(handles);
            end
        end
    end
end
handles = set_subjects_list(handles);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of okcheckbox


% --- Executes on button press in badcheckbox.
function badcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to badcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if( handles.current ~= -1 )
    val = get(handles.badcheckbox, 'Value');
    addr = handles.files(handles.current);
    addr = addr{1};
    name = get_name(addr);
    if( ~val && strcmp( handles.rating(name), 'Bad'))
        old_current = handles.current;
        handles = next(handles);
        if(handles.current == old_current)
            handles = previous(handles);
        end
    end

    if((val && is_filtered(handles, handles.current)) || ...
            (val && strcmp(handles.rating(name), 'Bad')))
        if(strcmp(handles.rating(name), 'Bad') && ...
                ~ is_filtered(handles, handles.current))
            handles = current(handles);
        else
            old_current = handles.current;
            handles = next(handles);
            if(handles.current == old_current)
                handles = previous(handles);
            end
        end
    end
end
handles = set_subjects_list(handles);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of badcheckbox


% --- Executes on button press in interpolatecheckbox.
function interpolatecheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to interpolatecheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if( handles.current ~= -1 )
    val = get(handles.interpolatecheckbox, 'Value');
    addr = handles.files(handles.current);
    addr = addr{1};
    name = get_name(addr);
    if( ~val && strcmp( handles.rating(name), 'Interpolate'))
        old_current = handles.current;
        handles = next(handles);
        if(handles.current == old_current)
            handles = previous(handles);
        end
    end

    if((val && is_filtered(handles, handles.current)) || ...
            (val && strcmp(handles.rating(name), 'Interpolate')))
        if(strcmp(handles.rating(name), 'Interpolate') && ...
                ~ is_filtered(handles, handles.current))
            handles = current(handles);
        else
            old_current = handles.current;
            handles = next(handles);
            if(handles.current == old_current)
                handles = previous(handles);
            end
        end
    end
end
handles = set_subjects_list(handles);
% Update handles structure
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of interpolatecheckbox


% --- Executes on button press in notratedcheckbox.
function notratedcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to notratedcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if( handles.current ~= -1 )
    val = get(handles.notratedcheckbox, 'Value');
    addr = handles.files{handles.current};
    name = get_name(addr);
    if( ~val && strcmp( handles.rating(name), 'Not Rated'))
        old_current = handles.current;
        handles = next(handles);
        if(handles.current == old_current)
            handles = previous(handles);
        end
    end

    if((val && is_filtered(handles, handles.current)) || ...
            (val && strcmp(handles.rating(name), 'Not Rated')))
        if(strcmp(handles.rating(name), 'Not Rated') && ...
                ~ is_filtered(handles, handles.current))
            handles = current(handles);
        else
            old_current = handles.current;
            handles = next(handles);
            if(handles.current == old_current)
                handles = previous(handles);
            end
        end
    end
end

handles = set_subjects_list(handles);
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of notratedcheckbox


% --- Executes on button press in previousbutton.
function previousbutton_Callback(hObject, eventdata, handles)
% hObject    handle to previousbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = previous(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in nextbutton.
function nextbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = next(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes when selected object is changed in rategroup.
function rategroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in rategroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.current == -1 || is_filtered(handles, handles.current))
    return;
end
handles = get_rating(handles);
addr = handles.files(handles.current);
addr = addr{1};
name = get_name(addr);
if( strcmp(handles.rating(name), 'Interpolate') )
   handles = turn_on_selection(handles);
end

% Update handles structure
guidata(hObject, handles);

function handles = load_state(handles, varargin)
handles.project_name = varargin{1};
handles.fileName = strcat(handles.project_name,'_state.mat');
handles.fileName = handles.fileName{1};

if ~ exist(handles.fileName, 'file')
    waitfor(msgbox('The project you chose does not exist.'));
    return;
end

handles = load_project_state(handles);

% set checkboxs
set(handles.interpolatecheckbox,'Value', 1)
set(handles.badcheckbox,'Value', 1)
set(handles.okcheckbox,'Value', 1)
set(handles.goodcheckbox,'Value', 1)
set(handles.notratedcheckbox,'Value', 1)

handles = set_subjects_list(handles);
set_rating(handles);
handles.selection = false;

% Load and show the first image
[handles, data] = load_current(handles);
handles = show_current(data, handles);
clear data;
handles = update_subject_list(handles);


function save_state(handles)
if(isa(handles, 'struct'))
    save_project_state(handles);
end


function [handles, reduced] = load_current(handles) %#ok<STOUT>
if ( handles.current == - 1 || is_filtered(handles, handles.current))
    reduced = [];
else
    red_address = handles.files(handles.current);
    load(red_address{1});
    handles.maxX = max(handles.maxX, size(reduced.data, 2));
    handles.badchans = reduced.auto_badchans;
end

function handles = current(handles)
handles = get_rating(handles);
[handles, data] = load_current(handles);
handles = show_current(data, handles);
clear data;
handles = update_subject_list(handles);
handles = set_rating(handles);

function handles = next(handles)
handles = get_rating(handles);
handles.current = get_next_index(handles.current, ...
    length(handles.files), handles);
[handles, data] = load_current(handles);
handles = show_current(data, handles);
clear data;
handles = update_subject_list(handles);
handles = set_rating(handles);

function handles = previous(handles)
handles = get_rating(handles);
handles.current = get_previous_index(handles.current, handles);
[handles, data] = load_current(handles);
handles = show_current(data, handles);
clear data;
handles = update_subject_list(handles);
handles = set_rating(handles);


function handles = set_rating(handles)
if( handles.current == - 1 || is_filtered(handles, handles.current))
    set(handles.rategroup,'selectedobject',[]);
    return
end
addr = handles.files(handles.current);
addr = addr{1};
name = get_name(addr);

set(handles.turnonbutton,'Enable', 'off')
set(handles.turnoffbutton,'Enable', 'off')
switch handles.rating(name)
    case 'Good'
       set(handles.rategroup,'selectedobject',handles.goodrate)
    case 'OK'
        set(handles.rategroup,'selectedobject',handles.okrate)
    case 'Bad'
        set(handles.rategroup,'selectedobject',handles.badrate)
    case 'Interpolate'
        set(handles.rategroup,'selectedobject',handles.interpolaterate)
        set(handles.turnonbutton,'Enable', 'on')
        set(handles.turnoffbutton,'Enable', 'on')
    case 'Not Rated'
        set(handles.rategroup,'selectedobject',handles.goodrate)
end

function handles = get_rating(handles)
if( handles.current == -1)
    return
end
addr = handles.files{handles.current};
split = strsplit(addr, '/');
subject = split{end - 1};
name = get_name(addr);

pure_name = strsplit(name, '_');
pure_name = pure_name{end};


[~ , ~, ~, interpolated_addr] = ...
            get_adresses(subject, strcat(pure_name,handles.file_extension), handles);     
if( isempty(handles.rategroup.SelectedObject))
    return;
else
    switch handles.rategroup.SelectedObject.String
        case 'Good'
            handles.rating(name) = 'Good';
            handles.interpolate_list(name) = [];
            if exist(interpolated_addr, 'file')
               delete(interpolated_addr);
            end
        case 'OK'
            handles.rating(name) = 'OK';
            handles.interpolate_list(name) = [];
            if exist(interpolated_addr, 'file')
               delete(interpolated_addr);
            end
        case 'Bad'
            handles.rating(name) = 'Bad';
            handles.interpolate_list(name) = [];
            if exist(interpolated_addr, 'file')
               delete(interpolated_addr);
            end
        case 'Not Rated'
            handles.rating(name) = 'Not Rated';
            handles.interpolate_list(name) = [];
            if exist(interpolated_addr, 'file')
               delete(interpolated_addr);
            end
        case 'Interpolate'
            handles.rating(name) = 'Interpolate';
    end
end

function handles = show_current(reduced, handles)
if( handles.current == -1)
    return
end

if isfield(reduced, 'data')
    data = reduced.data;
else
    data = [];
end
axe = handles.axes;
current = handles.current;
cla(axe);

addr = handles.files(current);
addr = addr{1};
name = get_name(addr);

im = imagesc(data);
set(im, 'ButtonDownFcn', {@on_selection,handles})
set(gcf, 'Color', [1,1,1])
colormap jet
caxis([-100 100])
title(name, 'Interpreter','none')
handles.im = im;

draw_lines(handles);
mark_interpolated_chans(handles)

function idx = get_next_index(current, n, handles)
if(current == -1)
    idx = current;
    return
end

tmp = current;
while(true)
    tmp = tmp + 1;
    if( tmp > n)
        tmp = current;
        break;
    end
    
    if( ~ is_filtered(handles, tmp) )
        break;
    end
end
idx = tmp;

function idx = get_previous_index(current, handles)
if(current == -1)
    idx = current;
    return
end

tmp = current;
while(true)
    tmp = tmp - 1;
    if( tmp < 1)
        tmp = current;
        break;
    end
    
    if( ~ is_filtered(handles, tmp))
        break;
    end
end
idx = tmp;

function bool = is_filtered(handles, subj)
if( handles.current == -1)
    bool = true;
    return;
end

switch class(subj)
    case 'double'
        addr = handles.files(subj);
        addr = addr{1};
        name = get_name(addr);
    case 'char'
        name = subj;
end

switch handles.rating(name)
    case 'Good'
        bool = ~get(handles.goodcheckbox,'Value');
    case 'OK'
        bool = ~get(handles.okcheckbox,'Value');
    case 'Bad'
        bool = ~get(handles.badcheckbox,'Value');
    case 'Interpolate'
        bool = ~get(handles.interpolatecheckbox,'Value');
    case 'Not Rated'
        bool = ~get(handles.notratedcheckbox,'Value');
    otherwise
        bool = false;
end

function handles = turn_on_selection(handles)

if(is_filtered(handles, handles.current))
    return;
end

set(handles.turnoffbutton,'Enable', 'on')
set(handles.turnonbutton,'Enable', 'off')
handles.selection = true;

% To update both oncall functions with new handles where the selection is
% changed
set(handles.im, 'ButtonDownFcn', {@on_selection,handles})
update_lines(handles)

set(gcf,'Pointer','crosshair');
switch_gui('off', handles);

function handles = turn_off_selection(handles)

if(is_filtered(handles, handles.current))
    return;
end

set(handles.turnoffbutton,'Enable', 'off')
set(handles.turnonbutton,'Enable', 'on')
handles.selection = false;

% To update both oncall functions with new handles where the selection is
% changed
set(handles.im, 'ButtonDownFcn', {@on_selection,handles})
update_lines(handles)

set(gcf,'Pointer','arrow');
switch_gui('on', handles);

function on_selection(source, event, handles)
if( handles.selection )
    y = event.IntersectionPoint(2);
    process_input(y, handles);
end


function process_input(y, handles)
add = handles.files(handles.current);
add = add{1};
name = get_name(add);
list = handles.interpolate_list(name);
y = int64(y);
if( ismember(y, list ) )
    error('No way the callback function is called here !')
else
    list = [list y];
    draw_line(y, handles.maxX, handles, 'b');
end
handles.interpolate_list(name) = list;
set(handles.channellistbox,'String',list)

function draw_line(y, maxX, handles, color)
axe = handles.axes;
axes(axe);
hold on;
p1 = [0, maxX];
p2 = [y, y];
p = plot(axe, p1, p2, color ,'LineWidth', 3);
set(p, 'ButtonDownFcn', {@delete_line, p, y, handles})
hold off;

function draw_lines(handles)
if(handles.current == -1 || is_filtered(handles, handles.current))
    return;
end
current = handles.current;
addr = handles.files(current);
addr = addr{1};
name = get_name(addr);
list = handles.interpolate_list(name);
for chan = 1:length(list)
    draw_line(list(chan), handles.maxX, handles, 'b');
end
set(handles.channellistbox,'String',list)

function update_lines(handles)
lines = findall(gcf,'Type','Line');
for i = 1:length(lines)
   delete(lines(i)); 
end
draw_lines(handles);
mark_interpolated_chans(handles);

function delete_line(source, event, p, y, handles)
if( ~ handles.selection )
    return;
end
axes(handles.axes);
delete(p);
add = handles.files(handles.current);
add = add{1};
name = get_name(add);
list = handles.interpolate_list(name);
list = list(list ~= y);
handles.interpolate_list(name) = list;
set(handles.channellistbox,'String',list)

function mark_interpolated_chans(handles)
if(handles.current == -1 || is_filtered(handles, handles.current))
    return;
end
axe = handles.axes;
badchans = handles.badchans;
axes(axe);
hold on;
for i = 1:length(badchans)
    plot(0 , badchans(i),'r*')
end
hold off;


function switch_gui(mode, handles)
set(handles.nextbutton,'Enable', mode)
set(handles.previousbutton,'Enable', mode)
set(handles.interpolaterate,'Enable', mode)
set(handles.okrate,'Enable', mode)
set(handles.badrate,'Enable', mode)
set(handles.goodcheckbox,'Enable', mode)
set(handles.okcheckbox,'Enable', mode)
set(handles.badcheckbox,'Enable', mode)
set(handles.interpolatecheckbox,'Enable', mode)
set(handles.notratedcheckbox,'Enable', mode)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = get_rating(handles);
save_state(handles);
h = main_gui;
handle = guidata(h);
main_gui('load_project', handle);
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on selection change in subjectsmenu.
function subjectsmenu_Callback(hObject, eventdata, handles)
% hObject    handle to subjectsmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Determine the selected data set.
list = get(hObject, 'String');
idx = get(hObject,'Value');
name = list{idx};
if(strcmp(name, ''))
    return;
end
IndexC = strfind(handles.files, name);
Index = find(not(cellfun('isempty', IndexC)));
handles.current = Index;
[handles, data] = load_current(handles);
handles = show_current(data, handles);
clear data;
handles = set_rating(handles);
% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns subjectsmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subjectsmenu

function handles = set_subjects_list(handles)
files = handles.files;
list = {};
for i = 1:length(files)
    add = files(i);
    add = add{1};
    name = get_name(add);
    if( ~ is_filtered(handles, name) )
        list{end + 1} = name;
    end
end
if( isempty(list))
    list{end + 1} = '';
end
set(handles.subjectsmenu,'String',list);
handles = update_subject_list(handles);

function handles = update_subject_list(handles)
if( handles.current == -1)
    return;
end
add = handles.files(handles.current);
add = add{1};
name = get_name(add);
IndexC = strfind(handles.subjectsmenu.String, name);
Index = find(not(cellfun('isempty', IndexC)));
if(isempty(Index))
    Index = 1;
end
set(handles.subjectsmenu,'Value',Index);

% --- Executes during object creation, after setting all properties.
function subjectsmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectsmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channellistbox.
function channellistbox_Callback(hObject, eventdata, handles)
% hObject    handle to channellistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if( handles.current == -1)
    return;
end
index_selected = get(handles.channellistbox,'Value');
channels = cellstr(get(handles.channellistbox,'String'));
channel = channels{index_selected};
channel = str2num(channel);

update_lines(handles);
lines = findall(gcf,'Type','Line');
for i = 1:length(lines)
   if (lines(i).YData(1) == channel)
       break;
   end
end
delete(lines(i));
draw_line(channel, handles.maxX, handles, 'r')
% Hints: contents = cellstr(get(hObject,'String')) returns channellistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channellistbox


% --- Executes during object creation, after setting all properties.
function channellistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channellistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
