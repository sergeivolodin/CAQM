A(:, :, 1) = [0 1 0 0; 1 0 0 0; 0 0 0 1; 0 0 1 0];
A(:, :, 2) = [0 0 1 0; 0 2 0 1; 1 0 2 0; 0 1 0 0];
A(:, :, 3) = [0 0 0 1; 0 -1 1 0; 0 1 1 0; 1 0 0 0];
A(:, :, 4) = eye(4);
b = zeros(4);
rng(10);
c_minus = get_c_minus(A, b, [0, 0, 0, 1]', 10);
rng(10);
is_nonconvex = nonconvexity_certificate(A, b, [0, 0, 0, 1]', 10);

display(is_nonconvex);
display(c_minus);
