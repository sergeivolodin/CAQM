clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading map
load('./maps/article_example03_C2_R4.mat');

%% displaying the map
display(A);
display(b);
display(c_plus');

%% setting the random seed
rng(41);

%% cutting the convex part
z_max = get_z_max(A, b, c_plus, 0.1, 200, 1);
    
fprintf('Result: convex subpart, z_max = %f\n', z_max);
