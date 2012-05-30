function [ numPositives, numNegatives ] = countPosNeg( dataSet, numSurrounding )
%COUNTPOSNEG Counts the number of positive and negative observations
% countPosNeg counts the number of positive and negative observations in
% the input dataSet where an observation is defined as a group of rows in
% the data set representing data at a location and its surrounding locations.
% An observation is negative if there was no storm at that day and
% location, and it is positive if there was a storm at that day and
% location.  This is represented with a 0 (negative) or a 1 (positive) 
% in the first column of each row.
% INPUT:
% dataSet - The cell array which has a cell for each year containing a 2d
% matrix of all the observations for that year.
% numSurrounding
% OUTPUT:
% numPositives - The number of positive observations (i.e. the number of
% storms in the data set)
% numNegatives - The number of negative observations in the data set.

if nargin < 2
    numSurrounding = 9;
end

numPositives = 0;
numNegatives = 0;

numYears = length(dataSet);

for i = 1:numYears
    numPositives = numPositives + sum(dataSet{i}(:, 1));
    numNegatives = numNegatives + sum(~dataSet{i}(:, 1));
end

numPositives = numPositives/numSurrounding;
numNegatives = numNegatives/numSurrounding;

fprintf('There are %d positives and %d negatives.\n',  ... 
    numPositives, numNegatives)
fprintf('The ratio of positives to negatives is %.4f.\n', numPositives/numNegatives)
fprintf('The ratio of negatives to positives is %.4f.\n', numNegatives/numPositives)

end

