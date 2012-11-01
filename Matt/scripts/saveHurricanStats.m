load /project/expeditions/ClimateCodeMatFiles/condensedHurDat.mat;

hurricanes = condensedHurDat(condensedHurDat(:, 1) >= 1979 & condensedHurDat(:, 1) <= 2010, :);



