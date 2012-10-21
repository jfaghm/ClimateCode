dir = '/project/expeditions/ClimateCodeMatFiles/';
addpath('/project/expeditions/lem/ClimateCode/Matt/indexExperiment');
prefix = {'augOct', 'marOct'};
postfix = {'AtlanticBasin', 'PacificBasin', 'JointBasins'};
load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat;
leaveK = [1, 2, 4, 8];

cvDir = ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/'...
    'results/paperDraft/EOFPrincipalComponents/'];

for i = 1:5
    for j = 1:length(leaveK)
        for k = 1:length(postfix)
            t = load([dir 'augOct' postfix{k} 'EOFPCs.mat']);
            [ypred, model, cc] = lassoCrossVal(t.PCs(:, 1:i), aso_tcs, leaveK(j), 0);
            save([cvDir 'crossValidationModels/' 'augOct' postfix{k} 'Leave' ...
                num2str(leaveK(j)) 'OutCrossValidationFirst' num2str(i) ...
                'Components.mat'], 'ypred', 'model', 'cc');
            ccMat(i, j, k) = cc;
        end
    end
end





%{
k = 4;
numPCs = 4;
load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat
ccMat = zeros(length(prefix), length(postfix));
for i = 1:length(prefix)
    for j = 1:length(postfix)
        t = load([dir prefix{i} postfix{j} 'EOFPCs.mat']);
        [ypred, model, cc] = lassoCrossVal(t.PCs(:, 1:numPCs), aso_tcs, k);
        save([dir 'crossValidationModels/' prefix{i} postfix{j} 'Leave' num2str(k)...
            'OutCrossValidation.mat'], 'ypred', 'model', 'cc');
        ccMat(i, j) = cc;
    end
end
%}



