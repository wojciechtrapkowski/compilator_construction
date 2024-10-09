%{
    #include <stdlib.h>
    #include <stdio.h>

    int sum = 0;
    int wasLetterDetected = 0;
%}
DIGIT [0-9]
NON_DIGIT [^0-9\n\r]
END_OF_LINE [\n\r]

%%
{NON_DIGIT}+ { 
    if(wasLetterDetected) { 
        printf("+"); 
    }; 
}

{DIGIT}+ { 
    wasLetterDetected = 1; 
    sum += atoi(yytext); 
    printf("%s", yytext); 
}

{END_OF_LINE}+ { 
    if (wasLetterDetected) {
        printf("=%d\n", sum); sum = 0; wasLetterDetected = 0;
    } else {
        printf("\n");
    }
}

%%
int main(int argc, char **argv)
{
    yylex();
    return 1;   
}