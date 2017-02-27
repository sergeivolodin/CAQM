function z_max = get_z_max(A, b, y, k, c_plus, MAXITER, DEBUG)
%% z_max = get_z_max(A, b, y, k, c_plus, MAXITER)
% obtain z_max = inf z(c) over C_- using at most
% k iterations of get_c_minus with MAXITER

%%
if nargin == 6
    DEBUG = 0;
end

%% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

%% todo:
% y = new_basis(y)

z_array = Inf;

for i = 1:k
    try
        %% c, s.t. Theorem 3.4 holds
        [c, ~] = get_c_minus(A_, b_, y, MAXITER, DEBUG);
        
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