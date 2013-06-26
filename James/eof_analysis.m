% %test EOFs and hurricane data correaltaions and non-linear relationships
load condensedHurDat
% %load augOctAtlanticBasinEOFPCs
% %load augOctJointBasinsEOFPCs
% %load augOctPacificBasinEOFPCs.mat
% load('/project/expeditions/ClimateCodeMatFiles/regression_model_sst_data.mat', 'pacific_indices_mar_oct')
% 
% start_month =8;
% end_month =10;
% min_speed = -8;
% start_year = 1948;
% end_year = 1978;
% min_lat = 5;
% max_lat = 40;
% max_lon = -12;
% min_lon = -100;
% all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
% storms = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);
% 
% 
% 
% corr(storms', pac_pcs_aug_oct(:,1))
% corr(aso_tcs,pac_pcs_aug_oct(:,1))
% 
% predictors = [pacific_indices_mar_oct];
% 
% %% get the cross validation of Pacific inidces alone
% %[~,~,~,~,BmatLeave2Out, intercepts2] = lassoCrossVal(predictors, storms, 2);
% %[~,~,~,~,BmatLeave4Out, intercepts4] = lassoCrossVal(predictors, storms, 4);
% [~,~,~,~,BmatLeave8Out, intercepts8] = lassoCrossVal(predictors, storms, 8);
% leave8OutPred = predictForAllLambdasCrossVal(BmatLeave8Out, predictors, intercepts8);
% for j = 1:size(leave8OutPred, 2)%min([size(leave2OutPred, 2), size(leave4OutPred, 2), size(leave8OutPred, 2)])
%        correlationsLeave8Out(j) = corr(leave8OutPred(:, j), storms');
% end


%% get the EOF for PI and GPI
count =1;
for i=1:3:94 
    dd(:,:,count) = mean(data(:,:,i:i+2),3);
    count = count+1;
end
 latRange = [0, 40];
 lonRange = [280, 345];
row_i = lat >= min(latRange) & lat <= max(latRange);
col_i = lon >= min(lonRange) & lon <= max(lonRange);
dd = dd(row_i,col_i,:);

for i = 1:32
    [maps{i}, PCs(:, i)] = eof(dd, i);
end
