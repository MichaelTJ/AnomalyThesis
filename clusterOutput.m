function varargout = clusterOutput(varargin)
% CLUSTEROUTPUT MATLAB code for clusterOutput.fig
%      CLUSTEROUTPUT, by itself, creates a new CLUSTEROUTPUT or raises the existing
%      singleton*.
%
%      H = CLUSTEROUTPUT returns the handle to a new CLUSTEROUTPUT or the handle to
%      the existing singleton*.
%
%      CLUSTEROUTPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLUSTEROUTPUT.M with the given input arguments.
%
%      CLUSTEROUTPUT('Property','Value',...) creates a new CLUSTEROUTPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before clusterOutput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to clusterOutput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help clusterOutput

% Last Modified by GUIDE v2.5 15-Oct-2015 09:34:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @clusterOutput_OpeningFcn, ...
                   'gui_OutputFcn',  @clusterOutput_OutputFcn, ...
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


% --- Executes just before clusterOutput is made visible.
function clusterOutput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to clusterOutput (see VARARGIN)

% Choose default command line output for clusterOutput
handles.output = hObject;
setAxes(hObject,eventdata,handles,varargin{:})

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes clusterOutput wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function setAxes(hObject,eventdata,handles,varargin)
%varargin 4.. = data,clusters,counts, actualNumCols, actualCatCols

%get min, max and mean for each variable in each cluster
minClusters = zeros(size(varargin{1,5},1),size(varargin{1,7},2))
maxClusters = zeros(size(varargin{1,5},1),size(varargin{1,7},2))
meanClusters = zeros(size(varargin{1,5},1),size(varargin{1,7},2))

maxData = max(cell2mat(varargin{4}(:,varargin{7})))
minData = min(cell2mat(varargin{4}(:,varargin{7})))

%if minData(1,i) == maxData(1,i) then you'l get divide by zero problems
cartPoints = cell(size(varargin{1,5},1),size(varargin{1,7},2))
thetaS = zeros(size(varargin{1,5},1),size(varargin{1,7},2))
for j=1:size(thetaS,1)
    for i=1:size(thetaS,2)
        thetaS(j,i) = (2*pi/size(thetaS,2))*i+...
            ((2*pi/size(thetaS,2))/size(thetaS,1))*(j-1)...
            +pi/2;
    end
end
clusters = varargin{1,5};
%for every cluster
for i=1:size(varargin{1,5},1)
    %set the columns to mins of that cluster
    rows = clusters{i,1};
    combRows = varargin{1,4}(rows,varargin{7});
    %if there's only one row in the combRows then min and max fail
    if size(combRows,1)~=1
        minClusters(i,:) = (min(cell2mat(combRows))-minData(1,:))./...
            (maxData(1,:)-minData(1,:));
        maxClusters(i,:) = (max(cell2mat(combRows))-minData(1,:))./...
            (maxData(1,:)-minData(1,:));
        meanClusters(i,:) = (mean(cell2mat(combRows))-minData(1,:))./...
            (maxData(1,:)-minData(1,:));
    else
        minClusters(i,:) = (cell2mat(combRows)-minData(1,:))./...
            (maxData(1,:)-minData(1,:));
        maxClusters(i,:) = (cell2mat(combRows)-minData(1,:))./...
            (maxData(1,:)-minData(1,:));
        meanClusters(i,:) = (cell2mat(combRows)-minData(1,:))./...
            (maxData(1,:)-minData(1,:));
    end
    %cartPoints{i,:} = 
    [X,Y] = pol2cart(thetaS(i,:),maxClusters(i,:))
    for j=1:size(X,2)
        cartPoints{i,j} = [X(1,j),Y(1,j)]
    end
end
hold on
colors = get(0,'DefaultAxesColorOrder')
for i=1:size(cartPoints,1)
    X = []
    Y = []
    for j=1:size(cartPoints,2)
        X(end+1) = cartPoints{i,j}(1,1)
        Y(end+1) = cartPoints{i,j}(1,2)
    end
    h = compass(X,Y)
    nextColor = colors(mod(i-1,length(colors))+1,:)
    for j=1:length(h)
        
        if i==1
            set(h(j),'color',nextColor,'LineWidth',3)
            
        else
            set(h(j),'color',nextColor)
        end
    end
end
hold off
%divide the compass into equal sections
%create the directions for each of the arrows
%compass arrows
a=1

% --- Outputs from this function are returned to the command line.
function varargout = clusterOutput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in clusterListBox.
function clusterListBox_Callback(hObject, eventdata, handles)
% hObject    handle to clusterListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns clusterListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from clusterListBox


% --- Executes during object creation, after setting all properties.
function clusterListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clusterListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
