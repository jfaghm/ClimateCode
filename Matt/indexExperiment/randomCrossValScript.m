sstIndex = buildIndex4(1, 3, 10);
randomCrossValCorrelations(sstIndex, 32, 1000, 'SST');
'done with sst'
olrIndex = buildIndex4(2, 3, 10);
randomCrossValCorrelations(olrIndex, 32, 1000, 'OLR');
'done with olr'