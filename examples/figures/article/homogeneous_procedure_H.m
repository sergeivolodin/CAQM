%% building the array
% minimal dimensionality
imin = 3;

% maximal dimensionality
imax = 15;

% is degenerate (average over k repetitions)?
is_deg = zeros(imax, 1);
k = 100;

% building the array
for i=imin:imax
    is_deg(i) = is_deg_average(i, i, k);
end

% saving the result
save('homogeneous_procedure_H.mat', 'is_deg', 'k');

%% plotting the array
% loading data
load('homogeneous_procedure_H.mat');
figure;
plot(is_deg, 'LineWidth', 2);
xlabel('$n=m$','interpreter','latex','fontsize', 20);
ylabel('$P(\#\lambda_{\min}(c_{Procedure}\cdot A_{Gauss})>1|n=m)$','interpreter','latex','fontsize', 15);
ylim([-0.1, 1.1]);
xticks(linspace(1, imax, imax));

%% Functions

function res = is_deg_average(n, m, k)
%% Run is_degenerate k times and average
    % fraction of degenerate in k tries
    result = zeros(k, 1);
    for i = 1:k
        result(i) = is_degenerate(n, m);
    end
    %disp(result)
    res = mean(result);
end

function res = is_degenerate(n, m)
%% Is a random n, m map's resulting c give A_c with degenerate smallest eigenvalue?

% loading the example 10 from the Article
[A, b] = get_random_f(n, m, 0);

% zeroing b
b = zeros(n, m);

% showing A
%disp('A:');
%disp(A);

% obtaining c from the proposed procedure
    try
        get_c_minus_homog_real_H(A);
        res = 1;
    catch
        res = 0;
    end
end
