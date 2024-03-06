% Zadanie 1 -  Analiza częstotliwościowa
clear all; close all;

% Dane
N = 100;    % liczba probek
fs = 1000;  % czestotliwosc probkowania
st = 1/fs;  % krok próbkowania
T = 0.1;    % czas trwania probkowania (100 probek dla 1000Hz = 0.1s)

sample = st:st:T; % przedział czasowy próbkowania

% Czestotliwosci sinusoid 
f1 = 50; 
f2 = 100;
f3 = 150;

% Amplitudy sinusoid 
A1 = 50;
A2 = 100;
A3 = 150;

% Tworzenie sygnału z sumy sinusów 
s1 = @(t) A1 * sin(2*pi*f1*t);
s2 = @(t) A2 * sin(2*pi*f2*t);
s3 = @(t) A3 * sin(2*pi*f3*t);

% Sygnał x z sumy sinusów 
x = s1(sample) + s2(sample) + s3(sample); 

figure(2);
subplot(2,1,1);
hold all;
plot(s1(sample), 'r-o');
plot(s2(sample), 'g-o');
plot(s3(sample), 'b-o');
title('Trzy sinusy do sumowania');
legend('s1 50Hz','s2 100Hz','s3 150Hz');

figure(2);
subplot(2,1,2);
plot(x, 'r-o')
title('Zsumowane sinusy');
legend('s1 + s2 + s3');
xlabel('Numer próbki');

% Budowanie macierzy A=DCT i S=IDCT dla 100 próbek
sk = sqrt(1/N);

for k = 1:N 
    for n = 1:N 
        A(k,n) = sk * cos(pi*(k-1)/N * ((n-1)+0.5));
    end
    sk = sqrt(2/N);
end

S = inv(A);

% Wyświetlanie w pętli wartości wszystkich 
% wierszy macierzy A i kolumn macierzy S
%figure(3);
for i=1:100
    plot(A(i,:),'b-x');
    hold on;
    plot(S(:,i),'r-o');
    title('Wiersze i kolumny macierzy A i S (DCT i IDCT)');
    legend('wiersze A=DCT','kolumny S=IDCT');
    fprintf(' %u Wiersz A / Kolumna S %u\n', i);
    pause
    hold off;
end

% Analiza sygnału y=Ax
y = A * x';

% Porównaj wartości współczynników niezerowych
% z wartościami amplitud składowych sygnału 
f =(1:N)*fs/(2*N);
figure(4);
subplot(2,1,1);
stem(f, y, 'b');
title('Obserwacja współczynników');
xlabel('Częstotliwość [Hz]');
subplot(2,1,2);
plot(x, 'r-o');
title('Sygnał sumy sinusów');
xlabel('Numer próbki');

% Rekonstrukcja sygnału 
rcnst = S * y;

% Sprawdzenie czy transformata posiada 
% właściwość perfekcyjnej rekonstrukcji
tol = max(max(abs(x'-rcnst)));
fprintf('Rekonstrukcja sygnału z błędem: %u\n', tol)

% Porównanie sygnału z rekonsrtrukcji z rekonstruowanym
figure(5);
hold all;
subplot(2,1,1);
plot(x, 'b');
title('Sygnał sumy sinusów');
subplot(2,1,2);
plot(rcnst, 'r');
title('Rekonstrukcja sygnału sumy sinusów');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zmiana f2 na 105 Hz
f2 = 105;
s2 = @(t) A2 * sin(2*pi*f2*t);
x = s1(sample) + s2(sample) + s3(sample); 

% Analiza sygnału y=Ax
y = A * x'; 

f =(1:N)*fs/(2*N);
figure(6);
subplot(2,1,1);
stem(f, y, 'b');
title('Obserwacja współczynników, f2 + 5Hz');
xlabel('Częstotliwość [Hz]');
subplot(2,1,2);
plot(x, 'r-o');
title('Sygnał sumy sinusów, f2 + 5Hz');
xlabel('Numer próbki');

% Rekonstrukcja sygnału 
rcnst = S * y;

% Sprawdzenie czy transformata posiada 
% właściwość perfekcyjnej rekonstrukcji
tol = max(max(abs(x'-rcnst)));
fprintf('Rekonstrukcja sygnału z błędem: %u\n', tol)

% Porównanie sygnału z rekonsrtrukcji z rekonstruowanym
figure(7);
hold all;
subplot(2,1,1);
plot(x, 'b');
title('Sygnał sumy sinusów');
subplot(2,1,2);
plot(rcnst, 'r-');
title('Rekonstrukcja sygnału sumy sinusów');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zmiana częstotliwości o 2.5 Hz
f1 = 52.5; 
f2 = 102.5;
f3 = 152.5;

% Tworzenie sygnału z sumy sinusów 
s1 = @(t) A1 * sin(2*pi*f1*t);
s2 = @(t) A2 * sin(2*pi*f2*t);
s3 = @(t) A3 * sin(2*pi*f3*t);

% Sygnał x z sumy sinusów 
x = s1(sample) + s2(sample) + s3(sample); 

% Analiza sygnału y=Ax
y = A * x'; 

f =(1:N)*fs/(2*N);
figure(8);
subplot(2,1,1);
stem(f, y, 'b');
title('Obserwacja współczynników, f1, f2, f3 + 2.5 Hz');
xlabel('Częstotliwość [Hz]');
subplot(2,1,2);
plot(x, 'r-o');
title('Sygnał sumy sinusów, f1, f2, f3 + 2.5 Hz');
xlabel('Numer próbki');

% Rekonstrukcja sygnału 
rcnst = S * y;

% Sprawdzenie czy transformata posiada 
% właściwość perfekcyjnej rekonstrukcji
tol = max(max(abs(x'-rcnst)));
fprintf('Rekonstrukcja sygnału z błędem: %u\n', tol)

% Porównanie sygnału z rekonsrtrukcji z rekonstruowanym
figure(9);
hold all;
subplot(2,1,1);
plot(x, 'b');
title('Sygnał sumy sinusów');
subplot(2,1,2);
plot(rcnst, 'r');
title('Rekonstrukcja sygnału sumy sinusów');
