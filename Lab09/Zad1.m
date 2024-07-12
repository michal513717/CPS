clear;
close all;

% Parametry sygnału
fs = 8000; % częstotliwość próbkowania
t = 1; % czas trwania
A1 = -0.5; f1 = 34.2; % amplituda i częstotliwość 1
A2 = 1; f2 = 115.5; % amplituda i częstotliwość 2

% Generowanie sygnału
n = 0:1/fs:t-1/fs;
dref = A1*sin(2*pi*f1*n) + A2*sin(2*pi*f2*n); % sygnał ”czysty” do porównania

% Parametry filtru
M = 10; % długość filtru
mi = 0.01; % współczynnik szybkości adaptacji

% Szumy o różnej mocy
for SNR = [10, 20, 40]
    d = awgn(dref, SNR, 'measured'); % WE: sygnał odniesienia dla sygnału x
    x = [d(1) d(1:end-1)]; % WE: sygnał filtrowany, teraz opóźniony d

    y = []; e = []; % sygnały wyjściowe z filtra
    bx = zeros(M,1); % bufor na próbki wejściowe x
    h = zeros(M,1); % początkowe (puste) wagi filtru

    for n = 1:length(x)
        bx = [x(n); bx(1:M-1)]; % pobierz nową próbkę x[n] do bufora
        y(n) = h' * bx; % oblicz y[n] = sum( x .* bx) – filtr FIR
        e(n) = d(n) - y(n); % oblicz e[n]
        h = h + mi * e(n) * bx; % LMS
    end

    % Obliczanie SNR
    N = length(dref);
    SNRdB = 10 * log10(sum(dref.^2) / sum((dref - y).^2));
    fprintf('SNR dla szumu o mocy %d dB: %f dB\n', SNR, SNRdB);

    % Wykresy
    figure;
    plot(dref, 'b'); hold on;
    plot(d, 'r'); hold on;
    plot(y, 'g'); hold off;
    legend('Sygnał oryginalny', 'Sygnał zaszumiony', 'Sygnał odszumiony');
    title(sprintf('Sygnał dla szumu o mocy %d dB', SNR));
end