function [] = makeImages( data )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:size(data)
    imagesc(data{i})
    colorbar
    pause

end

