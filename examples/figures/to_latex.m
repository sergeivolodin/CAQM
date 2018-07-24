% generating text for A, b
n = size(A, 1);
m = size(A, 3);
disp('A random-generated example is studied:');
disp('');
disp('{\tiny');
for k = 1:m
    fprintf('$A_%d=\\left(\\arraycolsep=1.4pt\\def\\arraystretch{1}\n', k);
    fprintf('\\begin{array}{%s}\n', repmat('c', 1, n));
    %latex(A(:, :, k), 'nomath', '%d');
    latex1(A(:, :, k));
    disp('\end{array}\right)$,');
end
for k = 1:m
    fprintf('$b_%d=\\left(\\arraycolsep=1.4pt\\def\\arraystretch{1}\n', k)
    disp('\begin{array}{c}');
    %latex(b(:, k), 'nomath', '%d')
    latex1(b(:, k));
    disp('\end{array}\right)$.')
end
disp('}');
disp('');

%%

disp('For this map, a number of tests were conducted.');
fprintf('First the boundary oracle for $y=0$ and $d$ was called and returned correctly with a value of $%.10f$\n', t);
disp('In addition, the normal vector $c$ at the boundary was found.');
disp('Moreover, the algorithm for discovering boundary non-convexities returned a $c_-$, therefore, certifying that the map is non-convex.');

disp('A vector $c_+$ was discovered.');
fprintf('For that $c_+$ and a default initial guess $z_{\\max}=%.2f$ the value $z_{\\max}=%.2f$ was found using $100$ iterations of non-convexity certificate.\n', z_max_guess, z_max);
disp('');
disp('$d=\left(\begin{array}{c}');
latex(d, 'nomath', '%.2f');
disp('\end{array}\right)$,');
disp('$c=\left(\begin{array}{c}');
latex(c_d, 'nomath', '%.2f');
disp('\end{array}\right)$,');
disp('$c_-=\left(\begin{array}{c}');
latex(c_minus, 'nomath', '%.2f');
disp('\end{array}\right)$,');
disp('$c_+=\left(\begin{array}{c}');
latex(c_plus, 'nomath', '%.2f');
disp('\end{array}\right)$,');