function c = homogeneous_real_nonconvexity_certificate(A)
%% c = homogeneous_real_nonconvexity_certificate(A)
% obtain vector c s.t. lambda_min(c*A) -> max
% and Tr(c*A)=0
% and sum(c) == 1

%% initializing
    c = [];
     
    % dimensions
    m = size(A, 3);
    n = size(A, 1);
    
    % only works for real maps
    assert(isreal(A));

    cvx_clear;
    cvx_quiet true;
    
%% looking for c_plus
    
    cvx_clear;
    cvx_begin
        variable gam;
        variable c(m);
        maximize(gam);
        Ac = get_Ac(A, c);
        sum(c) == 1;
        Ac - gam * eye(n) == hermitian_semidefinite(n);
        trace(Ac) == 0;
    cvx_end
     
    % checking feasibility
    if cvx_optval >= Inf
        error('Not found');
    end

%    fprintf('CVX Status: %s\n', cvx_status);
%    fprintf('Gamma: %.5f\n', gam);
     
%    c = c;
end
