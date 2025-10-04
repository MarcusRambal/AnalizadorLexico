%{
#include <stdio.h>
#include <string.h>

#define MAX_IDS 400
#define MAX_ERRORS 100

char *ids[MAX_IDS];   
int id_count = 0;

// Error tracking
typedef struct {
    int line;
    int column;
    char *text;
} Error;

Error errors[MAX_ERRORS];
int error_count = 0;
int current_line = 1;
int current_column = 1;

void add_error(const char *text) {
    if (error_count < MAX_ERRORS) {
        errors[error_count].line = current_line;
        errors[error_count].column = current_column;
        errors[error_count].text = strdup(text);
        error_count++;
    }
}

int get_id_number(const char *name) {
    for (int i = 0; i < id_count; i++) {
        if (strcmp(ids[i], name) == 0) {
            return i + 1; 
        }
    }
    if (id_count < MAX_IDS) {
        ids[id_count] = strdup(name); 
        id_count++;
        return id_count;
    } else {
        fprintf(stderr, "Error: demasiados identificadores\n");
        return -1;
    }
}
%}

%x AFTER_NUM

DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          [a-zA-Z_][a-zA-Z0-9_]*
ENTERO      [0-9]+
LONGINTEGER {ENTERO}([lL])
DECIMAL_NUM {ENTERO}"."{DIGITO}*([eE][+-]?{DIGITO}+)?|{ENTERO}([eE][+-]?{DIGITO}+)
DECIMAL_PUNTO "."{DIGITO}+([eE][+-]?{DIGITO}+)?
IMAGINARIO  ({ENTERO}|{DECIMAL_NUM}|{DECIMAL_PUNTO})[jJ]
STRING      \"([^\"\n])*\"|\'([^'\n])*\'
INVALID_ID  {DIGITO}+{ID}
INVALID_DECIMAL {ENTERO}"."{DIGITO}+([eE][+-]?{DIGITO}+)?{LETRA}+|{ENTERO}([eE][+-]?{DIGITO}+){LETRA}+

%%

<INITIAL,AFTER_NUM>True        { fprintf(yyout, "TRUE "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>False       { fprintf(yyout, "FALSE "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>range       { fprintf(yyout, "RANGE "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>and         { fprintf(yyout, "AND "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>else        { fprintf(yyout, "ELSE "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>is          { fprintf(yyout, "IS "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>return      { fprintf(yyout, "RETURN "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>break       { fprintf(yyout, "BREAK "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>for         { fprintf(yyout, "FOR "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>not         { fprintf(yyout, "NOT "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>while       { fprintf(yyout, "WHILE "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>continue    { fprintf(yyout, "CONTINUE "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>if          { fprintf(yyout, "IF "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>or          { fprintf(yyout, "OR "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>def         { fprintf(yyout, "DEF "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>import      { fprintf(yyout, "IMPORT "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>pass        { fprintf(yyout, "PASS "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>elif        { fprintf(yyout, "ELIF "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>in          { fprintf(yyout, "IN "); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>print       { fprintf(yyout, "PRINT "); current_column += yyleng; BEGIN(INITIAL); }

<INITIAL,AFTER_NUM>"**"    { fprintf(yyout, "pot=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"//"    { fprintf(yyout, "divent=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"<<"    { fprintf(yyout, "shiftizq=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>">>"    { fprintf(yyout, "shiftder=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"<="    { fprintf(yyout, "menorig=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>">="    { fprintf(yyout, "mayorig=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"=="    { fprintf(yyout, "comp=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"!="    { fprintf(yyout, "dif=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"<>"    { fprintf(yyout, "dif=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"+"     { fprintf(yyout, "suma=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"-"     { fprintf(yyout, "menos=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"*"     { fprintf(yyout, "mult=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"/"     { fprintf(yyout, "div=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"%"     { fprintf(yyout, "mod=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"<"     { fprintf(yyout, "menor=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>">"     { fprintf(yyout, "mayor=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"&"     { fprintf(yyout, "bitand=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"|"     { fprintf(yyout, "bitor=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"^"     { fprintf(yyout, "xor=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"~"     { fprintf(yyout, "bitnot=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }

<INITIAL,AFTER_NUM>"("     { fprintf(yyout, "parabre=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>")"     { fprintf(yyout, "parcier=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"["     { fprintf(yyout, "corabre=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"]"     { fprintf(yyout, "corcier=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"="     { fprintf(yyout, "asig=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>";"     { fprintf(yyout, "puntocoma=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>","     { fprintf(yyout, "coma=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>":"     { fprintf(yyout, "dospunt=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<AFTER_NUM>"."     { fprintf(yyout, "punto=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL>"."     { fprintf(yyout, "punto=%s ", yytext); current_column += yyleng; }

<INITIAL,AFTER_NUM>">>="   { fprintf(yyout, "asig_shiftder=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"<<="   { fprintf(yyout, "asig_shiftizq=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"+="    { fprintf(yyout, "asig_suma=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"-="    { fprintf(yyout, "asig_resta=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"*="    { fprintf(yyout, "asig_mult=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"/="    { fprintf(yyout, "asig_div=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"//="   { fprintf(yyout, "asig_divent=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"&="    { fprintf(yyout, "asig_and=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"|="    { fprintf(yyout, "asig_or=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"^="    { fprintf(yyout, "asig_xor=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"**="   { fprintf(yyout, "asig_pot=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }
<INITIAL,AFTER_NUM>"%="    { fprintf(yyout, "asig_mod=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }

<INITIAL,AFTER_NUM>\#[^\n]*    { current_column += yyleng; }
<INITIAL,AFTER_NUM>\n    { fprintf(yyout, "\n"); current_line++; current_column = 1; BEGIN(INITIAL); }
<INITIAL>[ \t]+    { fprintf(yyout, "%s", yytext); current_column += yyleng; }
<AFTER_NUM>[ \t]+    { fprintf(yyout, "%s", yytext); current_column += yyleng; /* Permanece en AFTER_NUM */ }

<INITIAL,AFTER_NUM>{INVALID_DECIMAL} {
    fprintf(yyout, "error=%s ", yytext);
    add_error(yytext);
    current_column += yyleng;
    BEGIN(AFTER_NUM);
}

<INITIAL,AFTER_NUM>{IMAGINARIO} { fprintf(yyout, "imaginario=%s ", yytext); current_column += yyleng; BEGIN(AFTER_NUM); }
<INITIAL,AFTER_NUM>{LONGINTEGER} { fprintf(yyout, "long=%s ", yytext); current_column += yyleng; BEGIN(AFTER_NUM); }
<INITIAL,AFTER_NUM>{DECIMAL_NUM}   { fprintf(yyout, "real=%s ", yytext); current_column += yyleng; BEGIN(AFTER_NUM); }
<INITIAL,AFTER_NUM>{ENTERO}    { fprintf(yyout, "entero=%s ", yytext); current_column += yyleng; BEGIN(AFTER_NUM); }
<INITIAL>{DECIMAL_PUNTO}   { fprintf(yyout, "real=%s ", yytext); current_column += yyleng; BEGIN(AFTER_NUM); }

<AFTER_NUM>{ID} {
    fprintf(yyout, "error=%s", yytext);
    add_error(yytext);
    current_column += yyleng;
    BEGIN(INITIAL);
}

<INITIAL,AFTER_NUM>{INVALID_ID} {
    fprintf(yyout, "error=%s ", yytext);
    add_error(yytext);
    current_column += yyleng;
    BEGIN(AFTER_NUM);
}

<INITIAL>{ID} {
    int num = get_id_number(yytext);
    if (num > 0) {
        fprintf(yyout, "id%d=%s ", num, yytext);
    }
    current_column += yyleng;
    BEGIN(INITIAL);
}

<INITIAL,AFTER_NUM>{STRING}    { fprintf(yyout, "cadena=%s ", yytext); current_column += yyleng; BEGIN(INITIAL); }

<INITIAL,AFTER_NUM>.   { 
    fprintf(yyout, "error=%s ", yytext);
    add_error(yytext);
    current_column += yyleng;
    BEGIN(INITIAL);
}

%%

int main(int argc, char **argv) {
    FILE *archivo = NULL;
    FILE *salida  = NULL;

    if (argc != 2) {
        fprintf(stderr, "Uso: %s <archivo_entrada>\n", argv[0]);
        return 1;
    }

    archivo = fopen(argv[1], "rb");
    if (!archivo) {
        perror("No se pudo abrir el archivo de entrada");
        return 1;
    }

    salida = fopen("salida.txt", "w");
    if (!salida) {
        perror("No se pudo crear el archivo de salida");
        fclose(archivo);
        return 1;
    }

    yyin  = archivo;
    yyout = salida;

    yylex();       
    fclose(archivo); 

    fprintf(salida, "\n\n");
    
    for (int i = 0; i < id_count; i++) {
        fprintf(salida, "Id%-2d = %s\n", i+1, ids[i]);
    }

    if (error_count > 0) {
        fprintf(salida, "\n%d error(es) léxico(s) encontrado(s):\n", error_count);
        for (int i = 0; i < error_count; i++) {
            fprintf(salida, "Error en línea %d, columna %d: '%s'\n", 
                   errors[i].line, errors[i].column, errors[i].text);
        }
    } else {
        fprintf(salida, "\nNo se encontraron errores léxicos.\n");
    }

    fclose(salida);
    printf("Análisis completado. Resultados guardados en salida.txt\n");
    
    return 0;
}


