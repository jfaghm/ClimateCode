% This script counts the number of storms that occurred in each month of
% each year and stores the result in a 2-D matrix where each column is a
% year, and each row is a month.  Each entry indicates the number of storms
% which took place in the corresponding month of the corresponding year.

dataPath = '/project/expeditions/haasken/MATLAB/Hurricane/';

load([dataPath 'condensedHurDat.mat'])

startYear = min(condensedHurDat(:, 1));
endYear = max(condensedHurDat(:, 1));
numYears = endYear - startYear + 1;

stormCounts = zeros(12, numYears);

for year = startYear:endYear
    yearStorms = condensedHurDat(condensedHurDat(:, 1) == year, :);
    
    numYearStorms = size(yearStorms, 1);
    
    for i = 1:numYearStorms
        monthNumber = yearStorms(i, 2);
        
        assert(monthNumber >=1 && monthNumber <= 12)
        
        stormCounts(monthNumber, year - startYear + 1) = stormCounts(monthNumber, year - startYear + 1) + 1;
    end
end
