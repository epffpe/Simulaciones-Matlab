% estado = [x y x' y' x'' y'']

t = [0:50];
a0 = 0.014;
a = a0 - t/length(t) * a0;
v0 = 4;
v = v0 + a .* t;

j = v.*t + 0.5 * a .* t.^2;
% j(70:end) = j(70);
xin = [t;j];
plot(t,j,'rx'),shg

close(1)
figure(1)
axis([-10 10 -10 10]); grid
x = [0 5 0 0 0 0]';
P = [1000 0 0 0 0 0; 0 1000 0 0 0 0; 0 0 1000 0 0 0; 0 0 0 1000 0 0; 0 0 0 0 1000 0; 0 0 0 0 0 1000];
F = [1 0 1 0 0.5 0; 0 1 0 1 0 0.5; 0 0 1 0 1 0; 0 0 0 1 0 1; 0 0 0 0 1 0; 0 0 0 0 0 1];
H = [1 0 0 0 0 0; 0 1 0 0 0 0];
R = [0.01 0 ;0 0.01];
I = eye(6);
xm = zeros(2,length(t));
xp = zeros(2,length(t));
for n = 1:length(t)
    n
%     z = xin(:,n);
    z = ginput(1)';
    hold on
    plot(z(1),z(2),'bo','MarkerSize',10);
    hold off
%     i(:,n) = z; 
    if (mod(n,10) == 0)
        P = P + 1*I;
    end
    %Medida
    y = z - H * x;
    S = H * P * H' + R;
    K = P * H' / S;
    
    x = x + (K * y);
    xm(:,n) = x(1:2);
    hold on
    plot(x(1),x(2),'rx', 'MarkerSize',10);
    hold off
    P = (I - K * H) * P;
    P
    %Prediccion
    x = F * x;
    xp(:,n) = x(1:2);
    hold on
    plot(x(1),x(2),'gx', 'MarkerSize',10);
    hold off
    P = F * P * F';
end


plot(xin(1,:), xin(2,:),'rx', xm(1,:),xm(2,:),'bx'),shg
hold on
plot(xm(1,:),xm(2,:),'gx'),shg
hold off