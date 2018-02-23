#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include "BitOutputStream.h"
#include "Tokenizer.h"
#include <unordered_map>
#include <unordered_set>

#include <vector>
class Assembler
{
    private:
        std::unordered_map<char *, char *> instructions;
        std::unordered_map<char*, char*> registers;
        std::unordered_map<char*, char*> sugar;
        std::unordered_set<char*> branch_instructions;
        std::unordered_set<char*> no_ops;
        std::unordered_set<char*> immediate_insts;


        char function_keyword[16];
        std::vector<byte> lut;
        std::unordered_map<char*, int> GenerateLookupTable(Tokenizer &t);

    public:
        Assembler(char * ISA_filepath);
        bool Assemble(const char * in_file, const char * outfile);

        static bool WriteBlock(char * block, int num_bits, std::ofstream &out);
        static bool WriteImmediate(int immediate, int num_bits, std::ofstream &out);
};

#endif