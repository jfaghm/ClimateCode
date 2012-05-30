%compare nino indices
load('monthly_nino_data.mat')
nino_data = data;
load('sst_study.mat')

%get december nino_data to build DJF
decs = nino_data(nino_data(:,2)==12,:);
decs = decs(1:end-2,:); %1950-2009
jans = nino_data(nino_data(:,2)==1,:); 
jans = jans(2:end-2,:);%1951-2010 skip a year to align with previous december (ie. dec 1950 jan 1951 feb 1951, etc.)
febs = nino_data(nino_data(:,2)==2,:);
febs = febs(2:end-1,:); %1951-2010
nino12_DJF_anoms = mean([decs(:,4) jans(:,4) febs(:,4)],2);
nino3_DJF_anoms = mean([decs(:,6) jans(:,6) febs(:,6)],2);
nino4_DJF_anoms = mean([decs(:,8) jans(:,8) febs(:,8)],2);
nino34_DJF_anoms = mean([decs(:,10) jans(:,10) febs(:,10)],2);
ii = find(decs(:,1)>=1971);
nino12_DJF_anoms = nino12_DJF_anoms(ii);
nino3_DJF_anoms = nino3_DJF_anoms(ii);
nino4_DJF_anoms = nino4_DJF_anoms(ii);
nino34_DJF_anoms = nino34_DJF_anoms(ii);

for i =1:7
   nino12_djf_corr(i) =  corr(nino12_DJF_anoms,all_storms(i,1:end-1)');
   nino3_djf_corr(i) =  corr(nino3_DJF_anoms,all_storms(i,1:end-1)');
   nino4_djf_corr(i) =  corr(nino4_DJF_anoms,all_storms(i,1:end-1)');
   nino34_djf_corr(i) =  corr(nino34_DJF_anoms,all_storms(i,1:end-1)');
end


for i =1:7
   nino12_djf_corr_wa(i) =  corr(nino12_DJF_anoms,wa_storms(i,1:end-1)');
   nino3_djf_corr_wa(i) =  corr(nino3_DJF_anoms,wa_storms(i,1:end-1)');
   nino4_djf_corr_wa(i) =  corr(nino4_DJF_anoms,wa_storms(i,1:end-1)');
   nino34_djf_corr_wa(i) =  corr(nino34_DJF_anoms,wa_storms(i,1:end-1)');
end

for i =1:7
   nino12_djf_corr_ea(i) =  corr(nino12_DJF_anoms,ea_stroms(i,1:end-1)');
   nino3_djf_corr_ea(i) =  corr(nino3_DJF_anoms,ea_stroms(i,1:end-1)');
   nino4_djf_corr_ea(i) =  corr(nino4_DJF_anoms,ea_stroms(i,1:end-1)');
   nino34_djf_corr_ea(i) =  corr(nino34_DJF_anoms,ea_stroms(i,1:end-1)');
end

for i =1:7
   nino12_djf_corr_c1(i) =  corr(nino12_DJF_anoms,c1(i,1:end-1)');
   nino3_djf_corr_c1(i) =  corr(nino3_DJF_anoms,c1(i,1:end-1)');
   nino4_djf_corr_c1(i) =  corr(nino4_DJF_anoms,c1(i,1:end-1)');
   nino34_djf_corr_c1(i) =  corr(nino34_DJF_anoms,c1(i,1:end-1)');
end
for i =1:7
   nino12_djf_corr_c2(i) =  corr(nino12_DJF_anoms,c2(i,1:end-1)');
   nino3_djf_corr_c2(i) =  corr(nino3_DJF_anoms,c2(i,1:end-1)');
   nino4_djf_corr_c2(i) =  corr(nino4_DJF_anoms,c2(i,1:end-1)');
   nino34_djf_corr_c2(i) =  corr(nino34_DJF_anoms,c2(i,1:end-1)');
end
for i =1:7
   nino12_djf_corr_c3(i) =  corr(nino12_DJF_anoms,c3(i,1:end-1)');
   nino3_djf_corr_c3(i) =  corr(nino3_DJF_anoms,c3(i,1:end-1)');
   nino4_djf_corr_c3(i) =  corr(nino4_DJF_anoms,c3(i,1:end-1)');
   nino34_djf_corr_c3(i) =  corr(nino34_DJF_anoms,c3(i,1:end-1)');
end
for i =1:7
   nino12_djf_corr_c4(i) =  corr(nino12_DJF_anoms,c4(i,1:end-1)');
   nino3_djf_corr_c4(i) =  corr(nino3_DJF_anoms,c4(i,1:end-1)');
   nino4_djf_corr_c4(i) =  corr(nino4_DJF_anoms,c4(i,1:end-1)');
   nino34_djf_corr_c4(i) =  corr(nino34_DJF_anoms,c4(i,1:end-1)');
end


mar = nino_data(nino_data(:,2)==3,:);
mar = mar(1:end-1,:); %1950-2010
apr = nino_data(nino_data(:,2)==4,:); 
apr = apr(1:end-1,:);%1950-2010
may = nino_data(nino_data(:,2)==5,:);
may = may(1:end-1,:); %1950-2010

nino12_MAM_anoms = mean([mar(:,4) apr(:,4) may(:,4)],2);
nino3_MAM_anoms = mean([mar(:,6) apr(:,6) may(:,6)],2);
nino4_MAM_anoms = mean([mar(:,8) apr(:,8) may(:,8)],2);
nino34_MAM_anoms = mean([mar(:,10) apr(:,10) may(:,10)],2);

ii = find(mar(:,1)>=1971);
nino12_MAM_anoms = nino12_MAM_anoms(ii);
nino3_MAM_anoms = nino3_MAM_anoms(ii);
nino4_MAM_anoms = nino4_MAM_anoms(ii);
nino34_MAM_anoms = nino34_MAM_anoms(ii);

for i =1:7
   nino12_mam_corr(i) =  corr(nino12_MAM_anoms,all_storms(i,:)');
   nino3_mam_corr(i) =  corr(nino3_MAM_anoms,all_storms(i,:)');
   nino4_mam_corr(i) =  corr(nino4_MAM_anoms,all_storms(i,:)');
   nino34_mam_corr(i) =  corr(nino34_MAM_anoms,all_storms(i,:)');
end

for i =1:7
   nino12_mam_corr_wa(i) =  corr(nino12_MAM_anoms,wa_storms(i,:)');
   nino3_mam_corr_wa(i) =  corr(nino3_MAM_anoms,wa_storms(i,:)');
   nino4_mam_corr_wa(i) =  corr(nino4_MAM_anoms,wa_storms(i,:)');
   nino34_mam_corr_wa(i) =  corr(nino34_MAM_anoms,wa_storms(i,:)');
end

for i =1:7
   nino12_mam_corr_ea(i) =  corr(nino12_MAM_anoms,ea_stroms(i,:)');
   nino3_mam_corr_ea(i) =  corr(nino3_MAM_anoms,ea_stroms(i,:)');
   nino4_mam_corr_ea(i) =  corr(nino4_MAM_anoms,ea_stroms(i,:)');
   nino34_mam_corr_ea(i) =  corr(nino34_MAM_anoms,ea_stroms(i,:)');
end

for i =1:7
   nino12_mam_corr_c1(i) =  corr(nino12_MAM_anoms,c1(i,:)');
   nino3_mam_corr_c1(i) =  corr(nino3_MAM_anoms,c1(i,:)');
   nino4_mam_corr_c1(i) =  corr(nino4_MAM_anoms,c1(i,:)');
   nino34_mam_corr_c1(i) =  corr(nino34_MAM_anoms,c1(i,:)');
end
for i =1:7
   nino12_mam_corr_c2(i) =  corr(nino12_MAM_anoms,c2(i,:)');
   nino3_mam_corr_c2(i) =  corr(nino3_MAM_anoms,c2(i,:)');
   nino4_mam_corr_c2(i) =  corr(nino4_MAM_anoms,c2(i,:)');
   nino34_mam_corr_c2(i) =  corr(nino34_MAM_anoms,c2(i,:)');
end
for i =1:7
   nino12_mam_corr_c3(i) =  corr(nino12_MAM_anoms,c3(i,:)');
   nino3_mam_corr_c3(i) =  corr(nino3_MAM_anoms,c3(i,:)');
   nino4_mam_corr_c3(i) =  corr(nino4_MAM_anoms,c3(i,:)');
   nino34_mam_corr_c3(i) =  corr(nino34_MAM_anoms,c3(i,:)');
end
for i =1:7
   nino12_mam_corr_c4(i) =  corr(nino12_MAM_anoms,c4(i,:)');
   nino3_mam_corr_c4(i) =  corr(nino3_MAM_anoms,c4(i,:)');
   nino4_mam_corr_c4(i) =  corr(nino4_MAM_anoms,c4(i,:)');
   nino34_mam_corr_c4(i) =  corr(nino34_MAM_anoms,c4(i,:)');
end

jun = nino_data(nino_data(:,2)==6,:);
jun = jun(1:end-1,:); %1950-2010
jul = nino_data(nino_data(:,2)==7,:); 
jul = jul(1:end-1,:);%1950-2010
aug = nino_data(nino_data(:,2)==8,:);
aug = aug(1:end-1,:); %1950-2010

nino12_JJA_anoms = mean([jun(:,4) jul(:,4) aug(:,4)],2);
nino3_JJA_anoms = mean([jun(:,6) jul(:,6) aug(:,6)],2);
nino4_JJA_anoms = mean([jun(:,8) jul(:,8) aug(:,8)],2);
nino34_JJA_anoms = mean([jun(:,10) jul(:,10) aug(:,10)],2);

ii = find(jun(:,1)>=1971);
nino12_JJA_anoms = nino12_JJA_anoms(ii);
nino3_JJA_anoms = nino3_JJA_anoms(ii);
nino4_JJA_anoms = nino4_JJA_anoms(ii);
nino34_JJA_anoms = nino34_JJA_anoms(ii);

for i =1:7
   nino12_jja_corr(i) =  corr(nino12_JJA_anoms,all_storms(i,:)');
   nino3_jja_corr(i) =  corr(nino3_JJA_anoms,all_storms(i,:)');
   nino4_jja_corr(i) =  corr(nino4_JJA_anoms,all_storms(i,:)');
   nino34_jja_corr(i) =  corr(nino34_JJA_anoms,all_storms(i,:)');
end

for i =1:7
   nino12_jja_corr_wa(i) =  corr(nino12_JJA_anoms,wa_storms(i,:)');
   nino3_jja_corr_wa(i) =  corr(nino3_JJA_anoms,wa_storms(i,:)');
   nino4_jja_corr_wa(i) =  corr(nino4_JJA_anoms,wa_storms(i,:)');
   nino34_jja_corr_wa(i) =  corr(nino34_JJA_anoms,wa_storms(i,:)');
end

for i =1:7
   nino12_jja_corr_ea(i) =  corr(nino12_JJA_anoms,ea_stroms(i,:)');
   nino3_jja_corr_ea(i) =  corr(nino3_JJA_anoms,ea_stroms(i,:)');
   nino4_jja_corr_ea(i) =  corr(nino4_JJA_anoms,ea_stroms(i,:)');
   nino34_jja_corr_ea(i) =  corr(nino34_JJA_anoms,ea_stroms(i,:)');
end

for i =1:7
   nino12_jja_corr_c1(i) =  corr(nino12_JJA_anoms,c1(i,:)');
   nino3_jja_corr_c1(i) =  corr(nino3_JJA_anoms,c1(i,:)');
   nino4_jja_corr_c1(i) =  corr(nino4_JJA_anoms,c1(i,:)');
   nino34_jja_corr_c1(i) =  corr(nino34_JJA_anoms,c1(i,:)');
end
for i =1:7
   nino12_jja_corr_c2(i) =  corr(nino12_JJA_anoms,c2(i,:)');
   nino3_jja_corr_c2(i) =  corr(nino3_JJA_anoms,c2(i,:)');
   nino4_jja_corr_c2(i) =  corr(nino4_JJA_anoms,c2(i,:)');
   nino34_jja_corr_c2(i) =  corr(nino34_JJA_anoms,c2(i,:)');
end
for i =1:7
   nino12_jja_corr_c3(i) =  corr(nino12_JJA_anoms,c3(i,:)');
   nino3_jja_corr_c3(i) =  corr(nino3_JJA_anoms,c3(i,:)');
   nino4_jja_corr_c3(i) =  corr(nino4_JJA_anoms,c3(i,:)');
   nino34_jja_corr_c3(i) =  corr(nino34_JJA_anoms,c3(i,:)');
end
for i =1:7
   nino12_jja_corr_c4(i) =  corr(nino12_JJA_anoms,c4(i,:)');
   nino3_jja_corr_c4(i) =  corr(nino3_JJA_anoms,c4(i,:)');
   nino4_jja_corr_c4(i) =  corr(nino4_JJA_anoms,c4(i,:)');
   nino34_jja_corr_c4(i) =  corr(nino34_JJA_anoms,c4(i,:)');
end


sep = nino_data(nino_data(:,2)==9,:);
sep = sep(1:end-1,:); %1950-2010
oct = nino_data(nino_data(:,2)==10,:); 
oct = oct(1:end-1,:);%1950-2010
nov = nino_data(nino_data(:,2)==11,:);
nov = nov(1:end-1,:); %1950-2010

nino12_SON_anoms = mean([sep(:,4) oct(:,4) nov(:,4)],2);
nino3_SON_anoms = mean([sep(:,6) oct(:,6) nov(:,6)],2);
nino4_SON_anoms = mean([sep(:,8) oct(:,8) nov(:,8)],2);
nino34_SON_anoms = mean([sep(:,10) oct(:,10) nov(:,10)],2);

ii = find(sep(:,1)>=1971);
nino12_SON_anoms = nino12_SON_anoms(ii);
nino3_SON_anoms = nino3_SON_anoms(ii);
nino4_SON_anoms = nino4_SON_anoms(ii);
nino34_SON_anoms = nino34_SON_anoms(ii);

for i =1:7
   nino12_son_corr(i) =  corr(nino12_SON_anoms,all_storms(i,:)');
   nino3_son_corr(i) =  corr(nino3_SON_anoms,all_storms(i,:)');
   nino4_son_corr(i) =  corr(nino4_SON_anoms,all_storms(i,:)');
   nino34_son_corr(i) =  corr(nino34_SON_anoms,all_storms(i,:)');
end
for i =1:7
   nino12_son_corr_wa(i) =  corr(nino12_SON_anoms,wa_storms(i,:)');
   nino3_son_corr_wa(i) =  corr(nino3_SON_anoms,wa_storms(i,:)');
   nino4_son_corr_wa(i) =  corr(nino4_SON_anoms,wa_storms(i,:)');
   nino34_son_corr_wa(i) =  corr(nino34_SON_anoms,wa_storms(i,:)');
end
for i =1:7
   nino12_son_corr_ea(i) =  corr(nino12_SON_anoms,ea_stroms(i,:)');
   nino3_son_corr_ea(i) =  corr(nino3_SON_anoms,ea_stroms(i,:)');
   nino4_son_corr_ea(i) =  corr(nino4_SON_anoms,ea_stroms(i,:)');
   nino34_son_corr_ea(i) =  corr(nino34_SON_anoms,ea_stroms(i,:)');
end
for i =1:7
   nino12_son_corr_c1(i) =  corr(nino12_SON_anoms,c1(i,:)');
   nino3_son_corr_c1(i) =  corr(nino3_SON_anoms,c1(i,:)');
   nino4_son_corr_c1(i) =  corr(nino4_SON_anoms,c1(i,:)');
   nino34_son_corr_c1(i) =  corr(nino34_SON_anoms,c1(i,:)');
end
for i =1:7
   nino12_son_corr_c2(i) =  corr(nino12_SON_anoms,c2(i,:)');
   nino3_son_corr_c2(i) =  corr(nino3_SON_anoms,c2(i,:)');
   nino4_son_corr_c2(i) =  corr(nino4_SON_anoms,c2(i,:)');
   nino34_son_corr_c2(i) =  corr(nino34_SON_anoms,c2(i,:)');
end
for i =1:7
   nino12_son_corr_c3(i) =  corr(nino12_SON_anoms,c3(i,:)');
   nino3_son_corr_c3(i) =  corr(nino3_SON_anoms,c3(i,:)');
   nino4_son_corr_c3(i) =  corr(nino4_SON_anoms,c3(i,:)');
   nino34_son_corr_c3(i) =  corr(nino34_SON_anoms,c3(i,:)');
end
for i =1:7
   nino12_son_corr_c4(i) =  corr(nino12_SON_anoms,c4(i,:)');
   nino3_son_corr_c4(i) =  corr(nino3_SON_anoms,c4(i,:)');
   nino4_son_corr_c4(i) =  corr(nino4_SON_anoms,c4(i,:)');
   nino34_son_corr_c4(i) =  corr(nino34_SON_anoms,c4(i,:)');
end


years = unique(nino_data(:,1));
years = years(years>=1971 & years <= 2010);
for i = 1:length(years)
    nino12_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i),4));
    nino3_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i),6));
    nino4_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i),8));
    nino34_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i),10));
end


% for i =1:7
%    nino12_annual_corr(i) =  corr(nino12_annual_anoms',all_storms(i,:)');
%    nino3_annual_corr(i) =  corr(nino3_annual_anoms',all_storms(i,:)');
%    nino4_annual_corr(i) =  corr(nino4_annual_anoms',all_storms(i,:)');
%    nino34_annual_corr(i) =  corr(nino34_annual_anoms',all_storms(i,:)');
% end
% for i =1:7
%    nino12_annual_corr_wa(i) =  corr(nino12_annual_anoms',wa_storms(i,:)');
%    nino3_annual_corr_wa(i) =  corr(nino3_annual_anoms',wa_storms(i,:)');
%    nino4_annual_corr_wa(i) =  corr(nino4_annual_anoms',wa_storms(i,:)');
%    nino34_annual_corr_wa(i) =  corr(nino34_annual_anoms',wa_storms(i,:)');
% end
% for i =1:7
%    nino12_annual_corr_ea(i) =  corr(nino12_annual_anoms',ea_stroms(i,:)');
%    nino3_annual_corr_ea(i) =  corr(nino3_annual_anoms',ea_stroms(i,:)');
%    nino4_annual_corr_ea(i) =  corr(nino4_annual_anoms',ea_stroms(i,:)');
%    nino34_annual_corr_ea(i) =  corr(nino34_annual_anoms',ea_stroms(i,:)');
% end
% for i =1:7
%    nino12_annual_corr_c1(i) =  corr(nino12_annual_anoms',c1(i,:)');
%    nino3_annual_corr_c1(i) =  corr(nino3_annual_anoms',c1(i,:)');
%    nino4_annual_corr_c1(i) =  corr(nino4_annual_anoms',c1(i,:)');
%    nino34_annual_corr_c1(i) =  corr(nino34_annual_anoms',c1(i,:)');
% end
% for i =1:7
%    nino12_annual_corr_c2(i) =  corr(nino12_annual_anoms',c2(i,:)');
%    nino3_annual_corr_c2(i) =  corr(nino3_annual_anoms',c2(i,:)');
%    nino4_annual_corr_c2(i) =  corr(nino4_annual_anoms',c2(i,:)');
%    nino34_annual_corr_c2(i) =  corr(nino34_annual_anoms',c2(i,:)');
% end
% for i =1:7
%    nino12_annual_corr_c3(i) =  corr(nino12_annual_anoms',c3(i,:)');
%    nino3_annual_corr_c3(i) =  corr(nino3_annual_anoms',c3(i,:)');
%    nino4_annual_corr_c3(i) =  corr(nino4_annual_anoms',c3(i,:)');
%    nino34_annual_corr_c3(i) =  corr(nino34_annual_anoms',c3(i,:)');
% end
% for i =1:7
%    nino12_annual_corr_c4(i) =  corr(nino12_annual_anoms',c4(i,:)');
%    nino3_annual_corr_c4(i) =  corr(nino3_annual_anoms',c4(i,:)');
%    nino4_annual_corr_c4(i) =  corr(nino4_annual_anoms',c4(i,:)');
%    nino34_annual_corr_c4(i) =  corr(nino34_annual_anoms',c4(i,:)');
% end
% %for visualization only
% nn(1,:) = [nino12_annual_corr(6) nino12_annual_corr_ea(6) nino12_annual_corr_wa(6) nino12_annual_corr_c1(6) nino12_annual_corr_c2(6) nino12_annual_corr_c3(6) nino12_annual_corr_c4(6)];
% nn(2,:) = [nino3_annual_corr(6) nino3_annual_corr_ea(6) nino3_annual_corr_wa(6) nino3_annual_corr_c1(6) nino3_annual_corr_c2(6) nino3_annual_corr_c3(6) nino3_annual_corr_c4(6)];
% nn(3,:) = [nino4_annual_corr(6) nino4_annual_corr_ea(6) nino4_annual_corr_wa(6) nino4_annual_corr_c1(6) nino4_annual_corr_c2(6) nino4_annual_corr_c3(6) nino4_annual_corr_c4(6)];
% nn(4,:) = [nino34_annual_corr(6) nino34_annual_corr_ea(6) nino34_annual_corr_wa(6) nino34_annual_corr_c1(6) nino34_annual_corr_c2(6) nino34_annual_corr_c3(6) nino34_annual_corr_c4(6)];
% 
% %%%%%
% %get our own index
% load('sst_study.mat')
% load('modoki.mat')
% %file_name = '/project/expeditions/jfagh/data/ersstv3/seasons/SON_annual_mean_1948_2010.nc';
% file_name = '/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_annual_mean.nc';
% ncid = netcdf.open(file_name,'NC_NOWRITE');
% varid_sst = netcdf.inqVarID(ncid,'sst');
% sst_1971_2010 =  squeeze(netcdf.getVar(ncid,varid_sst));
% sst_1971_2010(sst_1971_2010==-999)=NaN;
% annual_sst = permute(sst_1971_2010,[2 1 3])./100;
% 
% box_north = 20;
% box_south = -20;
% box_west = 140;
% box_east = 270;
% if ismember(box_north, lat)
%    [~, northRow] = ismember(box_north, lat);
%    [~, southRow] = ismember(box_south, lat);
% else
%     error('Bad lat input!');
% end
% if ismember(box_east, lon)
%    [~, eastCol] = ismember(box_east, lon);
%    [~, westCol] = ismember(box_west, lon);
% else
%     error('Bad lat input!');
% end
% annual_pacific = double(annual_sst(northRow:southRow,westCol:eastCol,:));
% box_row =5;
% box_col = 20;
% for t=1:size(annual_pacific,3)
%    ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
% end
% 
% mean_box_sst_pacific = ss(round(box_row/2):end-round(box_row/2),round(box_col/2):end-round(box_col/2),:)./(box_row*box_col);
% %mean_box_sst_pacific = ss./(box_row*box_col);
% for t = 1:size(mean_box_sst_pacific,3)
%     current = mean_box_sst_pacific(:,:,t);
%    [index(t) loc(t)] = max(current(:));
% end
% for i = 1:size(loc,2)
%     [I(i),J(i)] = ind2sub(size(mean_box_sst_pacific),loc(i));
% end
% 
% 
%     cc(1) = corr(J(24:end)',all_storms(6,:)');
%     cc(2) = corr(J(24:end)',ea_stroms(6,:)');
%     cc(3) = corr(J(24:end)',wa_storms(6,:)');
%     cc(4) = corr(J(24:end)',c1(6,:)');
%     cc(5) = corr(J(24:end)',c2(6,:)');
%     cc(6) = corr(J(24:end)',c3(6,:)');
%     cc(7) = corr(J(24:end)',c4(6,:)');
% lat1 = 20:-2:-20;
% lon1 = 140:2:270;
% [AX,H1,H2] = plotyy(1971:2010,lon1(J(24:end))',1971:2010,wa_storms(6,:)');
% set(get(AX(1),'Ylabel'),'String','Logitude')
% set(get(AX(2),'Ylabel'),'String','Jun-Oct TC Count')
% set(AX(1),'yLim',[min(lon1(J(24:end))) max(lon1(J(24:end)))]);
% set(AX(2),'yLim',[min(wa_storms(6,:)) max(wa_storms(6,:))]);
% title(['Location based index vs. West Atlantic storms 1971-2010 corr = ' num2str(cc(3))]);