function [ collapsedDataSet ] = collapseSurrounding( dataSet )
%COLLAPSESURROUNDING Puts surrounding locations all on one row.
%   

numHeaderRows = 4;
numSurrounding = 9;

collapsedDataSet = cell(1, length(dataSet));

for i = 1:length(dataSet)
    
    numRows = size(dataSet{i}, 1);
    
    collapsedDataSet{i} = zeros(numRows/numSurrounding, ...
        (size(dataSet{i}, 2) - numHeaderRows)*numSurrounding + numHeaderRows);
    
    for row = 1:numSurrounding:numRows
        
        mainSection = dataSet{i}(row, :);
        
        otherSection = dataSet{i}((row+1):(row+numSurrounding-1), (numHeaderRows+1):end);
        
        surroundingVector = reshape(otherSection', 1, []);
        
        collapsedDataSet{i}(ceil(row/numSurrounding), :) = [mainSection surroundingVector];
    
    end

end

