function [ offset, set ] = findBoxIndex(sizes, index)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

set = zeros(size(index));
offset = zeros(length(index), 1);

for i = 1:length(index)
    sum = 0;
    currSet = 1;
    for j = 1:length(sizes)
        if(sum + sizes(j) > index(i))
            break
        end
        sum = sum + sizes(j);
        currSet = currSet+1;
    end


    offset(i) = index(i) - sum;
    set(i) = currSet;
    if offset(i) == 0
        set(i) = currSet-1;
        offset(i) = sizes(currSet-1);
    end

end
end



