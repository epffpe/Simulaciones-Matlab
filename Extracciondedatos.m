clear
load Datos_temp_sweep_9_33_volt_sweep.mat

baro = baroRAW;
batt = battRAW;
pitot = pitotRAW;
temp = tempRAW;

load Datos_sweep_t_v_26_36.mat
fclose(s)
delete(s)
clear s

baro = [baro baroRAW(1:n-1)];
batt = [batt battRAW(1:n-1)];
pitot = [pitot pitotRAW(1:n-1)];
temp = [temp tempRAW(1:n-1)];

load data_sweep_t_37_39.mat
fclose(s)
delete(s)
clear s

baro = [baro baroRAW(1:n-100)];
batt = [batt battRAW(1:n-100)];
pitot = [pitot pitotRAW(1:n-100)];
temp = [temp tempRAW(1:n-100)];

temperatura = ((temp *3.24 / (2^12-1))-0.5)*100;

n = temperatura > 0;
baro = baro(n);
batt = batt(n);
pitot = pitot(n);
temp = temp(n);



n = batt > 3220;
baro = baro(n);
batt = batt(n);
pitot = pitot(n);
temp = temp(n);

temperatura = ((temp *3.24 / (2^12-1))-0.5)*100;
plot(batt),shg



clear n, 
clear N,
clear X
clear out
clear ans
clear baroRAW
clear battRAW
clear pitotRAW
clear tempRAW

save data_sweep_temp_v.mat


%%
%%
clear all; close all; clc
load datos_buenos_7_25.mat

temperatura = ((tempRAW *3.24 / (2^12-1))-0.5)*100;
plot(temperatura),shg

n = battRAW >1000;
baro = baroRAW(n);
pitot = pitotRAW(n);
temp = tempRAW(n);
batt = battRAW(n);

baroIIR = filtroIIR(baro,baro(1),128);
pitotIIR = filtroIIR(pitot,pitot(1),128);
tempIIR = filtroIIR(temp,temp(1),128);
battIIR = filtroIIR(batt,batt(1),32);


% temperatura1 = ((temp *3.24 / (2^12-1))-0.5)*100;
% plot(batt * 3.3 / 4095 *(13.0/3)),shg
% subplot(211)
% plot(temp),shg
% subplot(212)
% plot(baro),shg
% subplot(212)
% n = 1:length(pitot);
% plot(n,pitot,'b', n,pitotIIR,'r'),shg
% subplot(212)
% n = 1:length(baro);
% plot(n,baro,'b', n,baroIIR,'r'),shg
% plot(n,temp,'b',n,tempIIR,'r'),shg
% plot(n,batt,'b',n,battIIR,'r'),shg
% plot(tempIIR(8e4:end), pitotIIR(8e4:end), 'rx'),shg

load datos_bien_26_36.mat

plot(tempRAW(1:n-2)),shg

baro = [baro baroRAW(1:n-2)];
pitot = [pitot pitotRAW(1:n-2)];
temp = [temp tempRAW(1:n-2)];
batt = [batt battRAW(1:n-2)];

baroIIR = [baroIIR filtroIIR(baroRAW(1:n-2),baroRAW(1),128)];
pitotIIR = [pitotIIR filtroIIR(pitotRAW(1:n-2),pitotRAW(1),128)];
tempIIR = [tempIIR filtroIIR(tempRAW(1:n-2),tempRAW(1),128)];
battIIR = [battIIR filtroIIR(battRAW(1:n-2),battRAW(1),32)];

plot(temp),shg

load datos_bien_39_40.mat

n = tempRAW > 1120;
baro = [baro baroRAW(n)];
pitot = [pitot pitotRAW(n)];
temp = [temp tempRAW(n)];
batt = [batt battRAW(n)];

baroIIR = [baroIIR filtroIIR(baroRAW(n),baroRAW(1),128)];
pitotIIR = [pitotIIR filtroIIR(pitotRAW(n),pitotRAW(1),128)];
tempIIR = [tempIIR filtroIIR(tempRAW(n),tempRAW(1),128)];
battIIR = [battIIR filtroIIR(battRAW(n),battRAW(1),32)];

plot(batt),shg
plot(temp, pitot, 'rx'),shg
plot(tempIIR, pitotIIR, 'rx'),shg
plot(batt, baro, 'rx'),shg
plot(battIIR, baroIIR, 'rx'),shg

figure(1)
subplot(211)
plot(batt)
subplot(212)
plot(temp)

%%
XRAW = [ones(length(temp),1),temp', batt'];
Xfilt = [ones(length(tempIIR),1),tempIIR', battIIR'];
baro = baro';
pitot = pitot';
baroIIR = baroIIR';
pitotIIR = pitotIIR';
save datos_buenos.mat XRAW Xfilt baro pitot baroIIR pitotIIR

temperatura = ((Xfilt(:,2) *3.24 / (2^12-1))-0.5)*100;

m = [1:length(temperatura)]';
n= (25.5 > temperatura) & (temperatura > 24.5) & (m > 8e4);
subplot(211)
plot(temperatura(n))
subplot(212)
plot(XRAW(n,3)),shg %bateria
plot(baroIIR(n)),shg
plot(baro(n))


a = filtroIIR(baro(n), 3240, 128);
hold on
plot(a,'r'),shg
hold off

baroA25grados = mean(baro(n)); % 3241.7 = 3242;