%{
 #include <ctype.h>
 int letterCounter = 0;
%}

smallLetters [a-z]
bigLetters [A-Z]

%%
{smallLetters} { printf("%c", toupper(yytext[0])); letterCounter++; }
{bigLetters} { printf("%c", tolower(yytext[0])); letterCounter++; }
%%
int yywrap()
{
    printf("Ciąg wejściowy zawierał %d liter", letterCounter);
    return 1;   
}
    /*
    
    Other examples

    [a-z]+ printf(yytext);
    [A-Z]+ ECHO;
    . {}; 
    [AaEeUu]la printf("Ola");
    
    */