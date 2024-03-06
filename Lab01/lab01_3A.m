
L = load('Lab01\adsl_x.mat');
x = L.x;
f = abs(fft(x)); % Fast fiurier transorm 
plot(f);
f_sort = sort(f, 'descend');
i1 = f_sort(1);
i2 = f_sort(2);
i3 = f_sort(3);
i4 = f_sort(4);
i = max(f);

hold on;
plot(x(i1:i1+32) - x(i2:i2+32), 'r-');
plot(x(i2:i2+32) - x(i3:i3+32), 'g-*');
plot(x(i3:i3+32) - x(i1:i1+32), 'b-o');