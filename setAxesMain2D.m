function handles = setAxesMain2D(hObject, eventdata, handles)
%SETAXESMAIN2D Summary of this function goes here
%   Detailed explanation goes here



%get wanted data from x and y labels
xColNum = get(handles.popupX,'value');
yColNum = get(handles.popupY,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
handles = updateIgnoreRowList(hObject,eventdata,handles);
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
            xCats = categorical(rawX);
            yCats = categorical(rawY);
            ordPlotX = double(ordinal(rawX));
            ordPlotY = double(ordinal(rawY));
            %TODO change values according to count
            axes(handles.axesMain)
            gscatter(ordPlotX,ordPlotY,xCats);
            
            
        else
            %if Xdata catagorical       (x(Cat),y(Num))
            yPlot = cell2mat(rawY);
            xCats = categorical(rawX);
            %can't plot against strings
            ordPlot = double(ordinal(rawX));
            axes(handles.axesMain)
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
            axes(handles.axesMain)
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

