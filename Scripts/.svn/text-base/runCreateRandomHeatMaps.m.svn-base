
% This script runs createRandomHeatMaps with 1000 trials

stormLims.step = 1;
stormLims.minWidth = 15;
stormLims.maxWidth = 60;
stormLims.minHeight = 10;
stormLims.maxHeight = 25;
stormLims.north = 35;
stormLims.south = -5;
stormLims.west = -90;
stormLims.east = 0;
%stormLims.minStorms = ;

sstLims.step = 1;
sstLims.minWidth = 10;
sstLims.maxWidth = 10;
sstLims.minHeight = 10;
sstLims.maxHeight = 10;
sstLims.north = 35;
sstLims.south = -5;
sstLims.west = -90;
sstLims.east = 0;

saveEach = false;
encConstraint = true;

createRandomHeatMaps( sstLims, stormLims, [-60 60], [-90 10], 'Presentation/', 1000, encConstraint, saveEach );

!pwd | mail -s finished haask010@umn.edu