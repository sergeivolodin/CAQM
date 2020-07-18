load('plot_performance.mat')

figure
hold on;
for i=1:repetitions
    plot(nmin:nmax, results(:, i, 1))
end
ylabel('time (seconds)');
xlabel('dimension');
hold off;

figure
hold on;
for i=1:repetitions
    plot(nmin:nmax, 100 * results(:, i, 2) / k)
end
ylabel('success percent')
xlabel('dimension');

hold off;