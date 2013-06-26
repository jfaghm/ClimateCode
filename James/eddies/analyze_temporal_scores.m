%analyze the eddies temporal score samples

load('temporalScoreData')

%of the sampled tracks, keep only eddies that are 4 weeks long and were not
%at the beginning or end of the track
sigTracks = data(data(:,6)>3&data(:,7)./data(:,6)<=0.9&data(:,7)./data(:,6)>=0.1,:);
%since sigTracks are much less than randData we'll sample ramdoly the same
%number of random data
rand_ind = randperm(length(sigTracks));
sampleRandData = randData(rand_ind,:);

%get low scores
seg(:,1) = histc(sigTracks(sigTracks(:,1)<10,1),0:0.2:10);
seg(:,2) = histc(sampleRandData(sampleRandData(:,1)<10,1),0:0.2:10);
bar(seg)

%analyze rest
a = hist(sigTracks(sigTracks(:,1)>=10,1),10:10:200)';
b = hist(sampleRandData(sampleRandData(:,1)>=10,1),10:10:200)';


%% Analyze rotational speed distribution

overlapping = overlappingBURotSpeed;
%load('mergeData.mat');
merge_speed= cell2mat(mergeData(:,1));
unmerge_speed = cell2mat(mergeData(:,2));

for i=1:size(no_merge,1) max_rs(i) = max(no_merge{i}(:,4)); end

for i=1:size(no_merge,1) sum_rs(i) = sum(no_merge{i}(:,4)); end


