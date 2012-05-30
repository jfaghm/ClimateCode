%index results
clear
close all
load('PacAnomalyIndex_Apr-Oct_1971-2010.mat')
load('sst_study.mat')

load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat')
load('monthly_nino_data.mat')
nino_data = data;
years = unique(nino_data(:,1));
years = years(years>=1971 & years <= 2010);
m_start =4;
m_end=10;
months = [m_start:m_end];

for i = 1:length(years)
    nino12_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i) & ismember(nino_data(:,2),months),4));
    nino3_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i)& ismember(nino_data(:,2),months),6));
    nino4_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i)& ismember(nino_data(:,2),months),8));
    nino34_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i)& ismember(nino_data(:,2),months),10));
end
for i=1:40
    seasonal_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==years(i),11))/10^7;
    seasonal_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==years(i),12))/10^5;
    seasonal_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==years(i)&condensedHurDat(:,10)>=1&condensedHurDat(:,10)<=3 ,10));
    seasonal_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==years(i)&condensedHurDat(:,10)>=4 ,10));
end
for i =1:7
    cc(i) = corr(all_storms(i,:)',index);
end
r(1) = cc(6);
r(4)= corr(seasonal_pdi',index);
r(5)=corr(seasonal_ace',index);
r(2)=corr(seasonal_hurricanes',index);
r(3)=corr(seasonal_major_hurricanes',index);

nino12_corr(1) = corr(all_storms(6,:)',nino12_annual_anoms');
nino12_corr(4)= corr(seasonal_pdi',nino12_annual_anoms');
nino12_corr(5)=corr(seasonal_ace',nino12_annual_anoms');
nino12_corr(2)=corr(seasonal_hurricanes',nino12_annual_anoms');
nino12_corr(3)=corr(seasonal_major_hurricanes',nino12_annual_anoms');
