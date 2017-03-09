function [A_, b_, x0, y0] = change_basis(A, b, c_plus)
%% [A_, b_, x0, y0] = change_basis(A, b, c_plus)
% change basis s.t. 
% c_plus * A_ = I
% c_plus * b_ = 0
%
% equations:
% x = S(x' + x0)
% y = y' + y0

%%
    % dimension
    m = size(A, 3);
    
    % c_plus * A
    A_plus = get_Ac(A, c_plus);
    
    % eigenvectors of A_+
    [q1, q2] = eig(A_plus);
    S_0 = q1;
    S_1 = sqrt(inv(q2));
    S = S_0 * S_1;
    
    % new x0
    x0 = -S'*(b * c_plus);
    
    % y0
    y0 = quadratic_map(A, b, x0);

    % new A_, b_
    A_ = zeros(size(A));
    b_ = zeros(size(b));
    
    % filling A_ and b_
    for i = 1:m
        A_(:, :, i) = S' * A(:, :, i) * S;
        b_(:, i) = S' * b(:, i) + A_(:, :, i) * x0;
    end
end