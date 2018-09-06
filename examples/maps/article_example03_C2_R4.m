%%
clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

%% defining map
n = 2;
m = 4;
is_complex = 1;

A = zeros(n, n, m);
b = zeros(n, m);

A(:, :, 1) = [[2, -0.5]; [-0.5, 0]];
A(:, :, 2) = [[0, -0.5]; [-0.5, 1]];
A(:, :, 3) = [[-1, -0.5i]; [+0.5i,  0]];
A(:, :, 4) = [[0,  +0.5i]; [-0.5i,  0]];

b(:, 1) = [+0.5+0.5i;  0];
b(:, 2) = [0        ;  0];
b(:, 3) = [-0.5+0.5i;  0];
b(:, 4) = [0        ;  0];

c_plus = [1 1 0 0]' / sqrt(2);

%% saving results
save('article_example03_C2_R4.mat', 'A', 'b', 'n', 'm', 'is_complex', 'c_plus');
