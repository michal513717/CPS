clc;
% Zadanie 2 - Filtr Hilberta, modulacja AM
clear all; close all;



% Działanie: Modulacja AM polega na zmianie amplitudy fali nośnej 
% proporcjonalnie do sygnału informacyjnego. Jest to podstawowa forma 
% modulacji używana w radiowych systemach komunikacyjnych.

% Zalety: Modulacja AM jest prostą i opłacalną metodą przesyłania informacji. 
% Ma niższe wymagania dotyczące przepustowości i jest bardziej wydajna
% pod względem wykorzystania widma8.

% Wady: Modulacja AM jest podatna na zakłócenia i szumy, 
% które mogą pogorszyć jakość odbieranego sygnału1.



%% Generowanie teoretycznej odpowiedzi impulsowej
fs = 400e3;                         % czestotliwosc probkowania
fc = 100e3;                         % czestotliwosc nosna
M  = 1024;                            % polowa dlugosci filtra
N  = 2*M+1;
n  = 1:M;
h  = (2/pi)*sin(pi*n/2).^2 ./n;     % połowa odpowiedzi impulsowej (TZ str. 352)
h  = [-h(M:-1:1) 0 h(1:M)];         % cała odpowiedź dla n = ?M,...,0,...,M

%% Wymnażanie przez okno Blackmana
w  = blackman(N); 
w  = w';            
hw = h.*w;                          % wymnożenie odpowiedzi impulsowej z oknem

%% Zaladowanie sygnalow modulowanych
[x1,fs1] = audioread('mowa8000.wav');
x1 = x1';
x2 = fliplr(x1);                    % druga stacja to mowa8000 od tyłu

%% Parametry sygnalow radiowych
fs  = 400e3;                        % czestotliwosc probkowania sygnalu radiowego
fc1 = 100e3;                        % czestotliwosc nosna 1 stacji
fc2 = 110e3;                        % czestotliwosc nosna 2 stacji
dA  = 0.25;                         % glebokosc modulacji obu stacji

%% Resampling w celu uzyskania poprawnej modulacji AM
xr1 = resample(x1, fs, fs1);
xr2 = resample(x2, fs, fs1);        %fs/fsx

xh1 = conv(xr1,hw);
xh2 = conv(xr2,hw);

xh1 = xh1(M+1:length(xr1)+M);
xh2 = xh2(M+1:length(xr2)+M);

t1 = length(x1)/fs1;
t  = 0:1/fs:t1-1/fs;

%% Filtrowanie filterm Hilberta
% xh1 = hilbert(xr1); 
% xh1 = imag(xh1);
% 
% xh2 = hilbert(xr2); 
% xh2 = imag(xh2);

%% Generowanie sygnalow radiowych
%DSB-C
Ydsb_c_a = (1+xr1).*cos(2*pi*fc1*t); %stacja 1
Ydsb_c_b = (1+xr2).*cos(2*pi*fc2*t); %stacja 2
Ydsb_c   = dA*(Ydsb_c_a + Ydsb_c_b);

%DSB-SC
Ydsb_sc_a = xr1.*(cos(2*pi*fc1*t));
Ydsb_sc_b = xr2.*(cos(2*pi*fc2*t));
Ydsb_sc   = dA*(Ydsb_sc_a + Ydsb_sc_b);

%SSB-SC (+) wstega po lewej
Yssb_sc1_a = 0.5*xr1.*cos(2*pi*fc1*t) + 0.5*xh1.*sin(2*pi*fc1*t);
Yssb_sc1_b = 0.5*xr2.*cos(2*pi*fc2*t) + 0.5*xh2.*sin(2*pi*fc2*t);
Yssb_sc1   = dA*(Yssb_sc1_a + Yssb_sc1_b);

%SSB-SC (-) wstega po prawej
Yssb_sc2_a = 0.5*xr1.*cos(2*pi*fc1*t) - 0.5*xh1.*sin(2*pi*fc1*t);
Yssb_sc2_b = 0.5*xr2.*cos(2*pi*fc2*t) - 0.5*xh2.*sin(2*pi*fc2*t);
Yssb_sc2   = dA*(Yssb_sc2_a + Yssb_sc2_b);

%transformaty powyzszych sygnalow AM
HYdsb_c   = fft(Ydsb_c);
HYdsb_sc  = fft(Ydsb_sc);
HYssb_sc1 = fft(Yssb_sc1);
HYssb_sc2 = fft(Yssb_sc2);

%% Wykresy widm - porównanie typów modulacji AM
f = (0:length(HYdsb_c)-1)/length(HYdsb_c)*fs;
figure('Name','Wykresy widm - porównanie typów modulacji AM');
set(figure(2),'units','points','position',[0,0,1440,750]);

subplot(1,4,1);
plot(f, abs(HYdsb_c));
title('fft DSB-C');
xlim([90e3 120e3]);

subplot(1,4,2);
plot(f, abs(HYdsb_sc));
title('fft DSB-SC');
xlim([90e3 120e3]);

subplot(1,4,3);
plot(f, abs(HYssb_sc1));
title('fft SSB-SC (+)');
xlim([90e3 120e3]);

subplot(1,4,4);
plot(f, abs(HYssb_sc2));
title('fft SSB-SC (-)');
xlim([90e3 120e3]);

% DSB-C (Double Side Band - Full Carrier): Jest to najprostsza forma modulacji AM,
% która zawiera pełne widmo sygnału i pełną falę nośną. Na wykresie widzimy
% dwa piki, które reprezentują obie strony pasma sygnału.

% DSB-SC (Double Side Band - Suppressed Carrier): Jest to forma modulacji AM, 
% która eliminuje falę nośną, co prowadzi do oszczędności energii. 
% Na wykresie widzimy dwa piki, które są symetryczne względem zera,
% co pokazuje, że fala nośna została stłumiona.

% SSB-SC (+) (Single Side Band - Suppressed Carrier): Jest to forma modulacji 
% AM, która eliminuje jedno z pasm i falę nośną, co prowadzi do jeszcze większych 
% oszczędności energii. Na wykresie widzimy tylko jeden pik, co pokazuje, że jedno z pasm zostało usunięte.

% SSB-SC (-) (Single Side Band - Suppressed Carrier): Jest to inna forma
% modulacji SSB-SC, która eliminuje przeciwne pasmo w porównaniu do SSB-SC 
% (+). Na wykresie widzimy tylko jeden pik, ale na przeciwnym końcu spektrum w porównaniu do SSB-SC (+).

