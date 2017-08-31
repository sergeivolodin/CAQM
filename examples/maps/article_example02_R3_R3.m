%%
clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

%% defining map
n = 3;
m = 3;

A(:, :, 1) = [1 -0.25 0.5;-0.25 0 0;0.5 0 0];
A(:, :, 2) = [0 -0.25 0;-0.25 1 -0.5;0 -0.5 0];
A(:, :, 3) = [0 0 -eps;0 0 -eps;-eps -eps 1];

b(:, 1) = [-0.75 0 0]';
b(:, 2) = [0 0.25 0]';
b(:, 3) = [0 0 -0.5];

c_plus = [0.5 0.5 0.25]';
c_plus = c_plus / norm(c_plus);

%% saving results
save('article_example02_R3_R3.mat', 'A', 'b', 'n', 'm', 'c_plus');
