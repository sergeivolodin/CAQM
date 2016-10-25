function m = get_m(A_, b_, c_1, n, x_0, lambda)
    c_lambda = c_1 + lambda * n;
    c_lambda = c_lambda / norm(c_lambda);
    A_lambda = get_Ac(A_, c_lambda);
    [q1, ~] = eig(A_lambda);
    %lambda_min_lambda = q2(1, 1);
    x_0_lambda = q1(:, 1);
    if dot(x_0_lambda, x_0) < 0
        x_0_lambda = -x_0_lambda;
    end
    x_0_lambda = x_0_lambda / norm(x_0_lambda);
    m = (b_ * c_lambda)' * x_0_lambda;
end

