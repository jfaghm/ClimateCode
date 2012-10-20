%% -----------------------Plot Hurricane Counts-----------------------------

if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
addpath('/project/expeditions/lem/ClimateCode/Matt/');
addpath('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/');

load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat
[nYears, pYears] = getPosNegYearsFromVector(aso_tcs, 1, true, 1979);

plotIndividualComposites(vars, nYears, pYears, 'hurricaneCounts', 'AugOct', '1StdDev');

%% 
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat;
[nYears, pYears] = getPosNegYearsFromVector(aso_tcs, 0.8, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'hurricaneCounts', 'AugOct', '0.8StdDev');

%% 
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
plotIndividualComposites(vars, nYears, pYears, 'AtlanticBasinEOF1stPC', 'AugOct');

%% 
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end

load /project/expeditions/ClimateCodeMatFiles/augOctAtlanticBasinEOFPCs.mat
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 0.8, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'AtlanticBasinEOF1stPC', 'AugOct', '0.8StdDev');

%%
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
plotIndividualComposites(vars, nYears, pYears, 'PacificBasinEOF1stPC', 'AugOct');

%% ---------------Aug-Oct Joint Basins PC 1-------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/augOctJointBasinsEOFPCs.mat;
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'JointBasinsEOF1stPC', 'AugOct');

%% ----------------Mar-Oct Atlantic EOF PC1-------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/marOctAtlanticBasinEOFPCs.mat;
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'AtlanticBasinEOF1stPC', 'MarOct');

%% --------------Mar-Oct PacificEOF PC1-----------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/marOctPacificBasinEOFPCs.mat
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'PacificBasinEOF1stPC', 'MarOct');

%% ----------------Mar-Oct Joint Basins PC 1------------------------------
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
load /project/expeditions/ClimateCodeMatFiles/marOctJointBasinsEOFPCs.mat
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'JointBasinsEOF1stPC', 'MarOct');



