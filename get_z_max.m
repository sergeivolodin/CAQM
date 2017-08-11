function z_max = get_z_max(A, b, c_plus, z_max_guess, k, DEBUG)
%% z_max = get_z_max(A, b, c_plus, z_max_guess, k)
% obtain z_max = inf z(c) over C_- using at most
% k iterations of get_c_minus
%
% Format for the map f:
% matrices (A_1, ..., A_m) -> tensor A(i, j, k) -- i'th row, j'th column of matrix A_k
% vectors  (b_1, ..., b_m) -> tensor b(i, j)    -- i'th element          of vector b_j
%
% y = y_0 - z_max_guess * c_plus
% where y_0 is the boundary point which is touched by hyperplane c_plus
%
%% example
% 1) loading map from file
% 2) obtaining c_plus for map
% 3) minimizing z(c) over c_- using k = 1 starting point
%
% clear all;
% load('maps/real_R4_R4.mat');
% c_plus = get_c_plus(A, 10, 1);
% get_z_max(A, b, c_plus, 0.01, 10)

%%
    if nargin == 5
        DEBUG = 0;
    end

%%
    x = -get_Ac(A, c_plus) * get_Ac(b, c);
    y = quadratic_map(A, b, x) - z_max_guess * c_plus;

%% basis: c_+A=I, c_+b=0
    [A_, b_, ~, y0] = change_basis(A, b, c_plus);

% new y0 for A_, b_
    y = y - y0;

% resulting z
    z_array = Inf(k + 1, 1);

    for i = 1:k
        try
            %% c, s.t. Theorem 3.4 holds
            [c, ~] = get_c_minus(A_, b_, y, 1, DEBUG);

            % minimizing z(c)
            [z, ~, ~] = minimize_z_c(A_, b_, c, c_plus, 1, 1, DEBUG);

            % adding z(c^*) to z_array
            z_array(end + 1) = z;
        catch
            continue
        end
    end

    z_max = min(z_array);
end
