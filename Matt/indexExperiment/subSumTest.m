addpath('/project/expeditions/lem/ClimateCode/sst_project/');

a = ones(5, 5) * 10;

b = sub_sum(a, 2, 2);

c = b(1+1:end-1, 1+1:end-1) ./ (4);

