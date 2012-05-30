function test_suite = testGetBoxMeans %#ok<*STOUT>
initTestSuite;
end

function setup
addpath('/project/expeditions/haasken/matlab/OptimizeCorr/')
end

function teardown
rmpath('/project/expeditions/haasken/matlab/OptimizeCorr/')
end

% ----------------------------------------------------------------------------
% Test for a simple region (one that does not cross the edge of the grid)
% with simple data.  Tests without weighting by area.
% ----------------------------------------------------------------------------
function testSimpleBoxUnweighted %#ok<*DEFNU>

data = NaN(10, 10, 20);
gridInfo.lats = [ 5 4 3 2 1 0 -1 -2 -3 -4 ];
gridInfo.lons = 0:36:(360-36);

for i = 1:20
    data(3:6, 5:10, i) = repmat(300, 4, 6) + i;
end

monthIndices = reshape(1:20, 5, 4);
daysPerMonth = repmat( [30 31 31 30 31]', 1, 4 );

rows = [ 3 6 ];
cols = [ 5 10 ];

boxMeans = getBoxMeans(data, gridInfo, monthIndices, daysPerMonth, rows, cols, false);

expectedMeans = sum(reshape( 301:320, 5, 4 ) .* daysPerMonth, 1) ./ sum(daysPerMonth, 1);

assertElementsAlmostEqual(boxMeans, expectedMeans);

end
% ----------------------------------------------------------------------------
% Test for a simple region (one that does not cross the edge of the grid)
% with simple data.  Tests with weighting by area.
% ----------------------------------------------------------------------------
function testSimpleBoxWeighted

data = NaN(10, 10, 20);
gridInfo.lats = [ 5 4 3 2 1 0 -1 -2 -3 -4 ];
gridInfo.lons = 0:36:(360-36);

for i = 1:20
    data(3:6, 5:10, i) = repmat(300, 4, 6) + i;
end

monthIndices = reshape(1:20, 5, 4);
daysPerMonth = repmat( [30 31 31 30 31]', 1, 4 );

rows = [ 3 6 ];
cols = [ 5 10 ];

boxMeans = getBoxMeans(data, gridInfo, monthIndices, daysPerMonth, rows, cols, true);

expectedMeans = sum(reshape( 301:320, 5, 4 ) .* daysPerMonth, 1) ./ sum(daysPerMonth, 1);

assertElementsAlmostEqual(boxMeans, expectedMeans);

end
% ----------------------------------------------------------------------------
% Test for a simple region (one that does not cross the edge of the grid)
% with magic data.  Tests without weighting by area.
% ----------------------------------------------------------------------------
function testSimpleBoxUnweighted2

data = NaN(10, 10, 20);
gridInfo.lats = [ 5 4 3 2 1 0 -1 -2 -3 -4 ];
gridInfo.lons = 0:36:(360-36);

for i = 1:20
    data(4:8, 4:8, i) = magic(5) + i;
end

monthIndices = reshape(1:20, 5, 4);
daysPerMonth = repmat( [30 31 31 30 31]', 1, 4 );

rows = [ 4 8 ];
cols = [ 4 8 ];

boxMeans = getBoxMeans(data, gridInfo, monthIndices, daysPerMonth, rows, cols, false);

expectedMeans = sum(reshape( 14:33, 5, 4 ) .* daysPerMonth, 1) ./ sum(daysPerMonth, 1);

assertElementsAlmostEqual(boxMeans, expectedMeans);

end
% ----------------------------------------------------------------------------
% Test for a simple region (one that does not cross the edge of the grid)
% with magic data.  Tests with weighting by area.
% ----------------------------------------------------------------------------
function testSimpleBoxWeighted2

data = NaN(10, 10, 20);
gridInfo.lats = [ 5 4 3 2 1 0 -1 -2 -3 -4 ];
gridInfo.lons = 0:36:(360-36);

for i = 1:20
    data(4:8, 4:8, i) = magic(5) + i;
end

monthIndices = reshape(1:20, 5, 4);
daysPerMonth = repmat( [30 31 31 30 31]', 1, 4 );

rows = [ 4 8 ];
cols = [ 4 8 ];

boxMeans = getBoxMeans(data, gridInfo, monthIndices, daysPerMonth, rows, cols, true);

weight = repmat( cos( (2:-1:-2)' *pi/180 ), 1, 5 );
expStart = sum(sum(magic(5) .* weight)) / sum(weight(:));

expectedMeans = sum(reshape( (expStart+1):(expStart+20), 5, 4 ) .* daysPerMonth, 1) ./ sum(daysPerMonth, 1);

assertElementsAlmostEqual(boxMeans, expectedMeans);

end
% ----------------------------------------------------------------------------
% Test for an overlapping region (one that does cross the edge of the grid)
% with magic data.  Tests without weighting by area.
% ----------------------------------------------------------------------------
function testOverlapBoxUnweighted

data = NaN(10, 10, 20);
gridInfo.lats = [ 5 4 3 2 1 0 -1 -2 -3 -4 ];
gridInfo.lons = 0:36:(360-36);

for i = 1:20
    data(4:8, [9:10 1:3], i) = magic(5) + i;
end

monthIndices = reshape(1:20, 5, 4);
daysPerMonth = repmat( [30 31 31 30 31]', 1, 4 );

rows = [ 4 8 ];
cols = [ 9 3 ];

boxMeans = getBoxMeans(data, gridInfo, monthIndices, daysPerMonth, rows, cols, false);

expectedMeans = sum(reshape( 14:33, 5, 4 ) .* daysPerMonth, 1) ./ sum(daysPerMonth, 1);

assertElementsAlmostEqual(boxMeans, expectedMeans);

end
% ----------------------------------------------------------------------------
% Test for an overlapping region (one that does cross the edge of the grid)
% with magic data.  Tests with weighting by area.
% ----------------------------------------------------------------------------
function testOverlapBoxWeighted

data = NaN(10, 10, 20);
gridInfo.lats = [ 5 4 3 2 1 0 -1 -2 -3 -4 ];
gridInfo.lons = 0:36:(360-36);

for i = 1:20
    data(4:8, [9:10 1:3], i) = magic(5) + i;
end

monthIndices = reshape(1:20, 5, 4);
daysPerMonth = repmat( [30 31 31 30 31]', 1, 4 );

rows = [ 4 8 ];
cols = [ 9 3 ];

boxMeans = getBoxMeans(data, gridInfo, monthIndices, daysPerMonth, rows, cols, true);

weight = repmat( cos( (2:-1:-2)' *pi/180 ), 1, 5 );
expStart = sum(sum(magic(5) .* weight)) / sum(weight(:));

expectedMeans = sum(reshape( (expStart+1):(expStart+20), 5, 4 ) .* daysPerMonth, 1) ./ sum(daysPerMonth, 1);

assertElementsAlmostEqual(boxMeans, expectedMeans);

end
