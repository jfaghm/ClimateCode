%build sst index spatial distribution map
clear
load('ersstv3_1854_2012_raw.mat')
[sstA sstA_dates] = getMonthlyAnomalies(sst,sstDates,1948,2012);
count =1;
for year=62:63
    parfor month =1:12
        sstA_year = getAnnualSSTAnomalies(month,month,year+1949,year+1949,sstA,sstA_dates);
        [index(year,month), maxI, maxJ, minI, minJ] = buildSSTLon(sstA_year, sstLat, sstLon);
        
    end
end
