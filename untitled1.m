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


% Last Modified by GUIDE v2.5 25-Oct-2015 08:41:53


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
excelObj = actxserver('Excel.Application');
[handles.fileName,Folder] = uigetfile({'*.xlsx';'*.xls'});
fileObj = excelObj.Workbooks.Open(fullfile(Folder,handles.fileName));
sheetObj = excelObj.Worksheets.get('Item','Sheet1');
rowEnd = sheetObj.Range('A1').End('xlDown').Row;
colEnd = sheetObj.Range('A1').End('xlToRight').Column;
if(rowEnd > 65000)   
    %get data from file
    readRange = strcat('A1:',xlscol(colEnd));
    readRange = strcat(readRange,'65000'); %change this back to 1000
   [numbers, strings,raw] = xlsread(handles.fileName,readRange);

else
   [numbers, strings,raw] = xlsread(handles.fileName); 
end
Quit(excelObj);
delete(excelObj);
%Set column names to first row in file
colNames = raw(1,:);
%formatting so that column names are readable
hs = '<html><font size="4">'; %html start
he = '</font></html>'; %html end
cnh = cellfun(@(x)[hs x he],colNames,'uni',false); %with html

%set values on the form page
set(handles.columnsListBox,'string',colNames);
%for each column in raw data
for i=1:size(raw,2)
    if ~iscellstr(raw(2,i))
        if (sum(cell2mat(raw(2:end,i))==1)+sum(cell2mat(raw(2:end,i))==0))==...
                (size(raw,1)-1)
            %replace all the ones with 'true'
            replacement = cell(size(raw(2:end,1)))
            onesTemp = find(cell2mat(raw(2:end,i))==1)
            replacement(onesTemp,1) = {'true'}
            zerosTemp = find(cell2mat(raw(2:end,i))==0)
            replacement(zerosTemp,1) = {'false'}
            raw(2:end,i) = replacement(:,1)
            %isLogical
            clear onesTemp
            clear zerosTemp
            
        end
    end
end
        
%put all data in main table (uitable2)
set(handles.uitable2,'Data',raw(2:end,:),'ColumnName',cnh);

set(handles.popupX,'string',colNames);
set(handles.popupY,'string',colNames,'value',2);
set(handles.popup3X,'string',colNames);
set(handles.popup3Y,'string',colNames);
set(handles.popup3Z,'string',colNames);

%create subsets
handles.subsets = cell(size(colNames));

%set globals for passing data between guis
handles.subsets = setGlobals(hObject, colNames, raw(2:end,:), handles);

%create ignoreRowList
sizeData = size(raw(2:end,:));
handles.ignoreRowList = ones(sizeData(1),1);
handles.runRows = ones(sizeData(1),1);
handles.runCols = num2cell(logical(ones(sizeData(2),1)));



anomStruct = struct('rows',[],...
    'catSet',[],'catProp',[],'catMean',[],'catStd',[],...
    'numSet',[],'numProp',[],'numMean',[],'numStd',[],...
    'clusterNum',[],'clusters',{},'LOF',[],...
    'anomType',{});
handles.allAnoms = struct('cols',[],'Anom',[])



%make a plot
%setAxesMain(handles);
handles = setAxesMain2D(hObject,eventdata,handles);
guidata(hObject, handles)

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

handles.dimensionGroup = uitabgroup('Parent',handles.dimensionPanel,...
    'Position',[0 0 1 1]);
dTabs(1) = uitab('Parent',handles.dimensionGroup,'Title','2D');
dTabs(2) = uitab('Parent',handles.dimensionGroup,'Title','3D');
dTabs(3) = uitab('Parent',handles.dimensionGroup,'Title','4D');
dTabs(4) = uitab('Parent',handles.dimensionGroup,'Title','4+D');
dTabs(5) = uitab('Parent',handles.dimensionGroup,'Title','All');
guidata(hObject, handles);
%Set 2D panel to tab
set(handles.Interface2DPanel,'Parent',dTabs(1));
%Set 3D panel to tab
set(handles.Interface3DPanel,'Parent',dTabs(2));
%Set All panel to tab
set(handles.InterfaceAllDPanel,'Parent',dTabs(5));

handles.uiTabGroup = uitabgroup('Parent',handles.Interface2DPanel,...
    'Position',[0 0 1 1]);
%uiTabGroup.SelectionChangedFcn = @uiTabGroup_Callback;
hTabs(1) = uitab('Parent',handles.uiTabGroup,'Title','FitLine');
hTabs(2) = uitab('Parent',handles.uiTabGroup,'Title','FitDist');
hTabs(3) = uitab('Parent',handles.uiTabGroup,'Title','Closest');
hTabs(4) = uitab('Parent',handles.uiTabGroup,'Title','Cluster');
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

%set(handles.dimensionGroup,'SelectionChangeFcn',@DChanged);

guidata(hObject,handles);

function DChanged(hObject,eventdata)
index = get(hObject,'SelectedIndex');
childrens = get(hObject,'Children')
get(childrens(1))
get(childrens(2))
set(childrens(1),'Visible','off')
set(childrens(2),'Visible','off')
set(childrens(3),'Visible','off')
set(childrens(4),'Visible','off')
set(childrens(5),'Visible','off')
set(childrens(index),'Visible','on')
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

%{
% --------------------------------------------------------------------
function setAxesMain(handles)

%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
updateIgnoreRowList(handles);
%get all data
rawX = plotData(:,xColNum);
rawY = plotData(:,yColNum);

%delete rows that are on the ignore list
%    from bottom to top
%for every element in column
sizeRawX = size(rawX);
trueLength = sizeRawX(1);
for i=trueLength:-1:1
    %if the row is off
    if handles.ignoreRowList(i)==0
        rawX(i)= [];
        rawY(i)= [];
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
%}

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
handles = setAxesMain2D(hObject,eventdata,handles);
guidata(hObject, handles)

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
handles = setAxesMain2D(hObject,eventdata,handles);
guidata(hObject, handles)

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
handles = setAxesMain2D(hObject,eventdata,handles);
guidata(hObject, handles)
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

%rawX = cell2mat(plotData(:,get(handles.popupX,'Value')));

%rawY = cell2mat(plotData(:,get(handles.popupX,'Value')));

anomRows = ones(size(plotData(:,get(handles.popupX,'Value'))));

%get error std deviation and mean
[rows,xData,yData] = selectdata('axes',handles.axesMain);

%prepare to update Anom table
%set returned rows to 0
anomRows(rows) = 0;

cols = [get(handles.popupX,'Value') get(handles.popupY,'Value')]
anomStruct = struct('rows',find(anomRows)',...
    'catSet',[],'catProp',[],'catMean',[],'catStd',[],...
    'numSet',[],'numProp',[],'numMean',[],'numStd',[],...
    'clusterNum',1,'clusters',{{}},'LOF',{'Unknown'},...
    'anomType',{'cluster'});
if isempty(handles.allAnoms(1).cols)
    handles.allAnoms(end) = struct('cols',cols,'Anom',anomStruct)
else
    handles.allAnoms(end+1) = struct('cols',cols,'Anom',anomStruct)
end
allRows = {mat2str(find(anomRows)')};
allCols = cell(size(allRows));
allDevs = cell(size(allRows));
allAccept = cell(size(allRows));
allAccept = cell(size(allRows));
allContext = cell(size(allRows));
cols = mat2str(cols);

for i=1:size(allCols,1)
    allCols{i,1} = cols
    allDevs{i,1} = [0]
    allAccept{i,1} = [1]
    allIgnore{i,1} = [0]
    allContext{i,1} = 'cluster'
end
curAnomTable = get(handles.uitableAnomList,'data')
if isempty(curAnomTable{1,1})
    set(handles.uitableAnomList,...
        'data',[allRows,allCols,allDevs,allAccept,allIgnore,allContext])
else
    curAnomTable(end+1,:) = ...
        [allRows,allCols,allDevs,allAccept,allIgnore,allContext]
    set(handles.uitableAnomList,...
        'data',curAnomTable)
    
end
guidata(hObject,handles)
    
%{
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
%}

% --- Executes during object creation, after setting all properties.
function uitableAnomList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitableAnomList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hs = '<html><font size="4">'; %html start
he = '</font></html>'; %html end
cn = {'Row/s','Column/s','Deviation','Accept','Ignore','Context'}; %original
cnh = cellfun(@(x)[hs x he],cn,'uni',false); %with html

set(hObject,'ColumnName', cnh);

function foundAnom(handles, x, y, deviation, context)
% x         x column from data
% y         y column from data
% deviation array: usually standard deviations from model
% context   array: array of plotted variables [x, y, z] when anom was found
%NOTE: deviation matches context
foundAnoms = cell2mat(get(handles.uitableAnomList,'data'))
%x
%y
%deviation
%context
dataVector = [x,y,deviation,context]
if isempty(foundAnoms)
    foundAnoms = num2cell(dataVector)
    set(handles.uitableAnomList,'data',foundAnoms);
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
            set(handles.uitableAnomList,'data',num2cell(foundAnoms))
        end
    else
        %add a new row
        foundAnoms = num2cell([foundAnoms;[x,y,deviation,context]])
        set(handles.uitableAnomList,'data',foundAnoms);
        
    end
end

% --- Executes on button press in AnomContextButton.
function AnomContextButton_Callback(hObject, eventdata, handles)
% hObject    handle to AnomContextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AnomTable = get(handles.uitableAnomList,'data');

% --- Executes on button press in AnomDeleteButton.
function AnomDeleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to AnomDeleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.uitableAnomList,'data')
rows = get(handles.uitableAnomList,'UserData')
mask = (1:size(data,1));
mask(rows) = [];
data = data(mask,:);
set(handles.uitableAnomList,'data',data);

% --- Executes when selected cell(s) is changed in uitableAnomList.
function uitableAnomList_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitableAnomList (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% get indices of selected rows and make them available for other callbacks
index = eventdata.Indices;
if any(index)             %loop necessary to surpress unimportant errors.
    rows = index(:,1)
    %getting anomaly data
    set(hObject,'UserData',rows);
    temp = [handles.allAnoms.Anom];
    temp = temp(rows)
    cols = {handles.allAnoms.cols}
    cols = fliplr(cols{rows(1)})
    set(handles.uitableAnomData,'data',...
        {temp.catSet,temp.catProp,temp.clusterNum,0}) 
    %getting real data
    data = get(handles.uitable2,'data')

    data = data(:,cols)

    catCols = [];
    numCols = [];
    numColsIndx = [];
    catColsIndx = [];
    %split the columns into numerical and categorical arrays
    for i=1:size(data,2)
        if iscellstr(data(1,i))
            catCols = [catCols data(:,i)];
            catColsIndx = [catColsIndx i];
        else
            numCols = [numCols data(:,i)];
            numColsIndx = [numColsIndx i];
        end
    end
    
    if isempty(catCols)
       catCols = cell(size(data,1),1);
       catCols(:) = {'No category'};
    end
    
    %Combine Cat Cols
    combCats = cell(size(catCols,1),1);
    
    parfor i=1:size(data,1)
        combCats{i} = strjoin(catCols(i,:));
    end
    
    setAxesAnomND(hObject, eventdata, handles,numCols,combCats,temp.rows)

end

%juiTable = findjobj(handles.uitableAnomList,'class','UIScrollPane');
%jtable = juiTable(1).getComponent(0).getComponent(0);
%jtable.setNonContiguousCellSelection(false);
%jtable.setColumnSelectionAllowed(false);
%jtable.setRowSelectionAllowed(true);

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
editSets2(hObject,eventdata,handles)
%EditSets(hObject, eventdata, handles)

% --- Executes on button press in EditSetX.
function EditSetX_Callback(hObject, eventdata, handles)
% hObject    handle to EditSetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Gsubsets = setGlobals(hObject, colNames, raw, handles)

%set colCount to the second index of size raw
sz = size(raw);
colCount = sz(2);

%set an empty cell array the size of raw
uniques = cell(size(raw));

%for each column
for n=1:colCount
    %get the column in question
    rawX = raw(:,n);
    %if the column has a string at start
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
    handles.subsets{n} = newList;
end
%output value
Gsubsets = handles.subsets;



% --- Executes on selection change in popup3X.
function popup3X_Callback(hObject, eventdata, handles)
% hObject    handle to popup3X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup3X contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup3X
handles = setAxesMain3D(hObject,eventdata,handles);
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function popup3X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup3X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup3Y.
function popup3Y_Callback(hObject, eventdata, handles)
% hObject    handle to popup3Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup3Y contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup3Y
handles = setAxesMain3D(hObject,eventdata,handles);
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function popup3Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup3Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup3Z.
function popup3Z_Callback(hObject, eventdata, handles)
% hObject    handle to popup3Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup3Z contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup3Z
handles = setAxesMain3D(hObject,eventdata,handles);
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function popup3Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup3Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveAnalysisBut.
function saveAnalysisBut_Callback(hObject, eventdata, handles)
% hObject    handle to saveAnalysisBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%asdfsadf


% --- Executes on button press in runAllButton.
function runAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to runAllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = runAll(hObject,eventdata,handles)
guidata(hObject, handles);



function deviationEdit_Callback(hObject, eventdata, handles)
% hObject    handle to deviationEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deviationEdit as text
%        str2double(get(hObject,'String')) returns contents of deviationEdit as a double


% --- Executes during object creation, after setting all properties.
function deviationEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deviationEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in conePlotButton.
function conePlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to conePlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = setAxesMain3D(hObject,eventdata,handles);
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function uitableAnomData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitableAnomData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

hs = '<html><font size="4">'; %html start
he = '</font></html>'; %html end
cn = {'Combined Categories','Category percentage','Cluster No.','Clusters'}; %original
cnh = cellfun(@(x)[hs x he],cn,'uni',false); %with html

set(hObject,'ColumnName', cnh);


% --- Executes on button press in viewAllButton.
function viewAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewAllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure()

%getting real data
data = get(handles.uitable2,'data');
%getting real data
handles = updateIgnoreRowList(hObject,eventdata,handles);
handles.dataColsList = [1:size(data,2)]
data = data(:,cell2mat(handles.runCols))
handles.dataColsList = handles.dataColsList(:,cell2mat(handles.runCols))
catCols = [];
numCols = [];
numColsIndx = [];
catColsIndx = [];
%split the columns into numerical and categorical arrays
for i=1:size(data,2)
    if iscellstr(data(1,i))
        catCols = [catCols data(:,i)];
        catColsIndx = [catColsIndx i];
    else
        numCols = [numCols data(:,i)];
        numColsIndx = [numColsIndx i];
    end
end

handles.dataColsList = handles.dataColsList(numColsIndx)
if isempty(catCols)
   catCols = cell(size(data,1),1);
   catCols(:) = {'No category'};
end

%Combine Cat Cols
combCats = cell(size(catCols,1),1);

parfor i=1:size(data,1)
    combCats{i} = strjoin(catCols(i,:));
end
figure()

guidata(hObject,handles);
%gplotmatrix(x,y,group,clr,sym,siz,doleg,dispopt,xnam,ynam)
names = regexprep(get(handles.uitable2,'ColumnName'),'<.*?>','')
names = names(cell2mat(handles.runCols))
numNames = names(numColsIndx);
colNames = names(catColsIndx);
if ~isempty(numNames)
    [h, ax, bigax] = gplotmatrix(cell2mat(numCols),[],combCats,...
        [],'o',[],'on','',numNames,numNames)
    %.o+*xsd^v><ph
    

    %{
    h is an array of handles to the lines on the graphs. 
    The array's third dimension corresponds to groups in the input 
    argument group. 
    ax is a matrix of handles to the axes of the 
    individual plots. 
    If dispopt is 'hist', 'stairs', or 'grpbars', 
    ax contains one extra row of handles to invisible axes in which
    the histograms are plotted. 
    bigax is a handle to big (invisible) axes framing the entire plot matrix.
    bigax is fixed to point to the current axes, so a subsequent title, 
    xlabel, or ylabel command will produce labels that are centered 
    with respect to the entire plot matrix.
    %}
    for i=1:size(ax,1)
        for j=1:size(ax,2)
            set(ax(i,j),'ButtonDownFcn',{@axes_ButtonDownFcn,handles,...
                [i,j],numCols,combCats})
        end
    end
end
%need a cell array, each cell holding a matrix containing
%the count of each unique element for each variable
uniqCounts = cell(1,size(catCols,2))
uniqLias = zeros(size(catCols))
colorMapGrid = zeros(size(catCols))
curMax = 0;
for i=1:size(catCols,2)
    [uniqs, ~, uniqLias(:,i)] = unique(catCols(:,i));
    %uniqCounts for this column = empty array
    uniqCounts{1,i} = [];
    for j=1:size(uniqs,1)
        uniqCounts{1,i} = [uniqCounts{1,i} sum(uniqLias(:,i) == j)];
    end
    
    if size(uniqs,1)>curMax
        curMax = size(uniqs,1);
    end
end

%for every group of uniqs
for i=1:size(uniqCounts,2)
    %sort it
    [b,index] = sort(uniqCounts{1,i},'descend');
    b = cumsum(b);
    %add 1 at the start, remove last element
    b = [1 b(1:end-1)];
    b(index) = b;
    b = curMax -b
    for j=1:size(uniqCounts{1,i},2)
        a = find(uniqLias(:,i)==j);
        uniqLias(a,i) = b(j);
    end
    
    
end

catViewAll(hObject,eventdata,handles,uniqLias,catCols,...
    colNames)


%check variable names for bad chars
A = isstrprop(colNames,'alphanum')
for k=1:numel(A)
    %if a value is not alpha numeric, set it to space
    colNames{k}(find(A{k} == 0)) = '_'
    if length(colNames{k}) > namelengthmax
        colNames{k} = colNames{k}(1:namelengthmax)
    end
end

%highest number = curMax


%
%need to split the uniqCounts Columns into 


%tableData = cell2table(catCols,'VariableNames',colNames)

     %{   
h
ax
bigax
%}

function axes_ButtonDownFcn(hObject, eventdata, handles,...
    loc, numCols,combCats)
%set axesMain to hObject
loc
handles.dataLoc = loc;
guidata(hObject,handles)
axes(handles.axesMain)
set(handles.popupX,'Value',handles.dataColsList(loc(1)))
set(handles.popupY,'Value',handles.dataColsList(loc(2)))
%set axes Main to numeric rows and cols
%handles.dataLoc = loc;
scatter(cell2mat(numCols(:,loc(1))),cell2mat(numCols(:,loc(2))),[],...
    categorical(combCats))
guidata(hObject,handles)



% --- Executes on button press in selectSetsButton.
function selectSetsButton_Callback(hObject, eventdata, handles)
% hObject    handle to selectSetsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
editSets2(hObject,eventdata,handles)


function handles = updateIgnoreRowList(hObject,eventdata,handles)
%get subset list
sizeUniques = size(handles.subsets);
%get data
data = get(handles.uitable2,'Data');
%get size of data
sizeData = size(data);
%make a ones table same size as main data
handles.ignoreRowList = ones(sizeData(1),1)
%for each column
for i=1:sizeUniques(2)
    %get the related set
    uniqSet = handles.subsets(1,i);
    actUniqSet = [uniqSet{:}];
    sizeActUniqSet = size(actUniqSet);
    %for each uniq subset in column
    for j=1:sizeActUniqSet(1)
        %if off on/off value
        if(actUniqSet{j,2}==0)
            a = cell(actUniqSet);
            %for every value in the column
            for k=1:sizeData(1)
                %if the value matches the subset
                if strcmp(data(k,i),a(j,1))
                    %set the ignore row value to off
                    handles.ignoreRowList(k) = 0;
                end
            end
        end
    end
end