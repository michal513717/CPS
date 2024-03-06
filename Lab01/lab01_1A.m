% Zadanie 1.A
close all;
hold on;

A = 230; freq = 50; T = 0.1;

f = @(t) A * sin(freq * 2 * pi * t);

values = [10^4 500 200];
keys = ['b-' 'r-o' 'k-o' ];

x1 = 0: 1/values(1) :T;
x2 = 0: 1/values(2) :T;
x3 = 0: 1/values(3) :T;

plot(x1, f(x1), keys(1));
plot(x2, f(x2), keys(2));
plot(x3, f(x3), keys(3));

title('1.A');
pause;
close all;
hold on;
