function RunAll(hObject, eventdata, handles)
%RUNALL Summary of this function goes here
%   Detailed explanation goes here

data = get(handles.uitable2,'Data');
%size of data
sizeData = size(data);

%single col analysis
for i=1:sizeData(2)
    %get the column in question
    rawCol = data(:,i);
    %if the first element is a string
    if iscellstr(rawCol(1))
        %
        grouped = ordinal(rawCol)
        A = summary(grouped)
        if meanStd(meanStd(A))
            pie(A)
        end
    end
end

function plottable = meanStd(oneDArray)
meanArr = mean(oneDArray(:))
stdArr = std(oneDArray(:))
sizeArr = size(oneDArray)
plottable = false;
for i=1:sizeArr(1)
    if abs(oneDArray(i)-meanArr)/1>stdArr |...
            oneDArray(i) == 1
        plottable = true;
    end
end
        

    

