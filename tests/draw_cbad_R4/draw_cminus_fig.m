function draw_cminus_fig(c_item_array, c_plus)
    % drawing C_bad
    % projecting 4D to 3D

    % three vectors ortohonal to c_plus
    R = null(c_plus')';

    hold on;
    grid on;

    s = size(c_item_array, 2);
    c_item_color = [];
    c_item_color(:, 1 : s) = repmat([0.5 0.5 1]', 1, s);
    c_item_color(:, end) = [1 0 0]';
    c_item_color(:, 1) = [0 0 1]';

    v = R * c_item_array;

    for j = 1:size(v, 2)
        v(:, j) = v(:, j) / norm(v(:, j));
    end

    plot_path = line(v(1, :), v(2, :), v(3, :), 'Color', [0.7 0.7 1]');
    plot_gd = scatter3(v(1, 2:end-1), v(2, 2:end-1), v(3, 2:end-1), 36, ...
        c_item_color(:, 2:end-1)', 'd');
    plot_end = scatter3(v(1, end), v(2, end), v(3, end), 1500, c_item_color(:, end)', '.');
    plot_begin = scatter3(v(1, 1), v(2, 1), v(3, 1), 800, c_item_color(:, 1)', '.');

    [Sx, Sy, Sz] = sphere(32);
    s = surf(Sx,Sy,Sz);
    set(s, 'FaceColor', [0 0 0], 'FaceAlpha', 0.05);
    set(s, 'EdgeColor', [0 0 0], 'EdgeAlpha', 0.1)

    legend([plot_path, plot_gd, plot_end, plot_begin], {'Path', 'Path', 'End', 'Start'});
end