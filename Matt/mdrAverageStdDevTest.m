function [mdrSpatialEnsoAverages, mdrNino3_4Averages, mdrHurrAverages]...
    = mdrAverageStdDevTest(varData, dates, lat, lon, label)
%---------------------------Method--------------------------------------
%
%This function gets the positive and negative years for the spatial ENSO
%index, the Nino 3.4 index, and the hurricane counts index by varying the
%standard deviation threshold for which we pick the high and low years.  
%We then composite varData for both high and low years, take the difference
%and then average the difference in composites in the main development region
%
%--------------------------Input----------------------------------------
%
%--->varData - the data that gets composited, this should be a 3
%dimensional matrix (latitude x longitude x time)
%--->dates - matrix containing all of the dates corresponding to varData.
%See the documentation from hoursToDate.m for more details.
%--->lat - the latitude of varData
%--->lon - the longitude of varData
%--->label - a string that contains that name of the varData that is
%composited (used when the image gets printed)
%
%--------------------------Output-----------------------------------------
%
%--->mdrSpatialEnsoAverages - a vector that contains the main
%development averages as described in the Method section for each standard
%deviation
%--->mdrNino3_4Averages - a vector that contains the main
%development averages as described in the Method section for each standard
%deviation



stdDevs = [.25, .50, .6, .7, .8, .85, .9, .95, 1, 1.1, 1.2, 1.3, 1.4];

mdrNino3_4Averages = zeros(length(stdDevs), 1);
mdrSpatialEnsoAverages = zeros(length(stdDevs), 1);
mdrHurrAverages = zeros(length(stdDevs), 1);
addpath('indexExperiment');
if matlabpool('size') == 0
    matlabpool open
end

parfor i = 1:length(stdDevs)
    ninoData = load('matFiles/monthly_nino_data.mat');
    hurdat = load('matFiles/condensedHurDat.mat');
    data = ninoData.data;
    condensedHurDat = hurdat.condensedHurDat;
    
    comboIndex = buildComboIndex(3, 10);
    [nYearsIndex, pYearsIndex] = getPosNegYearsFromVector(comboIndex, stdDevs(i), true);
    
    %[nYearsIndex, pYearsIndex] = getPosNegYearsIndex(3, 10, stdDevs(i));
    [nYearsENSO, pYearsENSO] = posNegNino3_4Years(data, 3, 10, stdDevs(i));
    [nYearsHurr, pYearsHurr] = getPositiveAndNegativeYears(condensedHurDat, stdDevs(i));

    [~,~,diffIndex] = getComposites(varData, pYearsIndex, nYearsIndex, dates, 8, 10);
    [~,~,diffENSO] = getComposites(varData, pYearsENSO, nYearsENSO, dates, 8, 10);
    [~,~,diffHurr] = getComposites(varData, pYearsHurr, nYearsHurr, dates, 8, 10);
    
    mdrSpatialEnsoAverages(i) = atlanticBoxMean(diffIndex, lat, lon);
    mdrNino3_4Averages(i) = atlanticBoxMean(diffENSO, lat, lon);
    mdrHurrAverages(i) = atlanticBoxMean(diffHurr, lat, lon);
end
close all
plot(stdDevs, mdrSpatialEnsoAverages, stdDevs, mdrNino3_4Averages, stdDevs, mdrHurrAverages);
legend('Combination Index', 'NINO3.4', 'Hurricane Counts');
xlabel('Standard Deviation');
ylabel(['Average Difference ' label ' Composite']);
title(['Compare Average Difference ' label ' Composites Varying Std Dev']);
print('-dpdf', '-r400', ['indexExperiment/results/comboIndex/varyingStdDevForComposites/varryingStdDevForComposites' label]);



end
   



