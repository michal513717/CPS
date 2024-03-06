% Zadanie 1.C1
x = 0: 1/100 :1;
for f=0: 5 :300
    plot(x, sin(x * 2 * pi * f));
    title(f);
    pause(0.5);
end

title('1.C1 5, 105, 205');
close all;
hold on; 

% Zadanie 1.C2
title('1.C2 95, 195, 295');
f = @(t) sin(2 * pi * t);
autoplot_const_fs( ...
          f,...
          100, ...
          1, ...
          containers.Map({'r-o', 'g-o', 'b-o'}, ...
                         { 95,    195,   295}));

pause();
close all;
hold on;

% Zadanie 1.C3
title('1.C3 95, 105');
autoplot_const_fs( ...
          f,...
          100, ...
          1, ...
          containers.Map({'r-o', 'g-*'}, ...
                         { 95,    105}));

pause();
close all;

function autoplot_const_fs(f, fs, T, m)
    v = values(m);
    k = keys(m);

    for i = 1:length(m)
        t = 0: 1/fs :T;
        k{i}, v{i}
        plot(t, f(v{i} * t), k{i});
    end    
end