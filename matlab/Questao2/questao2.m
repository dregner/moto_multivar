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
C = [1 0 0 0]; % saida questao 2
B = [0; 1/M; 0; -1/(M*L)];

Dsim = zeros(4,1);
x0 = [0 0 pi/180*10 0]; % condicao inicial do sistema
x0obs = [0 0 pi/180*10 0]; % condicao inicial do observador


%% Controlabilidade e Observabilidade Letra B

O = [C; C*A; C*A^2; C*A^3];
Cont = [B A*B A^2*B A^3*B];
    
%% ganho K

T = [A^3*B-14.715*A*B, A^2*B-14.715*B, A*B, B];
d = [5.0625, 13.5, 13.5, 6];
a = [0 , 0, -14.715, 0];
kd = d-a;
Kl = kd*inv(T);
eig(A-B*Kl)

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
%% Modelo Interno Seguir degrau e rejeita pert. degrau. Letra C
coef = [1 0];
M = [0];
N = [1];
Am = M;
Bm = N;
Cm = eye(1);
Dm = zeros(1,1);

Aa = [A zeros(4,1); -Bm*C Am];
Ba = [B; zeros(1,1)];
Ca = [C 0];

pd = -2;
Ka = place(Aa,Ba,[pd pd-0.025 pd-0.05 pd-0.075 pd-0.1]);
r = 0.001;
R = r;
Q = eye(5);
Ka = lqr(Aa,Ba,Q,R);

% Verificacao
polosMF = eig(Aa-Ba*Ka)

% Matriz de ganho para o estado da planta x 
K = Ka(:,1:4);

% Matriz de ganho para o estado do modelo interno xm
Km = Ka(:,5);

%%
D = [0]
sys=ss(A,B,C,D);   % define modelo de estado
 
G=zpk(tf(sys))     % matriz de transferencia

%% Modelo Interno  Seguir degrau, rejeita degra e seno 0.1 rad/s Letra E

coef = [0 -.1^2 0]
M = [zeros(2,1) eye(2); coef];
N = [0;0;1];
Am = M;
Bm = N;
Cm = eye(3);
Dm = zeros(3,1);


Aa = [A zeros(4,3); -Bm*C Am];
Ba = [B; zeros(3,1)];
Ca = [C 0];

pd = -1.5;
Ka = place(Aa,Ba,[pd pd-0.025 pd-0.05 pd-0.075 pd-0.1 pd-0.125 pd-0.15]);
r = 1;
R = r;
Q = eye(7);
Ka = lqr(Aa,Ba,Q,R);
% Verificacao
polosMF = eig(Aa-Ba*Ka)

% Matriz de ganho para o estado da planta x 
K = Ka(:,1:4);

% Matriz de ganho para o estado do modelo interno xm
Km = Ka(:,5:7);

%% Observador

% Polo repetido desejado para o observador
pobs = -8;
% Matriz de ganho para posicionar os polos de A-LC em pobs
H = place(A',C',[pobs pobs-0.025 pobs-0.05 pobs-0.075]);
L = H';

V1 =0.001*eye(4);
V2 = 0.0005;
q = 1;
L = lqr(A',C',V1,q*V2)';

polosObs = eig(A-L*C)

%% PLOTS
%close all
model = 'modelos';
load_system(model);
figure(1)
plot(tout,x(:,2),tout,x(:,3),tout,x(:,4), tout, x(:,5)) % plot estados
grid
title('Realimentação Estados')
figure(2)
plot(tout, y(:,2),tout,y(:,3))
grid
title('Realimentação de Estados')
% figure(3)
% plot(tout,x1(:,2),'r-',tout,x1(:,3),'b-',tout,x1(:,4),'g-', tout, x1(:,5),'y-') % plot estados
% hold on
% plot(tout,x2(:,2),'r--',tout,x2(:,3),'b--',tout,x2(:,4),'g--', tout, x2(:,5),'y--') % plot estados
% hold off
% grid
% title('Controlador Observador')
% figure(4)
% plot(tout(1,, y1(:,2),tout,y1(:,3))
% grid
% title('Controlador-Observador');
