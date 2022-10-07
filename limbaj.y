%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

int nr_identificatori=0,tip,nr_functii,nr_fct;
struct ident{
	char tip;
	//0 - global; 1 - in functie; 2 - in clasa; 3 - constanta; 4 - clasa
	int valoare[100],scop;
	int vect;
	char nume[50];
	
}indentificatori[100];


struct fun
{
 int nr_param, tip_param[20];
 char nume[50];
 char tip;
 
}functii[100];


struct f
{
  int valoare;
  char nume[50];
}fct[10];

%}

%union {
	char n[50];
	int numar;
};

%token BGIN END ASSIGN CONSTANT CONTROL CLASS STRING RET
%token <n> ID FCT
%token <numar> NR EVAL INT BOL FL CH STR
 
%type <numar> tip expresie

%start progr
%left '+'
%left '*'
%left '|'
%left '&'
%left '!'
%left '^'
%left '~'
%%
progr : declaratii bloc {printf("program corect sintactic\n");}
      ;

declaratii : declaratie ';'
	   | declaratii declaratie ';'
	   ;

declaratie : tip ID_list { }
           | tip ID '(' lista_param ')'
           {
           functii[nr_functii].tip=$1;
           strcpy(functii[nr_functii].nume,$2);
           if(verificaF($2,functii[nr_functii].nr_param,functii[nr_functii].tip_param)==0) yyerror("functie existenta");
           printf("%d %s %d %d %d\n", functii[nr_functii].tip,functii[nr_functii].nume,functii[nr_functii].nr_param,functii[nr_functii].tip_param[1],nr_functii);
           for(int i=0;i<functii[nr_functii].nr_param;i++)
           printf(" %d \n", functii[nr_functii].tip_param[i]);
           nr_functii++;
           }
           | tip ID '(' ')' { functii[nr_functii].tip=$1;
           strcpy(functii[nr_functii].nume,$2);
           if(verificaF($2,functii[nr_functii].nr_param,functii[nr_functii].tip_param)==0) yyerror("functie existenta");
           printf("%d %s %d %d %d\n", functii[nr_functii].tip,functii[nr_functii].nume,functii[nr_functii].nr_param,functii[nr_functii].tip_param[1],nr_functii);
           for(int i=0;i<functii[nr_functii].nr_param;i++)
           printf(" %d \n", functii[nr_functii].tip_param[i]);
           nr_functii++;
           }
	   | tip ID '(' lista_param ')' '{' declar_var list '}' 
           { functii[nr_functii].tip=$1;
           strcpy(functii[nr_functii].nume,$2);
           if(verificaF($2,functii[nr_functii].nr_param,functii[nr_functii].tip_param)==0) yyerror("functie existenta");
           printf("%d %s %d %d %d\n", functii[nr_functii].tip,functii[nr_functii].nume,functii[nr_functii].nr_param,functii[nr_functii].tip_param[1],nr_functii);
           for(int i=0;i<functii[nr_functii].nr_param;i++)
           printf(" %d \n", functii[nr_functii].tip_param[i]);
           nr_functii++;
           }
	   | tip ID '(' ')' '{' declar_var list '}' { functii[nr_functii].tip=$1;
           strcpy(functii[nr_functii].nume,$2);
           if(verificaF($2,functii[nr_functii].nr_param,functii[nr_functii].tip_param)==0) yyerror("functie existenta");
           printf("%d %s %d %d %d\n", functii[nr_functii].tip,functii[nr_functii].nume,functii[nr_functii].nr_param,functii[nr_functii].tip_param[1],nr_functii);
           for(int i=0;i<functii[nr_functii].nr_param;i++)
           printf(" %d \n", functii[nr_functii].tip_param[i]);
           nr_functii++;
           }
	   | CONSTANT ID NR { if(verifica($2)==1)
        {indentificatori[nr_identificatori].tip =1; 
	strcpy(indentificatori[nr_identificatori].nume,$2);
	indentificatori[nr_identificatori].valoare[1]=$3;
	indentificatori[nr_identificatori].scop=3;
	printf("%d %d %s %d\n",indentificatori[nr_identificatori].tip,nr_identificatori,indentificatori[nr_identificatori].nume,indentificatori[nr_identificatori].valoare[1]);
	nr_identificatori++; }
        else yyerror("ambiguitate in declaratie"); }
	   | CONSTANT ID STRING { if(verifica($2)==1)
        {
        indentificatori[nr_identificatori].tip =3;  
	strcpy(indentificatori[nr_identificatori].nume,$2);
	indentificatori[nr_identificatori].valoare[1]=0; 
	indentificatori[nr_identificatori].scop=3;
	printf("%d %d %s %d\n",indentificatori[nr_identificatori].tip,nr_identificatori,indentificatori[nr_identificatori].nume,indentificatori[nr_identificatori].valoare[1]);
	nr_identificatori++;}
        else yyerror("ambiguitate in declaratie"); 
	}
           | CLASS ID '{' declar_list '}'
           | ID ID
           | FCT '(' ')' '{' RET expresie ';' '}' 
           {fct[nr_fct].valoare=$6;
            strcpy(fct[nr_fct].nume,$1);
            printf("%s %d\n",$1,fct[nr_fct].valoare);
            nr_fct++;
           }
           ;

declar_list : declar ';'
            | declar_list declar ';' 
            ;

declar : tip ID_list 
       | tip ID '(' lista_param ')' '{' declar_var list '}'
       | tip ID '(' ')' '{' declar_var list '}'
       ;

    
declar_var : tip ID_list ';'
	   | declar_var tip ID_list ';'
	   ;

ID_list : ID ',' ID_list { if(verifica($1)==1)
        {indentificatori[nr_identificatori].tip = tip; 
	strcpy(indentificatori[nr_identificatori].nume,$1);
	indentificatori[nr_identificatori].valoare[1]=0;
	printf("%d %d %s %d\n",indentificatori[nr_identificatori].tip,nr_identificatori,indentificatori[nr_identificatori].nume,indentificatori[nr_identificatori].valoare[1]);
	nr_identificatori++;}
        else yyerror("ambiguitate in declaratie"); 
         	 
	}
	| ID ASSIGN NR ',' ID_list { if(verifica($1)==1)
        {indentificatori[nr_identificatori].tip = tip; 
	strcpy(indentificatori[nr_identificatori].nume,$1);
	indentificatori[nr_identificatori].valoare[1]=$3;
	printf("%d %d %s %d\n",indentificatori[nr_identificatori].tip,nr_identificatori,indentificatori[nr_identificatori].nume,indentificatori[nr_identificatori].valoare[1]);
	nr_identificatori++; }
        else yyerror("ambiguitate in declaratie"); 	 
	}
        | ID ASSIGN NR { if(verifica($1)==1)
        {indentificatori[nr_identificatori].tip = tip; 
	strcpy(indentificatori[nr_identificatori].nume,$1);
	indentificatori[nr_identificatori].valoare[1]=$3;
	printf("%d %d %s %d\n",indentificatori[nr_identificatori].tip,nr_identificatori,indentificatori[nr_identificatori].nume,indentificatori[nr_identificatori].valoare[1]);
	nr_identificatori++; }
        else yyerror("ambiguitate in declaratie"); 	 
	}
	| ID { if(verifica($1)==1)
        {indentificatori[nr_identificatori].tip = tip; 
	strcpy(indentificatori[nr_identificatori].nume, $1);
	indentificatori[nr_identificatori].valoare[1]=0;
	printf("%d %d %s %d\n",indentificatori[nr_identificatori].tip,nr_identificatori,indentificatori[nr_identificatori].nume,indentificatori[nr_identificatori].valoare[1]);
	nr_identificatori++; }
        else yyerror("ambiguitate in declaratie"); } 
	| ID ASSIGN STRING ',' ID_list
	| ID ASSIGN STRING
	| ID vector ',' ID_list {if(verifica($1)==1)
        { indentificatori[nr_identificatori].tip = tip ;
        indentificatori[nr_identificatori].vect=1; 
	strcpy(indentificatori[nr_identificatori].nume, $1);
	indentificatori[nr_identificatori].valoare[1]=0;
	printf("%d %d %s %d\n",indentificatori[nr_identificatori].tip,nr_identificatori,indentificatori[nr_identificatori].nume,indentificatori[nr_identificatori].valoare[1]);
	nr_identificatori++;}
        else yyerror("ambiguitate in declaratie"); }  
	| ID vector {if(verifica($1)==1)
        { indentificatori[nr_identificatori].tip = tip ; 
        indentificatori[nr_identificatori].vect=1;
	strcpy(indentificatori[nr_identificatori].nume, $1);
	indentificatori[nr_identificatori].valoare[1]=0;
	printf("%d %d %s %d\n",indentificatori[nr_identificatori].tip,nr_identificatori,indentificatori[nr_identificatori].nume,indentificatori[nr_identificatori].valoare[1]);
	nr_identificatori++;}
        else yyerror("ambiguitate in declaratie"); } 
	;

e : e '+' e
  | e '*' e
  | '(' e ')'
  | NR {tip=1;}
  | ID
   { int index=Verifica($1);     
     if(index==-1) yyerror("variabila nedeclarata");
     else 
        tip=indentificatori[index].tip; 
   }
  | ID '(' lista_apel ')' 
   { /*int index;     
     if(index==-1) yyerror("variabila nedeclarata");
     else 
        tip=functii[index].tip;*/ 
   }
  | ID vector
  | ID '.' ID
  | ID vector '.' ID
  ;
  
expresie : expresie '+' expresie {$$=$1 + $3;}
	 | expresie '*' expresie {$$=$1 * $3;}
	 | '(' expresie ')' {$$=$2;}
	 | NR {$$=$1;}
	 | ID {$$=valID($1);}
         | FCT '(' ')' 
           {
             int ok=1;
             for(int i=0;i<nr_fct;i++)
              if(strcmp(fct[i].nume,$1)==0)
                 {$$=fct[i].valoare; ok=0;}
             if(ok==1) yyerror("functie definita de utilizator nedeclarata");
           }
	 ;

E : STRING
  | E '~' E
  | E '^' e
  | '(' E ')'
  ;

logic : e '>' e
      | e '<' e
      | e '=' '=' e
      | logic '|' '|' logic
      | logic '&' '&' logic
      | '(' logic ')'
      | '!' logic
      ;

lista_param : param { functii[nr_functii].tip_param[functii[nr_functii].nr_param]=tip;  functii[nr_functii].nr_param++;}
            | lista_param ',' param { functii[nr_functii].tip_param[functii[nr_functii].nr_param]=tip; functii[nr_functii].nr_param++;}
            ;
            
param : tip ID
      { indentificatori[nr_identificatori].tip = tip ; 
        indentificatori[nr_identificatori].vect=0;
	strcpy(indentificatori[nr_identificatori].nume, $2);
	indentificatori[nr_identificatori].valoare[1]=0;
        indentificatori[nr_identificatori].scop=1;
	printf("%d %d %s %d %d\n",indentificatori[nr_identificatori].tip,nr_identificatori,indentificatori[nr_identificatori].nume,indentificatori[nr_identificatori].valoare[1],indentificatori[nr_identificatori].scop);
	nr_identificatori++;}
      ; 
      
vector : '[' e ']' vector
       | '[' e ']' 
       ;

tip : INT {$$=1; tip =1; }
    | FL {$$=2; tip =2; }
    | CH {$$=3; tip =3; }
    | BOL {$$=4; tip =4; }
    | STR {$$=5; tip=5; }
    ;

/* bloc */
bloc : BGIN list END  
     ;
     
/* lista instructiuni */
list : statement ';' 
     | list statement ';'
     | CONTROL logic statement ';'
     | list CONTROL logic statement ';'
     | CONTROL logic '{' list '}'
     | list CONTROL logic '{' list '}'
     ;

/* instructiune */
statement : ID ASSIGN e { if(verifica($1)==1) yyerror("variabila nedeclarata"); 
                          for(int i=0;i<nr_identificatori; i++)
                           if(strcmp($1,indentificatori[i].nume)==0) 
                             {if(tip==indentificatori[i].tip)
                              break;
                              else yyerror("nu corespunde tipul");
                             }
                         }
          | ID '(' lista_apel ')'
	  | ID vector ASSIGN e { if(verifica($1)==1) yyerror("variabila nedeclarata");}
	  | ID ASSIGN E { if(verifica($1)==1) yyerror("variabila nedeclarata");}
          | ID '.' ID ASSIGN e
          | ID vector '.' ID ASSIGN e
          | EVAL expresie {printf("%s %d\n","EVAL",$2);}
          ;
        
lista_apel : e
           | e ',' lista_apel
           |
           ;
%%

int verifica(char *s)
{

  int i;
  for(i=0;i<=nr_identificatori;i++)
   if(strcmp(indentificatori[i].nume,s)==0) return 0;
  return 1;
}

int Verifica(char *s)
{

  int i;
  for(i=0;i<=nr_identificatori;i++)
   if(strcmp(indentificatori[i].nume,s)==0) return i;
  return -1;
}

int verificaF(char *s, int nr_param, int tip_param[])
{
  int i,nr;
  if(nr_functii==0) return 1;
  for(i=0;i<nr_functii;i++)
  {
     if(strcmp(s,functii[i].nume)==0)
     {
        if(nr_param==functii[i].nr_param)
        {
          int j;
          nr=0;
          for(j=0;j<nr_param;j++)
           if(tip_param[j]!=functii[i].tip_param[j]) nr++;
          if(nr==0) return 0;
        }
     }
  }
  return 1;

}


int VerificaF(char *s, int nr_param, int tip_param[])
{
  int i,nr;
  if(nr_functii==0) return 1;
  for(i=0;i<nr_functii;i++)
  {
     if(strcmp(s,functii[i].nume)==0)
     {
        if(nr_param==functii[i].nr_param)
        {
          int j;
          nr=0;
          for(j=0;j<nr_param;j++)
           if(tip_param[j]!=functii[i].tip_param[j]) nr++;
          if(nr==0) return i;
        }
     }
  }
  return 1;
}



int existfun(char *s,char t,int nr_param, int tip_param[])
{

   int i,nr;
   for(i=0;i<nr_functii;i++)
   {
    if(strcmp(s,functii[i].nume)==0)
        {  if(functii[i].tip==t)
            { if(nr_param==functii[i].nr_param)
                {
                int j;
                 nr=0;
                for(j=0;j<nr_param;j++)
                if(tip_param[j]!=functii[i].tip_param[j]) nr++;
                if(nr!=0) return 0;
             } 
          }  
        }
   }
   return 1;
}


int existvar(char *s, char tip)
{
   int i;
   for(i=0;i<nr_identificatori;i++)
   { 
      if(strcmp(indentificatori[i].nume,s)==0)
       {  if(tip==indentificatori[i].tip) return 1;
       }
   }
  return 0;  
}

int valID(char *s)
{
  for(int i=0;i<nr_identificatori;i++)
    if(strcmp(s,indentificatori[i].nume)==0 && indentificatori[i].tip==1) return indentificatori[i].valoare[1];
  yyerror("valoarea nu este de tip int");
}

void yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
exit(0);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 

