function z_max = get_z_max(A, b, y, k, c_plus, MAXITER)
%% z_max = get_z_max(A, b, y, k, c_plus)
% obtain z_max = inf z(c) over C_-

%% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

%% todo:
% y = new_basis(y)

z_array = [Inf];

for i = 1:k
    %% c, s.t. Theorem 3.4 holds
    [~, c] = get_c_minus(A_, b_, y, MAXITER);

    %% minimizing z(c)
    [z, ~, ~, success] = minimize_z_c(A_, b_, c, c_plus, 1, 1);

    if success == 1
        z_array(end + 1) = z;
    end
end

z_max = min(z_array);
end