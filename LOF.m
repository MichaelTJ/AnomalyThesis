function [clusters, LOF, clusterNo] = LOF(data, k, normalize)
%LOF Summary of this function goes here
%   Detailed explanation goes here

%get kth closest element
minPoints = k;
data = cell2mat(data);

%setup normalized array
if normalize
    
    %fprintf('Normalizing\n');
    normData = zeros(size(data));

    %for each column
    parfor i=1:size(data,2)
        [c,~,~] = unique(data(:,i));
        %if the column only contains one value
        if size(c,1) == 1
            %leave the column as zeros
        else
            %set the column to a normalized values between 0 and 1
            normData(:,i) = (data(:,i)-min(data(:,i))) / ...
                (max(data(:,i)) - min(data(:,i)));    
        end
    end
    
    %fprintf('ClosestPoints\n')
    [distances,closestPoints] = kthClosest(k,normData,minPoints);
else
    [distances,closestPoints] = kthClosest(k,data,minPoints);
end

%fprintf('LOF\n')
LOF = zeros(size(data,1),1);
parfor i=1:size(data,1)
    sumDistances = 0;
    for j=1:minPoints
        if closestPoints(i,j)==0
            break;
        end
        if distances(closestPoints(i,j)) ~=0
            sumDistances = sumDistances + ...
                distances(i)/distances(closestPoints(i,j));
        end
    end
    LOF(i) = sumDistances/minPoints;
end

i = 1;
%set up empty groups array
%while not every row has a group
groupRet = cell.empty();
%fprintf('Clustering\n')
while numel(cell2mat(groupRet)) < size(closestPoints,1)
    %find the elements that are missing
    usedRows = ismember(1:size(closestPoints,1),cell2mat(groupRet));
    row = find(usedRows==0,1,'first');
    
    groupRet{i} = getPoints(closestPoints, row, cell2mat(groupRet), [], i).';
    i = i+1
end
clusters = groupRet;
clusterNo = zeros(size(data,1),1);
%for each column in clusters
for i=1:size(clusters,2)
    %for each row in with respect to original data
        %make each row num have the value of the column (cluster Group)
        clusterNo(clusters{:,i}) = i;
end




function [distances,closestPoints] = kthClosest(k, columns,minPoints)
closestPoints = zeros(size(columns,1),minPoints);
%result, distance has distance, row
%For each column
distances = zeros(size(columns,1),1);
%for each point in column
parfor p1 = 1:size(columns,1)
    distance = zeros(size(columns(:,1),1),2);
    for a=1:size(columns,1)
        distance(a,2) = a;
    end
    %for each column
    diffCols = zeros(size(columns));
    for ci = 1:size(columns,2)
        %optimization
        
        %for every row
        %for p2 = 1:size(columns,1)
            %The new distance = 
            %distance(:,1) = distance(:,1).^2+(columns(p1,ci)-columns(:,ci)).^2;
        diffCols(:,ci) = (columns(p1,ci)-columns(:,ci)).^2;
        %end
    end
    distance(:,1) = sqrt(sum(diffCols,2));
    tops = Inf(k,1);
    [tops,closestPoints(p1,:)] = ...
        checktops(p1, tops, closestPoints(p1,:) , distance);
    distances(p1) = tops(k);
    %fprintf('%d: %d\n',p1,distances(p1))
end

function [tops,closestPoints] = checktops(p1, tops, closestPoints, dist)
%checks the top of the closest points list
%for every point in distance
for i=1:size(dist,1)
    if i~=p1
        for j=1:size(tops)
            if(tops(j,1)>dist(i,1))
                %iteratively push the rest down
                oldVal = tops(j,1);
                tops(j,1) = dist(i,1);
                dist(i,1) = oldVal;
                temp2 = closestPoints(1,j);
                closestPoints(1,j) = dist(i,2);
                dist(i,2) = temp2;
                
            end
        end
    end
end

function [retGroup] = getPoints(closestPoints, row, group, retGroup, groupNum)
retGroup = [row];
identicalRows = [];
curIndex = 1;
while curIndex<=size(retGroup,2)
    curRow = retGroup(1,curIndex);
    %if the row has no closest points EI is NaN or Inf
    if any(find(closestPoints(curRow,:)==0))
        %get all the other NaN's and Inf's
        matchingRows = ismember(closestPoints,closestPoints(curRow,:),'rows');
        retGroup = cat(1,retGroup,find(matchingRows));
        return
    end
    
    %looking for identical closestPoints groups (same value)
    %Get unique rows
    matchingRows = ismember(closestPoints,closestPoints(curRow,:),'rows');
    identicalRows = cat(1,identicalRows,find(matchingRows));
    %for each point in the row
    for i=1:size(closestPoints,2)
        %if the point is already in the group or already used by another group
        if (any(find(group==closestPoints(curRow,i))) ||...
            any(find(retGroup==closestPoints(curRow,i))) ||...
            any(find(identicalRows==closestPoints(curRow,i))));
            %can count the number of links here
        else
            %add it to the end of the list
            retGroup(end+1) = closestPoints(curRow,i);
        end
    end
    curIndex = curIndex + 1;
end
retGroup = union(retGroup,identicalRows);
    
%{
%if the group has no closest points EI is NaN or Inf
if any(find(closestPoints(row,:)==0))
    retGroup = row;
    return
end
%looking for identical closestPoints groups (same value)
%Get unique rows
matchingRows = ismember(closestPoints,closestPoints(row,:),'rows');
retGroup = cat(1,retGroup,find(matchingRows));
rowPoints = closestPoints(row,:);

%for each point in the row
for i=1:size(closestPoints,2)
    %if the point is already in the group or already used by another group
    if (any(find(group==rowPoints(i))) ||...
        any(find(retGroup==rowPoints(i))));
        %can count the number of links here
    else
        %retGroup(end+1) = rowPoints(i);
        %add a 'to be processed -> ignore if in list' for speed
        retGroup = getPoints(closestPoints, rowPoints(i), group, retGroup, groupNum);
    end
end
%}

        
    