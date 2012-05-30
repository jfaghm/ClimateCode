function test_suite = testGetBoxMeansVsSST
initTestSuite;
end

function setup
addpath('/project/expeditions/haasken/matlab/OptimizeCorr/')
end

function teardown
rmpath('/project/expeditions/haasken/matlab/OptimizeCorr/')
end

function testWithReynoldsSST

load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsSST.mat')

meanSST = getMeanSST(reynoldsSST, reynoldsDates, rGridInfo, [ 25 5 ], [ -90 20 ], 1982, 2010, 6:10, true);

gridInfo.lats = 89.5:-1:-89.5;
gridInfo.lons = [ 0.5:179.5 -179.5:-0.5 ];

[ seasonDates, daysPerMonth ] = getSeasonalDates(1982, 2010, 6:10);
[~, monthIndices] = ismember(seasonDates, reynoldsDates);

boxMean = getBoxMeans( reynoldsSST, gridInfo, monthIndices, daysPerMonth, [ 66 86 ], [ 271 21 ], true);

assertElementsAlmostEqual( meanSST, boxMean );

end
