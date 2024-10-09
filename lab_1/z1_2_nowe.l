%{
#include <stdio.h>

int keyWordsCount = 0;
int identifiersCount = 0;
int numbersCount = 0;
int floatsCount = 0;
int stringsCount = 0;
int charsCount = 0;
int operatorsCount = 0;
int totalChars = 0;
int totalWords = 0;
int whiteChars = 0;
int totalLines = 0;
int commentsCount = 0;

void print_counts() {
    printf("Liczba słów kluczowych: %d\n", keyWordsCount);
    printf("Liczba identyfikatorów: %d\n", identifiersCount);
    printf("Liczba liczb całkowitych: %d\n", numbersCount);
    printf("Liczba liczb rzeczywistych: %d\n", floatsCount);
    printf("Liczba napisów: %d\n", stringsCount);
    printf("Liczba stałych znakowych: %d\n", charsCount);
    printf("Liczba operatorów: %d\n", operatorsCount);
    printf("Całkowita liczba znaków: %d\n", totalChars);
    printf("Całkowita liczba słów: %d\n", totalWords);
    printf("Całkowita liczba wierszy: %d\n", totalLines);
}
%}

KEY_WORDS (int|char|void|for|if|else|while|return|break|continue)
IDENTIFIERS [a-zA-Z_][a-zA-Z0-9_]*
NUMBERS [0-9]+
FLOATS (\.[0-9]+|[0-9]+\.[0-9]*)
STRINGS \"([^\\\"\n]|\\.)*\"
CHARS \'[^\']\'
OPERATORS (\+\+|--|[+\-*/=<>&|!]=?|==|!=?|<=?|>=?|=)
WHITE_CHARS [ \t]+
NEWLINE \n
COMMENTS (\/\/.*)

%%

{KEY_WORDS} {
    keyWordsCount++;
    totalWords++;
}

{IDENTIFIERS} {
    identifiersCount++;
    totalWords++;
}

{NUMBERS} {
    numbersCount++;
}

{FLOATS} {
    floatsCount++;
}

{STRINGS} {
    stringsCount++;
}

{CHARS} {
    charsCount++;
}

{OPERATORS} {
    operatorsCount++;
}

{WHITE_CHARS} {
    whiteChars += yyleng; 
}

{NEWLINE} {
    totalLines++;
}

{COMMENTS} {
    commentsCount++;
}

. {
    totalChars++; 
}

%%

int main(int argc, char **argv) {
    yylex(); 
    print_counts(); 
    return 0;
}

int yywrap() {
    return 1; // End of input
}