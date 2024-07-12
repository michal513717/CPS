% Parametry sygnału
fs = 8000; % częstotliwość próbkowania
t = 1; % czas trwania
fpilot = 19e3; % częstotliwość pilota

% Generowanie sygnału
n = 0:1/fs:t-1/fs;
p = sin(2*pi*fpilot*n); % sygnał pilotowy

% Parametry PLL
alpha = 1e-2;
beta = alpha^2/4;

% Dodawanie szumu AWGN o różnej mocy i sprawdzanie szybkości zbieżności
for SNR = [0, 5, 10, 20]
    p_noisy = awgn(p, SNR, 'measured');

    % Pętla PLL dla zaszumionego sygnału
    theta = zeros(1,length(p_noisy)+1);
    freq = 2*pi*fpilot/fs;
    for n = 1:length(p_noisy)
        perr = -p_noisy(n)*sin(theta(n));
        theta(n+1) = theta(n) + freq + alpha*perr;
        freq = freq + beta*perr;
    end

    % Generowanie sygnału harmonicznej o 3 razy większej częstotliwości
    c57 = cos(3*theta(1:end-1)); % nosna 57 kHz

    % Obliczanie liczby próbek, po których oscylator dostroił się do sygnału
    threshold = 0.01; % próg zbieżności
    diff = abs(c57 - p_noisy(1:length(c57)));
    convergence_sample = find(diff < threshold, 1);
    fprintf('Dla szumu o mocy %d dB, oscylator dostroił się po %d próbkach\n', SNR, convergence_sample);
end

% Alpha (α): Ten parametr jest nazywany współczynnikiem proporcjonalności i
% wpływa na szybkość, z jaką oscylator dostosowuje swoją fazę do fazy sygnału 
% wejściowego. Wysoka wartość alpha powoduje szybsze dostrojenie, ale 
% może prowadzić do większych oscylacji wokół wartości docelowej. 
% Niska wartość alpha prowadzi do wolniejszego dostrojenia, ale z mniejszymi oscylacjami.

% Beta (β): Ten parametr jest nazywany współczynnikiem całkowania i 
% wpływa na zdolność oscylatora do dostosowywania się do zmian 
% częstotliwości sygnału wejściowego. Wysoka wartość beta pozwala 
% oscylatorowi szybko dostosować się do zmian częstotliwości, ale 
% może prowadzić do niestabilności. Niska wartość beta powoduje wolniejsze 
% dostosowanie do zmian częstotliwości, ale zwiększa stabilność oscyla

% oscylator dostroił się szybciej, gdy moc szumu była mniejsza (42 próbki dla 0 dB), 
% a wolniej, gdy moc szumu była większa (93 próbki dla 20 dB).
% To jest zgodne z oczekiwaniami, ponieważ większy szum może utrudniać dostrojenie oscylatora do sygnału wejściowego.

