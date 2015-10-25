function varargout = editSets2(varargin)
% EDITSETS2 MATLAB code for editSets2.fig
%      EDITSETS2, by itself, creates a new EDITSETS2 or raises the existing
%      singleton*.
%
%      H = EDITSETS2 returns the handle to a new EDITSETS2 or the handle to
%      the existing singleton*.
%
%      EDITSETS2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITSETS2.M with the given input arguments.
%
%      EDITSETS2('Property','Value',...) creates a new EDITSETS2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before editSets2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to editSets2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help editSets2

% Last Modified by GUIDE v2.5 25-Oct-2015 12:44:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @editSets2_OpeningFcn, ...
                   'gui_OutputFcn',  @editSets2_OutputFcn, ...
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


% --- Executes just before editSets2 is made visible.
function editSets2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to editSets2 (see VARARGIN)

% Choose default command line output for editSets2
handles.output = hObject;
pHandles = varargin{3}
handles.parent = pHandles
%set uitableCols
%set uitableCols
names = regexprep(get(pHandles.uitable2,'ColumnName'),'<.*?>','')
a = [names pHandles.runCols]

set(handles.uitableCols,'data',a)
set(handles.uitable2B,'data',get(pHandles.uitable2,'data'),...
    'columnName',get(pHandles.uitable2,'columnName'))


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes editSets2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = editSets2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj('Tag','uitable2');
 % if exists (not empty)
 if ~isempty(h)
    % set g1data to the gui data
    g1data = guidata(h);
    %get the data from the original gui table
    g1data.subsets = handles.parent.subsets
    g1data.runCols = handles.parent.runCols
    guidata(h,g1data)
    guidata(hObject,handles)
 end
 
close;

 
% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitableSubcats.
function uitableSubcats_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitableSubcats (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
a = handles.parent.subsets
a{handles.curRow} = get(handles.uitableSubcats,'data')
handles.parent.subsets = a
% Update handles structure
guidata(hObject, handles);

% --- Executes when entered data in editable cell(s) in uitableCols.
function uitableCols_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitableCols (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
handles.curRow = eventdata.Indices(1);
set(handles.uitableSubcats,'data',handles.parent.subsets{handles.curRow});
temp = get(handles.uitableCols,'data')
handles.parent.runCols = temp(:,2)
% Update handles structure
guidata(hObject, handles);



% --- Executes when selected cell(s) is changed in uitableCols.
function uitableCols_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitableCols (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.curRow = eventdata.Indices(1);
set(handles.uitableSubcats,'data',handles.parent.subsets{handles.curRow});
temp = get(handles.uitableCols,'data')
handles.parent.runCols = temp(:,2)
% Update handles structure
guidata(hObject, handles);
