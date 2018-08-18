%%
clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

%% defining map
n = 4;
m = 4;
is_complex = 0;

% fixing the random seed
rng(47, 'twister');

% defining A matrices
A(:, :, 1) = [0 1 0 0; 1 0 0 0; 0 0 0 1; 0 0 1 0];
A(:, :, 2) = [0 0 1 0; 0 2 0 1; 1 0 2 0; 0 1 0 0];
A(:, :, 3) = [0 0 0 1; 0 -1 1 0; 0 1 1 0; 1 0 0 0];
A(:, :, 4) = eye(4);

% homogeneous map, therefore b = 0
b = zeros(4);

%% calculating c_plus
c_plus = [0 0 0 1]';
disp('=== c_plus:');
disp(c_plus');

%% saving results
save('article_example10_homog_R4_R4.mat', 'A', 'b', 'n', 'm', 'is_complex', 'c_plus');