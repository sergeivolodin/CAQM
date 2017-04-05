function c = get_best_c_plus(A)
%% c = get_near_c_plus(A, p, norm_penalty)
% obtain vector c s.t. lambda_min(c * A) -> max
% and c ' * c <= 1

%% initializing
    c = [];
     
    % dimensions
    m = size(A, 3);
    n = size(A, 1);
    
    cvx_clear;
    cvx_quiet true;
    
%% looking for c_plus
    
    cvx_clear;
    cvx_begin
        variable c(m)
        Ac = get_Ac(A, c);
        c' * c <= 1;
        maximize(lambda_min(Ac));
    cvx_end
     
    % checking feasibility
    if cvx_optval >= Inf
        error('Not found');
    end
     
    c = c / norm(c);
end