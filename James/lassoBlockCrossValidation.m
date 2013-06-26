%lassoBlockCrossValidation.m
%Runs a leave-k-out cross validation and shifts by a single step to predict
%the entire observed vector

function [B, testMSE, y_pred fold_mse, y, cc] =  lassoBlockCrossValidation(x,y,k, lambda)
assert(mod(size(x,1),k)==0,'X/k must be 0 i.e. 8 elements and leave 2 out.');
assert(isscalar(lambda), 'lambda must be a scalar');
count = 1;

%add the first k-1 y values to the end of the y vector
if k > 1
    y = [y; y(1:k-1)];
    x = [x ; x(1:k-1, :)];
end

for i=1:size(x,1)-k+1
    test = x(i:i+k-1,:); %set the first k observations as test
    train = x; 
    train(i:i+k-1,:)=[]; %hide the first k observations from the training set
    test_y = y(i:i+k-1);
    train_y = y; 
    train_y(i:i+k-1)=[];
    [B{count},F{count}] = lasso(train,train_y,'lambda',lambda);
    assert(F{count}.DF>=1,'Lambda value is too high. All predictors are dropped.')
    %y_pred{count} = test * B{count} + F{count}.Intercept;
    y_pred(:, count) = x * B{count} + F{count}.Intercept;
    %fold_mse(count) = mean(sqrt((test_y - y_pred{count}).^2));
    fold_mse(count) = mean(sqrt((y - y_pred(:, count)).^2));
   
    cc(:, count) = corr(y_pred(:, count), y);
    
    testPrediction = test * B{count} + F{count}.Intercept;
    
    testMSE(count) = mean(sqrt((y(i:i+k-1) - testPrediction).^2));
    
     count = count+1;
end
end

