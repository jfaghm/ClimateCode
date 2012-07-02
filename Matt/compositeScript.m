load matFiles/condensedHurDat.mat;
[nYears, pYears] = getPositiveAndNegativeYears(condensedHurDat);
createComposites('Hurr', 'composites/hurricaneFrequency', pYears, nYears);
load matFiles/monthly_nino_data.mat;
[nYears, pYears] = posNegNino3_4Years(data, 3, 10);
createComposites('ENSO', 'composites/ENSO_3.4', pYears, nYears);
[nYears, pYears] = getPosNegYearsAMO();
createComposites('AMO', 'composites/AMO', pYears, nYears);
[nYears, pYears] = getPosNegYearsEPNP();
createComposites('EPNP', 'composites/EPNP', pYears, nYears);
[nYears, pYears] = getPosNegYearsIndex();
createComposites('Index', 'composites/index', pYears, nYears);
[nYears, pYears] = getPosNegYearsNAO();
createComposites('NAO', 'composites/NAO', pYears, nYears);
[nYears, pYears] = getPosNegYearsSOI();
createComposites('SOI', 'composites/NAO', pYears, nYears);


