clear all; close all; clc
load datos_buenos.mat

m = length(baro);

plot(baro),shg
title('Señal obtenida directamente del barómetro')
ylabel('Barometro')
xlabel('Muestras')
grid

plot(pitot),shg
title('Señal obtenida directamente del sensor de presion diferencial')
ylabel('Pitot')
xlabel('Muestras')
grid


fprintf(' x = [%.0f %.0f %.0f], y = %.0f \n', [XRAW(1:10,:) baro(1:10,:)]');
X = Xfilt;
X(:,1) = [];
[X mu sigma] = featureNormalize(X);

X = [ones(m, 1) X];

%%
% Para el barometro
temperatura = ((Xfilt(:,2) *3.24 / (2^12-1))-0.5)*100;
plot(temperatura),shg
title('Patron de temperatura para calibración de sensores analógicos')
ylabel('Temperatura en ºC')
xlabel('Muestras')
grid

tension = ((Xfilt(:,3) *3.3 / (2^12-1) * 13/3)) ;
plot(tension),shg
title('Patron de tension para calibración de sensores analógicos')
ylabel('Tension en V')
xlabel('Muestras')
grid



plot(baroIIR)
title('BaroIIR en función de la temperatura y de la tensión de entrada')
ylabel('Barometro')
xlabel('Muestras')
grid

y = baroIIR - 3242;
plot(y),shg
title('Error BaroIIR en función de la temperatura y de la tensión de entrada')
ylabel('Barometro')
xlabel('Muestras')
grid


alpha = 0.3;
num_iters = 50;

% Init Theta and Run Gradient Descent 
theta = zeros(3, 1);
[theta1, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters);


% Init Theta and Run Gradient Descent 
alpha = 0.1;
theta = zeros(3, 1);
[theta2, J_history2] = gradientDescentMulti(X, y, theta, alpha, num_iters);
% Init Theta and Run Gradient Descent 
alpha = 0.03;
theta = zeros(3, 1);
[theta3, J_history3] = gradientDescentMulti(X, y, theta, alpha, num_iters);



% Plot the convergence graph
% figure;
plot(1:numel(J_history), J_history, '-b', 'LineWidth', 2);
hold on
plot(1:numel(J_history), J_history2, '-r', 'LineWidth', 2);
plot(1:numel(J_history), J_history3, '-k', 'LineWidth', 2);
hold off
xlabel('Number of iterations');
ylabel('Cost J');

% Display gradient descent's result
fprintf('Theta computed from gradient descent: \n');
fprintf(' %f \n', theta1);
fprintf('\n');


%%
% theta1 =
% 
%     3.7861
%     5.7205
%     2.9083
%     
% mu =
% 
%   1.0e+003 *
% 
%     1.0328    3.1380
%     
% sigma =
% 
%    89.3707  536.0434
%     
%%
error = zeros(length(baro),1);
for n = 1:length(baro)
    x=([Xfilt(n,2) Xfilt(n,3)]-mu)./sigma;
    x=[1 x];
    error(n)=x*theta1;
end
n = 1:length(baro);
plot(n, y,'b',n,error,'r');shg
title('Error aprendido en funcion de la temperatura y tension de entrada')
ylabel('Error')
xlabel('Muestras')
legend('Error','Error aprendido en funcion de la temp y tension de entrada')


y = baroIIR - error;
plot(n,baro,'b',n,y,'r'),shg
title('Barómetro corregido en función de la temperatura y de la tensión de entrada')
ylabel('Barometro')
xlabel('Muestras')
grid
%%
% Para el pitot

temperatura = ((Xfilt(:,2) *3.24 / (2^12-1))-0.5)*100;
plot(temperatura),shg

m = [1:length(temperatura)]';
n= (25.2 > temperatura) & (temperatura > 24.8) & (m > 8e4);

subplot(211)
plot(temperatura(n))
title('Patron de temperatura para calibracion del sensor de presion diferencial')
ylabel('Temperatura en ºC')
subplot(212)
plot(XRAW(n,3)),shg %bateria
plot(pitot(n))
title('Presion diferencial en función de la temperatura y la tensión de entrada')
ylabel('Presion diferencial')
plot(pitotIIR(n)),shg
title('Presion diferencial IIR en función de la temperatura y la tensión de entrada')
ylabel('Presion diferencial')


a = filtroIIR(pitot(n), 947.3, 128);
hold on
plot(a,'r'),shg
hold off

pitotA25grados = mean(pitot(n)); % 947.77 = 948;
close
%
%%

y = pitotIIR - 948;
plot(y),shg
title('Error Presion diferencial IIR en función de la temperatura y la tensión de entrada')
ylabel('Error Presion diferencial')

alpha = 0.3;
num_iters = 50;

% Init Theta and Run Gradient Descent 
theta = zeros(3, 1);
[theta1, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters);


% Init Theta and Run Gradient Descent 
alpha = 0.1;
theta = zeros(3, 1);
[theta2, J_history2] = gradientDescentMulti(X, y, theta, alpha, num_iters);
% Init Theta and Run Gradient Descent 
alpha = 0.03;
theta = zeros(3, 1);
[theta3, J_history3] = gradientDescentMulti(X, y, theta, alpha, num_iters);



% Plot the convergence graph
% figure;
plot(1:numel(J_history), J_history, '-b', 'LineWidth', 2);
hold on
plot(1:numel(J_history), J_history2, '-r', 'LineWidth', 2);
plot(1:numel(J_history), J_history3, '-k', 'LineWidth', 2);
hold off
xlabel('Number of iterations');
ylabel('Cost J');

% Display gradient descent's result
fprintf('Theta computed from gradient descent: \n');
fprintf(' %f \n', theta1);
fprintf('\n');
%%
% theta1 =
% 
%  6.240364 
%  7.102920 
%  0.096182 
%     
% mu = [1.032798025166036e+03 3.138031264383561e+03]
% 
%   1.0e+003 *
% 
%     1.0328    3.1380
%     
% sigma =
% 
%    89.3707  536.0434
%     
%%
error = zeros(length(pitot),1);
for n = 1:length(pitot)
    x=([Xfilt(n,2) Xfilt(n,3)]-mu)./sigma;
    x=[1 x];
    error(n)=x*theta1;
end
n = 1:length(pitot);
plot(n, y,'b',n,error,'r');shg
title('Error presion diferencial IIR aprendido en funcion de la temperatura y tension de entrada')
ylabel('Error')
xlabel('Muestras')
legend('Error','Error aprendido en funcion de la temp y tension de entrada')


y = pitotIIR - error;
plot(n,pitot,'b',n,y,'r'),shg
title('Pitot corregido en función de la temperatura y de la tensión de entrada')
ylabel('Barometro')
xlabel('Muestras')
grid