function [c, i] = get_c_minus(A, b, y0, MAXITER, DEBUG)
%% Usage
% c = get_c_minus(A, b, [y], [k], [DEBUG])
%
%% Description
% This function finds and returns vector c such that ∂F_c is non-convex through a stochastic
% algorithm using up to k iterations.
%
% This function consequently generates up to k random directions d and for each one finds vector c normal
% to ∂G at the boundary point y + td ∈ ∂G. Next it finds ∂F_c, the intersection of F with the supporting
% hyperplane orthogonal to c and checks if it is non-convex.
%
% If y and k are not specified, the unction uses default values y = f(0) = 0 and k = 10.
%
% DEBUG, if set to 1, will produce additional output indicating progress. Default value is 0
% which gives no additional output
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
% * y (optional parameter) -- column vector
%   Dimensions: m x 1
%     The point inside G = conv F, where F is the image of the quadratic map specified
%     by A and b. This point is used in the heuristic algorithm, see get_c_from_d
%
% * k (optional parameter) -- integer
%     This parameter specifies the number of iterations for the heuristic algorithm.
%     The procedure will use up to k random directions d. If your current k does not
%     yield the vector c, try larger number k
%
%% Output
% This function stops and returns c if non-convexity of ∂F c was established during one
% of the iterations. If the vector c was not found, an exception is produced.
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

% Construct y in G
x = [1 1 0 0]';
y = quadratic_map(A, b, x);

% Fix the random seed
rng(10);

% Run the procedure
get_c_minus(A, b, y, 10, 1)
% ans = 0.7891 0.3782 -0.3916 -0.2843
% --------------------------------------------------------------------------------------
%}
%
%% Copyright
% CAQM: Convexity Analysis of Quadratic Maps
% Copyright (c) 2015-2017 Anatoly Dymarsky, Elena Gryazina, Boris Polyak, Sergei Volodin
%
%% Implementation
%% Processing arguments
    % error message on too few arguments
    if nargin < 2
        error('This function accepts at least 2 arguments, see readme.pdf');
    end

    % 2 arguments => assuming y0 = f(0)
    if nargin == 2
        y0 = quadratic_map(A, b, zeros(size(A, 1), 1));
    end

    % no 4th argument => assuming MAXITER=10
    if nargin <= 3
        MAXITER = 10;
    end

    % no 5th argument => assuming no debug
    if nargin <= 4
        DEBUG = 0;
    end

%% initializing
    % resulting c
    c = [];
    
    % m dimension
    m = size(A, 3);
    
    % H from article
    H = get_H(A, b);
    
    % is c found?
    found = 0;
    
    % iterator
    i = 0;
    
%% looking for c
    
    % making MAXITER attemts or less
    while (~found) && (i < MAXITER)
        if DEBUG
            fprintf('get_c_minus attempt %d\n', i);
        end
        
        % random direction
        d = randn(m, 1);
        
        % obtaining c via dual problem
        c = get_c_from_d_H(H, y0, d);
        
        % checking if c is a vector
        if size(c, 1) == m
            % checking nonconvexity
            if is_nonconvex(A, b, c)
                found = 1;
            else
                c = [];
            end
        end
        i = i + 1;
    end
    
    if size(c, 1) == 0
        error('No c_minus found');
    end
    
    % normalizing
    c = c / norm(c);
end
