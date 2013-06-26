%test the significance of the diffrences in mean of TC counts and NINO
% [nh,neutralh, lh, averageElNino, averageNeutral, averageLaNina] = ENSOStats(-8);
% 
% random_nino = nh(randperm(length(nh)));
% diff_length = length(neutralh) - length(nh);
% if diff_length > 0
%     nh = [nh; random_nino(1:diff_length)];
% end
% 
% random_nina = lh(randperm(length(lh)));
% diff_length = length(neutralh) - length(lh);
% if diff_length > 0
%     lh = [lh; random_nina(1:diff_length)];
% end
% 
% X = [neutralh nh lh];
% 
% p = anova1(X)

%% manually check this Tc count per nino year business
load /project/expeditions/ClimateCodeMatFiles/condensedHurDat.mat;
nn34 = getNINO(1979,2010,1,12,2);
years = 1979:2010;
thresh = 0.3;
nino_years = years(nn34>=thresh);
nina_years = years(nn34<=-thresh);
neutral_years = years(nn34 <thresh & nn34 >-thresh);

start_month =6;
end_month =10;
min_speed = -8;
start_year = 1979;
end_year = 2010;

all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
storms = countStorms(all_storms, start_year, end_year, [start_month:end_month],[0 45], [-90 -15]);

nino_tc = storms(ismember(years,nino_years))';
nina_tc = storms(ismember(years,nina_years))';
neutral_tc = storms(ismember(years,neutral_years))';

length(nino_tc)
length(nina_tc)
length(neutral_tc)


diff_length = length(neutral_tc) - length(nino_tc);
if diff_length > 0
    nino_tc = [nino_tc; nan(diff_length,1)];
end


diff_length = length(neutral_tc) - length(nina_tc);
if diff_length > 0
    nina_tc = [nina_tc; nan(diff_length,1)];
end

X = [nino_tc neutral_tc nina_tc];

p = anova1(X)
