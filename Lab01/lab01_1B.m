clear all; close all;

A = 230; f = 50; T = 1;
samplingFreq = [10^4, 51, 50, 49];
% samplingFreq = [10^4, 26, 25, 24];
names = ['b-', 'g-o', 'r-o', 'k-o'];

for k = 1:length(samplingFreq)
    time = 0:1/samplingFreq(k):T;
    func = A * sin(2 * pi * f * time);
    plot(time, func, names(k));
end

hold on;

xlabel('Czas [s]'); 
ylabel('Amplituda [V]');
title('Sinusoida o różnych częstotliwościach próbkowania');
legend('fs = 10 kHz', 'fs = 51 Hz', 'fs = 50 Hz', 'fs = 49 Hz');


hold off; %end