%%
clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading map
load('../../maps/article_example05_R4_R4.mat');

% for minimizing z
[A_, b_, ~, y0] = change_basis(A, b, c_plus);

% name for the output file
name = 'ex05_zc_big';

% number of trials per one z
trials = 1500;

% array of zs (change with name)
z_array = linspace(0, 500000, 20);

%% fixing the random seed
rng(10);

% array of number of nonconvexities
ncvx = [];

% array with nonconvexities
ncvx_c = [];

% min_branch z(c)
z_min_array = [];

% iterator
k = 1;

% loop over z values
for z = z_array
    % point y_boundary + z * c_plus
    y = point_inside(A, b, c_plus, z);
    
    % nonconvexities for this y
    ncvx_this = [];
    
    % minimal z for this y
    z_this = [];
    
    % loop over trials
    for i = 1:trials
        % trying to get a nonconvexity
        try
            % obtaining c
            c = get_c_minus(A, b, y, 1, 0);

            % saving it if found
            ncvx_this(:, end + 1) = c;
            
            % doing gradient descent, saving result
            z_this(end + 1) = minimize_z_c(A_, b_, c, c_plus, 1, 1, 1);
        catch
            c = [];
        end
    end

    % number of nonconvexities discovered
    sz = size(ncvx_this, 2);
    
    % saving the size of nonconvexities
    ncvx(end + 1) = sz;
    
    % saving cs
    ncvx_c(k, :, 1 : sz) = ncvx_this;
    
    % saving min z
    z_min_array(k, 1 : sz) = z_this;

    % displaying the number of nonconvexities for this z
    fprintf(' z=%6f ncvx=%d\n', z, ncvx(end));
    
    % increasing counter
    k = k + 1;
end

% saving data
save(sprintf('results_%s.mat', name), 'ncvx', 'z_array', 'z_min_array', 'ncvx_c', 'trials');

%% plotting the array
%clear all;
%name = 'ex06_zc_big';
%load(sprintf('results_%s.mat', name));

%%
z_nonzero = [];
for z_min = reshape(z_min_array, 1, [])
    if z_min > 0
        z_nonzero(end + 1) = z_min;
    end
end

%%
precision = 0.01;
unique_z = uniquetol(z_nonzero, precision);

figure;
hold on;

labels = {};
plots = [];

plots(end + 1) = plot(z_array, ncvx / trials);
labels{end + 1} = 'Total';

s = 1;
for z_min = unique_z
    k = 1;
    ncvx_list = [];
    for z = z_array
        sz = ncvx(k);
        current_z = z_min_array(k, 1 : sz);
        current_this_z_min = 0;
        for cz = current_z
            [~, v] = min(abs(cz - unique_z));
            if v == s
                current_this_z_min = current_this_z_min + 1;
            end
        end
        ncvx_list(end + 1) = current_this_z_min / trials;
        k = k + 1;
    end
    s = s + 1;
    plots(end + 1) = plot(z_array, ncvx_list);
    labels{end + 1} = sprintf('zmin=%.4f', z_min);
end

title('Frequency of c over guesses');
xlabel('z_{\rm max}^{\rm guess}');
ylabel('Frequency of c');
legend(plots, labels);
