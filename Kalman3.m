function xm = Kalman3(xin, init, Rin )
% Filtro Kalman de orden 3, posicion, velocidad, aceleración

x = [init 0 0]';
P = [1000 0 0; 0 1000 0; 0 0 1000];
u = [0;0];
F = [1 1 0.5; 0 1 1; 0 0 1];
H = [1 0 0];
R = Rin;
I = eye(3);
xm = zeros(size(xin));
xp = zeros(size(xin));
for n = 1:length(xin)
    z = xin(n);
    %Medida
    y = z - H * x;
    S = H * P * H' + R;
    K = P * H' / S;
    x = x + (K * y);
    xm(n) = x(1);
    P = (I - K * H) * P;
    %Prediccion
    x = F * x;
    xp(n) = x(1);
    P = F * P * F';
end