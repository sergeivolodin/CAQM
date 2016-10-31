function z = get_z(A_, b_, c)
    n = size(A_, 1);
    % c * A
    Ac = get_Ac(A_, c);

    % calculating Q and x_0
    [q1, q2] = eig(Ac);
    [q2, q3] = sort(diag(q2));
    q1 = q1(:, q3);
    q2 = diag(q2);
    lambda_min = q2(1, 1);
    Q = Ac - lambda_min * eye(n);

    % calculating v
    b_c = b_ * c;
    Q_inv = pinv(Q, 1e-5);
    v = Q_inv * b_c;

    % z(c)
    z = norm(v) ^ 2;
end