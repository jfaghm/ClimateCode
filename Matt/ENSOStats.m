
if ~exist('dataLoaded', 'var') || dataLoaded == false
    load condensedHurDat.mat;
    load ENSOType.mat;
end
hurricanes = condensedHurDat(condensedHurDat(:, 1) >= 1950, :);
%only use tropical storms and greater
hurricanes = hurricanes(hurricanes(:, 10) >= 0, :);
%exclude tropical storms
if exist('OnlyHurricanes', 'var') && OnlyHurricanes == true
    hurricanes = hurricanes(hurricanes(:, 10) >= 1, :);
end
%only get the hurricanes that are classified 3 - 5
if exist('MajorHurricanesOnly', 'var') && MajorHurricanesOnly == true 
    hurricanes = hurricanes(hurricanes(:, 10) >= 3, :);
end  

numYearsElNino = sum(ENSOType(:) == 1);
numYearsNeutral = sum(ENSOType(:) == 0);
numYearsLaNina = sum(ENSOType(:) == -1);

baseYear = 1950; %base year for ENSO type data
eIndex = 1; nIndex = 1; lIndex = 1;
for i = 1:size(ENSOType, 1)
    yearOfHurricane = baseYear + i - 1;
    currentHurricanes = hurricanes(hurricanes(:, 1) == yearOfHurricane, :);
    if exist('OnlyHurricanes', 'var') && OnlyHurricanes == true
        currentHurricanes = currentHurricanes(currentHurricanes(:, 10) >= 1, :);
    end
    if exist('MajorHurricanesOnly', 'var') && MajorHurricanesOnly == true
        currentHurricanes = currentHurricanes(currentHurricanes(:, 10) >= 3, :);
    end
    switch ENSOType(i)
        case 1
            ElNinoHurricanes(eIndex) = numelements(currentHurricanes);
            eIndex = eIndex+1;
        case 0
            NeutralHurricanes(nIndex) = numelements(currentHurricanes);
            nIndex = nIndex+1;
        case -1
            LaNinaHurricanes(lIndex) = numelements(currentHurricanes);
            lIndex = lIndex+1;
    end
end

averageElNino = sum(ElNinoHurricanes)/size(ElNinoHurricanes, 2);
averageNeutral = sum(NeutralHurricanes)/ size(NeutralHurricanes, 2);
averageLaNina = sum(LaNinaHurricanes)/ size(LaNinaHurricanes, 2);
y = [averageElNino, averageNeutral, averageLaNina];
e = [std(ElNinoHurricanes), std(NeutralHurricanes), std(LaNinaHurricanes)];














