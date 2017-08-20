clear all;

%% This file
% 1) loads a map
% 2) generates a vector c_+
% 3) cuts convex subpart via z(c) minimization

%% using saved map
try
    % Real case R4->R4
    load('examples/maps/real_R4_R4.mat');

    % Complex case C2->R4, pre-defined c_plus
    %load('examples/maps/complex_C2_R4_poster.mat')
    
    display('MAP LOAD OK');
catch
    error('MAP LOAD FAILED');
end

%% obtaining c_plus
try
    if ~exist('c_plus')
        c_plus = get_max_c_plus(A);
    end
    
    display('C_PLUS OK');
catch
    error('C_PLUS FAILED');
end

%% setting the random seed
rng(43);


%% cutting the convex part
try
    z_max = get_z_max(A, b, c_plus, 10, 20, 1);
    
    fprintf('z_max = %f\n', z_max);
    display('TEST PASSED');
    msgbox('Test passed')
catch
    error('TEST FAILED');
end