% Pendulo Invertido linear
clc
clear all;
close all;
%% Variaveis do sistema
M = 1;
m = 0.5;
L = 1;
g = 9.81;

%% matrizes do sistema

A = [0 1 0 0; 
    0 0 -m*g/M 0;
    0 0 0 1;
    0 0 (m+M)*g/(M*L) 0];
%C = [1 0 0 0]; % saída do sistema
C = [1 0 0 0]; % saida questao 2
B = [0; 1/M; 0; -1/(M*L)];

Dsim = zeros(4,1);
x0 = [0 0 pi/4 0];

%% Controlabilidade e Observabilidade

O = [C; C*A; C*A^2; C*A^3];
Cont = [B A*B A^2*B A^3*B];

syms s;

%% ganho K

T = [A^3*B-14.715*A*B, A^2*B-14.715*B, A*B, B];
d = [5.0625, 13.5, 13.5, 6];
a = [0 , 0, -14.715, 0];
kd = d-a;
K = kd*inv(T);
eig(A-B*K)

%% calculo de L

Ab = transpose(A);
Bb = transpose(C);
Ob = [Bb Ab*Bb Ab^2*Bb Ab^3*Bb];

Tb = [Ab^3*Bb-14.715*Ab*Bb, Ab^2*Bb-14.715*Bb, Ab*Bb, Bb];
db = [256 256 96 16];
ab = a;
kdb = db-ab;
Kb = kdb*inv(Tb)
L = Kb'
eig(A-L*C)
