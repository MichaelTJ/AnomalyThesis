function runAll(hObject, eventdata, handles)
%RUNALL Summary of this function goes here
%   Detailed explanation goes here

data = get(handles.uitable2,'Data');
stdDevComp = str2num(get(handles.deviationEdit,'String'))
oneDAnalysis(hObject,eventdata,handles,data,stdDevComp)
twoDAnalysis(hObject,eventdata,handles,data,stdDevComp)

function oneDAnalysis(hObject,eventdata,handles,data,stdDevComp)
%size of data
sizeData = size(data);
%single col analysis
for i=1:sizeData(2)
    %get the column in question
    rawCol = data(:,i);
    %if the first element is a string
    if iscellstr(rawCol(1))
        %its a category
        %get data about categories
        grouped = nominal(rawCol)
        A = summary(grouped)
        %find out if it's interesting and why
        [plottable, msg] = meanStdCats(A,stdDevComp)
        if plottable
            %TODO: check to see the number of open windows
            %TODO: size and location of new window
            %TODO: make plot
            cats = categorical(rawCol);
            %TODO: take plot, dataRows, msg
            
            externalOutput(hObject, eventdata, handles,...
                data,msg,'hist1',cats)     
        end
    else
        %numerical
        [plottable, msg] = meanStdOneDNum(rawCol,stdDevComp)
        if plottable
            externalOutput(hObject, eventdata, handles,...
                data,msg,'hist1',cell2mat(rawCol))
        end
    end
end

function twoDAnalysis(hObject,eventdata,handles,data,stdDevComp)
%size of data
sizeData = size(data);
%get all data

%for each column
for i=1:sizeData(2)
    rawX = data(:,i);
    %for each future column
    for j=i+1:sizeData(2)
        rawY = data(:,j);
        if iscellstr(rawX(1))
            if iscellstr(rawY(1)) %(x(Cat),y(Cat))
                
                plotX = []
                plotY = []
                plotCount = []
                count = []
                for k=1:size(rawY)
                    combStr = strjoin([rawX(k) rawY(k)])
                    if ismember(combStr,plotCount)
                        %find the member
                        [lia,Locb] = ismember(combStr,plotCount)
                        %get the value associated with the 
                        count(Locb) = count(Locb)+1
                    else
                        count(end+1) = 1
                        plotX{end+1} = char(rawX(k))
                        plotY{end+1} = char(rawY(k))
                        plotCount{end+1} = combStr
                    end
                end     
                
                
               [plottable,msg] = meanStdCatCat(count,stdDevComp)
               if plottable
                   
                    adjCount = resizeC(count)
                    %Both sets are cateforical  (x(Cat),y(Cat))
                    columns = get(handles.uitable2,'ColumnName');
                    %bad way of cleaning up colNames
                    col1 = strrep(columns(i),'<html><font size="4">','');
                    col1 = strrep(col1,'</font></html>','');
                    col2 = strrep(columns(j),'<html><font size="4">','');
                    col2 = strrep(col2,'</font></html>','');

                    %calc anoms
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'catCat',plotX,plotY,col1,col2,adjCount)
               end

            else
                %if Xdata catagorical       (x(Cat),y(Num))
                %copied code from (x(Num),y(Cat))
                %swap rawX and rawY so it works
                a = rawX
                rawX = rawY
                rawY = a
                xPlot = cell2mat(rawX);
                %gets by categorical
                yCats = categorical(rawY);
                ordYCats = double(ordinal(rawY));
                
                [yCatUniques, ia, ic] = unique(yCats)
                %split values into categories
                
                seperated = {}
                for k=1:size(yCatUniques,1)
                    seperated{end+1} = []
                end
                %place values in the right columns
                for k=1:size(xPlot,1)
                    %the value
                    val = xPlot(k)
                    %the catNum
                    catNum = ordYCats(k)
                    seperated{catNum}(end+1) = val
                end
                seperated{1}
                plottableLoop = false
                for k=1:size(yCatUniques,1)
                    [plottable,msg] = meanStdOneDNum(seperated(k),stdDevComp);
                    if plottable
                        plottableLoop = true
                    end
                end
                if plottableLoop
                    
                    %Both sets are cateforical  (x(Cat),y(Cat))
                    columns = get(handles.uitable2,'ColumnName');
                    %bad way of cleaning up colNames
                    col1 = strrep(columns(i),'<html><font size="4">','');
                    col1 = strrep(col1,'</font></html>','');
                    col2 = strrep(columns(j),'<html><font size="4">','');
                    col2 = strrep(col2,'</font></html>','');
                    
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'catNum',rawY,xPlot,col2,col1)
                end
            end
        else
            if iscellstr(rawY(1))
                %xNumeric yCategoric        (x(Num),y(Cat))
                
                xPlot = cell2mat(rawX);
                %gets by categorical
                yCats = categorical(rawY);
                ordYCats = double(ordinal(rawY));
                
                [yCatUniques, ia, ic] = unique(yCats)
                %split values into categories
                
                seperated = {}
                for k=1:size(yCatUniques,1)
                    seperated{end+1} = []
                end
                %place values in the right columns
                for k=1:size(xPlot,1)
                    %the value
                    val = xPlot(k)
                    %the catNum
                    catNum = ordYCats(k)
                    seperated{catNum}(end+1) = val
                end
                seperated{1}
                plottableLoop = false
                for k=1:size(yCatUniques,1)
                    [plottable,msg] = meanStdOneDNum(seperated(k),stdDevComp);
                    if plottable
                        plottableLoop = true
                    end
                end
                if plottableLoop
                    
                    %Both sets are cateforical  (x(Cat),y(Cat))
                    columns = get(handles.uitable2,'ColumnName');
                    %bad way of cleaning up colNames
                    col1 = strrep(columns(i),'<html><font size="4">','');
                    col1 = strrep(col1,'</font></html>','');
                    col2 = strrep(columns(j),'<html><font size="4">','');
                    col2 = strrep(col2,'</font></html>','');
                    
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'catNum',rawY,xPlot,col2,col1)
                end
                    
                
            else
                %if Xdata catagorical       (x(Num),y(Num))
                xPlot = cell2mat(rawX);
                yPlot = cell2mat(rawY);
                
                %get mean and std deviation of 2d points
                [plottable,msg] = meanStdNumNum(rawX,rawY,stdDevComp)
                if plottable
                    %Both sets are cateforical  (x(Cat),y(Cat))
                    columns = get(handles.uitable2,'ColumnName');
                    %bad way of cleaning up colNames
                    col1 = strrep(columns(i),'<html><font size="4">','');
                    col1 = strrep(col1,'</font></html>','');
                    col2 = strrep(columns(j),'<html><font size="4">','');
                    col2 = strrep(col2,'</font></html>','');
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'numNum',rawY,rawY,col1,col2)
                end
                    
                %scatter(handles.axesMain,xPlot,yPlot);
            end
        end
    end
end

function resizeCount = resizeC(countArray)
countArray
meanArr = mean(countArray);
sizeArr = size(countArray);
resizeCount = countArray;
for i=1:sizeArr(2)
    resizeCount(i) = abs(countArray(i)-meanArr)*100;
end
resizeCount

function [plottable,msg] = meanStdCats(oneDArray,stdDevComp)
meanArr = mean(oneDArray(:))
stdArr = std(oneDArray(:))
sizeArr = size(oneDArray)
plottable = false;
msg = ''
%TODO: change msg to struct to return multiple msgs
%TODO: return more descriptive messages including var names
for i=1:sizeArr(1)
    if abs(oneDArray(i)-meanArr)/stdDevComp>stdArr 
        msg = sprintf('Has elements outside %d standard deviations.',stdDevComp);
        plottable = true
        %TODO get row for unique
    end
    if oneDArray(i) == 1
        msg = 'Has unique element.'
        plottable = true;
        %TODO get row for unique
    end
end

function [plottable, msg] = meanStdOneDNum(oneDArray,stdDevComp)
cellNums = cell2mat(oneDArray);
meanArr = mean(cellNums);
stdArr = std(cellNums);
sizeArr = size(oneDArray);
plottable = false;
msg = '';
for i=1:sizeArr(1)
    if abs(cellNums(i)-meanArr)/stdDevComp>stdArr 
        msg = sprintf('Has elements outside %d standard deviations.',stdDevComp);
        plottable = true;
    end
end

function [plottable, msg] = meanStdCatCat(combinedCounts,stdDevComp)
meanArr = mean(combinedCounts);
stdArr = std(combinedCounts);
sizeArr = size(combinedCounts);
plottable = false;
msg = '';
for i=1:sizeArr(2)
    if abs(combinedCounts(i)-meanArr)/stdDevComp>stdArr 
        msg = sprintf('Has elements outside %d standard deviations.',stdDevComp);
        plottable = true;
    end
end

function [plottable,msg] = meanStdNumNum(xArray,yArray,stdDevComp)
cellNumsX = cell2mat(xArray);
meanArrX = mean(cellNumsX);
stdArrX = std(cellNumsX);
sizeArrX = size(xArray);
cellNumsY = cell2mat(yArray);
meanArrY = mean(cellNumsY);
stdArrY = std(cellNumsY);
sizeArrY = size(yArray);
plottable = false;
msg = '';
for i=1:sizeArrX(1)
    %distance from centre point
    dist = sqrt((abs(cellNumsX(i)-meanArrX)/stdDevComp)^2+...
        (abs(cellNumsY(i)-meanArrY)/stdDevComp)^2)
    if dist>stdDevComp
        msg = sprintf('Has elements outside %d standard deviations.',stdDevComp);
        plottable = true;
    end
end
