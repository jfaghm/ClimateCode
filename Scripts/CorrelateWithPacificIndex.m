% This script computes pointwise correlations and MIC between the index based on
% location of warmest sst region of the pacific and various climate variables
% such as sst, geopotential height, and mslp.

% Add path to the functions
addpath('../');
% Load the index we developed
load ('../SmallData/PacAnomalyIndex_Apr-Oct_1971-2010.mat');

% Load the erv3sst data set
load /project/expeditions/haasken/data/ERSST/ersstv3.mat
% Compute anomalies from the SST data with a base period of 1971-2000
anomalies = computeAnomalies(erv3sst, erv3Dates, 'basePeriod', [1971 2000]);
% Take seasonal (June-Oct) averages of the anomalies from 1971-2010
seasonalAnomalies = monthlyToSeasonal(anomalies, erv3Dates, 6:10, 1971, 2010);

% Flatten the anomalies into rows of time series
flattenedAnomalies = flattenData(seasonalAnomalies);

% Compute the pointwise correlations and MIC
allCorrelations = rowCorr(flattenedAnomalies, index');
allMIC = rowMIC(flattenedAnomalies, index', '');

% Reshape the results into a grid of the same size as the original data
anomalyCorrGrid = reshape(allCorrelations, size(erv3sst, 1), size(erv3sst, 2));
anomalyMICGrid = reshape(allMIC, size(erv3sst, 1), size(erv3sst, 2));

% Load and reformat the NCEP mslp data
load /project/expeditions/haasken/data/ncep1/mslp_1948-2011.mat
seasonalMSLP = monthlyToSeasonal(mslp, dates, 6:10, 1971, 2010);

% Load and reformat the NCEP geopotential height data
load /project/expeditions/haasken/data/ncep1/gph850_1948-2011.mat
seasonalGPH = monthlyToSeasonal(gph850, dates, 6:10, 1971, 2010);

% Load and reformat the NCEP u wind shear data
load /project/expeditions/haasken/data/ncep1/uwindshear_1948-2012.mat
seasonalShear = monthlyToSeasonal(vws, dates, 6:10, 1971, 2010);

% Compute pointwise correlations and MIC for mslp, gph, and vws
[mslpCorr, mslpMIC] = CorrAndMICGrid( seasonalMSLP, index' );
[gphCorr, gphMIC] = CorrAndMICGrid( seasonalGPH, index' );
[vwsCorr, vwsMIC] = CorrAndMICGrid( seasonalShear, index' );


