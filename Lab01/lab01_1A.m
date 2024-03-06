% Zadanie 1.A
close all;
hold on;

A = 230; freq = 50; T = 0.1;

samplingFreq = [10^4, 500, 200];
names = ['b-', 'r-o', 'k-o' ];

for k = 1:length(samplingFreq)
    time = 0:1/samplingFreq(k):T;
    func = A * sin(2 * pi * f * time);
    plot(time, func, names(k));
end

title('1.A');
pause;
close all;
hold on;
