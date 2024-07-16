close all; clear all;
% Wczytaj nagranie z płyty CD
[x, fs_cd] = audioread('DontWorryBeHappy.wav');
fs_dab = 48000;

% Konwersja częstotliwości próbkowania za pomocą funkcji resample
y_resample = resample(x, 160, 147);

% Odsłuchaj sygnał oryginalny i przekonwertowany
disp('Odtwarzanie oryginalnego nagrania CD');
sound(x, fs_cd);
pause(length(x)/fs_cd + 2);
disp('job done');
disp('Odtwarzanie przekonwertowanego nagrania DAB (resample)');
sound(y_resample, fs_dab);


% Ręczna konwersja częstotliwości próbkowania
disp('job done');
% Nad-próbkowanie sygnału 160 razy (ekspander + filtr LP)
up_factor = 160;
x_upsampled = upsample(x, up_factor);
disp('job done');
% Projektowanie filtra dolnoprzepustowego
f_cutoff = min(fs_cd, fs_dab) / 2;
lp_filter = designfilt('lowpassfir', 'PassbandFrequency', f_cutoff / (up_factor * fs_cd), ...
    'StopbandFrequency', 1.5 * f_cutoff / (up_factor * fs_cd), 'PassbandRipple', 0.01, 'StopbandAttenuation', 80);
disp('job done');
% Filtracja nad-próbkowanego sygnału
x_upsampled_filtered = filtfilt(lp_filter, x_upsampled);

% Pod-próbkowanie sygnału 147 razy (filtr LP + reduktor)
down_factor = 147;
y_manual = downsample(x_upsampled_filtered, down_factor);
disp('job done');
% Odsłuchaj ręcznie przekonwertowany sygnał
disp('Odtwarzanie ręcznie przekonwertowanego nagrania DAB');
sound(y_manual, fs_dab);
pause(length(y_manual)/fs_dab + 2);
disp('job done');
% Porównanie długości sygnałów
disp(['Długość oryginalnego sygnału: ', num2str(length(x))]);
disp(['Długość sygnału przekonwertowanego funkcją resample: ', num2str(length(y_resample))]);
disp(['Długość sygnału ręcznie przekonwertowanego: ', num2str(length(y_manual))]);

% Zapisanie wyników do plików
audiowrite('nagranie_dab_resample.wav', y_resample, fs_dab);
audiowrite('nagranie_dab_manual.wav', y_manual, fs_dab);