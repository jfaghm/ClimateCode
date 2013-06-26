function mask = build_mask(lat,lon)
mask = zeros(length(lat),length(lon));
for i =1:length(lat)
    for j=1:length(lon)
        mask(i,j) = lat(i) & lon(j);
    end
end