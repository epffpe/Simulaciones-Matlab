s = serial('COM5');
set(s,'BaudRate',115200);
fopen(s);
%fprintf(s,'*IDN?')
out = fscanf(s);
[tline,count] = fgetl(s);
readasync(s)
oout = fread(s,s.BytesAvailable,'uint8');
% C = textscan(a, '%d%d%d%s%s','delimiter',';','EndOfLine','\r\n'); 
% 
% [br, sfc, hfc, par, tm] = deal(C{:});
% 
% br =
%         9600
% sfc =
%      0
% hfc =
%      0
% par = 
%     'NONE'
% tm = 
%     'LF'
fclose(s)
delete(s)
clear s


s = serial('COM5');
set(s,'BaudRate',115200);
fopen(s);

N=50000;
baroRAW = zeros(1,N);
pitotRAW = zeros(1,N);
tempRAW = zeros(1,N);
battRAW = zeros(1,N);
for n=1:30
%     out = fscanf(s, '$%d,%d,%d,%d\r\n')
    out = fscanf(s, '$%f,%f,%f\r\n')
end
for n=1:N
    out = fscanf(s, '$%f,%f,%f\r\n');
    baroRAW(n) = out(1);
    pitotRAW(n) = out(2);
    tempRAW(n) = out(3);
    
%     out = fscanf(s, '$%d,%d,%d,%d\r\n');
     
%     baroRAW(n) = out(1);
%     pitotRAW(n) = out(2);
%     tempRAW(n) = out(3);
%     battRAW(n) = out(4); 
    if (mod(n,1000) == 0)
        n
%         temperatura = ((tempRAW(n) *3.24 / (2^12-1))-0.5)*100
        out
    end
end

plot(baroRAW),shg
% save barotest.mat oout
fclose(s)
delete(s)
clear s

%%
% load señalBaro.mat
figure(1)
Ps0 = 102.2;
x = oout;
plot(oout),shg
linea = [0:length(x)-1] * (-0.5/length(x));
xcuadrado = [0:length(x)-1].^2 * (-0.9/length(x)^2);
xexp = exp([0:length(x)-1] * (1.5/length(x)))-1;
t = [0:length(x)-1]/length(x) * 2;
f=1;
xsin = 0.6 * (1 - cos(2*pi*f*t));
plot(x - xsin),shg
x = x - xsin;
[B,A] = cheby1(5,0.1,0.09);
barofilt = filter(B,A,x);
baroIIR(1) = x(1);
for n = 2:length(x)
    baroIIR(n) = (x(n) + 31*baroIIR(n-1))/32;
end
plot(barofilt,'b')
hold on
plot(x,'r'),plot(baroIIR,'g')
hold off
axis([200 length(x)-1 100 102]),shg

pause
%%
alt = ( 44330.76923 * (1 - (x / Ps0).^0.190263132));
altfilt = ( 44330.76923 * (1 - (barofilt / Ps0).^0.190263132));
altIIR = ( 44330.76923 * (1 - (baroIIR / Ps0).^0.190263132));
plot(altfilt,'b')
hold on
plot(alt,'r'),plot(altIIR,'g')
hold off
axis([200 length(x)-1 20 150]),shg

%%
%   Filtro de Kalman
%%
% x = x v
linea = [0:length(oout)-1] * (-0.5/length(oout));
xcuadrado = [0:length(oout)-1].^2 * (-0.9/length(oout)^2);
xexp = exp([0:length(oout)-1] * (1.5/length(oout)))-1;
t = [0:length(oout)-1]/length(oout) * 2;
f=1;
xsin = -0.6 * (1 - cos(2*pi*f*t));
xcomp = xexp(200) * ones(size(xsin));
xcomp(1:200) = xexp(1:200);

medidas = oout;
plot(medidas),shg

%% Variable de estado de dos dimensiones, valor, velocidad
x = [101.325 0]';
P = [1000 0; 0 1000];
u = [0;0];
F = [1 1; 0 1];
H = [1 0];
R = 0.0022;
I = eye(2);
xm = zeros(size(oout));
xp = zeros(size(oout));
n=1;
for n = 1:length(oout)
    
    z = medidas(n);
    %Medida
    y = z - H * x;
    S = H * P * H' + R;
    K = P * H' * inv(S);
    x = x + (K * y);
    xm(n) = x(1);
    P = (I - K * H) * P;
    %Prediccion
    x = F * x;
    xp(n) = x(1);
    P = F * P * F';
end
n = 1:length(medidas);
% plot(n,medidas,'b', n, xm, 'r'),shg
% pause
alt = ( 44330.76923 * (1 - (medidas / Ps0).^0.190263132));
altm = ( 44330.76923 * (1 - (xm / Ps0).^0.190263132));
plot(n,alt,'b', n, altm, 'r'),shg

%% Variable de estado de tres dimensiones, valor, velocidad y aceleración.
x = [101.325 0 0]';
P = [1000 0 0; 0 1000 0; 0 0 1000];
u = [0;0];
F = [1 1 0.5; 0 1 1; 0 0 1];
H = [1 0 0];
R = 0.01;
I = eye(3);
xm = zeros(size(oout));
xp = zeros(size(oout));
n=1;
z = 101.8606;
for n = 1:length(oout)
    
    z = medidas(n);
    %Medida
    S = H * P * H' + R;
    K = P * H' / S;
    y = z - H * x;
    x = x + (K * y);
    xm(n) = x(1);
    P = (I - K * H) * P;
    %Prediccion
    x = F * x;
    xp(n) = x(1);
    P = F * P * F';
end
n = 1:length(medidas);
% plot(n,medidas,'b', n, xm, 'r'),shg
% pause
alt = ( 44330.76923 * (1 - (medidas / Ps0).^0.190263132));
altm = ( 44330.76923 * (1 - (xm / Ps0).^0.190263132));
% plot(n,alt,'b', n, altm, 'r'),shg
hold on
plot(n, altm, 'g'),shg
hold off;