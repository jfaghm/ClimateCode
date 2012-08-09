function [ Means, bestYears ] = bestSubset(data, posYears, negYears, numPos, numNeg)
%This function is used to find some combination of positive and negative
%years that produce the most dramatic contrast between the two sets for
%some variable
%
%---------------------------Input---------------------------------------
%
%--->data - the variable for which we composite, this should be a three
%dimensional matrix (latitude x longitude x time)
%--->posYears - set of positive years, these are the years that are
%associated with high hurricane activity.
%--->negyears - set of negative yeras, these are the years that are
%associated with low hurricane activity.
%--->numPos - the number of positive years that should be used in each
%combination of positive years, this should be a scaler value.
%--->numNeg - same thing for the negative years 
%
%--------------------------Output----------------------------------------
%
%--->Means - the spatial averages of the difference in composites inside
%the main development region
%--->bestYears - a list of all the years that were used in each iteration

lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
lon(lon > 180) = lon(lon > 180) - 360;
lati = find(lat >= 5 & lat <= 20);
loni = find(lon >= -70 & lon <= -15);

nYearCombos = nchoosek(negYears, numNeg);
pYearCombos = nchoosek(posYears, numPos);

DiffComposites = cell(size(nYearCombos, 1), size(pYearCombos, 1));
Means = zeros(size(nYearCombos, 1), size(pYearCombos, 1));
for i = 1:size(nYearCombos, 1)
    for j = 1:size(pYearCombos, 1)
        [~,~, DiffComposites{i, j}] = getComposites(pYearCombos(j, :)', nYearCombos(i, :)', data, time, 'matrix', false, 8, 10);
        subset = DiffComposites{i, j}(lati, loni);
        Means(i, j) = nanmean(subset(:));
    end
end
[~, ind] = max(Means(:));
[i, j] = ind2sub(size(Means), ind);

bestYears = struct('negative', nYearCombos(i, :), 'positive', pYearCombos(j, :));





end

