function draw_cminus_fig(N, item_size, c_array, z_value, c_ans, c_plus, z_min, z_max)
    % drawing C_bad
    % projecting 4D to 3D

    % three vectors ortohonal to c_plus
    R = null(c_plus')';

    hold on;
    grid on;

    for i = 1:N
        s = item_size(i);
        c_item_array = [];

        if s == 1
            c_item_array(:, 1) = c_array(i, :, 1)';
            c_item_array(:, 2) = c_array(i, :, 1)';
        else
            c_item_array(:, :) = c_array(i, :, 1:s);
        end

        c_item_color = [];
        z_item_value = ((z_value(i, 1:s) - z_min) / (z_max - z_min)).^(1/10);
        c_item_color(:, 1 : s) = repmat([0.5 0.5 1]', 1, s) * diag(z_item_value)...
            + repmat([1 0.5 0.5]', 1, s) * diag(1 - z_item_value);
        c_item_color(:, end) = [1 0 0]';
        c_item_color(:, 1) = [0 0 1]';

        v = R * c_item_array;

        for j = 1:size(v, 2)
            v(:, j) = v(:, j) / norm(v(:, j));
        end

%        plot_gd = scatter3(v(1, 2:end-1), v(2, 2:end-1), v(3, 2:end-1), 36, ...
%            c_item_color(:, 2:end-1)', 'd');
        plot_end = scatter3(v(1, end), v(2, end), v(3, end), 100, [1 0 0], 's','LineWidth',1,'MarkerFaceColor',[1 0 0]);
        plot_begin = scatter3(v(1, 1), v(2, 1), v(3, 1), 300, [1 0.5 0], '>', 'LineWidth',2);
    end

    v = R * c_ans;
    v = v / norm(v);
    plot_dest = scatter3(v(1), v(2), v(3), 600, [0 0 1], 'p', 'LineWidth', 3);

    [Sx, Sy, Sz] = sphere(32);
    s = surf(Sx,Sy,Sz);
    set(s, 'FaceColor', [0 0 0], 'FaceAlpha', 0.1);
    set(s, 'EdgeColor', [0 0 0], 'EdgeAlpha', 0.1)

    [legh, objh] = legend([plot_end, plot_begin, plot_dest], {'GD end', 'GD start', 'Glob. minimum'});
    legh.FontSize = 13;
     
    % increasing marker size for legend
    for i = 1:length(objh)
        if size(objh(i).Children) == 0
            continue
        end
        child = objh(i).Children(1);
        if isprop(child, 'MarkerSize')
            objh(i).Children(1).MarkerSize = 8;
        end
    end
end
