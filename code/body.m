clear all

% example set
n = 3;
m = 3;
A(:, :, 1) = [1 1 1; 1 2 0; 1 0 2];
A(:, :, 2) = [3 -1 0; -1 0 -1; 0 -1 1];
A(:, :, 3) = eye(n, n);

b(:, 1) = [1 1 1];
b(:, 2) = [1 0 -1];
b(:, 3) = [0 0 0];

% a point inside F
y0 = [0 1 1];

% TODO: check infeasibility of y0

% c, s.t. Theorem 3.4 holds
%c = get_nonconvex_c(A, b, y0, 1000);

% c, s.t. c * A > 0
c_plus = get_c_plus(A);

% A_+ = c_+ * A
A_plus = get_Ac(A, c_plus);


[S, ~] = eig(A_plus);

A_tilde = zeros(size(A));
b_tilde = zeros(size(b));
for i = 1:m
    A_tilde(:, :, i) = S' * A(:, :, i) * S;
    b_tilde(:, i) = S' * b(:, i);
end