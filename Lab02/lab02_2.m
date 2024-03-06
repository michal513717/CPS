% Zadanie 2 -  Transformacja odwrotna - perekcyjna rekonstrukcja
clear all; close all;

% Generator wzorców cosinusowych w pętli z zadania 1
N = 20;
sk = sqrt(1/N);

for k = 1:N 
    for n = 1:N 
        A(k,n) = sk * cos(pi*(k-1)/N * ((n-1)+0.5));
    end
    sk = sqrt(2/N);
end

% Macierz odwrotna (syntezy) IDCT do macierzy DCT (macierz A)
S = A';

% Sprawdź czy SA = I (maczerz identycznościowa)
I = S*A;
tolA = max(max(abs(S-inv(A))));

% Matlab błędnie podaje wartosci bliskie 0 i 1. 
% Dlatego odpowiednie z nich zaokrąglamy
for l = 1:N
    for m = 1:N
        if abs(I(l,m)) < 1e-14 && l~=m
            I(l,m) = 0;
        end

        if abs(I(l,m) -1 ) < 1e-14 && l==m
            I(l,m) = 1;
        end
   end
end

% Sprawdzamy gotową macierz I
isidentic = 1;

for o = 1:N
    for p = 1:N
        if abs(I(o,p)) ~= 0 && o~=p
            isidentic = 0;
        end

        if abs(I(o,p)) ~= 1 && o==p
            isidentic = 0;
        end
   end
end


% Maksymalna wartość bezwzględnej różnicy między dwiema macierzami jest
% używana jako miara błędu lub tolerancji. Pozwala nam ocenić, 
% jak bardzo te dwie macierze różnią się od siebie.
if isidentic == 1
    fprintf('Macierz I jest identycznościowa z błędem: %u\n', tolA);
else
    disp('Macierz I nie jest identycznościowa');
end

% Analiza sygnału losowego 
srand = rand(20);
X = A * srand;

% Rekonstrukcja sygnału losowegoo
rcnst = S * X;

% Sprawdzenie czy transformata posiada 
% właściwość perfekcyjnej rekonstrukcji
tolB = max(max(abs(srand-rcnst)));

if tolB < 10^-10
    fprintf('Rekonstrukcja sygnału z błędem: %u\n', tolB);
end



