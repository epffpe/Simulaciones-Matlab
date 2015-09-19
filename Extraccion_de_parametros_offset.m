clear
load data_sweep_temp_v.mat

temperatura = ((temp *3.24 / (2^12-1))-0.5)*100;
plot(temperatura),shg

n = (temperatura > 24.8) & (temperatura < 25.2);
baro25 = baro(n);
temp25 = temp(n);
batt25 = batt(n);
clear n
temperatura25 = ((temp25 *3.24 / (2^12-1))-0.5)*100;
batt25_voltios = batt25  * 3.3 / 4095 *(13.0/3);
plot(baro25),shg

