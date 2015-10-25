function varargout = EditSets(varargin)
% EDITSETS MATLAB code for EditSets.fig
%      EDITSETS, by itself, creates a new EDITSETS or raises the existing
%      singleton*.
%
%      H = EDITSETS returns the handle to a new EDITSETS or the handle to
%      the existing singleton*.
%
%      EDITSETS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITSETS.M with the given input arguments.
%
%      EDITSETS('Property','Value',...) creates a new EDITSETS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EditSets_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EditSets_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EditSets

% Last Modified by GUIDE v2.5 25-Oct-2015 10:42:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EditSets_OpeningFcn, ...
                   'gui_OutputFcn',  @EditSets_OutputFcn, ...
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


% --- Executes just before EditSets is made visible.
function EditSets_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EditSets (see VARARGIN)

% Choose default command line output for EditSets

%handles.uitableUniques = handles.columnsListBox;

%parentHandles = varargin{3}

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes EditSets wait for user response (see UIRESUME)
% uiwait(handles.EditSetsGui);


% --- Outputs from this function are returned to the command line.
function varargout = EditSets_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Choose default command line output for EditSets
handles.output = hObject;

% Get default command line output from handles structure
varargout{1} = handles.output;
%get the gui related to the table
 h = findobj('Tag','uitable2');
 % if exists (not empty)
 if ~isempty(h)
    % set g1data to the gui data
    g1data = guidata(h);
    %get the data from the original gui table
    raw = get(g1data.uitable2,'data');
    %Set column names from original
    set(handles.uitableUniques, 'ColumnName',...
        get(g1data.uitable2,'ColumnName'));
    %set an empty cell array the size of raw
    uniques = cell(size(raw));
    
    sz = size(raw);
    %secon index = numColumns
    colCount = sz(2);
    %for each column
    for n = 1:colCount
        %get the column in question
        rawX = raw(:,n);
        %if the column has a string at start
        rawXa = rawX(1);
        isstr = iscellstr(rawX(1));
        if(iscellstr(rawX(1)))
            %get the unique values
            tempUniques = unique(rawX);
            %for every unique value
            for m = 1:size(tempUniques)
                %change uniques array value
                uniques(m,n) = tempUniques(m);
            end
        else
            %if its not a string column
            str = 'numerical';
            uniques(1,n) = {str};
        end
    end
    set(handles.uitableUniques, 'data', uniques);
    
    %%setting up listboxColNames
    set(handles.listboxColNames,'string',...
        get(g1data.columnsListBox, 'string'),...
        'Value',1);
        %set the original value
    listboxColNames_Callback(handles.listboxColNames, eventdata, handles);
        
    %set(handles.text1,'String',get(g1data.edit1,'String'));
    % maybe you want to get some data that was saved to the Gui1 app
    %%x = getappdata(h,'raw')
 end


% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%globStruct.splitSet = get(handles.listboxSplitting, 'string')
close(handles.EditSetsGui);


% --- Executes on button press in addSet.
function addSet_Callback(hObject, eventdata, handles)
% hObject    handle to addSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in removeSet.
function removeSet_Callback(hObject, eventdata, handles)
% hObject    handle to removeSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listboxColNames.
function listboxColNames_Callback(hObject, eventdata, handles)
% hObject    handle to listboxColNames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxColNames contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxColNames
%get the contents of the colNames
contents = cellstr(get(hObject,'String'));
selected = get(hObject,'Value');
%get the gui related to the table
 h = findobj('Tag','uitable2');
 % if exists (not empty)
 if ~isempty(h)
    % set g1data to the gui data
    g1data = guidata(h);
    %get the data from the original gui table
    raw = g1data.subsets;
    raw{selected};
    set(handles.uitableSubsets,'data',raw{selected});
 end
%add a logical column
%push the selected column to 
%set(handles.uitableSubsets,'data',newList)

% --- Executes during object creation, after setting all properties.
function listboxColNames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxColNames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function uitableSubsets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitableSubsets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes when entered data in editable cell(s) in uitableSubsets.
function uitableSubsets_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitableSubsets (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
trueInd = eventdata.Indices - [0 1];
%subCategory = get(handles.uitableSubsets,'data');
%gets the value related to the checkbox
%subCategory = subCategory(trueInd(1))
%get the gui related to the table
 h = findobj('Tag','uitable2');
 % if exists (not empty)
 if ~isempty(h)
    % get copy of original gui data
    g1data = guidata(h);
        
    %find the selected orig guidata column
    selectedCol = get(handles.listboxColNames,'Value');
    
    %change subsets to edited subsets
    g1data.subsets{selectedCol} = get(handles.uitableSubsets,'data');
    
    %set edited copy as guidata
    guidata(h,g1data);
    %update handles
    guidata(hObject,handles);
 end

% --- Executes on button press in pushbuttonSplit.
function pushbuttonSplit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSplit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get information from selected column
contents = cellstr(get(handles.listboxColNames,'String'));
selectedVal = contents{get(handles.listboxColNames,'Value')};

%TODO: check to see if already added
%update listbox
oldstring = get(handles.listboxSplitting, 'string');
if strcmp(oldstring(1),'Listbox')
    newstring = selectedVal;
elseif isempty(oldstring)
    newstring = selectedVal;
elseif ~iscell(oldstring)
    newstring = {oldstring selectedVal};
else
    newstring = {oldstring{:} selectedVal};
end
set(handles.listboxSplitting, 'string', newstring);


% --- Executes on selection change in listboxSplitting.
function listboxSplitting_Callback(hObject, eventdata, handles)
% hObject    handle to listboxSplitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxSplitting contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxSplitting
%TODO: remove splitted

% --- Executes during object creation, after setting all properties.
function listboxSplitting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxSplitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes when selected cell(s) is changed in uitableCols.
function uitableCols_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitableCols (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitableCols.
function uitableCols_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitableSubsets (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
trueInd = eventdata.Indices - [0 1];
%subCategory = get(handles.uitableSubsets,'data');
%gets the value related to the checkbox
%subCategory = subCategory(trueInd(1))
%get the gui related to the table
 h = findobj('Tag','uitable2');
 % if exists (not empty)
 if ~isempty(h)
    % get copy of original gui data
    g1data = guidata(h);
        
    %find the selected orig guidata column
    selectedCol = get(handles.listboxColNames,'Value');
    
    %change subsets to edited subsets
    g1data.subsets{selectedCol} = get(handles.uitableSubsets,'data');
    
    %set edited copy as guidata
    guidata(h,g1data);
    %update handles
    guidata(hObject,handles);
 end


% --- Executes during object creation, after setting all properties.
function uitableCols_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitableCols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%{
contents = cellstr(get(hObject,'String'));
selected = get(hObject,'Value');
%get the gui related to the table
 h = findobj('Tag','uitable2');
 % if exists (not empty)
 if ~isempty(h)
    % set g1data to the gui data
    g1data = guidata(h);
    %get the data from the original gui table
    raw = g1data.subsets;
    raw{selected};
    set(handles.uitableSubsets,'data',raw{selected});
 end
%}
