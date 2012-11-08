% analyze all correlations

%% load data
load condensedHurDat
load monthly_nino_data
load amm.mat
load PDO


%% Build the TC dataset
start_month =8;
end_month =10;
min_speed = -8;
start_year = 1979;
end_year = 2010;
min_lat = 5;
max_lat = 40;
max_lon = -12;
min_lon = -100;
all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
storms = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);


%% build NINO data
nino12_col = 4;
nino34_col = 10;
nino3_col = 6;
nino4_col = 8;

nino34 = data((data(:,1)>=start_year & data(:,1) <=end_year & data(:,2)>=8 & data(:,2)<=10),[1 2 nino34_col]);
nino12 = data((data(:,1)>=start_year & data(:,1) <=end_year & data(:,2)>=8 & data(:,2)<=10),[1 2 nino12_col]);
nino3 = data((data(:,1)>=start_year & data(:,1) <=end_year & data(:,2)>=8 & data(:,2)<=10),[1 2 nino3_col]);
nino4 = data((data(:,1)>=start_year & data(:,1) <=end_year & data(:,2)>=8 & data(:,2)<=10),[1 2 nino4_col]);
yrs = unique(nino34(:,1));
for i =1:length(yrs) 
    nino34_aso(i) = mean(nino34(nino34(:,1)==yrs(i),3)); 
    nino12_aso(i) = mean(nino12(nino12(:,1)==yrs(i),3)); 
    nino3_aso(i) = mean(nino3(nino3(:,1)==yrs(i),3)); 
    nino4_aso(i) = mean(nino4(nino4(:,1)==yrs(i),3)); 
end

nino34 = data((data(:,1)>=start_year & data(:,1) <=end_year & data(:,2)>=3 & data(:,2)<=10),[1 2 nino34_col]);
nino12 = data((data(:,1)>=start_year & data(:,1) <=end_year & data(:,2)>=3 & data(:,2)<=10),[1 2 nino12_col]);
nino3 = data((data(:,1)>=start_year & data(:,1) <=end_year & data(:,2)>=3 & data(:,2)<=10),[1 2 nino3_col]);
nino4 = data((data(:,1)>=start_year & data(:,1) <=end_year & data(:,2)>=3 & data(:,2)<=10),[1 2 nino4_col]);
for i =1:length(yrs) 
    nino34_mo(i) = mean(nino34(nino34(:,1)==yrs(i),3)); 
    nino12_mo(i) = mean(nino12(nino12(:,1)==yrs(i),3)); 
    nino3_mo(i) = mean(nino3(nino3(:,1)==yrs(i),3)); 
    nino4_mo(i) = mean(nino4(nino4(:,1)==yrs(i),3)); 
end

%% build AMM data
amm = AMM(AMM(:,1)>=start_year & AMM(:,1)<=end_year, 9:11);
amm_aso = mean(amm,2);
amm = AMM(AMM(:,1)>=start_year & AMM(:,1)<=end_year, 4:11);
amm_mo = mean(amm,2);

%% load EOF data
atl_aso = load('augOctAtlanticBasinEOFPCs');
pac_aso = load('augOctPacificBasinEOFPCs');
joint_aso = load('augOctPacificBasinEOFPCs');

atl_mo = load('marOctAtlanticBasinEOFPCs');
pac_mo = load('marOctPacificBasinEOFPCs');
joint_mo = load('marOctPacificBasinEOFPCs');

%% load Pacific index data
load('regression_model_sst_data','combo_index_aug_oct','combo_index_mar_oct','pacific_indices_aug_oct','pacific_indices_mar_oct');

%% build correlation matrix
combo_index_mar_oct = sum((pacific_indices_mar_oct),2);
predictors = [nino34_aso' nino12_aso' nino3_aso' nino4_aso' nino34_mo' nino12_mo' nino3_mo' nino4_mo' amm_aso amm_mo augOctPDO marOctPDO...
    atl_aso.PCs(:,1:5) pac_aso.PCs(:,1:5) joint_aso.PCs(:,1:5) atl_mo.PCs(:,1:5) pac_mo.PCs(:,1:5) joint_mo.PCs(:,1:5) pacific_indices_aug_oct pacific_indices_mar_oct combo_index_aug_oct combo_index_mar_oct storms'];

for i=1:size(predictors,2)
    for j=1:size(predictors,2)
        cc(i,j) = corr(predictors(:,i),predictors(:,j));
    end
end
