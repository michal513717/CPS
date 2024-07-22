close all; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declare consts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs  = 8000;
t = 0:1/fs:1;
A1 = -0.5;
f1 = 34.2;
A2 = 1;
f2 = 115.5;

% sygnal czysty do porownania - referencyjny
dref = A1*cos(2*pi*f1*t) + A2*cos(2*pi*f2*t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declare variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

awgn10 = 10;
M10 = 50; % długość filtru;
mi10 = 0.004; % współczynnik szybkości adaptacji;

awgn20 = 20;
M20 = 50;
mi20 = 0.01;

awgn40 = 40;
M40 = 50;
mi40 = 0.01;

global_M = 50;
global_mi = 0.01;

[d10, y10] = labSolver(awgn10, M10, mi10, dref);
[d20, y20] = labSolver(awgn20, M20, mi20, dref);
[d40, y40] = labSolver(awgn40, M40, mi40, dref);

[d10, y10] = labSolver(awgn10, global_M, global_mi, dref);
[d20, y20] = labSolver(awgn20, global_M, global_mi, dref);
[d40, y40] = labSolver(awgn40, global_M, global_mi, dref);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(3,1,1);
plot(t,dref,t,d10,t,y10);
title('AWGN 10dB');
legend('Sygnal czysty','Zaszumiony','Po odszumieniu');

subplot(3,1,2);
plot(t,dref,t,d20,t,y20);
title('AWGN 20dB');
legend('Sygnal czysty','Zaszumiony','Po odszumieniu');

subplot(3,1,3);
plot(t,dref,t,d40,t,y40);
title('AWGN 40dB');
legend('Sygnal czysty','Zaszumiony','Po odszumieniu');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SNR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SNR10 = 10*log10((1/fs*sum(dref.^2))/(1/fs*sum((dref-y10).^2)));
display(SNR10);

SNR20 = 10*log10((1/fs*sum(dref.^2))/(1/fs*sum((dref-y20).^2)));
display(SNR20);

SNR40 = 10*log10((1/fs*sum(dref.^2))/(1/fs*sum((dref-y40).^2)));
display(SNR40);

function [d, y] = labSolver(value, M, mi, dref)
    d = awgn(dref, value, 'measured');
    x = [ d(1) d(1:end-1) ];
    y = []; e = [];
    bx = zeros(M, 1);
    h = zeros(M, 1);

    for n = 1: length(x)
        bx = [ x(n); bx(1:M-1) ]; % pobierz nową próbkę x[n] do bufora
        y(n) = h' * bx; % oblicz y[n] = sum( x .* bx) – filtr FIR
        e(n) = d(n) - y(n); % oblicz e[n]
        h = h + mi * e(n) * bx; % LMS
        % h = h + mi * e(n) * bx /(bx'*bx); % NLMS
    end
end