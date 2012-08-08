function [nYears, pYears] = getPosNegYearsFromVector(vec, sigma,...
    positivilyCorrelated, baseYear)
%This function finds the years associated with high and low hurricane
%activity given an index.  
%
%----------------------------Input----------------------------------------
%
%--->vec - a vector containing the index, this vector should be consistant
%with the baseYear that is given to the function
%--->sigma - the threshold for which we choose the high and low years
%--->positivilyCorrelated - A boolean variable that determines if the index
%is positivily or negativly correlated with hurricane activity.  If it is
%positivily correlated, then the positive years are those that are sigma
%standard deviations above the mean, and vise versa for negative years.
%--->baseYear - the base year of the index data
%
%--------------------------Output-----------------------------------------
%
%--->nYears - a vector containing all of the years associated with low
%hurricane activity.
%--->pYears - a vector containing all of the years associated with high
%hurricane activity.

zVec = zscore(vec);
if positivilyCorrelated == true
    nYears = find(zVec <= -sigma) + baseYear - 1;
    pYears = find(zVec >= sigma) + baseYear - 1;
else
    nYears = find(zVec >= sigma) + baseYear - 1;
    pYears = find(zVec <= -sigma) + baseYear - 1;
end



end

