clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading map
load('./maps/article_example01_R3_R3.mat');

disp('1. The map R3->R3');
for i = 1:m
    fprintf('A_%d = %s\n', i, mat2str(A(:, :, i)));
end

for i = 1:m
    fprintf('b_%d = %s\n', i, mat2str(b(:, i)));
end

%%

fprintf('2. c_+ = %s\n', mat2str(c_plus));

%%
rand_seed = 42;
rng(rand_seed);
fprintf('3. Random seed set to %d\n', rand_seed);

%%
fprintf('4. Finding convex cut\n');
z_max = get_z_max(A, b, c_plus, 0.2, 200, 1);

fprintf('Result: convex cut of size %f\n', z_max);
