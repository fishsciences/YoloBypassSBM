# sobol tests

library(YoloBypassSBM) # master branch

a = YoloBypassSBM::rearing_growth("2011", 100, 7, "Yolo", 14) # previous value 14.78757

b = sobol::rearing_growth("2011", 100, 7, "Yolo", 14)

stopifnot(a != b) # these results should not be the same.
