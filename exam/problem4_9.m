close all; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decalre Consts 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = 2000;
fpr = 2000;
beta = 15;
dt = 1/fpr;
t = dt * (0:N-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate sin and window 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = sin (2 * pi * 50 * t);
y = kaiser(N, beta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate DTF 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_DTF = fft(x);
y_DTF = fft(y);

X_shifted = fftshift(x_DTF);
Y_shifted = fftshift(y_DTF);
f = linspace(-fpr/2, fpr/2, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;

subplot(5,1,1);
plot(f, x);
title('Sin x');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(5,1,2);
plot(f, X_shifted);
title('DFT sin x');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(5,1,3);
plot(f, abs(X_shifted));
title('DFT abs sin x');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(5,1,4);
plot(f, y);
title('Kaisera y');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(5,1,5);
plot(f, Y_shifted);
title('DFT window Kaisera y');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Operations 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Operacja 1: Liniowość (dodanie sygnałów)
z1 = x + y;
Z1 = fft(z1);

% Operacja 2: Skalowanie x(at), a = 2
a = 2;
z2 = sin(2 * pi * 50 * (t/a));
Z2 = fft(z2);

% Operacja 3: Odwrócenie czasu
z3 = fliplr(x);
Z3 = fft(z3);

% Operacja 4: Splot
z4 = conv(x, y, 'same');
Z4 = fft(z4);

% Operacja 5: Pochodna
z5 = diff(x) ./ diff(t);
% Dla pochodnej długość sygnału zmienia się, więc zerujemy ostatni element dla równej długości
z5 = [z5, 0];
Z5 = fft(z5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Shifting 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Z1_shifted = fftshift(Z1);
Z2_shifted = fftshift(Z2);
Z3_shifted = fftshift(Z3);
Z4_shifted = fftshift(Z4);
Z5_shifted = fftshift(Z5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
subplot(5,1,1);
plot(f, abs(Z1_shifted));
title('DFT after operation 1: Liniowość (x + y)');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(5,1,2);
plot(f, abs(Z2_shifted));
title('Widmo DFT after operation 2: Skalowanie x(at), a = 2');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(5,1,3);
plot(f, abs(Z3_shifted));
title('DFT after operation 3: Odwrócenie czasu');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(5,1,4);
plot(f, abs(Z4_shifted));
title('DFT after operation 4: Splot');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(5,1,5);
plot(f, abs(Z5_shifted));
title('DFT after operation 5: Pochodna');
xlabel('Frequency (Hz)');
ylabel('Amplitude');