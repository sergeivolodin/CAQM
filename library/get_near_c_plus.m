function c = get_near_c_plus(A, p, norm_penalty)
%% c = get_near_c_plus(A, p, norm_penalty)
% obtain vector c s.t. c * A > 0
% c close to p
% p -- initial vector
% norm_penalty -- penalty for c' * c (see below)

%% initializing

    % penalty for c' * c
    if nargin == 2
        norm_penalty = 0.01 + rand(1) / 10;
    end

    p = p / norm(p);

    % resulting c
    c = [];
     
    % dimensions
    m = size(A, 3);
    n = size(A, 1);
    
    cvx_clear;
    cvx_quiet true;
    
%% looking for c_plus
        
    % Want to obtain c close to p
    % c = x + y
    % y = p * (p, c)
    % x'x = c' (I-pp') c
    % total penalty: c * norm^2 + x'x
    P = (1 + norm_penalty) * eye(m) - p * p';

    % solving LMI
    % c * A - I >=0
    % c' * P * c -> min
    % c' * p >= 1
    cvx_clear;
    cvx_begin
        variable c(m)
        minimize(c' * P * c)
        Ac = get_Ac(A, c);
        Ac - eye(n)  == hermitian_semidefinite(n);
        c' * p >= 0;
     cvx_end
         
     % checking feasibility
     if cvx_optval >= Inf
         error('Not found');
     end
     
     c = c / norm(c);
end
