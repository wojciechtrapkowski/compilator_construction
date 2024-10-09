%{
#include <stdio.h>
#include <stdlib.h>

int sum = 0;
int first = 1; // To track whether the first number has been printed
%}

%option noyywrap

DIGIT   [0-9]+
NON_DIGIT [^0-9\n\r\t]+

%%

{DIGIT} {
    int num = atoi(yytext);  // Convert matched number to integer
    sum += num;  // Add to sum

    printf("%s", yytext);  // Print the number
    first = 0;  // Indicate that we've printed the first number
}

{NON_DIGIT} {
    if (!first) {
        printf("+"); // Replace non-digit characters between numbers with '+'
    }
}

[\n\r\t]+ {
    if (!first) {
        printf("=%d\n", sum);  // Print the sum of the current line
    } else {
        printf("\n");  // If there were no numbers, just print a newline
    }
    // Reset for the next line
    sum = 0;  
    first = 1; 
}

.  { /* Ignore any other characters */ }

%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}