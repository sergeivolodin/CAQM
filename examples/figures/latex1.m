function [] = latex1(arr)

n = size(arr, 1);
m = size(arr, 2);

for s1 = 1:n
    for s2 = 1:m
        number = arr(s1, s2);
        if isreal(number)
            fprintf('%d', number);
        elseif isreal(1i * number)
            fprintf('%di', imag(number));
        elseif imag(number) > 0
            fprintf('%d+%di', real(number), imag(number));
        else
            fprintf('%d-%di', real(number), -imag(number));
        end
        if s2 < m
            fprintf(' & ');
        end
    end
    fprintf('\\\\\n');
end

end