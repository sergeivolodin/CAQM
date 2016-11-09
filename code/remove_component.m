function v1 = remove_component(v, n)
    v1 = v - n * dot(n, v) / norm(n) ^ 2;
end

