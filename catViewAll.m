function varargout = catViewAll(varargin)
% CATVIEWALL MATLAB code for catViewAll.fig
%      CATVIEWALL, by itself, creates a new CATVIEWALL or raises the existing
%      singleton*.
%
%      H = CATVIEWALL returns the handle to a new CATVIEWALL or the handle to
%      the existing singleton*.
%
%      CATVIEWALL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CATVIEWALL.M with the given input arguments.
%
%      CATVIEWALL('Property','Value',...) creates a new CATVIEWALL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before catViewAll_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to catViewAll_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help catViewAll

% Last Modified by GUIDE v2.5 29-Oct-2015 17:38:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @catViewAll_OpeningFcn, ...
                   'gui_OutputFcn',  @catViewAll_OutputFcn, ...
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


% --- Executes just before catViewAll is made visible.
function catViewAll_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to catViewAll (see VARARGIN)

% Choose default command line output for catViewAll
handles.output = hObject;
%varargin 4 = lias
[newLias, indx] = sortrows(varargin{4});
sortedData = cell(size(varargin{5}));
sortedData = varargin{5}(indx,:);
set(handles.uitableSorted,'data',sortedData,'ColumnName',varargin{6});
im = imagesc(newLias);
set(im,'ButtonDownFcn',{@axes_ButtonDownFcnIm,handles});
colorbar;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes catViewAll wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function axes_ButtonDownFcnIm(hObject, eventdata, handles)
cursorPoint = get(handles.axesImg, 'CurrentPoint');
curX = cursorPoint(1,1);
curY = cursorPoint(1,2);
data = get(handles.uitableSorted,'data');
data = [num2str(floor(curY)) data(floor(curY),:)];
set(handles.uitable3,'data',data);
%{
xLimits = get(handles.axes1, 'xlim');
yLimits = get(handles.axes1, 'ylim');

if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
disp(['Cursor coordinates are (' num2str(curX) ', ' num2str(curY) ').']);
else
disp('Cursor is outside bounds of image.');
end
%}

% --- Outputs from this function are returned to the command line.
function varargout = catViewAll_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
