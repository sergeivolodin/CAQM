clear all;

nmin = 4;
nmax = 50;
repetitions = 3;
k = 100;
L = length(nmin:nmax);
results = zeros(L, repetitions, 3);

i = 1;
for n = nmin:nmax
    for j = 1:repetitions
        if results(i, j, 1) ~= 0
            fprintf("n=m=%d rep=%d\n", n, j);

            fprintf("Skipping");
            continue
        end
        [time, found_c, z_max] = measure_performance(n, n, k);
        results(i, j, :) = [time, found_c, z_max];
        
        fprintf("n=m=%d rep=%d time=%.2f found_c=%d\n\n", n, j, time, found_c);
    end
    i = i + 1;
end

save('plot_performance', 'nmin', 'nmax', 'repetitions', 'k', 'L', 'results');

function [time, found_c, z_max] = measure_performance(n, m, k)
    global c_array_export;
    [A, b] = get_random_f(n, m);
    tic
        c_plus = get_max_c_plus(A);
        z_max_guess = 10 * trace(get_Ac(A, c_plus));
        %z_max = get_z_max(A, b, c_plus, z_max_guess, k, 1);
        z_max = 0;
        get_c_array(A, b, c_plus, z_max_guess, k);
    time = toc;

    found_c = 0;
    for i=1:k
        if norm(c_array_export(:, i))
            found_c = found_c + 1;
        end
    end
end

function c_array = get_c_array(A, b, c_plus, z_max_guess, k, DEBUG)
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

    % checking if c_plus * A > 0
    assert(is_c_plus(A, c_plus), 'c_plus * A must be > 0');

%%
    y = point_inside(A, b, c_plus, z_max_guess);

%% basis: c_+A=I, c_+b=0
    [A_, b_, ~, y0] = change_basis(A, b, c_plus);

%% checking that the map is non-homogeneous
    assert(norm(b_) > 0, 'The map must be non-homogeneous to cut convex subparts with a hyperplane');

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
    % Using original map to avoid precision loss caused by change_basis()
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

    if DEBUG
        if is_parallel
            fprintf('C_- search: Using parallel mode\n');
        else
            fprintf('C_- search: Using non-parallel mode\n');
        end
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
    end

    global c_array_export;
    c_array_export = c_array;
end