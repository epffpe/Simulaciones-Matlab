load Datos_estable.mat
%%
baro =  baroRAW * 3.24 / (2^12-1) * (52.7 /34);
baro = (baro /4.91 + 0.095) / 0.009;
plot(baro),shg

alt = ( 44330.76923 * (1 - (baro / Ps0).^0.190263132));
%%
P0 = 101.325;
for n=1:length(baro)
    baro1(n) = (baro(n) + 15* P0)/16;
    P0 = baro1(n);
end
clear P0;
n = 1:length(baro);
plot(n, baro, 'r', n, baro1, 'b'), shg

%%
Ps0 = 102.2;
alt1 = ( 44330.76923 * (1 - (baro1 / Ps0).^0.190263132));
n = 1:length(baro);
plot(n,alt,'r',n,alt1,'b'),shg

%%

[B,A] = cheby1(5,0.1,0.09);
baro2 = filter(B,A,baro);
n = 1:length(baro);
plot(n, baro, 'r', n, baro1, 'b', n, baro2, 'g'), shg

%%
alt2 = ( 44330.76923 * (1 - (baro2 / Ps0).^0.190263132));
n = 1:length(baro);
plot(n,alt,'r',n,alt1,'b',n,alt2,'g'),shg

%%

x = [101.325 0 0]';
P = [1000 0 0; 0 1000 0; 0 0 1000];
u = [0;0];
F = [1 1 0.5; 0 1 1; 0 0 1];
H = [1 0 0];
R = 0.01;
I = eye(3);
baro3 = zeros(size(baro));
xp = zeros(size(baro));
n=1;
z = 101.8606;
for n = 1:length(baro)
    
    z = baro(n);
    %Medida
    S = H * P * H' + R;
    K = P * H' / S;
    y = z - H * x;
    x = x + (K * y);
    baro3(n) = x(1);
    P = (I - K * H) * P;
    %Prediccion
    x = F * x;
    xp(n) = x(1);
    P = F * P * F';
end
n = 1:length(baro);
plot(n, baro, 'r', n, baro1, 'b', n, baro2, 'g', n, baro3, 'y'), shg

%%

alt3 = ( 44330.76923 * (1 - (baro3 / Ps0).^0.190263132));
n = 1:length(baro);
plot(n,alt,'r',n,alt1,'b',n,alt2,'g',n,alt3,'y'),shg


%%
% Temperatura
temperatura = ((tempRAW *3.24 / (2^12-1))-0.5)*100;
plot(temperatura),shg
x = [20 0 0]';
P = [1000 0 0; 0 1000 0; 0 0 1000];
u = [0;0];
F = [1 1 0.5; 0 1 1; 0 0 1];
H = [1 0 0];
R = 0.01;
I = eye(3);
tm = zeros(size(tempRAW));
xp = zeros(size(tempRAW));
n=1;
for n = 1:length(tempRAW)
    
    z = temperatura(n);
    %Medida
    y = z - H * x;
    S = H * P * H' + R;
    K = P * H' * inv(S);
    x = x + (K * y);
    tm(n) = x(1);
    P = (I - K * H) * P;
    %Prediccion
    x = F * x;
    xp(n) = x(1);
    P = F * P * F';
end
%%
[B,A] = cheby1(5,0.5,0.01);
tm2 = filter(B,A,temperatura);
%%
% Mejor filtro
P0 = 20;
for n=1:length(temperatura)
    tm3(n) = (temperatura(n) + 63* P0)/64;
    P0 = tm3(n);
end
clear P0;
%%
n = 1:length(tempRAW);
plot(n, temperatura, 'r', n, tm, 'y', n, tm2,'g', n, tm3, 'b'), shg