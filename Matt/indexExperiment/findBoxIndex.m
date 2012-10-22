function [ offset, set ] = findBoxIndex(sizes, index)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
sum = 0;
set = 1;
for i = 1:length(sizes)
    if(sum + sizes(i) > index)
        break
    end
    sum = sum + sizes(i);
    set = set+1;
end


offset = index - sum;

if offset == 0
    set = set-1;
    offset = sizes(set);
end


end

