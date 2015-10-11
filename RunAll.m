function runAll(hObject, eventdata, handles)
%RUNALL Summary of this function goes here
%   Detailed explanation goes here

data = get(handles.uitable2,'Data');
stdDevComp = str2num(get(handles.deviationEdit,'String'))
%oneDAnalysis(hObject,eventdata,handles,data,stdDevComp)
%twoDAnalysis(hObject,eventdata,handles,data,stdDevComp)
%threeDAnalysis(hObject,eventdata,handles,data,stdDevComp)
allDAnalysis(hObject,eventdata,handles,data)

function allDAnalysis(hObject,eventdata,handles,data)
dataSize = size(data,2);
startNums = ones(1,dataSize);
maxNums = zeros(1,dataSize);
for i=1:dataSize
    maxNums(1,i) = dataSize+1-i;
end
curDim = 1;
nextSet = zeros(1,dataSize)
%while number isnt maxed
while any(find(~nextSet))
    for i=1:dataSize
        %if the digit is not maxed
        if nextSet(1,i)~=maxNums(1,i)
            %increment it
            nextSet(1,i) = nextSet(1,i)+1
            break
        else
            %if it's maxed
            %if curDim is maxed
            if curDim == i
                %increment the start counters
                for j=1:curDim
                    startNums(1,j) = startNums(1,j) + 1
                    %set nextSet
                    nextSet(1,j) = startNums(1,j)
                end
                curDim = curDim +1
                nextSet(1,curDim) = 1
                break
            else
                %dont worry about it
            end
        end
    end
    %for every non-zero value in nextSet
    toAnalysis = cell(size(data,2),0)
    for k=1:dataSize
        if nextSet(1,k)~=0
            if curDim ==2
                toAnalysis = [toAnalysis data(:,nextSet(1,k))]
            end
        end
    end
    analyzeAll(toAnalysis)
end



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
        [plottable, msg] = meanStdOneDNum(cell2mat(rawCol),stdDevComp)
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
for i=1:sizeData(2)-1
    rawX = data(:,i);
    %for each future column
    for j=i+1:sizeData(2)
        rawY = data(:,j);
        if iscellstr(rawX(1))
            if iscellstr(rawY(1)) %(x(Cat),y(Cat))
                [plotX plotY plotCount count] = getCatCatVals(rawX,rawY)
                
                               
                
                [plottable,msg] = meanStdCatCat(count,stdDevComp)
                if plottable
                   
                    adjCount = resizeC(count)
                    [col] = getColNames([i j])

                    %calc anoms
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'catCat',plotX,plotY,col{1},col{2},adjCount)
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
                    [plottable,msg] = meanStdOneDNum(cell2mat(seperated(k)),stdDevComp);
                    if plottable
                        plottableLoop = true
                    end
                end
                if plottableLoop
                    
                    [col] = getColNames([i j])
                    
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'catNum',rawY,xPlot,col{2},col{1})
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
                    [plottable,msg] = meanStdOneDNum(cell2mat(seperated(k)),stdDevComp);
                    if plottable
                        plottableLoop = true
                    end
                end
                if plottableLoop
                    
                    [col] = getColNames([i j])
                    
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'catNum',rawY,xPlot,col{2},col{1})
                end
                    
                
            else
                %if Xdata catagorical       (x(Num),y(Num))
                xPlot = cell2mat(rawX)
                yPlot = cell2mat(rawY)
                
                %get mean and std deviation of 2d points
                [plottable,stdMsg] = meanStdNumNum(rawX,rawY,stdDevComp)
                
                %get closest points
                [plottable,closestMsg] = closestPoints(xPlot,yPlot,stdDevComp)
                
                msg = [stdMsg, closestMsg, ' asdfasdf']
                if plottable
                    [col] = getColNames([i j],handles)
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'numNum',rawX,rawY,col{1},col{2})
                end
                    
                %scatter(handles.axesMain,xPlot,yPlot);
            end
        end
    end
end

function threeDAnalysis(hObject,eventdata,handles,data,stdDevComp)
plot1 = true
plot2 = true
plot3 = true
plot4 = true
for i=1:size(data,2)-2
    for j=i+1:size(data,2)-1
        for k=j+1:size(data,2)
            [catCount, numCount, catInd, numInd] = getCatNums(data,[i j k])
            if catCount==3
                %multigrid display
                
                [col] = getColNames([i j k],handles)
                rawX = data(:,i);
                rawY = data(:,j);
                rawZ = data(:,k);
                [plots, plotCount, count] = getAllCatVals([rawX,rawY,rawZ])
                [plotX, plotY, plotCount, count] = getCatCatVals(rawX,rawY)
                adjCount = resizeC(count)
                
                msg = 'No anom detection, just testing'
                if plot1
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'catCatCat',plotX,plotY,rawZ,...
                        col{1},col{2},col{3},adjCount)
                    plot1 = false
                end
            end
            if catCount==2
                %box plot with cats combined
                rawX = data(:,catInd(1))
                rawY = data(:,catInd(2))
                rawZ = data(:,numInd(1))
                
                [orderX,indexX,iX] = unique(rawX)
                [orderY,indexY,iY] = unique(rawY)
                %create a unique-rawX by unique-rawY cell array
                groups = cell(size(orderX,1),size(orderY,1))
                for groupi=1:size(iX,1)
                    iX(groupi)
                    iY(groupi)
                    groups{iX(groupi),iY(groupi)}
                    groups{iX(groupi),iY(groupi)} = ...
                        [groups{iX(groupi),iY(groupi)} ...
                        rawZ{groupi}]
                end
                
                [col] = getColNames([i j k],handles)
                msg = 'No anom detection, just testing'
                if plot2
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'catCatNum',rawX,rawY,rawZ,...
                        col{1},col{2},col{3})
                    plot2 = false
                end
                
            end
            if catCount ==1
                %box plot with cats combined
                rawX = data(:,catInd(1))
                rawY = data(:,numInd(1))
                rawZ = data(:,numInd(2))
                
                [col] = getColNames([i j k],handles)
                msg = 'No anom detection, just testing'
                if plot3
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'catNumNum',rawX,rawY,rawZ,...
                        col{1},col{2},col{3})
                    plot3 = false
                end
            end
            if catCount==0
                %box plot with cats combined
                rawX = data(:,numInd(1))
                rawY = data(:,numInd(2))
                rawZ = data(:,numInd(3))
                
                [col] = getColNames([i j k],handles)
                msg = 'No anom detection, just testing'
                if plot4
                    externalOutput(hObject, eventdata, handles,...
                        data,msg,'numNumNum',rawX,rawY,rawZ,...
                        col{1},col{2},col{3})
                    plot4 = false
                end
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
        msg = sprintf('Has elements outside %d standard deviations.\n',stdDevComp);
        plottable = true
        %TODO get row for unique
    end
    if oneDArray(i) == 1
        msg = 'Has unique element.\n'
        plottable = true;
        %TODO get row for unique
    end
end

function [plottable, msg] = meanStdOneDNum(oneDArray,stdDevComp)
meanArr = mean(oneDArray);
stdArr = std(oneDArray);
sizeArr = size(oneDArray);
plottable = false;
msg = '';
for i=1:sizeArr(1)
    if abs(oneDArray(i)-meanArr)/stdDevComp>stdArr 
        msg = sprintf('Has elements outside %d standard deviations.\n',stdDevComp);
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
        msg = sprintf('Has elements outside %d standard deviations.\n',stdDevComp);
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
        msg = sprintf('Has elements outside %d standard deviations.\n',stdDevComp);
        plottable = true;
    end
end

function [plottable,msg] = closestPoints(xPlot,yPlot,stdDevComp)

plottable = false;
msg = '';
min_dist = Inf;
%result has xValue and yValue and distance
result = zeros(size(xPlot,1),1);
%for each point in xIndex
for p1 = 1:size(xPlot,1)
    min_dist = Inf;
    %for each point in y index
    for p2 = 1:size(yPlot,1)
        %d = distance between point 1 and point 2
        d = sqrt((xPlot(p1)-xPlot(p2))^2+(yPlot(p1)-yPlot(p2))^2)
        %set the update the minimum distance if it is lower than curMin
        if d < min_dist && p1 ~= p2
            %min_p1 = p1;
            %min_p2 = p2;
            min_dist = d;
        end
    end
    %record min distance
    result(p1) = min_dist
end
[plottable, msg] = meanStdOneDNum(result,stdDevComp)
if plottable
    msg = 'Nearest neighbours mismatch.\n';
end

function [catCount, numCount, catElems, numElems] = getCatNums(data,columns)
catCount = 0;
numCount = 0;
catElems = int16.empty()
numElems = int16.empty()
%for each column
for i=1:size(columns,2)
    %get the data related to the column
    rawN = data(:,columns(i))
    if iscellstr(rawN(1))
        catCount = catCount+1;
        catElems(end+1) = columns(i)
    else
        numCount = numCount+1;
        numElems(end+1) = columns(i)
    end
end

function [plotX, plotY, plotCount, count] = getCatCatVals(rawX,rawY)
plotX = []
plotY = []
plotCount = []
count = []
% for each y val
for k=1:size(rawY)
    %join xCat and yCat
    combStr = strjoin([rawX(k) rawY(k)])
    %if it already exists
    if ismember(combStr,plotCount)
        %find the member
        [lia,Locb] = ismember(combStr,plotCount)
        %increment its count
        count(Locb) = count(Locb)+1
    else
        %if it doesn't already exist
        %add a new category to count
        count(end+1) = 1
        %set xCat and yCat
        plotX{end+1} = char(rawX(k))
        plotY{end+1} = char(rawY(k))
        %set combined cat
        plotCount{end+1} = combStr
    end
end    

function [plots, plotCount, count] = getAllCatVals(rawCols)
%plots is a cell array, each cell contains an array of the 
%   individual category's single string
%plotCount is the combined string of plots
%count is the number of times plotCount is found
%get the number of columns
colCount = size(rawCols,2)
%set plots to empty cell array of size of number of cols
plots = cell(1,colCount)
plotCount = []
count = []

%for each row
for i=1:size(rawCols,1)
    %for each column
    combStr = ''
    for j=1:size(rawCols,2)
        %combine the strings
        combStr = strjoin([combStr rawCols(i,j)])
    end
    if ismember(combStr,plotCount)
        %find the membet
        [lia,Locb] = ismember(combStr,plotCount)
        %incremebt its count
        count(Locb) = count(Locb)+1
    else
        %if it doesn't exit, add to the array
        count(end+1) = 1
        %for each column, update it's plots with cur row
        for j=1:size(rawCols,2)
            char(rawCols(i,j))
            plots{1,j}
            
            plots{1,j}{end+1} = char(rawCols(i,j))
        end
        plotCount{end+1} = combStr
    end
end
   

function [names] = getColNames(colIndexes,handles)
%Both sets are categorical  (x(Cat),y(Cat))
columns = get(handles.uitable2,'ColumnName');
%for every column
names = cell.empty()
for index=1:size(colIndexes,2)
    %add a column to names
    names{end+1} = ''
    names{index} = strrep(columns(index),'<html><font size="4">','');
    names{index} = strrep(names{index},'</font></html>','');
end