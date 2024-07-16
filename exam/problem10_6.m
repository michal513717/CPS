close all; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declare consts 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs_cd = 44100;
fs_dab = 48000;
resampleFactor_p = 160;
resampleFactor_q = 147;
up_factor = 160;
down_factor = 147;
filter_order = 512;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load audio file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[input_audio, fs] = audioread('DontWorryBeHappy.wav');
if fs ~= fs_cd 
    error('Częstotliwość próbkowania pliku audio musi wynosić 44100 Hz');
end

if size(input_audio, 2) > 1
    x = mean(input_audio, 2);
else
    x = input_audio;
end

disp('Audio załadowane poprawnie, naciśnij spacje aby odłsłuchać');

pause();

disp('Odtwarzanie oryginalnego sygnału');

sound(x, fs_cd);

pause(length(x)/fs_cd);

disp('Odtwarzanie zakończone');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Rozpoczynamy konwersję częstotliwości próbkowania (funkcja resample)');

y_resample = resample(x, resampleFactor_p, resampleFactor_q);

disp('Konwersja zakończona, naciśnij spacje aby odtworzyć');

pause();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Listening
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Odtwarzanie nagrania DAB przekonwertowanego za pomocą Resample');

sound(y_resample, fs_dab);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resampling part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('W tle rozpoczynamy proces ręcznej konwersji częstotliwości próbkowania');

x_upsampled = upsample(x, up_factor);

disp('Nad-próbkowanie zakończone');

f_cutoff = min(fs_cd, fs_dab) / 2;
nyquist_rate = up_factor * fs_cd / 2;
normalized_cutoff = f_cutoff / nyquist_rate;
lp_filter = fir1(filter_order, normalized_cutoff); % Zwiększona liczba współczynników filtra

disp('Projektowanie filtra dolnoprzepustowego zakończone');

disp('Start filtracji ...');

x_upsampled_filtered = filtfilt(lp_filter, 1, x_upsampled);

disp('Zakonczenie filtracji ...');

y_manual = downsample(x_upsampled_filtered, down_factor);
disp('Pod-próbkowanie zakończone');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Listening
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Konwersja zakończona, naciśnij spacje aby odtworzyć');

pause();

disp('Odtwarzanie ręcznie przekonwertowanego nagrania DAB');
sound(y_manual, fs_dab);
pause(length(y_manual)/fs_dab + 2);
disp('Odtwarzanie zakończone');

% Porównanie długości sygnałów
disp(['Długość oryginalnego sygnału: ', num2str(length(x))]);
disp(['Długość sygnału przekonwertowanego funkcją resample: ', num2str(length(y_resample))]);
disp(['Długość sygnału ręcznie przekonwertowanego: ', num2str(length(y_manual))]);

% Zapisanie wyników do plików
audiowrite('nagranie_dab_resample.wav', y_resample, fs_dab);
audiowrite('nagranie_dab_manual.wav', y_manual, fs_dab);
disp('Pliki zapisane');