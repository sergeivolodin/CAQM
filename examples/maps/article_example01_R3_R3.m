%%
clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

%% defining map
n = 3;
m = 3;

A(:, :, 1) = [1 1 1; 1 2 0; 1 0 2];
A(:, :, 2) = [3 -1 0; -1 0 -1; 0 -1 1];
A(:, :, 3) = eye(n);

b(:, 1) = [1 1 1]';
b(:, 2) = [1 0 -1]';
b(:, 3) = [0 0 0]';

c_plus = [0 0 1]';

%% saving results
save('article_example01_R3_R3.mat', 'A', 'b', 'n', 'm', 'c_plus');
