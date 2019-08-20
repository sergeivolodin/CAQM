clear all;

% loading c_dot data
load('example06_c_dot.mat');

N = size(item_size, 2) / 2;

%% plotting z(c(t))

% coefficient for removing too large z (see code below)
z_multiplier = 2.1;

% array for all t
all_t = [];

% array for all z
all_z = [];

figure;
hold on;

% array of lines
curves = [];

% min points pentagrams
min_points = [];

% minimal values
min_values = [];

% loop over data
for i = 1:(2 * N)
    % obtaining number of cs and array of cs
    s = item_size(i);
    c_item_array = [];
    
    if s == 1
        c_item_array(:, 1) = c_array(i, :, 1)';
        c_item_array(:, 2) = c_array(i, :, 1)';
    else
        c_item_array(:, :) = c_array(i, :, 1:s);
    end
    
    % z_value for this data
    z_item_value_orig = z_value(i, 1:s);
    
    % difference in c from the first point
    c_diff = c_item_array - [c_item_array(:,1) c_item_array(:,1:(s - 1))];
    
    % sum of dc1, dc2, dc3, ...
    % equal to t1, t2, t3, ...
    c_len_pos = cumsum(sqrt(diag(c_diff' * c_diff)));
    
    % removing too large values z
    % criteria: z < median(z) * multiplier
    z_threshold = median(z_item_value_orig) * z_multiplier;
    %disp(median(z_item_value_orig));
    
    % need to stop plotting at s_curve to remove too large z
    [~, s_curve] = max(z_item_value_orig > z_threshold);
    if s_curve == 1
        s_curve = s;
    end
    
    % current t and z(c(t)) values
    t_values = c_len_pos(1:s_curve);
    z_values = z_item_value_orig(1:s_curve);

    if(rem(i, 2) == 0)
        % 2 items done, direction -1
        direction = -1;
    else
        % 1 item done, direction +1
        direction = +1;
    end
    
    all_t(end + 1 : end + s_curve) = t_values * direction;
    all_z(end + 1 : end + s_curve) = z_values;
    
    if(rem(i, 2) == 0)
        % 2 items done, direction -1
        % sorting all
        [all_t, idx] = sort(all_t);
        all_z = all_z(idx);
        
        % calculating minimal z value
        [value, idx] = min(all_z);
        
        if i / 2 == 1
            style = '-';
        else
            style = '--';
        end
        
        plot_line = plot(all_t, all_z, style, 'linewidth', 3);
        plot_min = plot(all_t(idx), all_z(idx), '.', 'MarkerSize', 40, 'color', 'red');
        
        text(all_t(idx), all_z(idx) + 0.02, sprintf('  z=%.4f', min(all_z)), 'fontsize', 20);
        
        curves(end + 1) = plot_line;
        min_points(end + 1) = plot_min;
        min_values(end + 1) = min(all_z);
        
        %title('$z(c(t))$ curves for connected components', 'Interpreter', 'latex');
        
        all_t = [];
        all_z = [];
    end
end

ylim([0 0.4]);

[hleg, objh] = legend([curves(1), curves(2), min_points(1)], {'CC 1', 'CC 2', ...
    'Minimum for CC'},'location','northwest');
hleg.FontSize = 20;
set(gca,'linewidth',1.5);
ax = gca;
ax.FontSize = 16; 
xlim([-6 6]);
set(hleg.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.5]));

for h = 1:length(objh)
    if isprop(objh(h), 'FontSize')
        objh(h).FontSize = hleg.FontSize - 3;
    end
    
    if size(objh(h).Children) == 0
        continue
    end
    child = objh(h).Children(1);
    if isprop(child, 'MarkerSize')
        objh(h).Children(1).MarkerSize = 8;
    end
end

xlabel('t', 'Interpreter', 'latex', 'fontsize', 25);
ylabel('$z(c(t))$', 'Interpreter', 'latex', 'fontsize', 25);