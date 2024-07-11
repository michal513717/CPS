clc;
% Zadanie 2 - Filtr Butterworth LP
clear all; close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dane
N1 = 2; 
N2 = 4;
N3 = 6;
N4 = 8;

w3dB = 2*pi*100;
w    = 0.1:0.1:2000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fiiltry Butterworth LP: (można tu wsm funkcję walnąć)
% N1 = 2

for k = 1:N1
    p1(k) = w3dB * exp(j*((pi/2) + (1/2)*(pi/N1) + (k-1)*(pi/N1)));
end

z  = [];
bm = poly(z);          
an = poly(p1);          

H1    = polyval(bm, j*w)./polyval(an, j*w);
H1    = H1./max(H1);
H1log = 20*log10(abs(H1));

 % poly(A)       - Obliczanie wielomianu charakterystycznego dla A
 % polyval(p, x) - Rozwinięcie wielomianu p w każdym punkcie x

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fiiltry Butterworth LP:
% N2 = 4

for k = 1:N2
    p2(k) = w3dB * exp(j*((pi/2) + (1/2)*(pi/N2) + (k-1)*(pi/N2)));
end

z  = [];
bm = poly(z);          
an = poly(p2);          

H2    = polyval(bm, j*w)./polyval(an, j*w);
H2    = H2./max(H2);
H2log = 20*log10(abs(H2));

 % poly(A)       - Obliczanie wielomianu charakterystycznego dla A
 % polyval(p, x) - Rozwinięcie wielomianu p w każdym punkcie x

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fiiltry Butterworth LP:
% N3 = 6

for k = 1:N3
    p3(k) = w3dB * exp(j*((pi/2) + (1/2)*(pi/N3) + (k-1)*(pi/N3)));
end

z  = [];
bm = poly(z);          
an = poly(p3);          

H3    = polyval(bm, j*w)./polyval(an, j*w);
H3    = H3./max(H3);
H3log = 20*log10(abs(H3));

 % poly(A)       - Obliczanie wielomianu charakterystycznego dla A
 % polyval(p, x) - Rozwinięcie wielomianu p w każdym punkcie x

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fiiltry Butterworth LP:
% N4 = 8

for k = 1:N4
    p4(k) = w3dB * exp(j*((pi/2) + (1/2)*(pi/N4) + (k-1)*(pi/N4)));
end

z  = [];
bm = poly(z);          
an = poly(p4);          

H4    = polyval(bm, j*w)./polyval(an, j*w);
H4    = H4./max(H4);
H4log = 20*log10(abs(H4));

 % poly(A)       - Obliczanie wielomianu charakterystycznego dla A
 % polyval(p, x) - Rozwinięcie wielomianu p w każdym punkcie x

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wykresy biegunów
figure('Name',"Filtry Butterworth LP");
set(figure(3),'units','points','position',[0,400,400,350]);
subplot(2,2,1);
plot(real(p1),imag(p1),'b x');
title('Butterworth LP N=2');
xlim(max(abs(xlim)).*[-1 1]);

subplot(2,2,2);
plot(real(p2),imag(p2),'b x');
title('Butterworth LP N=4');
xlim(max(abs(xlim)).*[-1 1])

subplot(2,2,3);
plot(real(p3),imag(p3),'b x');
title('Butterworth LP N=6');
xlim(max(abs(xlim)).*[-1 1])

subplot(2,2,4);
plot(real(p4),imag(p4),'b x');
title('Butterworth LP N=8');
xlim(max(abs(xlim)).*[-1 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Narysuj na jednym rysunku ich charakterystyki amplitudowe
f    = w./2*pi;
flog = log10(f);

% W skali liniowej
figure('Name',"Charakterystyki amplitudowe"); 
set(figure(4),'units','points','position',[400,400,1040,350]);
subplot(1,2,1);
hold all;
plot(f, abs(H1),'r');
plot(f, abs(H2),'b');
plot(f, abs(H3),'g');
plot(f, abs(H4),'k');
title('Skala liniowa |H(j\omega)|');
legend('N=2','N=4','N=6','N=8');
xlabel('f [Hz]');
ylabel('H [j\omega]');
xlim([0 f(end)]);
hold off;

% W skali logarytmicznej
subplot(1,2,2);
hold all; 
semilogx(f,H1log,'r');
semilogx(f,H2log,'b');
semilogx(f,H3log,'g');
semilogx(f,H4log,'k');
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
legend('N=2','N=4','N=6','N=8');
xlabel('f [Hz]');
ylabel('H [j\omega]');
xlim([0 f(end)]);
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Narysuj charakterystyki fazowe

% Hp1 = atan(imag(H1)./real(H1));  % atan - Inverse tangent in radians
% Hp2 = atan(imag(H2)./real(H2));  
% Hp3 = atan(imag(H3)./real(H3));
% Hp4 = atan(imag(H4)./real(H4));

Hp1 = angle(H1);
Hp2 = angle(H2);  
Hp3 = angle(H3);
Hp4 = angle(H4);

% można też spróbować dla angle(H) zamiast liczenia atan

figure('Name','Charakterystyka fazowo-częstotliwościowa');
set(figure(5),'units','points','position',[400,31,1040,305]);
hold all;
plot(f, Hp1,'r'); 
plot(f, Hp2,'b'); 
plot(f, Hp3,'g'); 
plot(f, Hp4,'k'); 
title('Charakterystyka fazowo-częstotliwościowa');
xlabel('Częstotliwośc znormalizowana [Hz]');
legend('N=2','N=4','N=6','N=8');
ylabel('Faza [rad])');
xlim([0 f(end)]);
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wyznacz i narysuj odpowiedź impulsową filtru N=4 
% oraz jego odpowiedź na skok jednostkowy.

[bm, an] = zp2tf(z, p2', 1);   % Konwersja z biegunów do jw
sys = tf(bm, an);               % Transmitancja
printsys(bm, an,'s');           % Print filtru analogowego

figure('Name','Odpowiedź impulsowa filtru N=4');
set(figure(6),'units','points','position',[0,31,400,305]);
impulse(sys);

figure("Name","Odpowiedź filtru N=4 na skok jednostkowy");
set(figure(7),'units','points','position',[0,31,400,305]);
step(sys);

% zp2tf - Konwertuje parametry filtra zerowego wzmocnienia 
% z biegunów do wielomianów jw