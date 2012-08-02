function prediction = multipleRegress(indices, target)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


model = LinearModel.fit(indices, target);
prediction = feval(model, indices);

end

