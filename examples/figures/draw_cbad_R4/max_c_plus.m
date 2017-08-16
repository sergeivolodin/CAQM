clear all;
load('example02.mat');
k = 150;
z_max_guess = 0.5;
n = size(A, 1);
m = size(A, 3);

%%
get_z = @(c) get_z_max(A, b, c, z_max_guess, k, 1);
c_plus_max = get_max_c_plus(A);
z_max_max = get_z(c_plus_max);

%%
[SX, SY, SZ] = sphere(4);
SX = SX(:);
SY = SY(:);
SZ = SZ(:);
S = zeros(3, size(SX, 1));
S(1, :) = SX;
S(2, :) = SY;
S(3, :) = SZ;
N = size(S, 2);
%scatter3(S(1, :), S(2, :), S(3, :));

%%
h = waitbar(0, 'c_{+}');
c_plus_array = zeros(m, N);
for i = 1:N
    sph_vect = null(c_plus') * S(:, i);
    c_plus_array(:, i) = get_near_c_plus(A, sph_vect, 0.001);
    waitbar(1. * i / N, h, sprintf('c_{+} %d/%d', i, N));
end
close(h);

%%
h = waitbar(0, 'z_{max}');
z_max_array = zeros(N, 1);
for i = 1:N
    z_max_array(i) = get_z(c_plus_array(:, i));
    waitbar(1. * i / N, h, sprintf('z_{max} %d/%d', i, N));
end
close(h);

%% saving results
save('output/example02_max_c_plus.mat');