
%% 
addpath('/project/expeditions/lem/ClimateCode/Matt/');
addpath('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/');

%% -----------------------Plot Hurricane Counts 1StdDev--------------------

if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end


load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat
[nYears, pYears] = getPosNegYearsFromVector(aso_tcs, 1, true, 1979);

plotIndividualComposites(vars, nYears, pYears, 'hurricaneCounts', 'AugOct', '1StdDev');

%% --------------------Hurricane Counts 0.8 Std Dev------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat;
[nYears, pYears] = getPosNegYearsFromVector(aso_tcs, 0.8, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'hurricaneCounts', 'AugOct', '0.8StdDev');

%% --------------------Hurricane Counts 1.2 Std Dev------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat
[nYears, pYears] = getPosNegYearsFromVector(aso_tcs, 1.2, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'hurricaneCounts', 'AugOct', '1.2StdDev');

%% -----------Aug-Oct-Atlantic EOF PC 1------------------------------------

if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end

load /project/expeditions/ClimateCodeMatFiles/augOctAtlanticBasinEOFPCs.mat
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'AtlanticBasinEOF1stPC', 'AugOct', '1StdDev');

%% ---------Aug-Oct Atlantic EOF .8 StdDev----------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end

load /project/expeditions/ClimateCodeMatFiles/augOctAtlanticBasinEOFPCs.mat
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 0.8, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'AtlanticBasinEOF1stPC', 'AugOct', '0.8StdDev');

%% ------------------Aug-Oct Atlantic EOF 1.2 Std Dev----------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end

load /project/expeditions/ClimateCodeMatFiles/augOctAtlanticBasinEOFPCs.mat
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1.2, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'AtlanticBasinEOF1stPC', 'AugOct', '1.2StdDev');
%% ---------------Aug-Oct Pacific EOF PC1----------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end

load /project/expeditions/ClimateCodeMatFiles/augOctPacificBasinEOFPCs.mat;
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'PacificBasinEOF1stPC', 'AugOct', '1StdDev');

%% ---------------Aug-Oct Joint Basins PC 1-------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/augOctJointBasinsEOFPCs.mat;
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'JointBasinsEOF1stPC', 'AugOct', '1StdDev');

%% ----------------Mar-Oct Atlantic EOF PC1-------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/marOctAtlanticBasinEOFPCs.mat;
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'AtlanticBasinEOF1stPC', 'MarOct', 'StdDev');

%% --------------Mar-Oct PacificEOF PC1-----------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/marOctPacificBasinEOFPCs.mat
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'PacificBasinEOF1stPC', 'MarOct', '1StdDev');

%% ----------------Mar-Oct Joint Basins PC 1------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/marOctJointBasinsEOFPCs.mat
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'JointBasinsEOF1stPC', 'MarOct', '1StdDev');

%% ----------------EOF Box 1 Std Dev--------------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
ts = getMDRTS('EOF');
[nYears, pYears] = getPosNegYearsFromVector(ts, 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'EOFBox', 'AugOct', '1StdDev');

%% ---------------MDR Box 1 Std Dev---------------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
ts = getMDRTS('MDR');
[nYears, pYears] = getPosNegYearsFromVector(ts, 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'MDRSSTAnomaly', 'AugOct', '1StdDev');

%% -----------------Atlantic Basin 1 Std Dev-------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
ts = getMDRTS('Basin');
[nYears, pYears] = getPosNegYearsFromVector(ts, 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'AtlanticBasinSSTAnomaly', 'AugOct', '1StdDev');

%% --------------------------West African Basin 1 Std Dev------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
ts = getMDRTS('West Africa');
[nYears, pYears] = getPosNegYearsFromVector(ts, 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'WestAfricanBasin', 'AugOct', '1StdDev');

%% ---------------Combo Index 1 StdDev--------------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
index = buildIndexVariations(34, 3, 10);
[nYears, pYears] = getPosNegYearsFromVector(ts, 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'EOFBox', 'AugOct', '1StdDev');

%% ---------------Combo Index 1.2 StdDev--------------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
index = buildIndexVariations(34, 3, 10);
[nYears, pYears] = getPosNegYearsFromVector(ts, 1.2, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'EOFBox', 'AugOct', '1.2StdDev');


