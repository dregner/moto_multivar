function dx = pendulo_n_liear(v){

M = 1;
L = 1;
m = 0.5;
g = 9.81;

x1 = v(1);
x2 = v(2);
x3 = v(4);
x4 = v(5);
u = v(6);

dx1 = x2;
dx2 = (-m*g*sin(x3)+ m*L*x4^2*cos(x3))/((M+m)-m*(cos(x3))^2) + u/((M+m)-m*(cos(x3))^2);
dx3 = x4;
dx4 = (-m*cos(x3)/(m+M))*(M+m)/(m*L*(M+m)-m^2*(cos(x3))^2) + (m*g*sin(x3)+m*L*x4^4*sin(x3))*(M+m)/(m*L*(M+m)-m^2*(cos(x3))^2);

dx = [dx1; dx2; dx2; dx4]
end