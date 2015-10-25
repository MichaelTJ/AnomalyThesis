function [ output_args ] = setAxesAnomND(hObject, eventdata, handles,...
    numCols, combCats, rows)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%[h,ax,bigax] = gplotmatrix([1; 2; 3; 4],[1; 2; 3; 4],[1; 1; 2; 2])
numCols = cell2mat(numCols);
if size(numCols,2)>1
    parallelcoords(handles.axesAnom,numCols,'Group',combCats,'Standardize','on');
    lines = get(handles.axesAnom,'Children');
    lineVals = get(lines,'YData');
    %getting mean and stddev for each column/point here
    mn = mean(numCols);
    stdD = std(numCols);
    %for each row in selected rows
    rowMatch = zeros(numel(rows),size(numCols,2));
    for i=1:numel(rows)
        rowMatch(i,:) = (numCols(rows(i),:)-mn)./stdD;
        
        rows = find(ismember(cell2mat(lineVals),rowMatch(1,:),'rows'));
    end
    set(lines(rows), 'LineWidth', 3,'Color',[1 0 0],'Selected','on');
elseif size(numCols,2)==1
    axes(handles.axesAnom);
    scatter(handles.axesAnom,numCols,numCols);
    hold on;
    %TODO: check this
    scatter(handles.axesAnom,numCols(rows,:),numCols(rows,:),'fill');
    hold off;
%handles.axesAnom = [h,ax,bigax]
else
end

