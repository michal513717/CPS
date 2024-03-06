A = 230; %V
f = 50; %Hz
T = 1/f;
time = 1; %s

f1 = 10^4;
f2 = 51;
f3 = 50;
f4 = 49;
t1 = 0:1/f1:time;
t2 = 0:1/f2:time;
t3 = 0:1/f3:time;
t4 = 0:1/f4:time;
s1 = A*sin(2*pi*f*t1);
s2 = A*sin(2*pi*f*t2);
s3 = A*sin(2*pi*f*t3);
s4 = A*sin(2*pi*f*t4);

plot(t1, s1, 'b-');
hold on;
plot(t2, s2, 'g-o');
plot(t3, s3, 'r-o');
plot(t4, s4, 'k-o');
hold off; %end

xlabel('Czas [s]'); 
ylabel('Amplituda [V]');
title('Sinusoida o różnych częstotliwościach próbkowania');
legend('fs = 10 kHz', 'fs = 51 Hz', 'fs = 50 Hz', 'fs = 49 Hz');
