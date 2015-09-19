function IIR = filtroIIR(xin, init, N)

IIR = zeros(size(xin));
x0 = init;
for n=1:length(xin)
    IIR(n) = (xin(n) + (N-1)* x0)/N;
    x0 = IIR(n);
end