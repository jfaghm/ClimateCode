function constrainedData = applySSTConstraint(dataSet, tempThreshold)
%APPLYSSTCONSTRAINTS Removes negatives which are outside of tempThreshold
%   This function removes all the negative observations whose SST for the
%   day of the observation is outside of the tempThreshold.
%   INPUT:
%   dataSet - The cell array which has a cell for each year containing a 2d
%   matrix of all the observations for that year.
%   tempThreshold - the required closeness of each negative's SST to make
%   it into the constrained data output
%   OUTPUT: 
%   constrainedData - The same cell array as dataSet with all
%   negatives with SST outside of tempThreshold removed

targetSST = 0;
numYears = size(dataSet, 2);
constrainedData = cell(1, numYears);
for year = 1:numYears
    yearData = dataSet{year};
    numObs = size(yearData, 1);
    withinThreshold = true(numObs, 1);
    for obs = 1:numObs/9
        primaryIndex = (obs-1)*9+1;
        if yearData(primaryIndex, 1)
            targetSST = mean(yearData(primaryIndex, 5:8));
        else
            if all(abs(targetSST-yearData(primaryIndex, 5:8)) > tempThreshold)
                withinThreshold(primaryIndex:primaryIndex+8) = false;
            end
        end
    end
    constrainedData{year} = yearData(withinThreshold, :);
end



end