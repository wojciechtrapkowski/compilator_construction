%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int keyword_count = 0;
int identifier_count = 0;
int int_count = 0;
int float_count = 0;
int string_count = 0;
int char_count = 0;
int operator_count = 0;
int total_chars = 0;
int total_words = 0;
int total_lines = 0;

void count_total_chars(int count) {
    total_chars += count;
}

void count_total_words() {
    total_words++;
}

void print_counts() {
    printf("Liczba słów kluczowych: %d\n", keyword_count);
    printf("Liczba identyfikatorów: %d\n", identifier_count);
    printf("Liczba liczb całkowitych: %d\n", int_count);
    printf("Liczba liczb rzeczywistych: %d\n", float_count);
    printf("Liczba napisów: %d\n", string_count);
    printf("Liczba stałych znakowych: %d\n", char_count);
    printf("Liczba operatorów: %d\n", operator_count);
    printf("Całkowita liczba znaków: %d\n", total_chars);
    printf("Całkowita liczba słów: %d\n", total_words);
    printf("Całkowita liczba wierszy: %d\n", total_lines);
}
%}

%option noyywrap

%%

int     { keyword_count++; }
char    { keyword_count++; }
void    { keyword_count++; }
for     { keyword_count++; }
if      { keyword_count++; }
else    { keyword_count++; }
while   { keyword_count++; }
return  { keyword_count++; }
break   { keyword_count++; }
continue { keyword_count++; }


[a-zA-Z_][a-zA-Z0-9_]* {
    identifier_count++;
}

[0-9]+ {
    int_count++;
}

[0-9]*\.[0-9]+ {
    float_count++;
}

\"([^\\\"]|\\.)*\" {
    string_count++;
}

\'[^\']\' {
    char_count++;
}

[+\-*/%&|^!=<>]=?|\+\+|-- {
    operator_count++;
}

[ \t]+ {
    /* Ignorowanie białych znaków */
}
\n {
    total_lines++;
}

. {
    count_total_chars(1);
}

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Nie można otworzyć pliku");
            return EXIT_FAILURE;
        }
        yyin = file;
    }

    yylex();
    print_counts();
    return 0;
}