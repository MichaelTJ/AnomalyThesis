function handles = setAxesMain3D(hObject, eventdata, handles)
%SETAXESMAIN3D Summary of this function goes here
%   Detailed explanation goes here



%get wanted data from x and y labels
xColNum = get(handles.popup3X,'value');
yColNum = get(handles.popup3Y,'value');
zColNum = get(handles.popup3Z,'value');
%get raw cell data from uitable
plotData = get(handles.uitable2,'Data');
updateIgnoreRowList(handles);
%get all data
rawX = plotData(:,xColNum);
rawY = plotData(:,yColNum);
rawZ = plotData(:,zColNum);
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

%2 options, 3 variables = 6 prmutations
hold off
if iscellstr(rawX(1))
    xCats = categorical(rawX);
    if iscellstr(rawY(1))
        yCats = categorical(rawY);
        if iscellstr(rawZ(1))   %(x(Cat),y(Cat),z(Cat))
            zCats = categorical(rawZ);
            axes(handles.axesMain)
            scatter3(xCats,yCats,zCats);
        else                    %(x(Cat),y(Cat),z(Num))
            zPlot = cell2mat(rawZ);   
            axes(handles.axesMain)
            scatter3(xCats,yCats,zPlot);      
        end
    else 
        yPlot = cell2mat(rawY);         
        if iscellstr(rawZ(1))   %(x(Cat),y(Num),z(Cat))
            zCats = categorical(rawZ);
            axes(handles.axesMain)
            scatter3(xCats,yPlot,zCats);
        else                    %(x(Cat),y(Num),z(Num))
            zPlot = cell2mat(rawZ);     
            axes(handles.axesMain)
            scatter3(xCats,yPlot,zPlot);   
        end
    end
else
    xPlot = cell2mat(rawX);         
    if iscellstr(rawY(1))
        yCats = categorical(rawY);
        if iscellstr(rawZ(1))   %(x(Num),y(Cat),z(Cat))
            zCats = categorical(rawZ);
            axes(handles.axesMain)
            scatter3(xPlot,yCats,zCats);
        else                    %(x(Num),y(Cat),z(Num))
            zPlot = cell2mat(rawZ); 
            axes(handles.axesMain)
            scatter3(xPlot,yCats,zPlot);       
        end
    else
        yPlot = cell2mat(rawY);         
        if iscellstr(rawZ(1))   %(x(Num),y(Cat),z(Cat))
            zCats = categorical(rawZ);
            axes(handles.axesMain)
            scatter3(xPlot,yPlot,zCats);
        else                    %(x(Num),y(Num),z(Num))
            zPlot = cell2mat(rawZ);     
            axes(handles.axesMain)
            scatter3(xPlot,yPlot,zPlot);   
        end
    end
end
%{
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
%}

function updateIgnoreRowList(handles)
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


