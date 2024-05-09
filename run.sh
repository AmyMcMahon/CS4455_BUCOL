#!/bin/bash
flex bucol.l && bison -d bucol.y && gcc -c lex.yy.c bucol.tab.c && gcc -o example lex.yy.o bucol.tab.o -ll -lm && ./example