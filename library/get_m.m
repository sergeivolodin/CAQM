function m = get_m(A, b, c_1, n, x_0, lambda)
%% m = get_m(A, b, c_1, n, x_0, lambda)
% get m(lambda) = x_0'(c*b)
% it is a distance to c_minus
% function used in projection

%%
    % define c(lambda)
    c_lambda = c_1 + lambda * n;
    c_lambda = c_lambda / norm(c_lambda);
    A_lambda = get_Ac(A, c_lambda);
    
    % eigens of A_lambda
    [q1, q2] = eig(A_lambda);
    [~, q3] = sort(diag(q2));
    q1 = q1(:, q3);
    
    % obtain x_0(lambda)
    x_0_lambda = q1(:, 1);
    if dot(x_0_lambda, x_0) < 0
        x_0_lambda = -x_0_lambda;
    end
    
    x_0_lambda = x_0_lambda / norm(x_0_lambda);
    
    m = (b * c_lambda)' * x_0_lambda;
end

