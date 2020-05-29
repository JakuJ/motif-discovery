# Aproksymacyjne wykrywanie motywów w sieciach

Repozytorium stworzone na potrzeby projektu w ramach przedmiotu "Grafy i sieci: projekt"
prowadzonego w sem. letnim 2020 na Wydziale Matematyki i Nauk Informacyjnych PW.

Autorami projektu są:

* **[Łukasz Brzozowski](https://github.com/lukaszbrzozowski)**
* **[Jakub Janaszkiewicz](https://github.com/JakuJ)**
* **[Kacper Siemaszko](https://github.com/Siemashko)**

Projekt skupia się na badaniu możliwości poprawy algorytmu MODA przez zastąpienie jego pierwszego etapu
wersją algorytmu FASCIA z wczesnym stopowaniem opartym o testy statystyczne.

Dokumentacja wstępna opisująca badane zagadnienie znajduje się w pliku **[Dokumentacja.pdf](Dokumentacja.pdf)**.
Dokumentacja końcowa opisująca uzyskane wyniki i wnioski z badania znajduje się w pliku **[Raport.pdf](Raport.pdf)**.

Katalog `Wizualizacje` zawiera wszystkie pliki potrzebne do odtworzenia wizualizacji użytych w raporcie końcowym.

### Budowanie
Wymagane narzędzia:

* `CMake` w wersji >= 3.9
* Kompilator C++ wspierający OpenMP (np. standardowe dystrybucje `clang` lub `gcc`)

Aby zbudować programy wymagane do odtworzenia eksperymentów (implementacji algorytmu FASCIA
oraz generatora sieci podobnych) należy wykonać

```shell script
cmake .
```

wewnątrz głównego katalogu. Na systemach unixopodobnych wygeneruje to plik `Makefile`, dzięki któremu
poleceniem `make` można zbudować pliki wykonywalne. W przypadku systemu Windows programy można zbudować w środowisku WSL.

### Struktura repozytorium

Katalog `FASCIA` zawiera wersję algorytmu zmodyfikowaną tak, aby wypisywała wartość poszczególnych zliczeń na standardowe wyjście.
Oryginalne repozytorium znajduje się [tutaj](http://fascia-psu.sourceforge.net).
Instrukcje na temat używania programu znajdują się w pliku `FASCIA/index.html`.
Program `fascia` z flagą `-m` musi być wykonywany w tym samym katalogu co folder `motif`. 

Folder `sieci` zawiera sieci używane w eksperymentach. Pliki z rozszerzeniem `.graph` zawierają grafy w formacie
przeznaczonym do wykorzystania przez algorytm FASCIA, a `.txt` – algorytm MODA. To repozytorium nie zawiera
implementacji programu MODA. Można ją znaleźć [tutaj](https://github.com/smbadiwe/ParaMODA). Skrypt `moda2fascia.py`
pozwala na konwersję z formatu plików `.txt` do `.graph`.

Katalog `motif` zawiera zgrupowane względem liczby wierzchołków pliki z opisami drzew wykorzystywanych jako kandydaci na motywy
w badanych sieciach.

Folder `src` zawiera plik źródłowy programu generującego sieci podobne do zadanej.

### Odtworzenie wyników

Uruchomienie przygotowanych skryptów wymaga systemu unixopodobnego oraz następujących programów:

* programów `bin/fascia` oraz `bin/ensemble` zbudowanych w poprzednim kroku 
* powłoki `bash`
* programu pozwalającego na zmianę buforowania std. wyjścia – `stdbuf`
* interpretera Pythona, `python3`, z bibliotekami *pandas, numpy, scipy, matplotlib*
* opcjonalnie - środowiska `jupyter notebook` do odtworzenia wizualizacji przy użyciu notatnika [resultsCalc](Wizualizacje/resultsCalc.ipynb)

Po skompletowaniu wymaganych programów można przejść do odtworzenia eksperymentów wykonanych na potrzeby
projektu. Głównym skryptem przygotowanym z myślą o użytkowniku końcowym jest `filter.sh`. Skrypt zawiera dokumentację
na temat schematu użycia.

```shell script
>> ./filter.sh
Usage:  filter.sh <network file> <max. motif size> [<strat>] [<model>]
Arguments:
        motif size must range from 3 to 9
        strat:  "positive" or "nonnegative" - whether to return all templates that were
                not discarded or just the ones that were predicted to be a motif by FASCIA.
                Defaults to "nonnegative"
        model:  "meanRandom" or "expER" - a model for calculating max. number of iterations
                FASCIA tries before giving up.
                Defaults to "meanRandom"

        This script emits debug info to stderr. To get a list of probable motifs redirect
        output to a file like so: "./filter.sh path/to/file.graph 6 positive > motifs.txt"
```

Skrypt ten wykorzystuje inne skrypty i programy, łącząc je w potok przetwarzania będący kluczowym elementem
naszego podejścia do wykorzystania algorytmu FASCIA w ocenie potencjału danego drzewa na bycie motywem w
zadanej sieci.

Wszystkie zawarte w tym repozytorium skrypty i programy generują i korzystają z plików tymczasowych tworzonych w obrębie katalogu głównego.

### Pozostałe skrypty

Poniżej znajduje się opis działania skryptów pomocniczych, oraz pozostałych,
które zostały użyte do wygenerowania danych do opracowania końcowego.

* `run_motif.sh` - dla danej sieci, poddrzewa i innych parametrów generuje wykres rozkładów wystąpień poddrzewa w tej sieci
oraz w populacji sieci losowych (przy użyciu skryptu `wykres.py`). Parametry skryptu można ustawiać za pomocą zmiennych na jego początku.
* `niter.py` - oblicza maks. liczbę iteracji, którą może wykonać alg. FASCIA dla danej sieci. Korzysta z pliku tymczasowego
`losowe.csv` generowanego przy zliczaniu liczby wystąpień danego motywu w populacji sieci losowych.
* `script.py` - agreguje kolejne otrzymane na wejsciu zliczenia i wykonuje dla nich testy statystyczne. Jest ostatnim w kolejności
skryptem potoku prztwarzania, dzięki czemu kończąc działanie po wykryciu odpowiedniej istotności statystycznej
może zatrzymać działanie pozostałych programów.
* `srednia_losowych.sh`, `fascia_wszystkie.sh` - generują wyniki działania alg. FASCIA dla wszystkich sieci w folderze
`sieci` i wszystkich poddrzew do rozmiaru 6 włącznie, odpowiednio dla populacji gneerowanych sieci losowych i dla
samych sieci wejściowych.
* `srednia_losowych.py`, `srednia_fascii.py` - wersje skryptu `script.py` przygotowane na potrzeby powyższych
