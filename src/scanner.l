%{
#include <scanner.hpp>
#define YY_DECL int shrub::Scanner::flex_scan()
%}
%option reentrant batch stack noyywrap
%option prefix="shrub_flex_"
%%
"type" { return 34; }
%%
