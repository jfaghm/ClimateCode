%a function to improve our under/over estimation of low/high hurricane years
%epsilon is the parameter we need to vary to get a good fit
function u = improved_fit(aso_tcs,epsilon)
u = min(aso_tcs) + (max(aso_tcs) - min(aso_tcs))/(1+epsilon*exp(aso_tcs - mean(aso_tcs)))

end