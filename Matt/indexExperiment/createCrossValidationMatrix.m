function [ccMatrix, indexMatrix] = createCrossValidationMatrix()
load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
[comboIndex, indexMatrix] = buildComboIndex(3, 10);
sstBoxPressureVal = indexMatrix(:, 1);
sstBoxOLRVal = indexMatrix(:, 2);
minPressureLon = indexMatrix(:, 3);
sstBoxLonDiff = indexMatrix(:, 4);
maxSSTLon = buildIndexVariations(1, 3, 10);
%
%------------------Build Nino indices----------------------------------
%data matrix contains all of the nino data.
%-->column 3 = Nino 1+2
%-->column 5 = Nino 3
%-->column 7 = Nino 4
%-->column 9 = Nino 3.4
load /project/expeditions/lem/ClimateCode/Matt/matFiles/monthly_nino_data.mat;
data = stripData(data);
Nino1_2 = createNinoIndices(data(:, 3));
Nino3 = createNinoIndices(data(:, 5));
Nino4 = createNinoIndices(data(:, 7));
Nino3_4 = createNinoIndices(data(:, 9));
%---------------Build Modoki Indices-------------------------------------
%emi_1870_2010 contains the Modoki Nino data, the first column contains the
%years that the data was taken at
%-->column 2 = Box A
%-->column 3 = Box B
%-->column 4 = Box C
%-->column 5 = EMI(=Box_A-0.5*Box_B-0.5*Box_C)
load /project/expeditions/lem/ClimateCode/Matt/matFiles/emi.mat
emi = stripData(emi_1870_2010);
modokiBoxA = createNinoIndices(emi(:, 2));
modokiBoxB = createNinoIndices(emi(:, 3));
modokiBoxC = createNinoIndices(emi(:, 4));
modokiEMI = createNinoIndices(emi(:, 5));

vars = {'comboIndex', 'sstBoxPressureVal', 'sstBoxOLRVal', 'minPressureLon', ...
    'sstBoxLonDiff', 'maxSSTLon', 'Nino1_2', 'Nino3', 'Nino4', 'Nino3_4', ...
    'modokiBoxA', 'modokiBoxB', 'modokiBoxC', 'modokiEMI'};
hurrStats = {'aso_tcs', 'aso_major_hurricanes', 'aso_pdi', 'aso_ntc', 'aso_ace'};
folds = [1, 2, 4, 8];

indexMatrix = [aso_tcs, aso_major_hurricanes, aso_pdi, aso_ntc, aso_ace, ...
    comboIndex, sstBoxPressureVal, sstBoxOLRVal, minPressureLon, sstBoxLonDiff, ...
    maxSSTLon, Nino1_2, Nino3, Nino4, Nino3_4, modokiBoxA, modokiBoxB, ...
    modokiBoxC, modokiEMI];

%--leave 1, 2, 4, and 8 years out for cross validation
ccMatrix = zeros(length(vars), length(hurrStats), length(folds)+2);
for i = 1:length(vars)
    for j = 1:length(hurrStats)
        for k = 1:length(folds)
            ccMatrix(i, j, k) = kfoldCrossValidate(eval(vars{i}), eval(hurrStats{j}), ...
                folds(k));
        end
    end
end

%----Correlate raw indices with hurricane stats------------------------
for i = 1:length(vars)
    for j = 1:length(hurrStats)
        ccMatrix(i, j, length(folds)+1) = corr(eval(vars{i}), eval(hurrStats{j}));
    end
end

end



function [data] = stripData(data)
    %The first column must contain the years that the data was taken at
    data = data(data(:, 1) >= 1979, :);
    lastYear = find(data(:, 1) == 2010);
    data = data(1:lastYear(end), :);
end

function [index] = createNinoIndices(data)
    %data must contain information from 1979-2010 only
    year = 1;
    index = zeros(length(data)/12, 1);
    for i = 1:12:length(data)
        index(year) = mean(data(i+2:i+9));
        year = year+1;
    end
end




