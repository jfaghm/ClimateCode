% %compute the lasso regression for various SST regions and comboIndex
% load regression_model_sst_data.mat;
% load asoHurricaneStats.mat
% 
% sst_predictors = [pacific_indices_mar_oct pacific_indices_aug_oct combo_index_mar_oct combo_index_aug_oct...
%                   pac_pcs_aug_oct atl_pcs_aug_oct sst_anomaly_boxes_may_july(:,6:end)' sst_anomaly_boxes_aug_oct(:,6:end)'...
%                   rel_sst_box_may_july(:,6:end)' rel_sst_box_aug_oct(:,6:end)' gpi_boxes_may_july(:,6:end)' gpi_boxes_aug_oct(:,6:end)'  ];
% %keep track where each predictor came from by keeping an index and a
% %corresonponding list of labels
% labels = {'pacific_indices_mar_oct' 'pacific_indices_aug_oct' 'combo_index_mar_oct' 'combo_index_aug_oct'...
%           'pac_pcs_aug_oct' 'atl_pcs_aug_oct' 'sst_anomaly_boxes_may_july' 'sst_anomaly_boxes_aug_oct'...
%           'rel_sst_box_may_july' 'rel_sst_box_aug_oct''gpi_boxes_may_july''gpi_boxes_aug_oct'};
% predictor_index(1:size(pacific_indices_mar_oct,2))=1;
% predictor_index(end+1:end+size(pacific_indices_aug_oct,2))=2;

tic
max_vars=[10,5,2,1];
options = statset('UseParallel','always');
for i =1:length(max_vars)
    [B,FitInfo] = lasso(sst_predictors,aso_tcs,'DFMax',max_vars(i),'CV',10,'Options',options);
    best_index(i) = FitInfo.Index1SE;
    best_weights(:,i) = B(:,best_index(i));
    best_mse(i) = FitInfo.MSE(best_index(i));
    best_lambda(i) = FitInfo.LambdaMinMSE;
    best_se(i) = FitInfo.SE(best_index(i));
end
toc