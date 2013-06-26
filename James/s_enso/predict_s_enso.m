%forecast June-Oct S-ENSO
%load('ersstv3_1854_2012_raw.mat')
[sstA sstA_dates] = getMonthlyAnomalies(sst,sstDates,1979,2010);
annualSST = getAnnualSSTAnomalies(6,10, 1979, 2010, sstA, sstA_dates);
%build June-Oct index
[index_jun_oct, maxI__jun_oct, maxJ__jun_oct, minI__jun_oct, minJ__jun_oct, maxValues__jun_oct, minValues__jun_oct] = buildSSTLon(annualSST, sstLat, sstLon);
%
        %sstA_year = getAnnualSSTAnomalies(i,i,1979,2010,sstA,sstA_dates);
[index, maxI, maxJ, minI, minJ, maxValues, minValues] = buildSSTLon(sstA, sstLat, sstLon);



%get the predictors
count =1;
for i=1:12:384
   predictors(count,:) = index(i:i+5); 
   count = count +1;
end

data = ([predictors index_jun_oct]);
%normalize
norm_data = (data - min(min(data))) ./ (max(max(data)) - min(min(data)));

x = [norm_data(:,1:end-1)];
yy = norm_data(:,end);

[cc, ypred, actuals] = kfoldCrossValidate(x, yy, 4);



%xx = diff(dd,1,2);
%[y,actual,cc] = crossValidate(xx(:,1:5),xx(:,6),2);

for i =1:32
    figure
   bar(x(i,:))
   hold on
   bar(7,yy(i),'r')
   pause
end