function [ regressionMatrix, corrMatrix  ] = pointRegression( data, index )
%This function is used to calculate the linear regression coefficients for
%each point spatially in the data set that is provided.  
%
%----------------------------Input---------------------------------------
%
%--->data - the data for which we perform the regrssion on, this should be
%a three dimensional matrix (latitude x longitude x time)
%--->index - an index that contains the same amount of years as the data
%matrix.
%
%----------------------------Output--------------------------------------
%
%--->regressionMatrix - a three dimensional matrix that contains the
%regression coefficints and p-values.  the first two dimensions should be
%the same size as data.  The first index into the third dimension
%(regressionMatrix(:, :, 1)) contains all of the intercepts of the
%regression function, the second index contains all of the slopes of the
%regression function, and the third index contains all of the p-values.
%--->corrMatrix - a two dimensional matrix that is the same size as the
%first two dimensions of the data matrix.  Each index in this matrix
%contains the temporal correlation between "index" and "data"


if size(data, 1) == 512
    data = permute(data, [2 1 3]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%EXTRACT YEARLY DATA%%%%%%%%%%%%%%%%%%%
yearlyData = zeros(size(data, 1), size(data, 2), size(data, 3)/12, 1);
i = 1;
for month = 1:12:size(data, 3)
    yearlyData(:, :, i) = nanmean(data(:, :, month+7:month+9), 3);    
    i = i+1;
end
regressionMatrix = zeros(size(data, 1), size(data, 2), 3);
if matlabpool('size') == 0
    matlabpool open;
end
%%%%%%%%%%%%%%%%%%%%GET REGRESSION COEFFICIENTS AND P-VALUES%%%%
parfor i = 1:size(data, 1)
    bflRow = zeros(1, size(data, 2), 3);
    for j = 1:size(data, 2)
        yd = squeeze(yearlyData(i, j, :));
        
        if isnan(yd(1)) == true
            bflRow(1, j, 1) = NaN;
            bflRow(1, j, 2) = NaN;
            bflRow(1, j, 3) = 1;
            continue
        end        
        s = regstats(yd, index, 'linear', 'beta');
        bflRow(1, j, 1) = s.beta(1); %intercept
        bflRow(1, j, 2) = s.beta(2); %slope
        bflRow(1, j, 3) = 0;%s.tstat.pval; %pvalue
    end
    regressionMatrix(i, :, :) = bflRow;
end
%%%%%%%%%%%GET CORRELATION COEFFICIENTS%%%%%%%%%%%%%%%%%%%%%%%%%%
corrMatrix = zeros(size(data, 1), size(data, 2));
parfor i = 1:size(data, 1)
    corrRow = zeros(1, size(data, 2));
    for j = 1:size(data, 2)
        corrRow(1, j) = corr(index, squeeze(yearlyData(i, j, :)));
    end
    corrMatrix(i, :) = corrRow;
end

end






