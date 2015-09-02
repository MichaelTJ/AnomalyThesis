function varargout = AnomDet(varargin)
% UNTITLED1 MATLAB code for untitled1.fig
%      UNTITLED1, by itself, creates a new UNTITLED1 or raises the existing
%      singleton*.
%
%      H = UNTITLED1 returns the handle to a new UNTITLED1 or the handle to
%      the existing singleton*.
%
%      UNTITLED1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED1.M with the given input arguments.
%
%      UNTITLED1('Property','Value',...) creates a new UNTITLED1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled1


% Last Modified by GUIDE v2.5 20-Aug-2015 11:31:51


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled1_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled1_OutputFcn, ...
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

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%look for files with extensions
handles.fileName = uigetfile({'*.xlsx';'*.xls'});
%get data from file
[numbers, strings,raw] = xlsread(handles.fileName);
%Set column names to first row in file
colNames = raw(1,:);
%formatting so that column names are readable
hs = '<html><font size="4">'; %html start
he = '</font></html>'; %html end
cnh = cellfun(@(x)[hs x he],colNames,'uni',false); %with html

%set values on the form page
set(handles.columnsListBox,'string',colNames);

%put all data in main table (uitable2)
set(handles.uitable2,'Data',raw(2:end,:),'ColumnName',cnh);
set(handles.popupX,'string',colNames);
set(handles.popupY,'string',colNames,'value',2);

%create subsets
handles.subsets = cell(size(colNames));

%set globals for passing data between guis
handles.subsets = setGlobals(hObject, colNames, raw(2:end,:), handles);
%create ignoreRowList
sizeMain = size(get(handles.uitable2,'Data'))
%make a ones table same size as main data
handles.ignoreRowList = ones(sizeMain(1),1)
%update the ignore list
updateIgnoreRowList(handles)
guidata(hObject,handles)
%make a plot
setAxesMain(handles)

% --- Executes just before untitled1 is made visible.
function untitled1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled1 (see VARARGIN)

% Choose default command line output for untitled1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

handles.uiTabGroup = uitabgroup('Parent',handles.InterfacePanel,...
    'Position',[0 0 1 1]);
%uiTabGroup.SelectionChangedFcn = @uiTabGroup_Callback;
hTabs(1) = uitab('Parent',handles.uiTabGroup,'Title','FitLine');
hTabs(2) = uitab('Parent',handles.uiTabGroup,'Title','FitDist');
hTabs(3) = uitab('Parent',handles.uiTabGroup,'Title','Closest');
hTabs(4) = uitab('Parent',handles.uiTabGroup,'Title','Cluster');
guidata(hObject,handles);
set(handles.axesMain, 'Parent', gcf)
set(handles.uiTabGroup, 'SelectedTab', hTabs(1));

%FitLine tab
set(handles.FitLineButton,'Parent',hTabs(1));
set(handles.ManualFit,'Parent',hTabs(1));

%FitDist tab
set(handles.FitDistButton,'Parent',hTabs(2));

%Closest tab
set(handles.closestButton,'Parent',hTabs(3));

%Cluster tab
set(handles.TagDataButton,'Parent',hTabs(4));

% --- Outputs from this function are returned to the command line.
function varargout = untitled1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function fig = getParentFigure(fig)
% if the object is a figure or figure descendent, return the
% figure. Otherwise return [].
while ~isempty(fig) & ~strcmp('figure', get(fig,'type'))
  fig = get(fig,'parent');
end

% --------------------------------------------------------------------
function setAxesMain(handles,uiTabGroup)
%set(handles.axesMain, 'Parent', get(handles.uiTabGroup,'SelectedTab'));
%set(handles.axesMain,'Parent',
%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
handles.subsets{4}
updateIgnoreRowList(handles)
%get all data
rawX = plotData(:,xColNum);
rawY = plotData(:,yColNum);

%delete rows that are on the ignore list
%for every element in column
sizeRawX = size(rawX);
trueLength = sizeRawX(1)
for i=trueLength:-1:1
    trueLength
    %if the row is off
    if handles.ignoreRowList(i)==0
        rawX(i)= []
        rawY(i)= []
    end
end


hold off
%if the same data is selected on both axes (x==y)
if xColNum == yColNum
    %if first element in col is string -> categorical             (x(Cat),y(Cat))
    if iscellstr(rawX(1))
        cats = categorical(rawX);
        hist(handles.axesMain,cats);
    else
        %if data is Numerical           (x(Num),y(Num))
        xPlot = cell2mat(rawX);         
        %yPlot = ones(size(rawX));
        hist(handles.axesMain,xPlot);
    end 
%else if data is variable

hold off
else
    %Data sets are different (x!=y)
    if iscellstr(rawX(1))
        if iscellstr(rawY(1))
            %Both sets are cateforical  (x(Cat),y(Cat))
            
        else
            %if Xdata catagorical       (x(Cat),y(Num))
            yPlot = cell2mat(rawY);
            xCats = categorical(rawX);
            %can't plot against strings
            ordPlot = double(ordinal(rawX));
            gscatter(ordPlot,yPlot,xCats)
            %plotSpread(handles.axesMain,xPlot,yPlot)
        end
    else
        if iscellstr(rawY(1))
            %xNumeric yCategoric        (x(Num),y(Cat))
            xPlot = cell2mat(rawX);
            %gets by categorical
            yCats = categorical(rawY);
            [yCatUniques, ia, ic] = unique(yCats);
            
            %can't plot against strings
            %gives strings a number for each unique value
            ordPlot = double(ordinal(rawY));
            gscatter(xPlot,yCats,ic)
            
            legend(char(yCatUniques));
            
        else
            %if Xdata catagorical       (x(Num),y(Num))
            xPlot = cell2mat(rawX);
            yPlot = cell2mat(rawY);
            scatter(handles.axesMain,xPlot,yPlot);
        end
    end
end

% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg('Close program?',...
    'Close request function',...
    'Yes','No','Yes');
switch selection,
    case 'Yes',
        delete(gcf)
    case 'No'
        return
end

% --- Executes on selection change in columnsListBox.
function columnsListBox_Callback(hObject, eventdata, handles)
% hObject    handle to columnsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns columnsListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from columnsListBox


% --- Executes during object creation, after setting all properties.
function columnsListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to columnsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupY.
function popupY_Callback(hObject, eventdata, handles)
% hObject    handle to popupY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupY
setAxesMain(handles)

% --- Executes during object creation, after setting all properties.
function popupY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupX.
function popupX_Callback(hObject, eventdata, handles)
% hObject    handle to popupX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupX
setAxesMain(handles)

% --- Executes during object creation, after setting all properties.
function popupX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function FitLineButton_Callback(hObject, eventdata, handles)
% hObject    handle to FitLineButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
%if categorical, bar chart
rawX = cell2mat(plotData(:,xColNum));
rawY = cell2mat(plotData(:,yColNum));
t = ~isnan(rawX) & ~isnan(rawY);
[curves gofs] = allfitlines(rawX(t),rawY(t));
setAxesMain(handles);
hold on;
for i=1:length(curves)
    if i<= 3
        a = plot(curves{i});
        set(a,'Tag',type(curves{i}));
    else
        a = plot(curves{i});
        set(a,'Visible','off');
        set(a,'Tag',type(curves{i}));
    end
    
end
legend('hide')
update_methodTable(curves,eventdata,handles)
hold off;

function update_methodTable(listItems,eventdata,handles)
newList = cell(2,length(listItems));
for indx1=1:length(listItems)
    newList{indx1,1} = type(listItems{indx1});
    if indx1<=3
        newList{indx1,2} = true;
    else
        newList{indx1,2} = false;
    end
end
set(handles.methodTable,'data',newList)

% --- Executes on button press in FitLineButton.
function FitLineButton_Callback2(hObject, eventdata, handles)
% hObject    handle to FitLineButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
%if categorical, bar chart
rawX = cell2mat(plotData(:,xColNum));
rawY = cell2mat(plotData(:,yColNum));

coeffs = splinefit(rawX,rawY,1);
yy = ppval(coeffs,rawX);
errors = (yy-rawY).^2;
hold on
plot(rawX,yy);
hold off
%calculate mean and standard deviation of errors

meann = mean(errors);
stdd = std(errors);

%find values that have errors outside 3 standard deviations
I = bsxfun(@lt, meann + 2*stdd, errors) | bsxfun(@gt, meann - 2*stdd, errors);
hold on
for i = 1:length(I)
    if(I(i) ~= 0)
        %put a red circle through anoms
        plot(rawX(i),rawY(i),'ro');
        foundAnom(handles,xColNum,i,...
            abs((rawY(i)-meann)/stdd),[xColNum,yColNum])
    end
end
hold off

%[coeffs,x,y] = clickfit_OH('method','spline')
%yy = ppval(coeffs,rawX)
%errors = (yy-rawY).^2


% --- Executes on button press in ManualFit.
function ManualFit_Callback(hObject, eventdata, handles)
% hObject    handle to ManualFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
%if categorical, bar chart
rawX = cell2mat(plotData(:,xColNum));
rawY = cell2mat(plotData(:,yColNum));

[coeffs,x,y] = clickfit_OH('method','spline');
yy = ppval(coeffs,rawX);
errors = (yy-rawY).^2;
meann = mean(errors);
stdd = std(errors);
I = bsxfun(@lt, meann + 2*stdd, errors) | bsxfun(@gt, meann - 2*stdd, errors);
hold on
for i = 1:length(I)
    if(I(i) ~= 0)
        
        %put a red circle through anoms
        plot(rawX(i),rawY(i),'ro');
        foundAnom(handles,xColNum,i,...
            abs((rawY(i)-meann)/stdd),[xColNum,yColNum])
    end
end
hold off

% --- Executes on button press in FitDistButton.
function FitDistButton_Callback(hObject, eventdata, handles)
% hObject    handle to FitDistButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
%if categorical, bar chart
%rawX = cell2mat(plotData(:,xColNum));
rawY = cell2mat(plotData(:,yColNum));

allfitdist(rawY,'PDF');

% --- Executes on button press in TagDataButton.
function TagDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to TagDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');

rawX = cell2mat(plotData(:,xColNum));
rawY = cell2mat(plotData(:,yColNum));
   


%get error std deviation and mean
[points,xData,yData] = selectdata('axes',handles.axesMain);

if iscell(yData)
    meann = mean(cell2mat(yData))
    stdd = std(cell2mat(yData)) 
else
    meann = mean(yData)
    stdd = std(yData) 
end

%Get error data that's 3std deviations away from mean. (Anoms)
I = bsxfun(@lt, meann + 3*stdd, rawY) | bsxfun(@gt, meann - 3*stdd, rawY);

hold on
for i = 1:length(I)
    if(I(i) ~= 0)
        
        %put a red circle through anoms
        plot(rawX(i),rawY(i),'ro');
        foundAnom(handles,xColNum,i,...
            abs((rawY(i)-meann)/stdd),[xColNum,yColNum])
    end
end
hold off

% --- Executes during object creation, after setting all properties.
function AnomTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnomTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hs = '<html><font size="4">'; %html start
he = '</font></html>'; %html end
cn = {'Variable','Sample No.','Deviation'}; %original
cnh = cellfun(@(x)[hs x he],cn,'uni',false); %with html

set(hObject,'ColumnName', cnh);

function foundAnom(handles, x, y, deviation, context)
% x         x column from data
% y         y column from data
% deviation array: usually standard deviations from model
% context   array: array of plotted variables [x, y, z] when anom was found
%NOTE: deviation matches context
foundAnoms = cell2mat(get(handles.AnomTable,'data'))
%x
%y
%deviation
%context
dataVector = [x,y,deviation,context]
if isempty(foundAnoms)
    foundAnoms = num2cell(dataVector)
    set(handles.AnomTable,'data',foundAnoms);
else
    %matching anoms 
    foundAnoms(:,1)
    foundAnoms(:,2)
    matchesI = find(foundAnoms(:,1) == x & foundAnoms(:,2) == y)
    
    %if it does match
    if any(matchesI)
        valueMatch = foundAnoms(matchesI,:)
        %if the new deviation is bigger
        if valueMatch(3)<deviation
            %replace the anom
            foundAnoms(matchesI) = [x,y,deviation,context]
            set(handles.AnomTable,'data',num2cell(foundAnoms))
        end
    else
        %add a new row
        foundAnoms = num2cell([foundAnoms;[x,y,deviation,context]])
        set(handles.AnomTable,'data',foundAnoms);
        
    end
end

% --- Executes on button press in AnomContextButton.
function AnomContextButton_Callback(hObject, eventdata, handles)
% hObject    handle to AnomContextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AnomTable = get(handles.AnomTable,'data');

% --- Executes on button press in AnomDeleteButton.
function AnomDeleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to AnomDeleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.AnomTable,'data')
rows = get(handles.AnomTable,'UserData')
mask = (1:size(data,1));
mask(rows) = [];
data = data(mask,:);
set(handles.AnomTable,'data',data);

% --- Executes when selected cell(s) is changed in AnomTable.
function AnomTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to AnomTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% get indices of selected rows and make them available for other callbacks
index = eventdata.Indices;
if any(index)             %loop necessary to surpress unimportant errors.
    rows = index(:,1);
    set(hObject,'UserData',rows);
end
juiTable = findjobj(handles.AnomTable,'class','UIScrollPane');
jtable = juiTable(1).getComponent(0).getComponent(0);
jtable.setNonContiguousCellSelection(false);
jtable.setColumnSelectionAllowed(false);
jtable.setRowSelectionAllowed(true);

% --- Executes on button press in closestButton.
function closestButton_Callback(hObject, eventdata, handles)
% hObject    handle to closestButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in methodsListBox.
function methodsListBox_Callback(hObject, eventdata, handles)
% hObject    handle to methodsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns methodsListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from methodsListBox

% --- Executes during object creation, after setting all properties.
function methodsListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methodsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in errorPopupMenu.
function errorPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to errorPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns errorPopupMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from errorPopupMenu

% --- Executes during object creation, after setting all properties.
function errorPopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when entered data in editable cell(s) in methodTable.
function methodTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to methodTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
eventdata.Indices
trueInd = eventdata.Indices - [0 1]
lineType = get(handles.methodTable,'data')
lineType = lineType(trueInd(1))
%methodTypes = get(findobj(handles.axesMain,'Type','line'),'Tag')
method = findobj(handles.axesMain,'Type','line','Tag',lineType{1})
if eventdata.NewData == 1
    set(method,'Visible','on')
else
    set(method,'Visible','off')
end
%get(gca,'Children','Type','line')



% --- Executes on button press in editSetsY.
function editSetsY_Callback(hObject, eventdata, handles) 
% hObject    handle to editSetsY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%empty set for incoming subset

EditSets(hObject, eventdata, handles)

% --- Executes on button press in EditSetX.
function EditSetX_Callback(hObject, eventdata, handles)
% hObject    handle to EditSetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Gsubsets = setGlobals(hObject, colNames, raw, handles)

%set colCount to the second index of size raw
sz = size(raw)
colCount = sz(2)

%set an empty cell array the size of raw
uniques = cell(size(raw));

%for each column
for n=1:colCount
    %get the column in question
    rawX = raw(:,n)
    %if the column has a string at start
    if(iscellstr(rawX(1)))
        %get the unique values
        tempUniques = unique(rawX)
        %for every unique value
        for m = 1:size(tempUniques)
            %change uniques array value
            uniques(m,n) = tempUniques(m)
        end
    else
        %if its not a string column
        str = 'numerical';
        uniques(1,n) = {str};
    end
end

%now have mostly empty list (uniques) with unique strings or 'numerical'
%create empty cell array for global
%for each column

for n=1:colCount
    a = uniques(:,n);
    %clear empties
    a = a(~cellfun('isempty',a));
    %create emptyies with logical column
    newList = cell(length(a),2);
    %for each element in unique column
    for indx=1:length(a)
        %set the first value to the unique string 
        newList{indx,1} = a{indx};
        %set the second val to logical true
        newList{indx,2} = true;
    end
    %add the uniques+logical cell to global
    handles.subsets{n} = newList
end
Gsubsets = handles.subsets

function updateIgnoreRowList(handles)
%get subset list
sizeUniques = size(handles.subsets)
data = get(handles.uitable2,'Data')
%get length of data
sizeData = size(data)
%for each column
for i=1:sizeUniques(2)
    %get the related set
    uniqSet = handles.subsets(1,i)
    actUniqSet = [uniqSet{:}]
    sizeActUniqSet = size(actUniqSet)
    %for each uniq subset in column
    for j=1:sizeActUniqSet(1)
        %if off on/off value
        if(actUniqSet{j,2}==0)
            a = cell(actUniqSet)
            %for every value in the column
            sizeData(1)
            for k=1:sizeData(1)
                %if the value matches the subset
                data(k,i)
                a(j,1)
                if strcmp(data(k,i),a(j,1))
                    %set the ignore row value to off
                    handles.ignoreRowList(k) = 0;
                end
            end
        end
    end
end
h = findobj('Tag','uitable2');
guidata(h,handles);
            
