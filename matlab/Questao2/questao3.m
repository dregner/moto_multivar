clc
clear all
close all

%% Questao 3

M = 1;
L = 1;
m = 0.5;
g = 9.81;

syms x1 x2 x3 x4 u;
x = [x1 x2 x3 x4];
C0 = 0;
x0 = [0 0 0.1 0];
%% Equa��es n�o lineares para cada estado
% dx1 = f1, dx2 = f2, dx3 = f3, dx4 = f4
f1 = x2;
f2 = (-m*g*sin(x3)+ m*L*x4^2*cos(x3))/((M+m)-m*(cos(x3))^2);
f3 = x4;
f4 = (m*g*sin(x3)+m*L*x2^2*sin(x3))*(M+m)/(m*L*(M+m)-m^2*(cos(x3))^2);
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


pd = -5;
K = place(A,B, [pd pd-.01 pd+0.05 pd+0.02]);

%% Sistema Aumentado para controle integral linear
Aa=[ A zeros(4,1);
    -C 0];

Ba=[B ; 0];

% Verifica a controlabilidade do Sistema Aumentado
Con = ctrb(Aa,Ba)
vsCon = svd(Con)

% Verifica a observabilidade da Planta
Obs = obsv(A,C)
vsObs = svd(Obs)

pd = -4
Kc = place(Aa, Ba, [pd pd-0.01 pd-0.02 pd-0.05 pd+0.01])
Kx = Kc(1,1:4)
Km = Kc(1,5)
%% Observador
x0obs = [0 ; 0; 0.1; 0]  

pd = -8;
L=place(A',C',[pd pd-0.05 pd-0.03 pd-0.04])';        % polo duplo de A-LC em s=-12     

%% LQR

Q = eye(4);
r = 0.0001;
R = r
Ka = lqr(A,B,Q,R)