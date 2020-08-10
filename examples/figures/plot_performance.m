load('plot_performance.mat')

%nmax=30
figure
hold on;
for i=1:repetitions
    plot(ns, log10(results(:, i, 1)))
end
ylabel('log10(time (seconds))');
xlabel('dimension');
hold off;

figure
hold on;
for i=1:repetitions
    plot(ns, 100 * results(:, i, 2) / k)
end
ylabel('success percent')
xlabel('dimension');
hold off;

figure
hold on;
for i=1:repetitions
    plot(ns, log10(results(:, i, 3)))
end
ylabel('log10(z_{max})')
xlabel('dimension');
hold off;

figure
hold on;
for i=1:repetitions
    plot(ns, 1 + results(:, i, 4))
end
ylabel('attempts')
xlabel('dimension');
hold off;

figure
hold on;
for i=1:repetitions
    plot(ns, log10(results(:, i, 1) / (1 + results(:, i, 4))))
end
ylabel('log10(mean attempt time)')
xlabel('dimension');
hold off;