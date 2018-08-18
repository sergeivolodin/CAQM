%%
clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

%% defining map
n = 5;
m = 5;
is_complex = 0;

rng(47, 'twister');

a_max = 1;
A = zeros(n, n, m);

for i = 1 : m
    A(:, :, i) = randi([-a_max a_max], n, n);
    A(:, :, i) = (A(:, :, i) + A(:, :, i)');
end

% adding a bit of E to ensure existence of c_plus
A(:, :, m) = A(:, :, m) + 5 * a_max * eye(n);

b = randi([-a_max, a_max], n, m);

%% calculating c_plus
c_plus = get_c_plus(A);
disp('=== c_plus:');
disp(c_plus');

%% saving results
save('article_example07_R5_R5.mat', 'A', 'b', 'n', 'm', 'is_complex', 'c_plus');
