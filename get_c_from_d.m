function c = get_c_from_d(A, b, y, d)
% USAGE
% c = get_c_from_d(A, b, y, d)
%
% DESCRIPTION
% This function finds the boundary point y + td ∈ ∂G by maximizing scalar value t and calculates
% the vector c normal to ∂G at that point by using the dual formulation of
% the optimization problem, see equation (4) of the accompanying article.
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
% OUTPUT
% The function returns vector variable c with the value of the normal vector at the boundary point
% y + td, where t = sup{τ | y + τd ∈ G}, G = convF, F is the image of quadratic map specified
% by A and b
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
%% Compute the point y from pre-image point x
%x = [0 0 1 0]';
%y = quadratic_map(A, b, x);
%
%% Set the direction
%d = [0 0 1 0]';
%
%% Run the procedure
%get_c_from_d(A, b, y, d)
%% ans = 2.1936 1.0360 -1.0000 -0.7509
%
% COPYRIGHT
% CAQM: Convexity Analysis of Quadratic Maps
% Copyright (c) 2015-2017 Anatoly Dymarsky, Elena Gryazina, Boris Polyak, Sergei Volodin
%

%% Implementation
%% check for infeasibility
    is_infeasible = infeasibility_oracle(A, b, y);
    if is_infeasible
        error('The input point y is not in the convex hull G (proven by infeasibility oracle). Please find a point y in G = conv F to use in this function.');
    end

%% call to function
    c = get_c_from_d_H(get_H(A, b), y, d);
end
