function [t, is_in_F] = boundary_oracle(A, b, y, d)
%% Usage
% [t, is_in_F] = boundary_oracle(A, b, y, d)
%
%% Description
% This function finds point y + td on the boundary ∂G with the largest t = sup{τ | y + τd ∈ G}
% and checks if this point belongs to F. See Optimization task (3) in the accompanying
% article for details.
%
%% Input
% * A -- tensor of rank 3
%   Dimensions: n x n x m
%     The element A(i, j, k) denotes i'th row and j'th column of the n x n matrix A_k
%     (k from 1 to m)
%
% * b -- tensor of rank 2
%   Dimensions: n x m
%     The element b(i, k) denotes i'th element of the vector b_k (k from 1 to m)
%
% * y -- column vector
%   Dimensions: m x 1
%     The point inside G = conv F, where F is the image of the quadratic map
%     specified by A and b
%
% * d -- column vector
%   Dimensions: m x 1
%     The direction of interest. The resulting point on the boundary will be of the form
%     y + t * d, where t is a scalar
%
%% Output
% The function returns t with the value of t, variable is_in_F = 1 if the boundary point y + td
% belongs to F, and variable is_in_F = 0 if feasibility of y + td with respect to F is uncertain.
%
% Exception: if the input vector y not in G or in the case if ∂G is not smooth at the
% boundary point y + td ∈ ∂G, the function produces an exception.
%
%% Example
%{
% --------------------------------------------------------------------------------------
% Unset all variables in the workspace
clear all;

% should be executed from the root project folder which contains the file README.md
ls README.md
% ans = README.md

% Load the map from file
load('examples/maps/article_example05_R4_R4.mat');

% Compute the point y from pre-image point x
x = [0 0 1 0]';
y = quadratic_map(A, b, x);

% Set the direction
d = [0 0 1 0]';

% Run the procedure
boundary_oracle(A, b, y, d)
% ans = 4.0169
% --------------------------------------------------------------------------------------
%}
%
%% Copyright
% CAQM: Convexity Analysis of Quadratic Maps
% Copyright (c) 2015-2017 Anatoly Dymarsky, Elena Gryazina, Boris Polyak, Sergei Volodin
%
%% Implementation
%% configuration
    rank_eps = 1e-3;

%% dimensions & init
    n = size(A, 1);
    m = size(A, 3);
    
    H = get_H(A, b);
    
    t = 0;
    is_in_F = 0;

%% solve task (4)
    cvx_clear;
    cvx_quiet true;
    
    cvx_begin
        % X vector from the article
        variable X(n + 1, n + 1);
        
        % resulting t
        variable t;
        
        % objective
        maximize(t)
        
        X == X';
        
        for i = 1:m
            trace(H(:, :, i) * X) == y(i) + t * d(i);
        end
        
        X == hermitian_semidefinite(n + 1);
        X(n + 1, n + 1) == 1
    cvx_end
    
%% no result (infeasible)
    if cvx_optval ~= Inf
        is_in_F = (rank(X, rank_eps) == 1);
    else
        error('Boundary oracle failed');
    end
end

