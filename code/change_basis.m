% change basis s.t. 
% c_plus * A = I
% c_plus * b = 0
%
% equations:
% x = S(x' + x0)
% y = y' + y0

function [A_, b_] = change_basis(A, b, c_plus)
    n = size(A, 1);
    m = size(A, 3);
    A_plus = get_Ac(A, c_plus);
    [q1, q2] = eig(A_plus);
    S_0 = q1;
    S_1 = sqrt(inv(q2));
    S = S_0 * S_1;
    x0 = -S'*(b * c_plus);

    A_ = zeros(size(A));
    b_ = zeros(size(b));
    for i = 1:m
        A_(:, :, i) = S' * A(:, :, i) * S;
        b_(:, i) = S' * b(:, i) + A_(:, :, i) * x0;
    end
end