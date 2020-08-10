load('plot_performance.mat')

%nmax=30
figure
hold on;
for i=1:repetitions
    s = round(linspace(nmin, nmax, howmuch))
    %s = s(1:25)
    l = size(s, 2)
    plot(s, log10(results(1:l, i, 1)))
end
ylabel('log10(time (seconds))');
xlabel('dimension');
hold off;

figure
hold on;
for i=1:repetitions
    plot(round(linspace(nmin, nmax, howmuch)), 100 * results(:, i, 2) / k)
end
ylabel('success percent')
xlabel('dimension');

hold off;