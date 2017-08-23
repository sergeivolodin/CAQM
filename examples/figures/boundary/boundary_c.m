%%
clear all;

%% obtaining c vectors
[SX, SY, SZ] = sphere(100);
SX = SX(:);
SY = SY(:);
SZ = SZ(:);
S = zeros(3, size(SX, 1));
S(1, :) = SX;
S(2, :) = SY;
S(3, :) = SZ;
N = size(S, 2);

%% the map
n = 3;
m = 3;

A(:, :, 1) = [1 1 1; 1 2 0; 1 0 2];
A(:, :, 2) = [3 -1 0; -1 0 -1; 0 -1 1];
A(:, :, 3) = eye(n);

b(:, 1) = [1 1 1]';
b(:, 2) = [1 0 -1]';
b(:, 3) = [0 0 0]';

Y = [];

h = waitbar(0);

for i = 1:N
    c = S(:, i);
    % x = - (c*A)^(-1)*(c*b)
    x = - pinv(get_Ac(A, c)) * (b * c);
    y = quadratic_map(A, b, x);
    Y(:, i) = y;
    waitbar(1. * i / N, h);
end

close(h);

%% plot
Y(:, diag(Y'*Y)>5) = 0;
scatter3(Y(1, :), Y(2, :), Y(3, :))