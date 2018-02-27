#include "Assembler.h"
#include "Tokenizer.h"
#include <iostream>

int main(int argc, char** argv)
{
  if(argc != 4) 
  {
    std::cout << "Incorrect usage. Usage: ./assemble isa_file code_file outfile" << std::endl;
  }
  Assembler a(argv[1]);
  a.Assemble(argv[2], argv[3]);
  exit(0);
}
