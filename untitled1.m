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

% Last Modified by GUIDE v2.5 27-Apr-2015 14:01:30

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
handles.fileName = uigetfile('*.xlsx')
[numbers, strings,raw] = xlsread(handles.fileName);
colNames = raw(1,:);



%set values on the form page
set(handles.columnsListBox,'string',colNames);
set(handles.uitable2,'Data',raw(2:end,:),'ColumnName',colNames);
set(handles.popupX,'string',colNames);
set(handles.popupY,'string',colNames,'value',2);

%make a plot
setAxesMain(handles)

function setAxesMain(handles)
%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
%if categorical, bar chart
rawX = plotData(:,xColNum);
rawY = plotData(:,yColNum);
hold off
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


coeffs = splinefit(rawX,rawY,1);
yy = ppval(coeffs,rawX);
errors = (yy-rawY).^2
hold on
plot(rawX,yy);
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

[coeffs,x,y] = clickfit_OH('method','spline')
yy = ppval(coeffs,rawX)
errors = (yy-rawY).^2
