%test SST boxes and FSS

%load /project/expeditions/haasken/data/ERSST/ersstv3.mat
%fire_mat = reshape(fss_aggregate,[],10);

for r=1:121
    fire_ts = fire_mat(r,:);
for i=1:10
        dataLims = struct('west', -70, 'east', -10, 'north', 60, 'south', 5, ...
            'minWidth', 10, 'maxWidth', 30, 'minHeight', 5, 'maxHeight',25, 'step', 1, ...
            'months', i:i+2, 'startYear', 2000, 'endYear', 2009);
        
        eatlBoxSST = getAllBoxData(erv3sst, erv3Dates, erv3GridInfo, dataLims);
       
        
        cc =rowCorr(eatlBoxSST(:,5:end),fire_ts);
        [v(i),ind] = max(abs(cc));
        box(i,:) = eatlBoxSST(ind,1:4);
        path = strcat('/project/expeditions/jfagh/data/fires/sst_results/region',num2str(r),'.mat');
        save(path,'v','box');
   
end
end

 
 
 
 