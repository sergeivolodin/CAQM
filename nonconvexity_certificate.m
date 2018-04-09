function is_nonconvex = nonconvexity_certificate(A, b, y, k)
% USAGE
% is_nonconvex = nonconvexity_certificate(A, b, [y], [k])
%
% DESCRIPTION
% This function calls get_c_minus and returns is_nonconvex = 1 if the latter returns a non-trivial c.
%
% INPUT
% * A -- tensor of rank 3
%   Dimensions: n x n x m
%     The element A(i, j, k) denotes i'th row and j'th column of the n x n matrix A_k
%     (k from 1 to m)
%
% * b -- tensor of rank 2
%   Dimensions: n x m
%     The element b(i, k) denotes i'th element of the vector b_k (k from 1 to m)
%
% * y (optional) -- column vector
%   Dimensions: m x 1
%     The point inside G = conv F, where F is the image of the quadratic map specified
%     by A and b. This point is used in the heuristic algorithm, see get_c_from_d
%     and get_c_minus
%   Default: f(0)
%
% * k (optional) -- integer
%     This parameter specifies the number of iterations for the heuristic algorithm.
%     The procedure will use up to k random directions d. Larger number k will result in
%     greater certainty if the result is is_nonconvex = 0
%   Default: 10
%
% OUTPUT
% This function attempts to establish if F is convex, returns is_nonconvex = 1 if F is non-convex,
% is_nonconvex = 0 if the convexity of F is uncertain
%
% EXAMPLE
%% Unset all variables in the workspace
%clear all;
%
%% should be executed from the root project folder which contains the file README.md
%ls README.md
%% ans = README.md
%
%% Load the map from file
%load('examples/maps/article_example05_R4_R4.mat');
%
%% Construct y in G
%x = [1 1 0 0]';
%y = quadratic_map(A, b, x);
%
%% Fix the random seed
%rng(10);
%
%% Run the procedure
%nonconvexity_certificate(A, b, y, 10)
%% ans = 1
%
% COPYRIGHT
% CAQM: Convexity Analysis of Quadratic Maps
% Copyright (c) 2015-2017 Anatoly Dymarsky, Elena Gryazina, Boris Polyak, Sergei Volodin
%

%% Implementation
%% Processing arguments
    if nargin < 2
        error('This function accepts at least 2 arguments, see readme.pdf');
    end

    % 2 arguments => assuming y0 = f(0)
    if nargin == 2
        y = quadratic_map(A, b, zeros(size(A, 1), 1));
    end

%% check for infeasibility
    is_infeasible = infeasibility_oracle(A, b, y);
    if is_infeasible
        error('The input point y is not in the convex hull G (proven by infeasibility oracle). Please find a point y in G = conv F to use in this function.');
    end

    % no 4th argument => assuming MAXITER=10
    if nargin <= 3
        k = 10;
    end

%% Running get_c_minus and checking if obtained any c
    is_nonconvex = 0;

    try
        [c, ~] = get_c_minus(A, b, y, k);
    
        if size(c, 1) > 0
            is_nonconvex = 1;
        end
    catch
    end
end
