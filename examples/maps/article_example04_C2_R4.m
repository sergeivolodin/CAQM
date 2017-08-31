%%
clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

%% defining map
is_complex = 1;
n = 2;
m = 4;

A(:, :, 1) = [3.7, -0.6 + 0.8j;-0.6-0.8j,0];
A(:, :, 2) = [1 0;0 0];
A(:, :, 3) = [0,-0.6-0.8j;-0.6+0.8j,3.6];
A(:, :, 4) = [0,-0.8+0.6j;-0.8-0.6j,4.8];

b(:, 1) = [-1.25+1.25j;0];
b(:, 2) = [0;0];
b(:, 3) = [0;-1.2+1.6j];
b(:, 4) = [0;-1.6-1.2j];

%% saving results
save('article_example04_C2_R4.mat', 'A', 'b', 'n', 'm', 'is_complex');
