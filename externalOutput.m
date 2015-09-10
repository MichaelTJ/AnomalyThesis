function varargout = externalOutput(varargin)
% EXTERNALOUTPUT MATLAB code for externalOutput.fig
%      EXTERNALOUTPUT, by itself, creates a new EXTERNALOUTPUT or raises the existing
%      singleton*.
%
%      H = EXTERNALOUTPUT returns the handle to a new EXTERNALOUTPUT or the handle to
%      the existing singleton*.
%
%      EXTERNALOUTPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXTERNALOUTPUT.M with the given input arguments.
%
%      EXTERNALOUTPUT('Property','Value',...) creates a new EXTERNALOUTPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before externalOutput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to externalOutput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help externalOutput

% Last Modified by GUIDE v2.5 10-Sep-2015 13:08:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @externalOutput_OpeningFcn, ...
                   'gui_OutputFcn',  @externalOutput_OutputFcn, ...
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


% --- Executes just before externalOutput is made visible.
function externalOutput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to externalOutput (see VARARGIN)

% Choose default command line output for externalOutput
handles.output = hObject;
setAxes(hObject,eventdata,handles,varargin{:})
% Check arguments
data = varargin{4};
msg = varargin{5};
%{
%get the plot from main gui
h = findobj('Tag','uitable2')
% set g1data to the gui data
g1data = guidata(h);
%get temp plot from g1data
handles.axesOut = g1data.extOutAxes)
%}

set(handles.uitableAnoms,'Data',data)
set(handles.textAnomDescripts,'String',msg)
set(gcf, 'CurrentAxes', [])
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes externalOutput wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = externalOutput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function setAxes(hObject,eventdata,handles,varargin)
%get plottype string
plotType = varargin{6}
if strcmp(plotType,'hist1')
    %assume varargin(7) is categorical
    %set axesOut to histogram
    hist(handles.axesOut,varargin{7})
elseif strcmp(plotType,'catCat')
    %assume v(7) and v(8) are rawdata
    %assume v(9),v(10) are respective colNames
    
    %trying to get matrix (x,y,count)
    %combined = varargin{7}.*varargin{8};
    %combOrd = ordinal(combined)
    
    %
    [order,index,iX] = unique(varargin{7})
    [order,index,iY] = unique(varargin{8})
    h = scatter(iX,iY,varargin{11})
    
    
    ordX = ordinal(varargin{7});
    ordY = ordinal(varargin{8});
    
    %have to convert to numbers to plot
    ordPlotX = double(ordX);
    ordPlotY = double(ordY);
    
    %plot
    
    %x,y labels
    xlabel(varargin{9});
    ylabel(varargin{10});
    %x,y ticks
    xLabels = getlabels(ordX);
    yLabels = getlabels(ordY);
    
    set(gca,'XTick',1:1:size(xLabels,2));
    set(gca,'YTick',1:1:size(yLabels,2));
    
    set(gca,'XTickLabel',xLabels);
    set(gca,'YTickLabel',yLabels);
elseif strcmp(plotType,'catNum')
    boxplot(handles.axesOut,varargin{8},categorical(varargin{7}))
    %x,y labels
    xlabel(varargin{9});
    ylabel(varargin{10});
elseif strcmp(plotType,'numNum')
    scatter(handles.axesOut,cell2mat(varargin{7}),cell2mat(varargin{8}))
    xlabel(varargin{9});
    ylabel(varargin{10});
end

        


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles
close(handles.output);


% --- Executes on button press in rejectButton.
function rejectButton_Callback(hObject, eventdata, handles)
% hObject    handle to rejectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.output);
