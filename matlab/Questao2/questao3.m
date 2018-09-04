%% Questao 3

M = 1;
L = 1;
m = 0.5;
g = 9.81;

syms x1 x2 x3 x4 u;
x = [x1 x2 x3 x4];
%% Equações não lineares para cada estado
% dx1 = f1, dx2 = f2, dx3 = f3, dx4 = f4
f1 = x2;
f2 = (-m*g*sin(x3)+ m*L*x4^2*cos(x3))/((M+m)-m*(cos(x3))^2);
f3 = x4;
f4 = (m*g*sin(x3)+m*L*x4^4*sin(x3))*(M+m)/(m*L*(M+m)-m^2*(cos(x3))^2);
f = [f1;f2;f3;f4];

u1 = 0;
u2 = 1/((M+m)-m*(cos(x3))^2);
u3 = 0;
u4 = (-m*cos(x3)/(m+M))*(M+m)/(m*L*(M+m)-m^2*(cos(x3))^2);
uf = [u1;u2;u3;u4];


A = double(subs(jacobian(f,x),[x1 x2 x3 x4],[0 0 0 0])); %nao entendo pq retorna matriz 4x3
B = double(subs(uf,[x3 x4],[0 0]));
C = [1 0 0 0];
D = zeros(2,2);
Con = ctrb(A,B); %Matriz Controlabilidade
 