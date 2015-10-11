function [ output_args ] = analyzeAll(rawCols)
%takes in columns of data, returns Analysis
%   Detailed explanation goes here
catCols = [];
numCols = [];
%split the columns into numerical and categorical arrays
for i=1:size(rawCols,2)
    if iscellstr(rawCols(1,i))
        catCols = [catCols rawCols(:,i)];
    else
        numCols = [numCols rawCols(:,i)];
    end
end
if isempty(catCols)
   catCols = cell(size(rawCols,1),1);
   catCols(:) = {'A'};
end
%Combine Cat Cols
combCats = cell(size(catCols,1),1);
for i=1:size(rawCols,1)
    combCats{i} = strjoin(catCols(i,:));
end
%analyze the combined categorical
%this splits up the categorical rows into combined categories
[catGroups, firstIndex, indexCatGroups] = unique(combCats);


%analyze the numerical
%this splits up the numerical rows into clusters
[clusters, LOFOut, indexClusters] = LOF(numCols, 4, true);
if isempty(clusters)
    clusters = ones(size(rawCols,1),1);
    indexClusters = ones(size(rawCols,1),1);
end
%for each combined category, get the count of all the clusters
counts = zeros(size(catGroups,1),size(clusters,2));
%for every combined category
for i=1:size(catGroups,1)
    %get just the rows where catGroups matches in index
    catGroupRows = indexCatGroups(:) == i;
    %multiply by clusterIndex to get matching clusterNums and zeros
    numGroupRows = catGroupRows.*indexClusters;
    %for every cluster group
    for j=1:size(clusters,2)
        %get the count of each cluster
        counts(i,j) = sum(numGroupRows(:)==j);
    end
end

%if clusters == 1 then the following will result in a 1 no matter what
%divide by num elements in catGroup
for i=1:size(catGroups,1)
    counts(i,:) = counts(i,:)./(sum(strcmp(combCats,catGroups{i,1})));
end
rawCols
catGroups
clusters

%if any of the counts == 1
%it implies that there's a perfect match between group and cluster
%taking anything with a 90%+ correlation
trend = false;
B = counts>=0.9;
if any(counts(:,:)>=0.95)
    trend = true;
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