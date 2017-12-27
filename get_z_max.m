function z_max = get_z_max(A, b, c_plus, z_max_guess, k, DEBUG)
%% Usage
% z_max = get_z_max(A, b, c_plus, [z_max_guess], [k], [DEBUG])
%
%% Description
% This function returns maximal value z_max such that the hyperplane perpendicular to c_+ and located
% distance z_max away from the boundary of F still does not contain non-convexities.
%
% DEBUG, if set to 1, will produce additional graphical output indicating progress.
% Default value is 0, which gives no additional output.
%
% This function uses MATLAB parallel capabilities, if they are detected on the system.
% Otherwise, a single thread is used.
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
% * c_plus -- column vector
%   Dimensions: m x 1
%     The direction in the image space satisfying c_+ · A >= 0. The resulting convex subpart will be
%     specified in terms of hyperplanes in the image space which are normal to this vector.
%
% * z_max_guess (optional) -- real
%     The guess value for the answer used by the heuristic algorithm. This value should be greater than
%     the answer. If too small value does not work, try bigger guess.
%   Default: 10 * Trace(c_+ · A) (heuristic)
%
% * k (optional) -- integer
%     Number of iterations for the heuristic algorithm. At each iteration, the algorithm tries to locate
%     a nonconvexity and thus lower the z_max bound. If your number of iterations k does not yield any
%     nonconvexities, try larger k
%   Default: 10
%
%% Output
% The function finds and returns maximal value z_max such that the compact part of F “cut” by the hyperplane
% c_+ · (y − y_0) = z_max, is still convex. Here y_0 ∈ ∂F_c+, the latter set is singleton.
%
% Exception: produces an exception if non-convexity of F confined within the half-plane c_+ ·(y - y_0) ≤ z_max
% has not been established, i.e. no non-convexities were found in that region.
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

% Fix the random seed
rng(10);

% Obtain c_plus s.t. c_plus · A > 0
c_plus = get_c_plus(A, 10, 1);

% Fix the random seed
rng(10);

% Run the procedure with graphical debug output
get_z_max(A, b, c_plus, 100, 10, 1)
% ans = 0.0073
% --------------------------------------------------------------------------------------
%}
%
%% Copyright
% CAQM: Convexity Analysis of Quadratic Maps
% Copyright (c) 2015-2017 Anatoly Dymarsky, Elena Gryazina, Boris Polyak, Sergei Volodin
%
%% Implementation
%% Process arguments
    % too few arguments
    if nargin < 3
        error('This function accepts at least 3 arguments, see readme.pdf');
    end

    % no z_max_guess provided
    if nargin == 3
        z_max_guess = 10 * trace(get_Ac(A, c_plus));
    end

    % no k provided
    if nargin <= 4
        k = 10;
    end

    % no DEBUG set
    if nargin <= 5
        DEBUG = 0;
    end

%%
    y = point_inside(A, b, c_plus, z_max_guess);

%% basis: c_+A=I, c_+b=0
    [A_, b_, ~, y0] = change_basis(A, b, c_plus);

%% new y0 for A_, b_
    y = y - y0;

%% resulting variables
    % resulting z
    z_array = Inf(k + 1, 1);

    % resulting c
    c_array = zeros(size(A, 3), k);

    % how many c found
    found = 0;

%% looking for C_-
    if DEBUG
        h = waitbar(0, 'Nonconvexity cert.: starting jobs');
    end

    % m dimension
    m = size(A, 3);
    % H from article
    H = get_H(A, b);

    % vectors d
    D = randn(m, k);

    % obtaining c via dual problem from d
    get_c_d = @(d) get_c_from_d_H(H, y, d);

    % parallel/non-parallel implementation
    % for different MATLAB versions
    is_parallel = 0;

    try
        try
            p = gcp();
            if isempty(p)
                error('Empty pool');
            end
            is_parallel = 1;
        catch
            parpool();
            p = gcp();
            is_parallel = 1;
        end
    catch
        is_parallel = 0;
    end

    if is_parallel
        fprintf('C_- search: Using parallel mode\n');
    else
        fprintf('C_- search: Using non-parallel mode\n');
    end

    if is_parallel
        for i = 1:k
            f(i) = parfeval(p, get_c_d, 1, D(:, i));
        end
    end

    for i = 1:k
        if is_parallel
            [~, c] = fetchNext(f);
        else
            c = get_c_d(D(:, i));
        end
        if norm(c) > 0 && is_nonconvex(A, b, c)
            c = c / norm(c);
            found = found + 1;
            c_array(:, i) = c;
        end
        if DEBUG == 1
            s = sprintf('Nonconvexity cert. %d/%d, found %d, success %.1f%%', i, k, found, 100. * found / i);
            waitbar(1. * i / k, h, s);
        elseif DEBUG == 2
            s = sprintf('Nonconvexity cert. (%d/%d, found %d)', i, k, found);
            waitbar(1. * i / k, h, s);
        end
    end

%% displaying info
    if DEBUG
        close(h);
        fprintf('Found C_-: %d/%d iterations (success %.1f%%)\n', found, k, 100. * found / k);

        for i = 1:k
            if norm(c_array(:, i)) > 0
                fprintf('c(%d/%d): ', i, k);
                for val=c_array(:, i)
                    fprintf('%.4f ', val);
                end
                fprintf('\n');
            end
        end

        fprintf('\n');

        h = waitbar(0, 'Gradient descent');
    end

%% gradient descent
    processed = 0;

    for i = 1:k
        try
            % minimizing z(c)
            if norm(c_array(:, i)) > 0
                if DEBUG
                    s = sprintf('Gradient descent (%d/%d)', processed, found);
                    waitbar(1. * processed / found, h, s);
                end
                [z, ~, ~] = minimize_z_c(A_, b_, c_array(:, i), c_plus, 1, 1, DEBUG);

                if DEBUG
                    fprintf('\n');
                end

                % adding z(c^*) to z_array
                z_array(end + 1) = z;
                processed = processed + 1;
            end
        catch
            continue
        end
    end

    if DEBUG
        close(h);
    end

    z_max = min(z_array);
end
