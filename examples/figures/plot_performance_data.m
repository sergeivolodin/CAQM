nmin = 4;
nmax = 20;
repetitions = 10;
k = 100;
L = length(nmin:nmax);
%results = zeros(L, repetitions, 3);

i = 1;
for n = nmin:nmax
    for j = 1:repetitions
        fprintf("n=m=%d rep=%d time=%.2f found_c=%d\n\n", n, j, time, found_c);

        if results(i, j, 1) ~= 0
            fprintf("Skipping");
            continue
        end
        [time, found_c, z_max] = measure_performance(n, n, k);
        results(i, j, :) = [time, found_c, z_max];
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
        z_max = get_z_max(A, b, c_plus, z_max_guess, k, 1);
    time = toc;

    found_c = 0;
    for i=1:k
        if norm(c_array_export(:, i))
            found_c = found_c + 1;
        end
    end
end