clear 
close all
load('monthly_nino_data.mat')
load('aso_stats.mat');
data = data(data(:,1)>=1979 & data(:,1)<2011,:);
nino34_mon = data(:,10);
nino34_mon = reshape(nino34_mon',12,[])';
num_year = 32;
count=1;
for m_s=1:11
    for m_e=m_s:11
        for y=1:num_year
            start = m_s;
            finish = m_e;
            seasonal_nino(y) = mean(nino34_mon(y,start:finish));
            %seasonal_nino(:,:,y) = nanmean(sst(:,:,m_s+((y-1)*12):m_e+((y-1)*12)),3);
        end
        index{m_s,m_e} = seasonal_nino;
        cc1(m_s,m_e) = corr(seasonal_nino',aso_tcs');
        cc2(m_s,m_e) = corr(seasonal_nino',aso_major_hurricanes');
        cc3(m_s,m_e) = corr(seasonal_nino',aso_ace');
        cc4(m_s,m_e) = corr(seasonal_nino',aso_pdi');
        cc5(m_s,m_e) = corr(seasonal_nino',aso_ntc');
        s(count) = start;
        e(count)=finish;
        count=count+1;
    
    end
end
