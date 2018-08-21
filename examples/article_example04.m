clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading map
load('./maps/article_example04_C2_R4.mat');

disp('1. The map C2->R4');
for i = 1:m
    fprintf('A_%d = %s\n', i, mat2str(A(:, :, i)));
end

for i = 1:m
    fprintf('b_%d = %s\n', i, mat2str(b(:, i)));
end

%%
rand_seed = 2;
rng(rand_seed);
fprintf('3. Random seed set to %d\n', rand_seed);

%% obtained s.t. point y0+c_plus*z_guess is close to the nonconvexity at (0, 0)
c_plus = [0.7991 -0.3533 0.3924 0.2876]';

fprintf('2. c_+ = %s\n', mat2str(c_plus));

%%
fprintf('4. Finding convex cut\n');
z_max = get_z_max(A, b, c_plus, 1.7901, 500, 1);

% Note that there are two vectors c_-: (0 1 0 0) -- analytically correct
% And another one, which is not really a c_- (numerical error for checking
% rank -- matrix is near degenerate and is considered degenerate, which is
% wrong.
fprintf('Result: convex cut of size %f\n', z_max);