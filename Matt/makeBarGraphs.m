function [  ] = makeBarGraphs(indexType )
%This function is used to create bar graphs for average difference of each
%of the composites for the atlantic region
% 
%-------------------------Input-----------------------------------------
%
%--->indexType - a string that specifies which index we should be using to
%make the bar graph for.
%
%-------------------------Output-----------------------------------------
%
%--->none, the bar graphs get printed inside the function to the directory
%specified inside the call to print

switch indexType
    case 'ENSO'
        load composites/ENSO_3.4/centralPresCompsites.mat;
    case 'AMO'
        load composites/AMO/CentralPressureComposite.mat;
    case 'SOI'
        load composites/SOI/CentralPressureComposite.mat
    case 'NAO'
        load composites/NAO/CentralPressureComposite.mat;
    case 'EPNP'
        load composites/EPNP/CentralPressureComposite.mat;
    case 'QBO'
        load composites/QBO/CentralPressureComposite.mat;
    case 'PNA'
        load composites/PNA/CentralPressureComposite.mat;
    case 'OLR'
        load composites/OLR/CentralPressureComposite.mat;
    case 'Index2'
        load composites/index2/CentralPressureComposite.mat;
    otherwise
        error('Index type not recognized');
end
load composites/hurricaneFrequency/centralPresComposites.mat;
load composites/index/centralPresComposites.mat;
var = 'Central Pressure';
eval(['atlanticBoxMean(diffIndex, diff' indexType ',  indexType , diffHurr, var);']);
print('-dpdf', '-r400', ['composites/barGraphs/' indexType '/avgDiffCentralPressure' indexType 'BarGraph']);
eval(['clear diffIndex diff' indexType ' diffHurr ;']);
load composites/hurricaneFrequency/PIComposites.mat
load composites/index/PIComposites.mat;
switch indexType
    case 'ENSO'
        load composites/ENSO_3.4/PIComposites.mat
    case 'AMO'
        load composites/AMO/PIComposite.mat
    case 'SOI'
        load composites/SOI/PIComposite.mat
    case 'NAO'
        load composites/NAO/PIComposite.mat;
    case 'EPNP'
        load composites/EPNP/PIComposite.mat;
    case 'QBO'
        load composites/QBO/PIComposite.mat;
    case 'PNA'
        load composites/PNA/PIComposite.mat;
    case 'OLR'
        load composites/OLR/PIComposite.mat;
    case 'Index2'
        load composites/index2/PIComposite.mat;
    otherwise
        error('Index type not recognized.');
end
var = 'PI';
eval(['atlanticBoxMean(diffIndex, diff' indexType ', indexType, diffHurr, var);']);
print('-dpdf', '-r400', ['composites/barGraphs/' indexType '/avgDiffPI' indexType 'BarGraph']);
eval(['clear diffIndex diff' indexType ' diffHurr']);
switch indexType
    case 'ENSO'
        load composites/ENSO_3.4/relativeHumidityComposites.mat;
    case 'AMO'
        load composites/AMO/relativeHumidityComposite.mat;
    case 'SOI'
        load composites/SOI/relativeHumidityComposite.mat;
    case 'NAO'
        load composites/NAO/relativeHumidityComposite.mat;
    case 'EPNP'
        load composites/EPNP/relativeHumidityComposite.mat;
    case 'QBO'
        load composites/QBO/relativeHumidityComposite.mat;
    case 'PNA'
        load composites/PNA/relativeHumidityComposite.mat;
    case 'OLR'
        load composites/OLR/relativeHumidityComposite.mat;
    case 'Index2'
        load composites/index2/relativeHumidityComposite.mat;
    otherwise
        error('Index type not recognized');
end
load composites/index/relativeHumidityComposites.mat;
load composites/hurricaneFrequency/relativeHumidityComposites.mat;
var = 'RH';
eval(['atlanticBoxMean(diffIndex, diff' indexType ', indexType, diffHurr, var);']);
print('-dpdf', '-r400', ['composites/barGraphs/' indexType '/avgDiffRelativeHumidity' indexType 'BarGraph']);
eval(['clear diffIndex diff' indexType ' diffHurr']);
switch indexType
    case 'ENSO'
        load composites/ENSO_3.4/sstComposites.mat;
    case 'AMO'
        load composites/AMO/sstComposite.mat;
    case 'SOI'
        load composites/SOI/sstComposite.mat;
    case 'NAO'
        load composites/NAO/sstComposite.mat;
    case 'EPNP'
        load composites/EPNP/sstComposite.mat;
    case 'QBO'
        load composites/QBO/sstComposite.mat;
    case 'PNA'
        load composites/PNA/sstComposite.mat;
    case 'OLR'
        load composites/OLR/sstComposite.mat;
    case 'Index2'
        load composites/index2/sstComposite.mat;
    otherwise
        error('Index type not recognized.');
end
load composites/index/sstComposites.mat;
load composites/hurricaneFrequency/sstComposites.mat;
var = 'SST';
eval(['atlanticBoxMean(diffIndex, diff' indexType ', indexType, diffHurr, var);']);
print('-dpdf', '-r400', ['composites/barGraphs/' indexType '/avgDiffSST' indexType 'BarGraph']);
eval(['clear diffIndex diff' indexType ' diffHurr']);
switch indexType
    case 'ENSO'
        load composites/ENSO_3.4/windShearComposite.mat;
    case 'AMO' 
        load composites/AMO/windShearComposite.mat;
    case 'SOI'
        load composites/SOI/windShearComposite.mat
    case 'NAO'
        load composites/NAO/windShearComposite.mat
    case 'EPNP'
        load composites/EPNP/windShearComposite.mat;
    case 'QBO'
        load composites/QBO/windShearComposite.mat;
    case 'PNA'
        load composites/PNA/windShearComposite.mat;
    case 'OLR'
        load composites/OLR/windShearComposite.mat;
    case 'Index2'
        load composites/index2/windShearComposite.mat;
    otherwise
        error('Index type not recognized');
end
load composites/index/windShearComposite.mat;
load composites/hurricaneFrequency/windShearComposite.mat;
var = 'Wind Shear';
eval(['atlanticBoxMean(diffIndex, diff' indexType ', indexType, diffHurr, var);']);
print('-dpdf', '-r400', ['composites/barGraphs/' indexType '/avgDiffWindShear' indexType 'BarGraph']);




end

