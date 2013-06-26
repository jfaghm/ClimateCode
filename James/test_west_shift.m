%test_westward_shift
clear
% %load('ersstv3_1854_2012_raw.mat')
% sst1 = reshape(sst,[],size(sst,3));
% a = detrend(sst1')';
% a = reshape(a, size(sst));
% sst2 = a;
[sstA sstA_dates] = getMonthlyAnomalies(sst2,sstDates,1948,2010);

parfor i =1:12
   [index(i,:), maxI, maxJ, minI, minJ, maxValues, minValues] = buildSSTLon(getAnnualSSTAnomalies(i,i,1979,2010,sstA,sstA_dates),sstLat,sstLon);
end

mean_shift = mean(index,1);
s = regstats(mean_shift,1979:2010);
s.rsquare
s.tstat.pval(2)
scatter(1979:2010,mean_shift)
title_str = 'Scatter for expanded north-south search space';
title([title_str ' r^2 = ' num2str(s.rsquare) ' p = ' num2str(s.tstat.pval(2))])

%% test leadtime correlations
for i=1:10
    parfor j=i:10
           [index, maxI, maxJ, minI, minJ, maxValues, minValues] = buildSSTLon(getAnnualSSTAnomalies(i,i,1979,2010,sstA,sstA_dates),sstLat,sstLon);
           cc(i,j) = corr(index,aso_tcs);
    end
end
cc(cc==0)=NaN;
lead_mat = nanmean(cc,1);
ll = [lead_mat; leads];
bar(abs(ll'))
legend('S-ENSO','NINO1+2','NINO3.4','NINO3','NINO4');

%% test NINO
for i=1:10
    for j = i:10
        nn12 = getNINO(1979,2010,i,j,1);
        nn34 = getNINO(1979,2010,i,j,2);
        nn3 = getNINO(1979,2010,i,j,3);
        nn4 = getNINO(1979,2010,i,j,4);
        cc1(i,j) = corr(nn12',storms_1979');
        cc2(i,j) = corr(nn34',storms_1979');
        cc3(i,j) = corr(nn3',storms_1979');
        cc4(i,j) = corr(nn4',storms_1979');
    end
end
cc1(cc1==0)=NaN;
cc2(cc2==0)=NaN;
cc3(cc3==0)=NaN;
cc4(cc4==0)=NaN;
lead1 = nanmean(cc1,1);
lead2 = nanmean(cc2,1);
lead3 = nanmean(cc3,1);
lead4 = nanmean(cc4,1);
leads = [lead1;lead2;lead3;lead3];