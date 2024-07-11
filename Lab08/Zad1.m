clc;
% Zadanie 1 - Filtr Hilberta, demodulacja AM
clear all; close all;

%% Dany sygnał
load('lab08_am.mat');
x = s6;


% Działanie: Filtr Hilberta wykonuje przesunięcie fazy o 90° na sygnale
% wejściowym. Jest to użyteczne w wielu zastosowaniach, takich jak analiza 
% sygnałów, przetwarzanie obrazów i komunikacja bezprzewodowa.

% Zalety: Filtr Hilberta jest użyteczny w wielu zastosowaniach, 
% takich jak analiza sygnałów, przetwarzanie obrazów i komunikacja bezprzewodowa.

%Wady: Filtr Hilberta może być trudny do zaimplementowania w praktyce,
% szczególnie dla sygnałów rzeczywistych. Wymaga precyzyjnej kontroli
% fazy, co może być trudne do osiągnięcia w rzeczywistych systemach.


%% Generowanie teoretycznej odpowiedzi impulsowej
fs = 1000;                          % czestotliwosc probkowania
fc = 200;                           % czestotliwosc nosna
M  = 64;                            % polowa dlugosci filtra
N  = 2*M+1;
n  = 1:M;
h  = (2/pi)*sin(pi*n/2).^2 ./n;     % połowa odpowiedzi impulsowej (TZ str. 352)
h  = [-h(M:-1:1) 0 h(1:M)];         % cała odpowiedź dla n = ?M,...,0,...,M

%% Wymnażanie przez okno Blackmana
w  = blackman(N); 
w  = w';            
hw = h.*w;                          % wymnożenie odpowiedzi impulsowej z oknem

% Okno Blackmana charakteryzuje się płaską charakterystyką widmową2.
% Dzięki temu możliwa jest dokładna estymacja amplitudy sygnału nawet
% w przypadku niesynchronicznej rejestracji, tj. niecałkowitej liczby okresów2.

% Okno Blackmana daje największe tłumienie dla 750 Hz: niecałe 60 dB3.

%Okno Blackmana jest używane w analizie widmowej, gdzie pomaga zmniejszyć 
% efekty przecieku widma i błędy estymacji fazy, częstotliwości i amplitudy 
% spowodowane próbkowaniem ciągłego widma sygnału dyskretnego przez DFT (Dyskretne Przekształcenie Fouriera)

% Jest stosowane w przypadkach, gdy sygnał dyskretny nie jest okresowy i występuje naturalna fluktuacja częstotliwości podstawowej2.


%% widmo Fouriera oraz wykresy

m = -M : 1 : M;                     % dla filtra nieprzyczynowego (bez przesunięcia o M próbek w prawo)
% m = 0 : N-1;                      % dla filtra przyczynowego (z przesunięciem o M próbek w prawo)
NF = 500; 
fn=0.5*(1:NF-1)/NF;
for k=1:NF-1
    H(k)  =sum (h  .* exp(-j*2*pi*fn(k)*m));
    HW(k) =sum (hw .* exp(-j*2*pi*fn(k)*m));
end

figure(2);
set(figure(2),'units','points','position',[0,0,1440,750]);
subplot(2,2,1);
stem(m,h); grid; title('h(n)'); xlabel('n');
subplot(2,2,2);
stem(m,hw); grid; title('hw(n)'); xlabel('n'); 
subplot(2,2,3);
plot(fn,abs(H)); grid; title('|H(fn)|'); xlabel('f norm]'); 
subplot(2,2,4);
plot(fn,abs(HW)); grid; title('|HW(fn)|'); xlabel('f norm]');
pause();
%% Porównanie z funkcja hilbert() matlaba
HT = hilbert(x);

%% Filtracja odpowiedzią impulsową
xHT = conv(x,hw);           % filtracja sygnału x(n) za pomocą odp. impulsowej hw(n); otrzymujemy Nx+N?1 próbek
xHT = xHT(N:1000);          % odcięcie stanów przejściowych (po N?1 próbek) z przodu sygnału y(n)
x2  = x(M+1:1000-M);        % odcięcie tych próbek z x(n), dla których nie ma poprawnych odpowiedników w y(n)
m   = sqrt(x2.^2 + xHT.^2); % obwiednia to pierwiastek z sumy kwadratów sygnałów x i jego transformacji Hilberta HT(x).

%% Sygnał x2 wraz z jego transformatą Hilberta xHT i obwiednią m
figure('Name','Sygnał x wraz z jego transformatą Hilberta xHT i obwiednią m');
set(figure(3),'units','points','position',[0,0,1440,750]);
hold on;
plot(x2,'r'); 
plot(xHT,'b');
plot(m,'k'); 
title('Przedstawienie sygnału z pliku, jego transformaty i obwiedni')
legend('x','HT(x)','obwiednia');
hold off;
pause();
%% FFT obwiedni
NFFT = 2^nextpow2(fs);
Y    = fft(m,NFFT)/fs;                  %transformata fouriera obwiedni
f    = fs/2*linspace(0,1,NFFT/2+1);

figure('Name','FFT obwiedni')
set(figure(4),'units','points','position',[0,0,1440,750]);;
plot(f,2*abs(Y(1:NFFT/2+1)),'b');
title('FFT obwiedni');
pause();
%% Odczytanie parametrów sygnału modulującego m(t)
[pks, locs] = findpeaks(2*abs(Y(1:NFFT/2+1)), 'SortStr','descend');

if(0)
    f1 = locs(1); f2=locs(2); f3=locs(3);
    A1 = pks(1);  A2=pks(2);  A3=pks(3);
else
    f1=6;  f2=60;    f3=90;
    A1=0.2; A2=0.33; A3=0.57;
end

%% Sygnał modulujący amplitudę mr(t) - suma trzech sygnałów
t  = 0:1/fs:1-1/fs;
mr = 1 + A1*cos(2*pi*f1*t) + A2*cos(2*pi*f2*t) + A3*cos(2*pi*f3*t);     % sygnał modulujący
mr = mr(M+1:1000-M);                                                    % odcięcie próbek

%% Sygnał m(t) z pliku po filtrze Hilberta vs Sygnał mr(t) rekonstruowany
figure('Name','Sygnał m(t) z pliku po filtrze Hilberta vs Sygnał mr(t) rekonstruowany');
set(figure(5),'units','points','position',[0,0,1440,750]);
hold on;
plot(m, 'b');
plot(mr,'r');
plot(abs(HT(M:end)),'k');
title('Porównanie sygnałów modulujących m i mr');
legend('m  - Z filtru FIR','mr - Zrekonstruowany','matlab hilbert()'); 
hold off;
pause();
%% Sygnał x z pliku zmodulowany vs Sygnał xr rekonstruowany i zmodulowany
xn = sin(2*pi*fc*t);          % nośna z treści
xn = xn(M+1:1000-M);          % odcięcie próbek
xr = xn.*mr;                  % sygnał zmodulowany po odtworzeniu

figure('Name','Sygnał x z pliku zmodulowany vs Sygnał xr rekonstruowany i zmodulowany');
set(figure(6),'units','points','position',[0,0,1440,750]);
hold on;
plot(x2,'r');
plot(xr,'b');
title('Porównanie sygnałów x i xr po modulacji');
legend('x  - Sygnał z pliku zmodulowany ','xr - Sygnał skonstruowany i zmodulowany');
hold off;
