function plot_storm_locations(lats,lons,marker,fig_title)
worldmap world
title(fig_title);
plotm(lats, lons,marker)
coast = load('coast');
geoshow(coast.lat, coast.long, 'Color', 'black')
