a = {'A','cat';...
    'A','cat';...
    'A','cat';...
    'A','cat';...
    'A','cat';...
    'A','cat';...
    'A','cat';...
    'A','cat';...
    'B','cat';...
    'B','dog';...
    'B','cat';...
    'B','cat';...
    'B','cat';...
    'C','cat';...
    'D','cat';}
c = a(1:end,1)
d = a(1:end,2)

[uniqs, loc, lia] = unique(c)
[uniqs, loc, lia] = unique(d)
for i=1:size(a,2) 
    counts = zeros(size(uniqs))
    for j=1:numel(uniqs)
        counts(j,1) = sum(lia == j)
    end
end


b = [1 2 3 4; 5 6 7 8;]
imagesc(b)
colorbar


