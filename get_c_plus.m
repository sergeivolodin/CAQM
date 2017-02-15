function c = get_c_plus(A)
%% get_c_plus(A)
% obtain vector c s.t. c * A > 0
%
% example:
% [A, b] = get_random_f(4, 4);
% c_plus = get_c_plus(A);
% c_plus =
%
%     0.5430
%     0.3073
%    -0.7657
%    -0.1560

%% initializing
    % resulting c
    c = [];
    
    % is c found?
    found = 0;
    
    % dimensions
    m = size(A, 3);
    n = size(A, 1);
    
    % iterator
    i = 0;
    
    cvx_clear;
    cvx_quiet true;
    
 %% looking for c_plus
    while ~found
        fprintf('get_c_plus attempt %d\n', i);
        
        % random variable for diversity
        p = randn(m, 1);

        % solving LMI
        % c * A - 0.01E >=0
        % (c, p) = 1
        cvx_clear;
        cvx_begin
            variable c(m)
            minimize(1)
            Ac = get_Ac(A, c);
            Ac = Ac - 0.01 * eye(n);
            Ac  == semidefinite(n);
            c' * p == 1;
         cvx_end
         
         % checking feasibility
         if cvx_optval < Inf
             found = 1;
         end
    end
    
    % normalizing
    c = c / norm(c);
end