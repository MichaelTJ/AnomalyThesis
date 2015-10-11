dataSize = 4
startNums = ones(1,dataSize)
maxNums = zeros(1,dataSize)
for i=1:dataSize
    maxNums(1,i) = dataSize+1-i
end
curDim = 1
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
    nextSet
end