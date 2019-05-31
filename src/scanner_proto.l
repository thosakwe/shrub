%{
#include <ast.hpp>
%}
%option reentrant batch stack noyywrap
%option prefix="shrub_flex_"
%%
"type" { return T_TYPE; }
%%
