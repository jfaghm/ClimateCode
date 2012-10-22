
addpath('/project/expeditions/ClimateCodeMatFiles/');
load asoHurricaneStats
load regression_model_sst_data.mat


useIndices = [1, 2, 3, 4];

sst_predictors = [pacific_indices_mar_oct pacific_indices_aug_oct combo_index_mar_oct combo_index_aug_oct...
               pac_pcs_aug_oct atl_pcs_aug_oct sst_anomaly_boxes_may_july(:,6:end)' sst_anomaly_boxes_aug_oct(:,6:end)'...
               rel_sst_box_may_july(:,6:end)' rel_sst_box_aug_oct(:,6:end)' gpi_boxes_may_july(:,6:end)' gpi_boxes_aug_oct(:,6:end)'  ];
%keep track where each predictor came from by keeping an index and a
%corresonponding list of labels
labels = {'pacific_indices_mar_oct', 'pacific_indices_aug_oct', 'combo_index_mar_oct', 'combo_index_aug_oct',...
       'pac_pcs_aug_oct', 'atl_pcs_aug_oct', 'sst_anomaly_boxes_may_july', 'sst_anomaly_boxes_aug_oct',...
       'rel_sst_box_may_july', 'rel_sst_box_aug_oct','gpi_boxes_may_july','gpi_boxes_aug_oct'};
   
formattedLabels = {'Pacific Indices Mar-Oct', 'Pacific Indices Aug-oct', ...
    'Combo Index Mar-Oct', 'Comobo Index Aug-Oct', 'Pacific PCs Aug-Oct', ...
    'Atlantic PCs Aug-Oct', 'SST Anomaly Boxes May-Jul', 'SST Anomaly Boxes Aug-Oct', ...
    'Relative SST Boxes May-Jul', 'Relative SST Boxes Aug-Oct', 'GPI Boxes May-Jul', ...
    'GPI Boxes Aug-Oct'};
   
   
sizes = [5, 5, 1, 1, 32, 32, 108, 108, 108, 108, 2930, 2930];

k = [4, 8];
useVars = [10, 5, 2];

%% 
for i = 1:length(k)
    for j = 1:length(useVars)
   %     [ypred{i, j}, model{i, j}, cc(i, j), mse{i, j}] = lassoCrossVal(sst_predictors, aso_tcs, k(i), useVars(j));
    end
end

%% 

options = statset('UseParallel', 'always');

for i = 1:length(useVars)
    [B{i}, fitInfo{i}] = lasso(sst_predictors, aso_tcs, 'Options', options, 'DFMax', useVars(i));
end
       

for i = 1:length(B)
    nonzero = find(B{i}(:, 1) ~= 0);
    count = 1;
    for j = 1:length(nonzero)
        [offset, set] = findBoxIndex(sizes, nonzero(j));
        if set <= 6
            continue
        end
        boxCorrdinates = eval([labels{set} '(offset, 2:5)']);
        plotBox(boxCorrdinates(1:2), boxCorrdinates(3:4), formattedLabels{set}, count, useVars(i));
        count = count+1;
    end
end









