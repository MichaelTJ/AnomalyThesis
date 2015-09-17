function [clusters, LOF] = LOF(data, k)
%LOF Summary of this function goes here
%   Detailed explanation goes here
%get kth closest element
minPoints = k
[distances,closestPoints] = kthClosest(k,columns,minPoints)
distances
closestPoints
LOF = zeros(size(columns,1),1)
for i=1:size(columns,1)
    sumDistances = 0;
    for j=1:minPoints
        sumDistances = sumDistances + distances(i)/distances(closestPoints(i,j))
    end
    LOF(i) = sumDistances/minPoints
end

i = 1;
%set up empty groups array
%while not every row has a group
groupRet = cell.empty()

while numel(cell2mat(groupRet)) < size(closestPoints,1)
    %find the elements that are missing
    usedRows = ismember(1:size(closestPoints,1),cell2mat(groupRet))
    row = find(usedRows==0,1,'first')
    
    groupRet{i} = getPoints(closestPoints, row, cell2mat(groupRet), [row], i)
    i = i+1
end
clusters = groupRet




function [distances,closestPoints] = kthClosest(k, columns,minPoints)
closestPoints = zeros(size(columns,1),minPoints)
%result, distance has distance, row
%For each column
distances = zeros(size(columns,1),1)
%for each point in column
for p1 = 1:size(columns,1)
    distance = zeros(size(columns(:,1),1),2)
    for a=1:size(columns,1)
        distance(a,2) = a
    end
    %for each column
    for ci = 1:size(columns,2)
        %for every other point in column
        for p2 = 1:size(columns,1)
            %The new distance = 
            distance(p2,1) = sqrt(distance(p2,1)^2+(columns(p1,ci)-columns(p2,ci))^2)
        end
    end
    tops = Inf(k,1);
    [tops,closestPoints] = checktops(p1, tops, closestPoints , distance)
    distances(p1) = tops(k)
end

function [tops,closestPoints] = checktops(p1, tops, closestPoints, dist)
%for every point in distance
for i=1:size(dist,1)
    if i~=p1
        for j=1:size(tops)
            if(tops(j,1)>dist(i,1))
                %iteratively push the rest down
                oldVal = tops(j,1)
                tops(j,1) = dist(i,1)
                dist(i,1) = oldVal
                temp2 = closestPoints(p1,j)
                closestPoints(p1,j) = dist(i,2)
                dist(i,2) = temp2
                
            end
        end
    end
end

function [retGroup] = getPoints(closestPoints, row, group, retGroup, groupNum)
rowPoints = closestPoints(row,:)
%for each point in the row
for i=1:size(closestPoints,2)
    %if the point is already in the group or already used by another group
    if (any(find(group==rowPoints(i))) ||...
        any(find(retGroup==rowPoints(i))))
        %can count the number of links here
    else
        %group = (2)
        retGroup(end+1) = rowPoints(i)
        %add a 'to be processed -> ignore if in list' for speed
        retGroup = getPoints(closestPoints, rowPoints(i), group, retGroup, groupNum)
    end
end