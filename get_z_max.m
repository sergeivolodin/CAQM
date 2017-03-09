function z_max = get_z_max(A, b, y, k, c_plus, MAXITER, DEBUG)
%% z_max = get_z_max(A, b, y, k, c_plus, MAXITER)
% obtain z_max = inf z(c) over C_- using at most
% k iterations of get_c_minus with MAXITER

%%
if nargin == 6
    DEBUG = 0;
end

%% basis: c_+A=I, c_+b=0
[A_, b_, ~, y0] = change_basis(A, b, c_plus);

% new y0 for A_, b_
y = y - y0;

% resulting z
z_array = Inf(k + 1, 1);

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