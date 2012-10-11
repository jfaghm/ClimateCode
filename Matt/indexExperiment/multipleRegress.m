function [prediction, formula, model] = multipleRegress(indices, target)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


model = LinearModel.stepwise(indices, target);
prediction = predict(model, indices);
formula = model.Formula;
end

