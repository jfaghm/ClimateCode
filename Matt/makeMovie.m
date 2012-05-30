function [ aviobj ] = makeMovie(data, filename )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

imagesc(data{1});

colorbar

aviobj = VideoWriter(filename);
open(aviobj);
for i = 1:size(data)
    imagesc(data{i});
    Frame = getframe(gcf);
    writeVideo(aviobj, Frame);
    
end
close(aviobj);

end

