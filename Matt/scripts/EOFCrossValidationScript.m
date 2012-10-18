dir = '/project/expeditions/lem/ClimateCode/Matt/indexExperiment/results/paperDraft/EOFPrincipalComponents/';
addpath('/project/expeditions/lem/ClimateCode/Matt/indexExperiment');
prefix = {'augOct', 'marOct'};
postfix = {'AtlanticBasin', 'PacificBasin', 'JointBasins'};

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



