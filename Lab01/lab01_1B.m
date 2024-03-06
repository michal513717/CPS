clear all; close all;

A = 230; f = 50; T = 1;
output = {};
samplingFreq = [10^4, 51, 50, 49];
% samplingFreq = [10^4, 26, 25, 24];

for k = 1:length(samplingFreq)
    time = 0:1/samplingFreq(k):T;
    func = A * sin(2 * pi * f * time);
    output{k} = { time, func };
end

hold on;

plot(output{1}{1}, output{1}{2}, 'b-');
plot(output{2}{1}, output{2}{2}, 'g-o');
plot(output{3}{1}, output{3}{2}, 'r-o');
plot(output{4}{1}, output{4}{2}, 'k-o');

xlabel('Czas [s]'); 
ylabel('Amplituda [V]');
title('Sinusoida o różnych częstotliwościach próbkowania');
legend('fs = 10 kHz', 'fs = 51 Hz', 'fs = 50 Hz', 'fs = 49 Hz');


hold off; %end