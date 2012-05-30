function testGetMeanSST( )
%TESTGETMEANSST Tests getMeanSST function.
% This is a test of the getMeanSST function.

addpath('/project/expeditions/haasken/matlab/OptimizeCorr/')

numTests = 8;
testsPassed = false(1, numTests);

% Set up a Hadley-like grid for starters
gridInfo.northLimit = 89.5; 
gridInfo.westLimit = -179.5; 
gridInfo.latStep = 1; 
gridInfo.lonStep = 1;

%% Sets up a testSST, testLonLims, testLatLims and a testDates to be used in several tests

testSST = zeros(180, 360, 10);
for i = 1:5
    testSST(66:85, 141:160, 2*(i-1)+1) = magic(20) + i;
    testSST(66:85, 141:160, 2*i) = magic(20) + i;
end

testDates = reshape(getSeasonalDates(2001, 2005, [12 1]), [], 1);

testLonLims = [-40 -21];
testLatLims = [5.5 24.5];

%% First Test: Tests a simple region with a season spanning year bounds
expectedResults = 201.5:205.5;
actualResults = getMeanSST(testSST, testDates, gridInfo, testLatLims, testLonLims, 2001, 2005, [12 1], false);
diff = abs(actualResults - expectedResults);

testsPassed(1) = all(diff < 1e-10);

%% Second Test: Tests the same region with some degrees added to SST of every month
for i = 1:5
    testSST(66:10:85, 141:10:160, 2*(i-1+1)) = testSST(66:10:85, 141:10:160, 2*(i-1+1)) + 1;
    testSST(66:10:85, 141:10:160, 2*i) = testSST(66:10:85, 141:10:160, 2*i) + 1;
end

expectedResults = [201.5:205.5] + 1/100;
actualResults = getMeanSST(testSST, testDates, gridInfo, testLatLims, testLonLims, 2001, 2005, [12 1], false);
diff = abs(actualResults - expectedResults);

testsPassed(2) = all(diff < 1e-10);

%% Third Test: Tests the same region with some degrees added to December of each Season
for i = 1:5
    testSST(66:10:85, 141:10:160, 2*(i-1+1)) = testSST(66:10:85, 141:10:160, 2*(i-1+1)) + 10;
end

expectedResults = [201.5:205.5] + 1/100 + 1/20;
actualResults = getMeanSST(testSST, testDates, gridInfo, testLatLims, testLonLims, 2001, 2005, [12 1], false);
diff = abs(actualResults - expectedResults);

testsPassed(3) = all(diff < 1e-10);

%% Fourth Test: Tests with two regions with the same season
testSST = zeros(180, 360, 10);
for i = 1:5
    testSST(66:85, 141:160, 2*(i-1)+1) = magic(20) + i;
    testSST(66:85, 141:160, 2*i) = magic(20) + i;
    testSST(91:100, [357:360 1:6], 2*(i-1)+1) = magic(10) + i;
    testSST(91:100, [357:360 1:6], 2*i) = magic(10) + i;
end

testLatLims(2, :) = [ -0.5 -9.5 ];
testLonLims(2, :) = [ 176 -175 ];

expectedResults = 171.5:175.5;
actualResults = getMeanSST(testSST, testDates, gridInfo, testLatLims, testLonLims, 2001, 2005, [12 1], false);
diff = abs(actualResults - expectedResults);

testsPassed(4) = all(diff < 1e-10);

%% Fifth Test: Same region and SST as above with a different Season (January-February)

testDates = reshape(getSeasonalDates(2001, 2005, [1 2]), [], 1);

expectedResults = 171.5:175.5;
actualResults = getMeanSST(testSST, testDates, gridInfo, testLatLims, testLonLims, 2001, 2005, [1 2], false);
diff = abs(actualResults - expectedResults);

testsPassed(5) = all(diff < 1e-10);

%% Sixth Test: Back to a single region, same season, check proper monthly weighting

testSST = zeros(180, 360, 10);
for i = 1:5
    testSST(66:85, 141:160, 2*(i-1)+1) = magic(20) + i;
    testSST(66:85, 141:160, 2*i) = magic(20) + 2*i;
end
testLonLims = [-40 -21];
testLatLims = [5.5 24.5];

% Construct the expected results
expectedResults = zeros(1, 5);
for i = 1:5
    year = 2000+i;
    expectedResults(i) = (sum(sum(magic(20) + i))*eomday(year, 1) + sum(sum(magic(20) + 2*i))*eomday(year, 2)) / ...
        400 / (datenum(year, 2, eomday(year, 2)) - datenum(year, 1, 0));
end

actualResults = getMeanSST(testSST, testDates, gridInfo, testLatLims, testLonLims, 2001, 2005, [1 2], false);
diff = abs(actualResults - expectedResults);

testsPassed(6) = all(diff < 1e-10);

%% Seventh Test: Using single region, test Season from December-January for reynolds

% First, change gridInfo so that it describes a reynolds-like grid
gridInfo.westLimit = 0.5;

testSST = zeros(180, 360, 10);
for i = 1:5
    testSST(66:85, 321:340, 2*(i-1)+1) = magic(20) + i;
    testSST(66:85, 321:340, 2*i) = magic(20) + i;
end
testLonLims = [-40 -21];
testLatLims = [5.5 24.5];

testDates = reshape(getSeasonalDates(2001, 2005, [12 1]), [], 1);

expectedResults = 201.5:205.5;

actualResults = getMeanSST(testSST, testDates, gridInfo, testLatLims, testLonLims, 2001, 2005, [12 1], false);
diff = abs(actualResults - expectedResults);

testsPassed(7) = all(diff < 1e-10);

%% Eighth Test: Using another single region, test reynolds again, same season
testSST = zeros(180, 360, 10);
for i = 1:5
    testSST(46:65, [352:360 1:11], 2*(i-1)+1) = magic(20) + i;
    testSST(46:65, [352:360 1:11], 2*i) = magic(20) + i;
end
testLonLims = [-9 10];
testLatLims = [25.5 44.5];

expectedResults = 201.5:205.5;

actualResults = getMeanSST(testSST, testDates, gridInfo, testLatLims, testLonLims, 2001, 2005, [12 1], false);
diff = abs(actualResults - expectedResults);

testsPassed(8) = all(diff < 1e-10);

%% Check whether all tests were passed
passedAllTests = all(testsPassed);

end