function [cc] = crossValCorrelations(indices, k)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
x = 1979:2010;
[yVals, actuals] = crossValidate(indices, aso_ace, k);
cc(1, 1) = corr(yVals, actuals);
[yVals, actuals] = crossValidate(indices, aso_major_hurricanes, k);
%{
plot(x, yVals, x, actuals);
legend('Predictions', 'Actuals');
c = corr(yVals, actuals);
title(strcat('Cross Validation ', t, 'correlation = ', num2str(c), ' (Major Hurricanes)'));
ylabel('Number of Major Hurricanes');
xlabel('Year');
print('-dpdf', '-r400', ['results/plots/crossValidationMajorHurricanes' t]);
%}
cc(2, 1) = corr(yVals, actuals);
[yVals, actuals] = crossValidate(indices, aso_ntc, k);
cc(3, 1) = corr(yVals, actuals);
[yVals, actuals] = crossValidate(indices, aso_pdi, k);
cc(4, 1) = corr(yVals, actuals);
[yVals, actuals] = crossValidate(indices, aso_tcs, k);
cc(5, 1) = corr(yVals, actuals);
%{
plot(x, yVals, x, actuals);
legend('Predictions', 'Actuals');
c = corr(yVals, actuals);
title(['Cross Validation ' t ' correlation = ' num2str(c) ' (Tropical Cyclones)']);
ylabel('Number of Tropical Cyclones');
xlabel('Year');
print('-dpdf', '-r400', ['results/plots/crossValidationTC' t]);
%}
end

