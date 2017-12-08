#!/bin/bash
# A simple script

bison -d sintatico.y
flex lexico.l
g++ sintatico.tab.c lex.yy.c -lfl -o executavel