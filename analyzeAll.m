function [clusters, counts, numColsIndx, catColsIndx, Summary, Anomalies] ...
    = analyzeAll(rawCols)
Summary = [];
Anomalies = struct('rows',[],...
    'catSet',[],'catProp',[],'catMean',[],'catStd',[],...
    'numSet',[],'numProp',[],'numMean',[],'numStd',[],...
    'clusterNum',[],'clusters',{},'LOF',[],...
    'anomType',{});
%takes in columns of data, returns Analysis
%   Detailed explanation goes here
catCols = [];
numCols = [];
numColsIndx = [];
catColsIndx = [];
%split the columns into numerical and categorical arrays
for i=1:size(rawCols,2)
    if iscellstr(rawCols(1,i))
        catCols = [catCols rawCols(:,i)];
        catColsIndx = [catColsIndx i];
    else
        numCols = [numCols rawCols(:,i)];
        numColsIndx = [numColsIndx i];
    end
end
if isempty(catCols)
   catCols = cell(size(rawCols,1),1);
   catCols(:) = {'A'};
end
%Combine Cat Cols
combCats = cell(size(catCols,1),1);
parfor i=1:size(rawCols,1)
    combCats{i} = strjoin(catCols(i,:));
end

%Analyzes:
%   -combined categories as a whole
%   -combined numeric columns as a whole
%   -combined numeric columns vs combined categories individually,
%   -combined numeric columns vs combined categories as a whole

%analyze the 
%this splits up the categorical rows into combined categories
[catGroups, firstIndex, indexCatGroups] = unique(combCats);
totalCount = size(combCats,1);
catPropsMean = zeros(size(catGroups));
catPropsStd = zeros(size(catGroups));
if size(catGroups,1)~=1
    parfor i=1:size(catGroups,1)
        groupCount = size(find(indexCatGroups(:)==i),1);
        catPropsStd(i) = groupCount/totalCount;
        catPropsMean(i) = groupCount/totalCount*groupCount;
    end
end
propMean = sum(catPropsMean)/totalCount;
propStd = std(catPropsStd,catPropsStd);

%second variable makes it weighted
anomaly = false;
%abs(propMean-catPropsStd(:))/propStd
%if there's a catGroup that's outside 3 std deviations
if any(abs(propMean-catPropsStd(:))/propStd > 3)
    %there is an anomaly
    %abs(propMean-catPropsStd(:))/propStd
    
    for i=1:size(abs(propMean-catPropsStd(:))/propStd,1)
        if abs(propMean-catPropsStd(i))/propStd > 3
            Anomalies(end+1) = struct('rows',find(indexCatGroups(:)==i),...
                'catSet',catGroups(i),...
                'catProp',catPropsStd(i),...
                'catMean',propMean,...
                'catStd',propStd,...
                'numSet',[],'numProp',[],'numMean',[],'numStd',[],...
                'clusterNum',[],'clusters',[],...
                'LOF',abs(propMean-catPropsStd(i))/propStd,...
                'anomType',{'Category'});
        end
    end
end

%analyze the combined categorical
%for each category, cluster their individual rows
if ~(isempty(numCols) || size(catGroups,1)==1)
    TotalCount = size(catGroups,1)
    for i=1:size(catGroups,1)
        fprintf('catClust %d / %d\n',i,TotalCount)
        %indexCatGroups(:)==i
        %find(indexCatGroups(:)==i)
        %ismember(i,indexCatGroups(:),'rows')
        %numCols(indexCatGroups(:)==i,:)
        k=5;
        %if the number of elements in the category is less than kth element
        if size(numCols(indexCatGroups(:)==i,:),1)>k
            rows = find(indexCatGroups(:)==i)
            [clusters,LOFOut,indexClusters] = ...
                LOF(numCols(indexCatGroups(:)==i),k,true);
            [Anomalies, clusterRep, invalid, msg] = ...
                analyzeClusters(clusters,k,indexClusters,catGroups(i),...
                {'Subcluster'},...
                Anomalies);
            highLOFs = find(LOFOut(:)>2)
            %if there's highLOFs
            if size(highLOFs,1)~=0
                for j=1:size(highLOFs,1)
                    %keeps anoms withon clusters
                    Anomalies(end+1) = struct('rows',rows(highLOFs(j)),...
                        'catSet',catGroups(i),'catProp',[],'catMean',[],...
                        'catStd',[],...
                        'numSet',[],'numProp',[],'numMean',[],'numStd',[],...
                        'clusterNum',indexClusters(highLOFs(j)),...
                        'clusters',{clusters},...
                        'LOF',LOFOut(highLOFs(j)),...
                        'anomType',{'Local Outlier'});
                end
            end
            %have to convert back to data rows notation
        end
        
    end
end
%analyze the numerical
%this splits up the numerical rows into clusters
k=5;
[clusters, LOFOut, indexClusters] = LOF(numCols, k, true);
if isempty(clusters)
    clusters = ones(size(rawCols,1),1);
    indexClusters = ones(size(rawCols,1),1);
else
    [Anomalies, clusterRep, invalid, msg] = ...
        analyzeClusters(clusters,k,indexClusters,[],{'Cluster'},Anomalies);
        highLOFs = find(LOFOut(:)>2)
        for i=1:size(highLOFs,1)
            %keeps cluster anoms
            Anomalies(end+1) = struct('rows',highLOFs(i),...
                'catSet',[],'catProp',[],'catMean',[],'catStd',[],...
                'numSet',[],'numProp',[],'numMean',[],'numStd',[],...
                'clusterNum',indexClusters(highLOFs(i)),...
                'clusters',{clusters},'LOF',LOFOut(highLOFs(i)),...
                'anomType',{'Outlier'});
        end
end


fprintf('Combinbing Cats and Clusters\n')
%for each combined category, get the count of all the clusters
counts = zeros(size(catGroups,1),size(clusters,2));
props = zeros(size(catGroups,1),1);
%for every combined category
for i=1:size(catGroups,1)
    %get just the rows where catGroups matches in index
    catGroupRows = indexCatGroups(:) == i;
    props(i,1) = sum(catGroupRows);
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

%if any of the counts == 1
%it implies that there's a perfect match between group and cluster
trend = false;
clusters = (clusters)';

if any(counts(:,:)>=0.95)
    %show the groups
    trend = true
end


%number of unique categories

%nuber of clusters, average value in cluster, size of clusters, 

%size of cluster wrt total count

%if there's multiple in counts, if sizeof count ==1 -> unique

function [Anomalies, clusterRep, invalid, msg] = ...
    analyzeClusters(clusters,k,IndexClusters,catSet,anomType,Anomalies)
invalid = false;
props = zeros(size(clusters));
counts = zeros(size(clusters));
totalCount = 0;
for i=1:size(clusters,2)
    totalCount = totalCount + numel(clusters{1,i});
end
if totalCount<=k
    clusterRep = 1;
    invalid = true;
    return
end


totProps = zeros(1,5);

for i=1:size(clusters,2)
    props(i) = numel(clusters{1,i})/totalCount;
    counts(i) = numel(clusters{1,i})/totalCount*numel(clusters{1,i});
    if props(i)<0.2
        totProps(1) = totProps(1) + props(i);
    elseif props(i)<0.4
        totProps(2) = totProps(2) + props(i);
    elseif props(i)<0.6
        totProps(3) = totProps(3) + props(i);
    elseif props(i)<0.8
        totProps(4) = totProps(4) + props(i);
    else
        totProps(5) = totProps(5) + props(i);
    end
end
propMean = sum(counts)/totalCount;
mean(props);
mean(counts);
propStd = std(props,props);

%second variable makes it weighted
%(propMean-props(:))
abs(propMean-props(:))/propStd
%abs(propMean-props(:))/propStd > 3
anomaly = false;
if any(abs(propMean-props(:))/propStd > 3)
    anomaly = true;
    
    %there is an anomaly
    for i=1:size(abs(propMean-props(:))/propStd,1)
        if abs(propMean-props(i))/propStd > 3
            Anomalies(end+1) = struct('rows',find(IndexClusters(:)==i),...
                'catSet',catSet,'catProp',[],'catMean',[],'catStd',[],...
                'numSet',[],'numProp',props(i),...
                'numMean',propMean,...
                'numStd',propStd,...
                'clusterNum',i,...
                'clusters',{clusters},...
                'LOF',abs(propMean-props(i))/propStd,...
                'anomType',anomType);
        end
    end
end
[clusterRep, centres] = hist(props,[0.1 0.3 0.5 0.7 0.9]);
if totProps(1)<0.1 && totProps(1)~=0
    anomaly = true;
end
%proportion analysis
%Get size of the biggest cluster
bigClust = max(props);
if bigClust>0.95
    msg = 'Trend';
elseif bigClust>0.5
    msg = 'Part Trend';
elseif bigClust>0.3
    msg = '30% trend';
else
    msg = 'No trend';
end


        


function [plots, plotCount, count] = getAllCatVals(rawCols)
%plots is a cell array, each cell contains an array of the 
%   individual category's single string
%plotCount is the combined string of plots
%count is the number of times plotCount is found
%get the number of columns
colCount = size(rawCols,2);
%set plots to empty cell array of size of number of cols
plots = cell(1,colCount);
plotCount = [];
count = [];

%for each row
for i=1:size(rawCols,1)
    %for each column
    combStr = '';
    for j=1:size(rawCols,2)
        %combine the strings
        combStr = strjoin([combStr rawCols(i,j)]);
    end
    if ismember(combStr,plotCount)
        %find the membet
        [lia,Locb] = ismember(combStr,plotCount);
        %incremebt its count
        count(Locb) = count(Locb)+1;
    else
        %if it doesn't exit, add to the array
        count(end+1) = 1;
        %for each column, update it's plots with cur row
        for j=1:size(rawCols,2)
            char(rawCols(i,j));
            plots{1,j};
            
            plots{1,j}{end+1} = char(rawCols(i,j));
        end
        plotCount{end+1} = combStr;
    end
end
