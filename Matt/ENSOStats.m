function [ElNinoHurricanes, NeutralHurricanes, LaNinaHurricanes, averageElNino, averageNeutral, averageLaNina] =...
    ENSOStats(hurCategory)
%This function is used to calculate the average number of hurricanes that
%occured in El Nino years, Neutral years, and La Nina years.
%
%------------------------Input-------------------------------------------
%
%--->hurCategory - the smallest category hurricane that should be included
%in the calculation, 0 = tropical cyclones, and 1-5 correspond to hurricane
%categories.  See condensedHurDat.mat labels matrix for other categories.
%
%-----------------------Output--------------------------------------------
%
%--->AverageElNino - average number of hurricanes that occured during El
%Nino phases
%--->AverageNeutral - average number of hurricanes that occured during
%Neutral phases
%--->AveargeLaNina - average number of hurricanes that occured during La
%Nina phases.
load /project/expeditions/ClimateCodeMatFiles/condensedHurDat.mat;
%load /project/expeditions/lem/ClimateCode/Matt/matFiles/ENSOType.mat
load /project/expeditions/ClimateCodeMatFiles/ENSOTypeWithWeakPhases.mat

baseYear = 1979;
endYear = 2010;

years = 1950:2011;

hurricanes = condensedHurDat(condensedHurDat(:, 1) >= baseYear & ...
    condensedHurDat(:, 1) <= endYear & condensedHurDat(:, 10) >= hurCategory, :);

eIndex = 1; nIndex = 1; lIndex = 1;

ENSOType = ENSOType(years >= baseYear & years <= endYear);

ElNinoHurricanes = zeros(numelements(find(ENSOType == 1)), 1);
NeutralHurricanes = zeros(numelements(find(ENSOType == 0)), 1);
LaNinaHurricanes = zeros(numelements(find(ENSOType == -1)), 1);

for i = 1:length(ENSOType)
    currentYear = baseYear + i - 1;
    currentHurricanes = hurricanes(hurricanes(:, 1) == currentYear, :);
    switch ENSOType(i)
        case 1
            ElNinoHurricanes(eIndex) = numelements(currentHurricanes);
            eIndex = eIndex + 1;
        case 0
            NeutralHurricanes(nIndex) = numelements(currentHurricanes);
            nIndex = nIndex + 1;
        case -1
            LaNinaHurricanes(lIndex) = numelements(currentHurricanes);
            lIndex = lIndex+1;
    end
end

eIndex = eIndex-1
nIndex = nIndex-1
lIndex = lIndex-1

averageElNino = sum(ElNinoHurricanes)/length(ElNinoHurricanes)
averageNeutral = sum(NeutralHurricanes)/ length(NeutralHurricanes)
averageLaNina = sum(LaNinaHurricanes)/ length(LaNinaHurricanes)

elNinoStd = std(ElNinoHurricanes)
neutralStd = std(NeutralHurricanes)
laNinaStd = std(LaNinaHurricanes)
%end
