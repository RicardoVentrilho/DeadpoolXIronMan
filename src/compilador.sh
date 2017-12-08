#!/bin/bash
# Compilador bison e flex

bison -d sintatico.y
flex lexico.l
g++ sintatico.tab.c lex.yy.c -lfl -o executavel