function test_suite = testGetAllBoxData %#ok<*STOUT>
initTestSuite;
end

function setup %#ok<*DEFNU>
addpath('/project/expeditions/haasken/matlab/OptimizeCorr/')
end

function teardown
rmpath('/project/expeditions/haasken/matlab/OptimizeCorr/')
end

% -----------------------------------------------------------------------------
% A test of getting the proper boxes given certain limits
% -----------------------------------------------------------------------------
function testGetProperBoxes

dataLims = struct('north', 5, 'south', -4, 'east', 180, 'west', 36, 'minBoxWidth', 4, 'maxBoxWidth', 4, ...
    'minBoxHeight', 10, 'maxBoxHeight', 10, 'step', 1, 'startYear', 1990, 'endYear', 1994, 'months', 6:10);

dates = zeros(20, 1);
index = 0;
for year = 1990:1993
    for month = 6:10
        index = index + 1;
        dates(index) = year*100 + month;
    end
end

data = NaN(10, 10, 20);
gridInfo.lats = [ 5 4 3 2 1 0 -1 -2 -3 -4 ];
gridInfo.lons = [0:36:180 -144:36:-36];

for i = 1:20
    data(4:8, [9:10 1:3], i) = magic(5) + i;
end

allBoxData = getAllBoxData( data, dates, gridInfo, dataLims, false );

boxLimits = allBoxData(:, 1:4);

expectedBoxLimits = [ 5 -4 36 144; 5 -4 72 180 ];

assertElementsAlmostEqual(boxLimits, expectedBoxLimits)

end
% -----------------------------------------------------------------------------
% A test of getting the proper boxes given certain limits
% -----------------------------------------------------------------------------
function testGetProperBoxes2

dataLims = struct('north', .8, 'south', -3.2, 'east', 175, 'west', -5, 'minBoxWidth', 6, 'maxBoxWidth', 6, ...
    'minBoxHeight', 4, 'maxBoxHeight', 5, 'step', 1, 'startYear', 1990, 'endYear', 1994, 'months', 6:10);

dates = zeros(20, 1);
index = 0;
for year = 1990:1993
    for month = 6:10
        index = index + 1;
        dates(index) = year*100 + month;
    end
end

data = NaN(10, 10, 20);
gridInfo.lats = [ 5 4 3 2 1 0 -1 -2 -3 -4 ];
gridInfo.lons = [0:36:180 -144:36:-36];

for i = 1:20
    data(4:8, [9:10 1:3], i) = magic(5) + i;
end

allBoxData = getAllBoxData( data, dates, gridInfo, dataLims, false );

boxLimits = allBoxData(:, 1:4);

expectedBoxLimits = [ 1 -2 0 180 ; 0 -3 0 180 ; 1 -3 0 180 ];

assertElementsAlmostEqual(boxLimits, expectedBoxLimits)

end
% -----------------------------------------------------------------------------
% A test in which no boxes should be found
% -----------------------------------------------------------------------------
function testGetProperBoxes3

dataLims = struct('north', 5, 'south', 0, 'east', -20, 'west', 40, 'minBoxWidth', 4, 'maxBoxWidth', 4, ...
    'minBoxHeight', 7, 'maxBoxHeight', 7, 'step', 1, 'startYear', 1990, 'endYear', 1994, 'months', 6:10);

dates = zeros(20, 1);
index = 0;
for year = 1990:1993
    for month = 6:10
        index = index + 1;
        dates(index) = year*100 + month;
    end
end

data = NaN(10, 10, 20);
gridInfo.lats = [ 5 4 3 2 1 0 -1 -2 -3 -4 ];
gridInfo.lons = [0:36:180 -144:36:-36];

for i = 1:20
    data(4:8, [9:10 1:3], i) = magic(5) + i;
end


allBoxData = getAllBoxData( data, dates, gridInfo, dataLims, false );

assert( isempty( allBoxData ) )

end

% -----------------------------------------------------------------------------
% A test using the real reynolds data set grid information
% -----------------------------------------------------------------------------
function testGetProperBoxesReynolds

load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsSST.mat')

dataLims = struct('north', 35, 'south', 0, 'east', 40, 'west', 30, 'minBoxWidth', 11, 'maxBoxWidth', 11, ...
    'minBoxHeight', 36, 'maxBoxHeight', 36, 'step', 1, 'startYear', 1990, 'endYear', 1994, 'months', 6:10);

gridInfo.lats = 89.5:-1:-89.5;
gridInfo.lons = [0.5:1:179.5 -179.5:1:-0.5];

allBoxData = getAllBoxData( reynoldsSST, reynoldsDates, gridInfo, dataLims, false );

expectedBoxLimits = [ 35.5 0.5 29.5 39.5 ];

assertElementsAlmostEqual( allBoxData(:, 1:4), expectedBoxLimits )

end

% -----------------------------------------------------------------------------
% Another test using the real reynolds data set grid information
% -----------------------------------------------------------------------------
function testGetProperBoxesReynolds2

load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsSST.mat')

dataLims = struct('north', 35, 'south', -20, 'east', -170, 'west', 170, 'minBoxWidth', 21, 'maxBoxWidth', 21, ...
    'minBoxHeight', 46, 'maxBoxHeight', 56, 'step', 10, 'startYear', 1990, 'endYear', 1994, 'months', 6:10);

gridInfo.lats = 89.5:-1:-89.5;
gridInfo.lons = [0.5:1:179.5 -179.5:1:-0.5];

allBoxData = getAllBoxData( reynoldsSST, reynoldsDates, gridInfo, dataLims, false );

expectedBoxLimits = [ 35.5 -9.5 169.5 -170.5 ; 25.5 -19.5 169.5 -170.5 ; 35.5 -19.5 169.5 -170.5 ];

assertElementsAlmostEqual( allBoxData(:, 1:4), expectedBoxLimits )

end
