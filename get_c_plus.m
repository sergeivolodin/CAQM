function c = get_c_plus(A, k, DEBUG)
% USAGE
% c_plus = get_c_plus(A, [k], [DEBUG])
%
% DESCRIPTION
% This function utilizes a randomized algorithm which is used to find c_+ such that c_+ · A > 0.
%
% DEBUG, if set to 1, will produce additional output indicating progress. Default value is 0
% which gives no additional output
%
% INPUT
% * A -- tensor of rank 3
%   Dimensions: n x n x m
%     The element A(i, j, k) denotes i'th row and j'th column of the n x n matrix A_k
%     (k from 1 to m)
%
% * k (optional) -- integer
%     The number of iterations for a heuristic algorithm. If your current k does not yield any c_+,
%     try larger value of k
%   Default: 10
%
% OUTPUT
% If successful, the function terminates and returns c_+ on the exit, otherwise the search attempt is repeated
% up to k times. If not specified explicitly, the default value of k is 10. If c_+ is not found during k iterations,
% the function produces an exception.
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
%% Fix the random seed
%rng(10);
%
%% Run the procedure
%get_c_plus(A, 10, 1)
%% ans = 1 0 0 0
%
% COPYRIGHT
% CAQM: Convexity Analysis of Quadratic Maps
% Copyright (c) 2015-2017 Anatoly Dymarsky, Elena Gryazina, Sergei Volodin, Boris Polyak
%

%% Implementation
%% Processing arguments
    % error message on too few arguments
    if nargin < 1
        error('This function accepts at least 1 argument, see readme.pdf');
    end

    % 1 argument => assuming k = 10
    if nargin == 1
        k = 10;
    end

    if nargin <= 2
        DEBUG = 0;
    end

%% initializing
    % resulting c
    c = [];
    
    % is c found?
    found = 0;
    
    % dimensions
    m = size(A, 3);
    
    % iterator
    i = 0;
    
    cvx_clear;
    cvx_quiet true;
    
%% looking for c_plus
    while ~found && i < k
        if DEBUG
            fprintf('get_c_plus attempt %d\n', i);
        end
        
        % choosing p for diversity
        p = randn(m, 1);
        
        try
            c = get_near_c_plus(A, p);
            found = 1;
        catch
            
        end
         
        i = i + 1;
    end
    
    if found == 0
        error('No c_plus found');
    end
    
    % normalizing
    c = c / norm(c);
end
