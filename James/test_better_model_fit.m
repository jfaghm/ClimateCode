%test to improve our model's fit
count =1;
for e=0.5
    y = improve_fit(aso_tcs,e)';
    x = pacific_indices_mar_oct;
    k = 8;
    lambda = 0;
    [B, F, cc{count}, fold_mse{count}, result] =  lassoBlockCrossValidation(x,y,k, lambda);
    count = count+1;
end


[B, F, cc1, mse1, result] =  lassoBlockCrossValidation(x,aso_tcs,k, lambda);