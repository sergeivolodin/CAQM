%% This file generates a random map
% and stores the result to a .mat file

clear all;

%% generating map
n = 4;
m = 4;
is_complex = 0;

[A, b] = get_random_f(n, m, is_complex);

%% saving results
save('real_R4_R4.mat', 'A', 'b', 'n', 'm', 'is_complex');
