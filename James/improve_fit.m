%transform the target variable to resolve the over/under estimation of
%low/high values
function u = improve_fit(aso_tcs,epsilon)
    min_tc = min(aso_tcs);
    max_tc = max(aso_tcs);
    mean_tc = mean(aso_tcs);
    for i =1:size(aso_tcs,1)
        u(i) =  min_tc + ( max_tc - min_tc)/(1+epsilon*exp(aso_tcs(i) - mean_tc));
    end