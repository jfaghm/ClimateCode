addpath('../');
addpath('../indexExperiment/');
if ~exist('vars', 'var')
	vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
members = {'sst', 'PI', 'pressure', 'windShear', 'windField850', 'windField500', 'windField200', 'relHumid850', 'relHumid500', 'relHumid850_500Diff', 'geoPotential500', 'geoPotential200', 'geoPotential500_1000Diff', 'precipitableWater', 'satDef850', 'satDef500', 'satDef500_850Avg', 'gpiMat', 'sstDeviations'};

year = 1;
for i = 1:length(members)
	switch size(eval(['vars.' members{i}]), 1)
		case 256
			lat = vars.lat;
			lon = vars.lon;
		case 241
			lat = vars.satDefLat;
			lon = vars.satDefLon;
		case 89
			lat = vars.sstLat;	
			lon = vars.sstLon;
	end
	former = zeros(length(lat), length(lon), 192/12);
	latter = zeros(length(lat), length(lon), 192/12);
	for j = 1:12:192
		former(:, :, year) = nanmean(eval(['vars.' members{i}  '(:, :, j+7:j+9)']), 3);
		latter(:, :, year) = nanmean(eval(['vars.' members{i} '(:, :, 192+i+7:192+i+9)']), 3);
		year = year+1;
	end
	former = nanmean(former, 3);
	latter = nanmean(latter, 3);

	scale = [max(nanmin(former(:)), nanmin(latter(:))), min(max(former(:)), max(latter(:)))];

    %{    
	subplot(2, 1, 1);
	worldmap([0 45], [-80, -15])	
	pcolorm(double(lat), double(lon), former);
	colorbar
	caxis(scale);
	title(['1979-1994 ' members{i} ' Aug-Oct Average']);
	geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])

	subplot(2, 1, 2);
	worldmap([0, 45], [-80, -15]);
	pcolorm(double(lat), double(lon), latter);
	colorbar
	caxis(scale);
	title(['1995-2010 ' members{i} ' Aug-Oct Average']);
	geoshow('landareas.shp', 'FaceColor', [.25, .2, .15]);

    subplot(3, 1, 3)
    worldmap([0 45], [-80, -15]);
    pcolorm(double(lat), double(lon), 
    %}
    
    
    figure(1);
    worldmap([0 45], [-80, -15]);
    pcolorm(double(lat), double(lon), latter - former);
    colorbar
    title(['Latter Years - Former Years ' members{i} ' Aug-Oct Average']);
    geoshow('landareas.shp', 'FaceColor', [.25, .2, .15]);
    
	saveDir = ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/results/paperDraft/formerLatterPlots/' members{i} 'FormerAndLatterYears.pdf'];
	set(gcf, 'PaperPosition', [0, 0, 8, 11]);
    	set(gcf, 'PaperSize', [8, 11]);
    	saveas(gcf, saveDir, 'pdf');

end










