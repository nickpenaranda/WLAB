function varargout = wlabGUI(varargin)
%WLABGUI M-file for wlabGUI.fig
%      WLABGUI, by itself, creates a new WLABGUI or raises the existing
%      singleton*.
%
%      H = WLABGUI returns the handle to a new WLABGUI or the handle to
%      the existing singleton*.
%
%      WLABGUI('Property','Value',...) creates a new WLABGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to wlabGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WLABGUI('CALLBACK') and WLABGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WLABGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wlabGUI

% Last Modified by GUIDE v2.5 15-Nov-2010 00:49:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wlabGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @wlabGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


function wlabGUI_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for wlabGUI
handles.output = hObject;

[handles.expNames handles.experiments] = getExperiments();

set(handles.listModules,'String',handles.expNames');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wlabGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function varargout = wlabGUI_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


function btnRun_Callback(hObject, eventdata, handles)
    doWLAB(hObject);

function btnDebug_Callback(hObject, eventdata, handles)
    keyboard;

function checkWindowed_Callback(hObject, eventdata, handles)
    v = get(hObject,'Value');
    if(~v), set(handles.editWinSize,'Enable','off');
    else set(handles.editWinSize,'Enable','on');
    end
    guidata(hObject,handles);

function editWinSize_Callback(hObject, eventdata, handles)


function editWinSize_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkSpeedy_Callback(hObject, eventdata, handles)


function editColClear_Callback(hObject, eventdata, handles)


function editColClear_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editColText_Callback(hObject, eventdata, handles)


function editColText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function listModules_Callback(hObject, eventdata, handles)


function listModules_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editSubID_Callback(hObject, eventdata, handles)


function editSubID_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function doWLAB(hObject)
    handles = guidata(hObject);
    
    % Build opt structure
    if(get(handles.checkWindowed,'Value')), opt.bWindowed = true;
    else opt.bWindowed = false; end
    if(get(handles.checkSpeedy,'Value')), opt.bSpeedy = true;
    else opt.bSpeedy = false; end
    
    opt.nWinSize = eval(get(handles.editWinSize,'String'));
    opt.colClear = eval(get(handles.editColClear,'String'));
    opt.colText =  eval(get(handles.editColText,'String'));
    opt.subID = get(handles.editSubID,'String');
    opt.conExperiments = handles.experiments;
    opt.conExpNames = handles.expNames;
    
    wlab(opt);
