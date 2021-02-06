% ryby.erl
-module(ryby).
-compile([export_all]).
-import(lists, []).

%uruchamiamy program poprzez funkcje main
%c(ryby).
%ryby:main().

%glowne zmienne:
%K-lista karpi kazda kolejna komorka to liczba karpi w danym wieku 
%Y-aktualny rok(krok symulacji)
%P-racje zywieniowe (domyslnie 2)

%zmienne drugorzedne
%W-wybrany wiek przy dodawaniu nowych ryb 
%N-numer indeksu przy iterowaniu listy karpi
%A-pozostala liczba karpi do odjecia
%A,B,C itp. to pomocnicze zmienne przy przetwarzaniu danych

%changetab i normalsterp wykonuja kolejny krok symulacji
changetab(K,P)->
	%edycja listy karpii
	%umieraja najstarsze karpie i ewentualnie rodza sie nowe zaleznie od pozywienia
	if
		P==0 -> [0 || _ <- lists:seq(1,20)];
		P==1 -> [lists:sum(lists:nthtail(2,K))]++lists:sublist(K,19);
		P==2 -> [5*lists:sum(lists:nthtail(2,K))]++lists:sublist(K,19);
		P==3 -> [10*lists:sum(lists:nthtail(2,K))]++lists:sublist(K,19);
		true -> io:format("Blad ilosci pozywienia")
	end.

%obliczna jest ilosc karpii z uwzglednieniem grup wiekowych
normalstep(K,Y,P)->
	NewY=Y+1,
	io:format("~nRok numer: "),
	io:fwrite("~p~n",[NewY]),
	io:format("Ilosc pozywienia:"),
	io:fwrite("~p~n",[P]),
	NewK=changetab(K,P),
	io:format("Wygenerowane karpie:~n"),
	io:fwrite("~w~n",[NewK]),
	Sum=lists:sum(NewK),
	io:format("Suma wszystkich karpi: "),
	io:fwrite("~w~n",[Sum]),
	Sum1=lists:sum(lists:sublist(NewK,2)),
	io:format("Suma karpi dzieci: "),
	io:fwrite("~w~n",[Sum1]),
	Sum2=lists:sum(lists:nthtail(2,NewK)),
	io:format("Suma karpi doroslych: "),
	io:fwrite("~w~n",[Sum2]),
	io:format("~n"),
	mainloop(NewK,NewY,P).
	
%mozliwosc zmiany racji zywieniowych wedlug skali 0-3
%UWAGA! zerowe racje zabija w nastepnym kroku wszystkie ryby
checkfood(K,Y,P)->
	io:format("Zmiana ilosci pozywienia~n"),
	io:format("0-brak pozywienia (wszystkie ryby umra)~n"),
	io:format("1-malo pozywienia (mala rozrodczosc)~n"),
	io:format("2-srednio pozywienia (srednia rozrodczosc)~n"),
	io:format("3-duzo pozywienia (duza rozrodczosc)~n"),
	io:format("Podaj nowa ilosc pozywienia~n"),
	NewP=io:fread("Ilosc: ", "~d"),
	B=element(2,NewP),
	A=lists:nth(1,B),
	if 
		A==0 -> mainloop(K,Y,A);
		A==1 -> mainloop(K,Y,A);
		A==2 -> mainloop(K,Y,A);
		A==3 -> mainloop(K,Y,A);
		true -> checkfood(K,Y,P) 
	end.
	
%uzytkownik moze dodac nowe ryby do hodowli jesli wybierze taka opcje
%aktualizacja listy	
addfish1(K,A,W)->
	if 
		W==1 -> [lists:nth(1,K)+A]++lists:nthtail(1,K);
		W==20 -> lists:sublist(K,19)++[lists:nth(20,K)+A];
		true -> lists:sublist(K,W-1)++[lists:nth(W,K)+A]++lists:nthtail(W,K)
	end.
	
%wybor wieku dodawanych ryb 
addfish(K,Y,P)->
	io:format("Wprowadz liczbe dodawanych ryb~n"),
	R=io:fread("Liczba ryb: ", "~d"),
	B=element(2,R),
	A=lists:nth(1,B),
	io:format("Wprowadz wiek ryb [0-19]~n"),
	W=io:fread("Wiek: ", "~d"),
	D=element(2,W),
	E=lists:nth(1,D),
	NewW=E+1,
	if 
		A<0 -> addfish(K,Y,P);
		NewW<1 -> addfish(K,Y,P);
		NewW>20 -> addfish(K,Y,P);
		true -> mainloop(addfish1(K,A,NewW),Y,P)
	end.

%wypisywanie stanu symulacji na zyczenie uzytkownika
writedata(K,Y,P)->
	io:format("Rok numer: "),
	io:fwrite("~p~n",[Y]),
	io:format("Ilosc pozywienia:"),
	io:fwrite("~p~n",[P]),
	io:format("Wygenerowane karpie:~n"),
	io:fwrite("~w~n",[K]),
	Sum=lists:sum(K),
	io:format("Suma wszystkich karpii: "),
	io:fwrite("~w~n",[Sum]),
	Sum1=lists:sum(lists:sublist(K,2)),
	io:format("Suma karpii dzieci: "),
	io:fwrite("~w~n",[Sum1]),
	Sum2=lists:sum(lists:nthtail(2,K)),
	io:format("Suma karpii doroslych: "),
	io:fwrite("~w~n",[Sum2]),
	io:format("~n"),
	mainloop(K,Y,P).

%wylawianie karpii i usuwanie ich z hodowli (np. do zjedzenia)
%subtract 1, 2 i 3 to rozne warianty ulozenia listy
subtract1(K,Y,P,A,N)->
	T=lists:nth(N,K),
	if 
		T-A<0 -> subtract([0]++lists:nthtail(N,K),Y,P,A-T,N-1);
		T-A==0 -> subtract([0]++lists:nthtail(N,K),Y,P,0,N-1);
		T-A>0 -> subtract([T-A]++lists:nthtail(N,K),Y,P,0,N-1);
		true -> "Subtract error"
	end.
	
subtract2(K,Y,P,A,N)->
	T=lists:nth(N,K),
	if 
		T-A<0 -> subtract(lists:sublist(K,N-1)++[0],Y,P,A-T,N-1);
		T-A==0 -> subtract(lists:sublist(K,N-1)++[0],Y,P,0,N-1);
		T-A>0 -> subtract(lists:sublist(K,N-1)++[T-A],Y,P,0,N-1);
		true -> "Subtract error"
	end.
	
subtract3(K,Y,P,A,N)->
	T=lists:nth(N,K),
	if 
		T-A<0 -> subtract(lists:sublist(K,N-1)++[0]++lists:nthtail(N,K),Y,P,A-T,N-1);
		T-A==0 -> subtract(lists:sublist(K,N-1)++[0]++lists:nthtail(N,K),Y,P,0,N-1);
		T-A>0 -> subtract(lists:sublist(K,N-1)++[T-A]++lists:nthtail(N,K),Y,P,0,N-1);
		true -> "Subtract error"
	end.

subtract(K,Y,P,A,N)->
	if 
	A==0 -> mainloop(K,Y,P);
	A<0 -> "Subtract error";
	N==1 -> subtract1(K,Y,P,A,N);
	N==20 -> subtract2(K,Y,P,A,N);
	true -> subtract3(K,Y,P,A,N)
	end.	
		
%jesli uzytkownik chcialby zabic wiecej ryb niz jest doroslych
%to musi potwierdzic czy chce zabic tez male ryby
check_subtract(K,Y,P,A)->
	io:format("Konieczne byloby zabicie niedoroslych ryb~n"),
	io:format("Czy chcesz kontynuowac?~n"),
	io:format("0-nie~n"),
	io:format("1-tak~n"),
	R=io:fread("Dzialanie: ", "~d"),
	B=element(2,R),
	C=lists:nth(1,B),
	if 
		C==0 -> catchfish(K,Y,P);
		C==1 -> subtract(K,Y,P,A,20);
		true -> check_subtract(K,Y,P,A)
	end.

%interfejs wylawiania ryb 
%program posiada zabezpieczenia graniczne
%nie mozna wylowic wiecej ryb niz jest w hodowli 
catchfish(K,Y,P)->
	io:format("Wprowadz liczbe ryb do wylowienia~n"),
	R=io:fread("Liczba ryb: ", "~d"),
	B=element(2,R),
	A=lists:nth(1,B),
	%suma wszystkich osobnikow
	Sum=lists:sum(K),
	%suma doroslych osobnikow
	Sum1=lists:sum(lists:nthtail(2,K)),
	if 
		A<Sum1+1 -> subtract(K,Y,P,A,20);
		A<Sum+1 -> check_subtract(K,Y,P,A);
		true -> catchfish(K,Y,P)
	end.

%glowna petla interfejsu programu
mainloop(K,Y,P)->
	io:format("Wybierz dzialanie:~n"),
	io:format("1-wczytaj nastepny krok:~n"),
	io:format("2-zmien ilosc pozywienia:~n"),
	io:format("3-odlow czesc ryb:~n"),
	io:format("4-dokup ryby:~n"),
	io:format("5-wypisz aktualne dane:~n"),
	io:format("6-zamknij:~n"),
	An=io:fread("Dzialanie: ", "~d"),
	A=element(2,An),
	%io:fwrite("~p~n",[A]),
	if 
		A==[1] -> normalstep(K,Y,P);
		A==[2] -> checkfood(K,Y,P);
		A==[3] -> catchfish(K,Y,P);
		A==[4] -> addfish(K,Y,P);
		A==[5] -> writedata(K,Y,P);
		A==[6] -> "Simulation has been stopped";
		%wymaga rozbudowy
		true -> mainloop(K,Y,P) 
	end.

%main to glowna funkcja, nalezy ja uruchamiac na starcie	
main()->
	io:format("~nSymulator hodowli karpii~n"),
	io:format("Jan Godlewski Joanna Partyka~n"),
	io:format("Program symuluje hodowle ryb. W zaleznosci od ilosci pozywienia~n"),
	io:format("i polowow suma ryb zmienia sie w czasie. Generowanie hodowli~n"),
	K=[rand:uniform(10) || _ <- lists:seq(1,20)],
	Y=0,
	P=2,
	io:format("~nRok numer: "),
	io:fwrite("~p~n",[Y]),
	io:format("Ilosc pozywienia: "),
	io:fwrite("~p~n",[P]),
	io:format("Wygenerowane karpie:~n"),
	io:fwrite("~w~n",[K]),
	Sum=lists:sum(K),
	io:format("Suma wszystkich karpi: "),
	io:fwrite("~w~n",[Sum]),
	Sum1=lists:sum(lists:sublist(K,2)),
	io:format("Suma karpi dzieci: "),
	io:fwrite("~w~n",[Sum1]),
	Sum2=lists:sum(lists:nthtail(2,K)),
	io:format("Suma karpi doroslych: "),
	io:fwrite("~w~n",[Sum2]),
	io:format("~n"),
	mainloop(K,Y,P).
	