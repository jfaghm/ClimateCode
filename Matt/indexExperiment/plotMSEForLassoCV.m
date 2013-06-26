

postFix = {'augOctAtlanticBasinEOFPCs.mat', 'marOctAtlanticBasinEOFPCs.mat', ...
    'augOctPacificBasinEOFPCs.mat', 'marOctPacificBasinEOFPCs.mat', ...
    'augOctJointBasinsEOFOCs.mat', 'marOctJointBasinsEOFPCs.mat'};
region = {'Aug-Oct Atlantic Basin', 'Mar-Oct Atlantic Basin', 'Aug-Oct Pacific Basin', ...
    'Mar-Oct Pacific Basin', 'Aug-Oct Joint Basins', 'Mar-Oct Joint Basins'};

for i = 1:length(region)
    eofData = load(['/project/expeditions/ClimateCodeMatFiles/' postFix{1}]);
    load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat;

    mse = zeros(8, 32);
    for j = 1:32
        [ypred, model, cc, mse(:, j)] = lassoCrossVal(eofData.PCs(:, 1:j), aso_tcs, 4);
    end

    errorbar(mean(mse), std(mse, 0, 1), 'x');
    title(['MSE for Cross Validation of First n Principal Components ' region{i}])
    ylabel('MSE')
    xlabel('Number of Principal Components Used');
    saveDir = ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/'...
        'results/paperDraft/EOFPrincipalComponents/MSEPLots/'];
    saveas(gcf, [saveDir region{i} 'MSEPlot.pdf'], 'pdf');
end

