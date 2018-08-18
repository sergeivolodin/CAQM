%%
clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

%% defining map
n = 3;
m = 6;
is_complex = 1;

rng(47, 'twister');

a_max = 1;
A = zeros(n, n, m);

for j = 1 : m
    A(:, :, j) = randi([-a_max a_max], n, n) + randi([-a_max a_max], n, n) * i;
    A(:, :, j) = (A(:, :, j) + A(:, :, j)');
end

% adding a bit of E to ensure existence of c_plus
A(:, :, m) = A(:, :, m) + 5 * a_max * eye(n);

b = randi([-a_max, a_max], n, m);

%% calculating c_plus
c_plus = get_c_plus(A);
disp('=== c_plus:');
disp(c_plus');

%% saving results
save('article_example09_C3_R6.mat', 'A', 'b', 'n', 'm', 'is_complex', 'c_plus');