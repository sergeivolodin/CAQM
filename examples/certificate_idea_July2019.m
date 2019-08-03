% loading the example 10 from the Article
load('./maps/article_example10_homog_R4_R4.mat');

% showing A
disp('A:');
disp(A);

% obtaining c from the proposed procedure
% will print some info
c = homogeneous_real_nonconvexity_certificate(A);

disp('c:');
disp(c');

% obtaining c * A
Ac = get_Ac(A, c);

% showing the trace and norm of c
fprintf('Trace of c*A: %.5f\n', trace(Ac));
fprintf('sum(c): %.5f\n', sum(c));

% showing eigenvalues
disp('Eigenvalues of c*A:');
disp(eig(Ac)');