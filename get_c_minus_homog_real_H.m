function c = get_c_minus_homog_real_H(A)
% USAGE
% c = get_c_minus_homog_real_H(A)
%
% DESCRIPTION
% This function finds and returns vector c such that ∂H_c is non-convex through a deterministic
% algorithm described in the Appendix B of the article. Only real homogeneous maps are supported
%
% Specifically, it obtains a vector c s.t. lambda_min(c*A) -> max; Tr(c*A)=0 and sum(c) == 1
% See Appendix B of the article for full problem description.
%
% INPUT
% * A -- tensor of rank 3
%   Dimensions: n x n x m
%     The element A(i, j, k) denotes i'th row and j'th column of the n x n matrix A_k
%     (k from 1 to m)
%
% OUTPUT
% This function stops and returns c if non-convexity of ∂H_c was established
% If the vector c was not found or it is not a non-convexity, an exception is produced.
%
% EXAMPLE
%% Unset all variables in the workspace
%clear all;
%
%% should be executed from the root project folder which contains the file README.md
%ls README.md
%% ans = README.md
%
%% Create a random homog. map (fixed random seed)
% rng(10);
% [A, ~] = get_random_f(10, 11);
%
%% Run the procedure
% c = get_c_minus_homog_real_H(A);
%% Outputs a value -- means that verification of non-convexity was done
%
% COPYRIGHT
% CAQM: Convexity Analysis of Quadratic Maps
% Copyright (c) 2015-2017 Anatoly Dymarsky, Elena Gryazina, Sergei Volodin, Boris Polyak
%

%% Implementation
%% Processing arguments
%% initializing
    c = [];
     
    % dimensions
    m = size(A, 3);
    n = size(A, 1);
    
    % only works for real maps
    assert(isreal(A));

    cvx_clear;
    cvx_quiet true;
    
%% looking for c_minus using the Optimization problem from Appendix B (article)
    
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

    % checking that it's non-convex
    if ~is_nonconvex(A, zeros(n, m), c, 0, 1)
        error('Found but not non-convex');
    end

%    fprintf('CVX Status: %s\n', cvx_status);
%    fprintf('Gamma: %.5f\n', gam);
     
%    c = c;
end
