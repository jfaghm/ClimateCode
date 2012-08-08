function [mdrSpatialEnsoAverages, mdrNino3_4Averages]...
    = mdrAverageSensitivityTest(varData, lat, lon, dates,lowerBound, upperBound, label)
%-----------------------------Method------------------------------------
%
%This function gets the positive and negative years for the spatial ENSO
%index and the Nino 3.4 index by varying the months for which we average
%the SST anomalies.  We then composite varData for both high and low years,
%take the difference and then average the difference in composites in the
%main development region
%
%-----------------------------Input-------------------------------------
%
%--->varData - the variable for which composite, take the differnce, and
%then average in the main development region.  This should be a three
%dimensional matrix (latitude x longitude x time)
%--->lat - the latitude of varData
%--->lon - the longitude of varData
%--->dates - matrix containing all of the dates corresponding to varData.
%See the documentation from hoursToDate.m for more details.
%--->lowerBound - the lower bound of the average difference in composites
%(used for scaling the image)
%--->upperBound - the upper bound of the average difference in composites
%(used for scaling the image)
%--->label - a string that contains that name of the varData that is
%composited (used when the image gets printed)
%
%-----------------------------Output-------------------------------------
%
%--->mdrSpatialEnsoAverages - a 12 x 12 matrix that contains the main
%development averages as described in the Method section for each month
%range
%--->mdrNino3_4Averages - a 12 x 12 matrix that contains the main
%development averages as described in the Method section for each month
%range



load /project/expeditions/lem/ClimateCode/Matt/matFiles/monthly_nino_data.mat;

mdrSpatialEnsoAverages = zeros(12, 12);
mdrNino3_4Averages = zeros(12, 12);
parfor i = 1:12
    t = load('matFiles/monthly_nino_data.mat');
    data = t.data;
    temp1 = zeros(1, 12);
    temp2 = zeros(1, 12);
    for j = i:12
        index = buildComboIndex(i, j);
        [nYearsIndex, pYearsIndex] = getPosNegYearsFromVector(index, 1, true);
        
        [nYearsENSO, pYearsENSO] = posNegNino3_4Years(data, i, j, 1);
        [~,~, diffIndex] = getComposites(varData, pYearsIndex, nYearsIndex, dates, 8, 10);
        [~,~, diffENSO] = getComposites(varData, pYearsENSO, nYearsENSO, dates, 8, 10);
        temp1(j) = atlanticBoxMean(diffIndex, lat, lon);
        temp2(j) = atlanticBoxMean(diffENSO, lat, lon);
        disp(['j = ' num2str(j)]);
    end
    mdrSpatialEnsoAverages(i, :) = temp1;
    mdrNino3_4Averages(i, :) = temp2;
    disp(['i = ' num2str(i)]);
end
printImages(mdrSpatialEnsoAverages, mdrNino3_4Averages, [lowerBound, upperBound], ...
    label);
end

function [] = printImages(mdrSpatialEnsoAverages, mdrNino3_4Averages, ...
    bounds, label)
if isempty(bounds)
    scale = false;
else
    scale = true;
end

months = {'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'};
subplot(2, 1, 1)
imagesc(mdrSpatialEnsoAverages);
colorbar
if scale == true
    caxis(bounds);
end
title(['Combo Index Averages of Main Development Region ' label]);
set(gca, 'XTick', 1:12);
set(gca, 'YTick', 1:12);
set(gca, 'XTickLabel', months);
set(gca, 'YTickLabel', months);

subplot(2, 1, 2)
imagesc(mdrNino3_4Averages);
colorbar
if scale == true
    caxis(bounds);
end
title(['NINO 3.4 Averages of Main Development Region ' label]);
set(gca, 'XTick', 1:12);
set(gca, 'YTick', 1:12);
set(gca, 'XTickLabel', months);
set(gca, 'YTickLabel', months);
%print('-dpdf', '-r400', ['indexExperiment/results/comboIndex/varyingMonths'...
%    'ForComposites/varryingMonthsForComposites' label]);
end






