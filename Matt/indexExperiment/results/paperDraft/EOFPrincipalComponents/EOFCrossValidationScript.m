prefix = {'augOct', 'marOct'};
postfix = {'AtlanticBasin', 'PacificBasin', 'JointBasins'};

k = 1;

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat
ccMat = zeros(length(prefix), length(postfix));
for i = 1:length(prefix)
    for j = 1:length(postfix)
        t = load([prefix{i} postfix{j} 'EOFPCs.mat']);
        [ypred, model, cc] = lassoCrossVal(t.PCs, aso_tcs, k);
        save(['crossValidationModels/' prefix{i} postfix{j} 'Leave' num2str(k)...
            'OutCrossValidation.mat'], 'ypred', 'model', 'cc');
        ccMat(i, j) = cc;
    end
end

