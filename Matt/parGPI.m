function [ gpiMat ] = parGPI( absVor, relHum,maxWindSpeeds, vWindSheer )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %{
gpiMat = zeros(size(absVor, 1), size(absVor, 2));
for i = 1:size(absVor, 1)
    for j = 1:size(absVor, 2)
        if maxWindSpeeds(i, j) == 0
            continue;
        end
        gpi = ((10^5) * absVor(i, j))^(3/2);
        gpi = gpi * ((relHum(i, j)/50)^3);
        gpi = gpi * ((maxWindSpeeds(i, j)/70)^3);
        gpi = gpi * ((1+0.1 * vWindSheer(i, j))^-2);
        gpiMat(i, j) = gpi;
        %If the absolute vorticity is negative, then it was incorrectly
        %calculated, just put a zero in its place so that we can at least
        %do an imagesc, otherwise we get complex numbers
        if absVor(i, j) < 0
            %error('absolute vorticity was incorrectly calculated')
            gpiMat(i, j) = 0;
        end
    end
end
%}

gpiMat = ((10^5 *absVor).^(3/2)) .* ((relHum./50).^3) .* (maxWindSpeeds./70).^3 .* ((1+(0.1*vWindSheer)).^-2);
gpiMat(imag(gpiMat) ~= 0) = 0;
end