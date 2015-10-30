function [ output_args ] = setAxesAnomND(hObject, eventdata, handles,...
    numCols, combCats, rows)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%[h,ax,bigax] = gplotmatrix([1; 2; 3; 4],[1; 2; 3; 4],[1; 1; 2; 2])
numCols = cell2mat(numCols);
if size(numCols,2)>1
    axes(handles.axesAnom)
    parallelcoords(handles.axesAnom,numCols,'Group',combCats,'Standardize','on');
    lines = get(handles.axesAnom,'Children');
    lineVals = get(lines,'YData');
    %getting mean and stddev for each column/point here
    mn = mean(numCols);
    stdD = std(numCols);
    %for each row in selected rows
    rowMatch = zeros(numel(rows),size(numCols,2));
    newRows = zeros(numel(rows),1)
    for i=1:numel(rows)
        rowMatch(i,:) = (numCols(rows(1,i),:)-mn)./stdD;
        
        newRows(i,1) = find(ismember(cell2mat(lineVals),rowMatch(i,:),'rows'));
    end
    set(lines(newRows), 'LineWidth', 3,'Color',[1 0 0],'Selected','on');
elseif size(numCols,2)==1
    axes(handles.axesAnom);
    scatter(handles.axesAnom,numCols,numCols);
    hold on;
    %TODO: check this
    scatter(handles.axesAnom,numCols(newRows,:),numCols(newRows,:),'fill');
    hold off;
%handles.axesAnom = [h,ax,bigax]
else
end

