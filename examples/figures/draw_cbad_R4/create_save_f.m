%% create_save_f
% create random map
% generate c_plus
% save to file

%%

clear all;

%% generating map
n = 4;
m = 4;

[A, b] = get_random_f(n, m);

%% looking for c_plus
c_plus = get_c_plus(A);

%% saving results
save('example.mat', 'A', 'b', 'c_plus', 'n','m');