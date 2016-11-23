function v1 = remove_component(v, n)
    X = null(n');
    v1 = X * X' * v;
end