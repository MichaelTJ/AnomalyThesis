function varargout = untitled1(varargin)
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

<<<<<<< HEAD
% Last Modified by GUIDE v2.5 27-Apr-2015 14:01:30
=======
% Last Modified by GUIDE v2.5 05-May-2015 08:40:03
>>>>>>> 474b6ba36020c844b45698410ac232fa42c03855

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

% UIWAIT makes untitled1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
<<<<<<< HEAD
handles.fileName = uigetfile('*.xlsx')
[numbers, strings,raw] = xlsread(handles.fileName);
colNames = raw(1,:);

=======
handles.fileName = uigetfile('*.xlsx');
[numbers, strings,raw] = xlsread(handles.fileName);
colNames = raw(1,:);

hs = '<html><font size="4">'; %html start
he = '</font></html>'; %html end
cnh = cellfun(@(x)[hs x he],colNames,'uni',false); %with html
>>>>>>> 474b6ba36020c844b45698410ac232fa42c03855


%set values on the form page
set(handles.columnsListBox,'string',colNames);
<<<<<<< HEAD
set(handles.uitable2,'Data',raw(2:end,:),'ColumnName',colNames);
=======
set(handles.uitable2,'Data',raw(2:end,:),'ColumnName',cnh);
>>>>>>> 474b6ba36020c844b45698410ac232fa42c03855
set(handles.popupX,'string',colNames);
set(handles.popupY,'string',colNames,'value',2);

%make a plot
setAxesMain(handles)

<<<<<<< HEAD
=======
function fig = getParentFigure(fig)
% if the object is a figure or figure descendent, return the
% figure. Otherwise return [].
while ~isempty(fig) & ~strcmp('figure', get(fig,'type'))
  fig = get(fig,'parent');
end

>>>>>>> 474b6ba36020c844b45698410ac232fa42c03855
function setAxesMain(handles)
%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
%if categorical, bar chart
rawX = plotData(:,xColNum);
rawY = plotData(:,yColNum);
<<<<<<< HEAD
hold off
=======
>>>>>>> 474b6ba36020c844b45698410ac232fa42c03855
%if the same data is selected on both axes (x==y)
if xColNum == yColNum
    %if data is categorical             (x(Cat),y(Cat))
    if iscellstr(rawX(1))
        cats = categorical(rawX);
        hist(handles.axesMain,cats);
    else
        %if data is Numerical           (x(Num),y(Num))
        xPlot = cell2mat(rawX);         
        yPlot = ones(size(rawX));
        scatter(handles.axesMain,xPlot,yPlot);
    end 
%else if data is variable
<<<<<<< HEAD
=======
hold off
>>>>>>> 474b6ba36020c844b45698410ac232fa42c03855
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
            yCats = categorical(rawY);
            %can't plot against strings
            ordPlot = double(ordinal(rawY));
            gscatter(xPlot,yCats,ordPlot)
        else
            %if Xdata catagorical       (x(Num),y(Num))
            xPlot = cell2mat(rawX);
            yPlot = cell2mat(rawY);
            scatter(handles.axesMain,xPlot,yPlot);
        end
    end
end

<<<<<<< HEAD
=======

>>>>>>> 474b6ba36020c844b45698410ac232fa42c03855
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


% --- Executes on button press in graphButton.
function graphButton_Callback(hObject, eventdata, handles)
% hObject    handle to graphButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setAxesMain(handles)

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


% --- Executes on button press in FitLineButton.
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

%sampleRange = rawX(1):...
%    1:...
%    rawX(end);
%vq1 = spaps(rawX,rawY,150000);

<<<<<<< HEAD

coeffs = splinefit(rawX,rawY,1);
yy = ppval(coeffs,rawX);
errors = (yy-rawY).^2
hold on
plot(rawX,yy);
=======
%fit spline
coeffs = splinefit(rawX,rawY,1);
yy = ppval(coeffs,rawX);
hold on
plot(rawX,yy)
hold off
%calculate mean and standard deviation of errors
errors = (yy-rawY).^2;
meann = mean(errors);
stdd = std(errors);

%find values that have errors outside 3 standard deviations
I = bsxfun(@lt, meann + 2*stdd, errors) | bsxfun(@gt, meann - 2*stdd, errors);
hold on
for i = 1:length(I)
    if(I(i) ~= 0)
        rawX(i)
        rawY(i)
        %put a red circle through anoms
        plot(rawX(i),rawY(i),'ro');
        foundAnom(handles,xColNum,i,...
            abs((rawY(i)-meann)/stdd),[xColNum,yColNum])
    end
end
>>>>>>> 474b6ba36020c844b45698410ac232fa42c03855
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

<<<<<<< HEAD
[coeffs,x,y] = clickfit_OH('method','spline')
yy = ppval(coeffs,rawX)
errors = (yy-rawY).^2
=======
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
rawX = cell2mat(plotData(:,xColNum));
rawY = cell2mat(plotData(:,yColNum));

figure

histfit(rawY);


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
x
y
deviation
context
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
>>>>>>> 474b6ba36020c844b45698410ac232fa42c03855
