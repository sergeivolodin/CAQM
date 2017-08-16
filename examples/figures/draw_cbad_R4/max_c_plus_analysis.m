clear all;
load('output/example02_max_c_plus.mat');

dist = c_plus_max - c_plus_array;
dist = sqrt(diag(dist'*dist));
z_max_array(z_max_array>=Inf) = 0;
scatter(dist, z_max_array)