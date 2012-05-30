load GPIData.mat;
load TippetIndex.mat

for i = 1:size(GPIData)
    temp = [GPIData{i} Tippett{i}];
    imagesc(temp)
    colorbar
    pause
end
    