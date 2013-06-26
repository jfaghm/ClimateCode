%lassoBlockCrossValidation.m
%Runs a leave-k-out cross validation and shifts by a single step to predict
%the entire observed vector
%NOTE: DOES NOT WORK IF X/k isn't a round number

function [B, F, cc, fold_mse, result, summary, mean_mse,std_mse,mean_sub_mse,std_sub_mse] =  lassoBlockCrossValidation(x,y,k, lambda)
assert(mod(size(x,1),k)==0,'X/k must be 0 i.e. 8 elements and leave 2 out.');
assert(isscalar(lambda), 'lambda must be a scalar');
count = 1;

for i=1:size(x,1)-k+1
    %test_sub is used to test the accuracy of the model on the hidden data
    %only
    test_sub = x(i:i+k-1,:); %set the first k observations as test
    test_y_sub = y(i:i+k-1);
    test = x; %we test on the entire dataset to have a full matrix
    train = x; 
    train(i:i+k-1,:)=[]; %hide the first k observations from the training set
    test_y = y; %test on entire dataset
    train_y = y; 
    train_y(i:i+k-1)=[];
    [B{count},F{count}] = lasso(train,train_y,'lambda',lambda);
    assert(F{count}.DF>=1,'Lambda value is too high. All predictors are dropped.')
    y_pred{count} = test * B{count} + F{count}.Intercept;
    fold_mse(count) = mean(sqrt((test_y - y_pred{count}).^2));
    
    y_pred_sub{count} = test_sub *  B{count} + F{count}.Intercept;
    fold_sub_mse(count) = mean(sqrt((test_y_sub - y_pred_sub{count}).^2));
    
    result(count,:) = y_pred{count};
    cc(count) = corr(y_pred{count},y);
    count = count+1;
end
summary = [y';result];
mean_mse = mean(fold_mse);
std_mse = std(fold_mse);
mean_sub_mse = mean(fold_sub_mse);
std_sub_mse = std(fold_sub_mse);
%pad with a zero to layout the table
cc = [0 cc];
fold_mse = [0 fold_mse];
fold_sub_mse = [0 fold_sub_mse];
summary = [summary cc' fold_mse' fold_sub_mse'];


end