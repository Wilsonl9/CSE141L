# A simple makefile for CSE 100 PA3

CC=g++
CXXFLAGS=-std=c++0x -g
LDFLAGS=-g

all: assemble

assemble: Assembler.o Tokenizer.o

Assembler.o: Tokenizer.o Assembler.h

Tokenizer.o: Tokenizer.h

clean:
	rm -f compress uncompress *.o core*
