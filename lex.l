%{
	#include <string.h>
	#include "y.tab.h"
	#define MAX 1000
	int yylex(void);
%}

%%


[<](!--)									 {
												return COMMENTO;
											 }
(--)[>]										 {
												return COMMENTC;
											 }
[<](link)([^>])*[>]						{
											return LINK;
										}
[<](div)[ ](class)[=].(caption)[_](text).[>] {
												yylval.str = strdup(yytext);
												return DIVON;
										     }
[<](div)[ ](class)[=].(accordion)[-](contact)[-](list).[>] {
																yylval.str = strdup(yytext);
																return DIVOC;
														   }
[<](div)[ ](class)[=].(facultyleftTabScroll)[^>]*[>] {
														yylval.str = strdup(yytext);
														return DIVOFTS;
										  			 }
[<](div)[ ](class)[=].(researcharea).[>] {
												yylval.str = strdup(yytext);
												return DIVOR;
										 }

[<](div)[ ](class)[=].(tab[-]pane).[ ]id[=].(resp[-]tab2).[>]   {
																	yylval.str = strdup(yytext);
																	return DIVOPUB;

																}
[<](div)[ ](class)[=].(tab[-]pane).[ ]id[=].(resp[-]tab3).[>]   {
																	yylval.str = strdup(yytext);
																	return DIVOPROJ;

																}
[<](div)[ ](class)[=].(tab[-]pane).[ ]id[=].(resp[-]tab4).[>]   {
																	yylval.str = strdup(yytext);
																	return DIVOGM;
 																}
[<](div)[^>]*[>] 	 	 				{
											yylval.str = strdup(yytext);
											return DIVO;
										}
[<][/](div)[>]	 	 					{
											yylval.str = strdup(yytext);
											return DIVC;
										}
[<][h](0|1|2|3|4|5|6)([^>])*[>] 		{
											yylval.str = strdup(yytext);
											return HO;
										}
[<][/][h](0|1|2|3|4|5|6)[>]		 		{
											yylval.str = strdup(yytext);
											return HC;
										}
[<](span)([^>])*[>] 	 	 			{
											yylval.str = strdup(yytext);
											return SO;
										}
[<][/](span)[>]		 					{
											yylval.str = strdup(yytext);
											return SC;
										}
[<][p]([^>])*[>] 		 				{
											yylval.str = strdup(yytext);
											return PO;
										}
[<][/][p][>] 		 					{
											yylval.str = strdup(yytext);
											return PC;
										}
[<][a]([^>])*[>] 		 				{
											yylval.str = strdup(yytext);
											return AO;
										}
[<][/][a][>] 		 					{
											yylval.str = strdup(yytext);
											return AC;
										}
[<](ul)([^>])*[>]								{
											yylval.str = strdup(yytext);
											return ULO;
										}
[<][/](ul)[>]								{
											yylval.str = strdup(yytext);
											return ULC;
										}                                                         
[<](li)([^>])*[>]						{
											yylval.str = strdup(yytext);
											return LIO;
										}
[<][/](li)[>]							{
											yylval.str = strdup(yytext);
											return LIC;
										}   
[<]i[ ](class)[=].(fa[ ]fa[-]envelope).[>][<][/]i[>] {
											yylval.str = strdup(yytext);
											return IOE;
										}
[<]i[ ](class)[=].(fa[ ]fa[-]phone).[>][<][/]i[>] {
											yylval.str = strdup(yytext);
											return IOP;
										}
[<]i[ ](class)[=].(fa[ ]fa[-]file[-]text).[>][<][/]i[>] {
											yylval.str = strdup(yytext);
											return IOW;
										}

[+a-zA-Z0-9][-+a-zA-Z@0-9&()/!:;,. ]*[a-zA-Z0-9).;] {
											yylval.str = strdup(yytext);
											return string;
										}
[<]font[^>]*[>]
[<][/]font[>]                       
[<](center)[>]
[<][/]center[>]
[<]u[>]
[<]b[>]
[<][/]b[>]
[<]br[>]       
[<][/]br[>] 
[<]i[>]
[<][/]i[>]
[ \t\n]|.


%%
int yywrap(){
	return 1;
}