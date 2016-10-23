clear all

n = 3;
m = 3;
A(:, :, 1) = [1 1 1; 1 2 0; 1 0 2];
A(:, :, 2) = [3 -1 0; -1 0 -1; 0 -1 1];
A(:, :, 3) = eye(n, n);

b(:, 1) = [1 1 1];
b(:, 2) = [1 0 -1];
b(:, 3) = [0 0 0];

y0 = [0 1 1];

% TODO: check infeasibility of y0

%c = get_nonconvex_c(A, b, y0, 1000);

%c

c_plus = get_c_plus(A);
c = get_nonconvex_c(A, b, y0, 1000);