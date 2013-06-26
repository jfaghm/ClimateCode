%test the sst dist index


%[index,cc] = buildIndexVariations(27,3,10);
%[index1,cc1] = buildIndexVariations(27,8,10);
% 
%clear
load('ersstv3Anom.mat')
%a = buildSSTLonDiff(getAnnualSSTAnomalies(6, 10, 1948, 1978),sstLat,sstLon);
%b = buildSSTLonDiff(getAnnualSSTAnomalies(6, 10, 1979, 2010),sstLat,sstLon);
count =1;
for i=1:12
    for j=i:12
        index{count} =  buildSSTLonDiff(getAnnualSSTAnomalies(i, j, 2000, 2010,sst, sstDates),sstLat,sstLon);
        count = count+1;
    end
end
% for i=1:length(index)
%    cc(i) = corr(index{i},storms'); 
%     
% end
% clear
% for i=1:12
%     parfor j=1:12
%     
%        [index(i,j,:), cc(i,j,:)] =  buildIndexVariations(27,i,j);
%         
%     end
%     
% end
% 
% best_index = squeeze(index(6,10,:));
%  
%  for i=1:12
%      for j =1:12
%          
%         index_corr(i,j) = corr(squeeze(index(i,j,:)),best_index);
%      end
%  end
%  count = 1;
%  for i=1:5
%      for j=1:5
%         predictors(count,:) = squeeze(index(i,j,:))';
%         count = count+1; 
%      end
%  end
% load condensedHurDat
% start_month =8;
% end_month =10;
% min_speed = -8;
% start_year = 1979;
% end_year = 2010;
% min_lat = 0;
% max_lat = 40;
% max_lon = -12;
% min_lon = -100;
% max_east_lon = -45;
% min_west_lon = -45;
% all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
% storms = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);
% east_storms = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_east_lon]);
% west_storms = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_west_lon max_lon]);
% ratio = (west_storms./storms)./(east_storms./storms);
%corr(best_index,ratio')

% for i =1:46
%     
%      [ii{i} nc(i,:)] =  buildIndexVariations(i,8,10);
%     
%         
%     
% end

%see if any PCs have high corr with best index

% for i=1:size(PCs,2)
%     
%    cc1(i) = corr(PCs{i},best_index); 
% end

% ii = reshape(index,[],32);
% cc= rowCorr(ii,aso_tcs','aa');
% mic = rowMIC(ii,aso_tcs','aa');
% non_lin = mic - (cc.^2);


% for i=1:12
%     for j=1:12
%         if squeeze(index(i,j,:)) == k'
%             disp(i)
%             disp(j)
%         end
%         
%     end
% end
% for i=1:32
%     if best_index(i)<=0 
%         b(i) =-1;
%     else 
%         b(i)=1;
%     end
% end

%sst1 = reshape(sst,[],

        