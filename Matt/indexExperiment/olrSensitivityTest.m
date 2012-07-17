function [coefficients] = olrSensitivityTest()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

coefficients = zeros(12, 12);
for i = 1:12
    for j = i:12
        [~, cc] = buildIndexOLR(3, i, j);
        coefficients(i, j) = sum(cc);
        i
        j
    end
end


end

function coefficients = latitudeSearchSpaceTest()
lats = 2.5:2.5:37.5;
coefficients = zeros(length(lats), length(lats));
count1 = 1; 
for i = 7.5:2.5:37.5
    count2 = 1;
    for j = -37.5:2.5:-7.5
        [~,cc] = buildIndexOLR(i, j, 4);
        coefficients(count1, count2) = sum(cc);
        i
        j
        count2 = count2 + 1;
        
    end
    count1 = count1 + 1;
end

end

function coefficients = northernHempisphereOnly()
    lats = 7.5:2:40;
    coefficients = zeros(length(lats), 1);
    count = 1;
    for i = 10:2.5:40
        [~,cc] = buildIndexOLR(i, 0, 4);
        coefficients(count) = sum(cc);
        count = count+1;
    end
end

function coefficients = southernHemisphereOnly()
    lats = 7.5:2:40;
    coefficients = zeros(length(lats), 1);
    count = 1;
    for i = -10:-2.5:-40
        [~,cc] = buildIndexOLR(i, 0, 4);
        coefficients(count) = sum(cc);
        count = count+1;
    end
end