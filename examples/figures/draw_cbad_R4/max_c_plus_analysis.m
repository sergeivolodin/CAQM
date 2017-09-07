clear all;
load('output/example03_max_c_plus.mat');

dist = c_plus_max - c_plus_array;
dist = sqrt(diag(dist'*dist));
%dist = c_plus_array' * c_plus_max;
z_max_array(z_max_array>=Inf) = 0;
scatter(dist, z_max_array)