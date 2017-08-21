clear all;

%% This file
% 1) loads a map
% 2) generates a vector c_+
% 3) cuts convex subpart via z(c) minimization

%% changing cwd to project folder (with README.md)
cd(strcat(fileparts(which(mfilename)),'/../'));

%% using saved map
try
    % Real case R4->R4
    load('examples/maps/real_R4_R4.mat');

    % Complex case C2->R4, pre-defined c_plus
    %load('examples/maps/complex_C2_R4_poster.mat')
    
    fprintf('Map load OK\n\n');
catch
    disp('Change current folder to folder with README.md');
    error('Map load failed');
end

%% obtaining c_plus
try
    if ~exist('c_plus')
        c_plus = get_max_c_plus(A);
    end
    
    fprintf('c_+ search OK: ');
    for val=c_plus
        fprintf('%.4f ', val);
    end
    fprintf('\n\n');
catch
    error('c_+ search failed');
end

%% setting the random seed
rng(43);


%% cutting the convex part
try
    z_max = get_z_max(A, b, c_plus, 10, 20, 2);
    
    fprintf('Optimization finished\n\n');
    
    if z_max >= Inf
        fprintf('Result: no C_- found\n');
    else
        fprintf('Result: convex subpart, z_max = %f\n', z_max);
    end
    
    disp('TEST PASSED');
catch
    error('TEST FAILED');
end