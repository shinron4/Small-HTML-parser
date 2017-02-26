%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <fcntl.h>
    #include <sys/stat.h>
    #include <sys/types.h>
    #define MAX 1000
    int yylex(void);
    void yyerror(const char *);
    char list[MAX], name[100], kdlist[20][4][100];
    FILE *designation, *responsibility, *email, *phone, *website, *awards, *ms, *phd, *pub, *proj;
    void yyerror(const char *);

%}

%union{
	int ival;
	char *str;
}

%token <str>DIVON <str>DIVO <str>DIVC <str>HO <str>HC <str>PO <str>PC <str>SO <str>SC <str>string  <str>DIVOC <str>ULO <str>ULC <str>LIO <str>LIC <str>IOE <str>IOP <str>IOC <str>AO <str>AC <str>IOW <str>DIVOR <str>DIVOFTS <str>DIVOGM <str>DIVOPUB <str>DIVOPROJ <ival>COMMENTO <ival>COMMENTC <ival> LINK

%type <ival> LS 
%type <ival> STDLI
%type <ival> PUBLI
%type <ival> PROJLI

%start T

%%

DN : DIVON HO string HC PO T SO string SC SO string SC PC DIVC {fprintf(designation, "%s;%s\n", $3, $8);strcpy(name,$3);}
    ;

LS : LS LIO string T LIC                  {
                                            char *ptr = strstr($3, "&amp;");
                                            if(ptr){
                                                while(ptr[5] != '\0'){
                                                    ptr[0] = ptr[5];
                                                    ptr++;
                                                }
                                                ptr[0] = '\0';
                                            }
                                            strcpy(&list[$1], $3);
                                            $$ = $1 + strlen($3);
                                            list[$$++] = '|';
                                            list[$$] = '\0';
                                         }
    | LS LIO LIC                         {
                                            $$ = $1;
                                         }
    ;
LS : {$$ = 0;}

EMAIL : LIO IOE string LIC {char *ptr = strstr($3, ";");fprintf(email, "%s;%s\n",name, ptr + 1);}
    ;
EMAIL :;

PHONE : LIO IOP string LIC {char *ptr = strstr($3, ";");fprintf(phone, "%s;%s\n",name, ptr + 1);}
    ;
PHONE :;
    
R1 : DIVO ULO LS ULC DIVC                 {
                                            int i = 0;
                                            fprintf(responsibility, "%s;", name);
                                            while(i < $3) fprintf(responsibility, "%c", list[i++]);
                                            fprintf(responsibility, "\n");

                                         } 
    | DIVOC ULO EMAIL PHONE ULC DIVC 
    ; 

R2 : DIVO DIVO ULO LS ULC DIVC DIVC      {
                                            int i = 0;
                                            fprintf(awards, "%s;", name);
                                            while(i < $4) fprintf(awards, "%c", list[i++]);
                                            fprintf(awards, "\n");

                                         } 
    ;
R2 :;


RESCON : DIVOR DIVO DIVO DIVO DIVO T DIVC DIVO R1 DIVC DIVC DIVC C DIVC DIVC
    ;

RESCON : DIVOR DIVO DIVO C DIVO T R2 DIVC DIVC C DIVC DIVC
    ;

RESCON : ;

WEB : HO IOW AO string AC AO string AC HC { 
                                            char *ptr = strstr($6, "href") + 6;
                                            int i = 0;
                                            char temp[100];
                                            while(*ptr != '\"' && *ptr != ';'){
                                                temp[i++] = *ptr;
                                                ptr++;
                                            }
                                            temp[i] = '\0';
                                            fprintf(website, "%s;%s\n",name, temp);
                                         }
    ;

WEB : HO IOW AO string AC HC    {
                                    char *ptr;
                                    int i = 0;
                                    char temp[100];
                                    if(strstr($4, "Bio Sketch") == 0){
                                        ptr = strstr($3, "href") + 6;
                                        while(*ptr != '\"' && *ptr != ';'){
                                            temp[i++] = *ptr;
                                            ptr++;
                                        }
                                        temp[i] = '\0';
                                        fprintf(website, "%s;%s\n",name, temp);
                                    }
                                }
    ;

WEB :;

FTS : DIVOFTS RESCON RESCON WEB RESCON DIVC
    ;

STD : HO string string HC STDLI {
                                    if(strstr($2, "Ph.D.")){
                                        int i;
                                        for(i = 0; i < $5; i++)
                                            fprintf(phd, "%s;%s;%s\n", name, kdlist[i][0], kdlist[i][1]);
                                    }
                                    else if(strstr($2, "MS")){
                                        int i;
                                        for(i = 0; i < $5; i++)
                                            fprintf(ms, "%s;%s;%s\n", name, kdlist[i][0], kdlist[i][1]);                                    
                                    }
                                }
   ;

STD :;

STDLI : STDLI PO SO SC string string string PC {
                                                 if ($1 < 19){
                                                    char *ptr = strstr($5, ";");
                                                    if(ptr){
                                                        while(ptr[5] != '\0'){
                                                            ptr[0] = ptr[5];
                                                            ptr++;
                                                        }
                                                        ptr[0] = '\0';
                                                    }
                                                    ptr = strstr($7, ";");
                                                    if(ptr){
                                                        while(ptr[5] != '\0'){
                                                            ptr[0] = ptr[5];
                                                            ptr++;
                                                        }
                                                        ptr[0] = '\0';
                                                    }
                                                    strcpy(kdlist[$1][0], $5);
                                                    strcpy(kdlist[$1][1], $7);
                                                    $$ = $1 + 1;
                                                 }
                                               }
    ;

STDLI : {
            $$ = 0;   
        }
    ;

GM : DIVOGM STD STD DIVC
   ;

PUBLI : PUBLI PO SO SC string string string T string PC {
                                                            char *ptr = strstr($5, "&amp;");
                                                            while(ptr){
                                                                while(ptr[5] != '\0'){
                                                                ptr[0] = ptr[5];
                                                                ptr++;
                                                                }
                                                                ptr[0] = '\0';
                                                                ptr = strstr($5, "&amp;");
                                                            }
                                                            ptr = $7;
                                                            while(*ptr){
                                                                if(*ptr == ';')
                                                                    *ptr = ',';
                                                                ptr++;
                                                            }
                                                            if ($1 < 19){
                                                                strcpy(kdlist[$1][0], $5);
                                                                strcpy(kdlist[$1][1], $7);
                                                                strcpy(kdlist[$1][2], $9);
                                                                $$ = $1 + 1;
                                                            }
                                                        }
     ;

PUBLI : {
            $$ = 0;
        }
      ;

PUB : DIVOPUB PUBLI DIVC { 
                            int i;
                            for(i = 0; i < $2; i++)
                                fprintf(pub, "%s;%s;%s;%s\n", name, kdlist[i][0], kdlist[i][1], kdlist[i][2]);
                         }
    ;

PROJLI : PROJLI PO SO SC string T  string PC   {
                                                char *ptr = strstr($5, "&amp;");
                                                while(ptr){
                                                    while(ptr[5] != '\0'){
                                                        ptr[0] = ptr[5];
                                                        ptr++;
                                                    }
                                                    ptr[0] = '\0';
                                                    ptr = strstr($5, "&amp;");
                                                }
                                                ptr = strstr($7, "&amp;");
                                                while(ptr){
                                                    while(ptr[5] != '\0'){
                                                        ptr[0] = ptr[5];
                                                        ptr++;
                                                    }
                                                    ptr[0] = '\0';
                                                    ptr = strstr($7, "&amp;");
                                                }
                                                ptr = strstr($5, "&nbsp;");
                                                while(ptr){
                                                    while(ptr[6] != '\0'){
                                                        ptr[0] = ptr[6];
                                                        ptr++;
                                                    }
                                                    ptr[0] = '\0';
                                                    ptr = strstr($5, "&nbsp;");
                                                }
                                                if ($1 < 19){
                                                    strcpy(kdlist[$1][0], $5);
                                                    strcpy(kdlist[$1][1], $7);
                                                    $$ = $1 + 1;
                                                }
                                            }
    ;

PROJLI : {
            $$ = 0;    
         }
    ;

PROJ : DIVOPROJ PROJLI DIVC  { 
                                int i;
                                for(i = 0; i < $2; i++)
                                    fprintf(proj, "%s;%s;%s\n", name, kdlist[i][0], kdlist[i][1]);
                             }
    ;

L : LIO T LIC
    ;
D : DIVO T DIVC
    ;
P : PO T PC
    ;
S : SO T SC
    ;
H : HO T HC
    ;
U : ULO T ULC
    ;
A : AO T AC
    ;
C : COMMENTO G COMMENTC
	;
G : DIVO G
    |DIVC G
    |PO G
    |PC G
    |HO G
    |HC G
    |SO G
    |SC G
    |LIO G
    |LIC G
    |ULO G
    |ULC G
    |AO G
    |AC G
    |string G
    |FTS G
    |DN G
    |C G
    |LINK G
    |IOW G
    ;
G : ;
T : T D
    |  T P
    |  T H
    |  T S
    |  T U
    |  T L
    |  T A
    |  T string
    |  T FTS
    |  T DN
    |  T C
    |  T LINK
    |  T IOW
    |  T GM
    |  T PUB
    |  T PROJ
    ;
T : ;
%%

void yyerror(const char *s){
    printf("%s\n", s);
   	fclose(designation);
    fclose(responsibility);
    fclose(email);
    fclose(phone);
    fclose(website);
    fclose(awards);
}

int main(int argc, char *argv[]){
    mkdir("Tables", 0700);
    designation = fopen("Tables/designation.csv", "a");
    responsibility = fopen("Tables/responsibility.csv", "a");
    email = fopen("Tables/email.csv", "a");
    phone = fopen("Tables/phone.csv", "a");
    website = fopen("Tables/website.csv", "a");
    awards = fopen("Tables/awards.csv", "a");
    ms = fopen("Tables/ms.csv", "a");
    phd = fopen("Tables/phd.csv", "a");
    pub = fopen("Tables/pub.csv", "a");
    proj = fopen("Tables/proj.csv", "a");
    return yyparse();
}