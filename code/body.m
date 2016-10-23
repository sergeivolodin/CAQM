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
%c = get_nonconvex_c(A, b, y0, 1000);

A_plus = get_Ac(A, c_plus);


[S, ~] = eig(A_plus);

A_tilde = zeros(size(A));
b_tilde = zeros(size(b));
for i = 1:m
    A_tilde(:, :, i) = S' * A(:, :, i) * S;
    b_tilde(:, i) = S' * b(:, i);
end