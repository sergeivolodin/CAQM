function [Q, Q_inv, k, v, lambda_min, z, dz_dc, normal_re, normal_im, drho_dc] = get_dz_dc(A, b, c)
%% [Q, Q_inv, x_0, v, lambda_min, z, dz_dc, normal_re, normal_im] = get_gradient(A_, b_, c)
% calculate gradient dz_dc
% also outputs values used in calculation

%%
    % dimensions
    n = size(A, 1);
    m = size(A, 3);
    
    % c * A
    Ac = get_Ac(A, c);

    % calculating Q and x_0
    [q1, q2] = eig(Ac);
    [q2, q3] = sort(diag(q2));
    q1 = q1(:, q3);
    q2 = diag(q2);
    lambda_min = q2(1, 1);
    k = q1(:, 1);
    Q = Ac - lambda_min * eye(n);

    % calculating v
    b_c = b * c;
    Q_inv = pinv(Q, get_config().Q_inv_eps);
    v = Q_inv * b_c;

    % z(c)
    z = norm(v) ^ 2;

    % calculating normal and gradient
    dz_dc = zeros(m, 1);
    drho_dc = zeros(m, 1);
    normal_re = zeros(m, 1);
    normal_im = zeros(m, 1);

    for i = 1:m
        R = A(:, :, i) - eye(n) * (k' * A(:, :, i) * k);
        q = b(:, i) - R * v;
        dz_dc(i) = 2 * real(v' * Q_inv * q);
        drho_dc(i) = 2 * real(b_c' * (k * k') * q);
        normal = (b(:, i)' - v' * R) * k;
        normal_re(i) = real(normal);
        normal_im(i) = imag(normal);
    end

    % normalizing normal
    normal_re = normal_re / norm(normal_re);
    normal_im = normal_im / norm(normal_im);
end

