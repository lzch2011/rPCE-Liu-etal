function V = funQiao(X)

a = X(:, 1);
c = X(:, 2);
theta = X(:, 3);

V = (1+a.^2-2*a.*cos(theta)).^c;
end
