function [ gpi ] = gpi(absVorticity, relHumidity, potIntensity, vShear)
%This function is used to calculate the genesis potential index as outlined
%in the Tropical cyclone genesis potential index in climate models paper by
%Kerry Emanuel
%   
    gpi = 0;
    gpi = ((10^5) * absVorticity)^(3/2);
    gpi = gpi * ((relHumidity/50)^3);
    gpi = gpi * ((potIntensity/70)^3);
    gpi = gpi * ((1+.01 * vShear)^-2) ;
end

