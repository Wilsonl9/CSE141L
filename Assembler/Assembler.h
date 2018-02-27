#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include "Tokenizer.h"
#include <fstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <string>
typedef char byte;

using namespace std;
class Assembler
{
    private:
        std::unordered_map<string, string> instructions;
        std::unordered_map<string, string> registers;
        std::unordered_map<string, string> sugar;
        std::unordered_set<string> branch_instructions;
        std::unordered_set<string> no_ops;
        std::unordered_set<string> immediate_insts;


        string function_keyword;
        std::vector<byte> lut;
        std::unordered_map<string, int> GenerateLookupTable(Tokenizer &t);

    public:
        Assembler(char * ISA_filepath);
        bool Assemble(const char * in_file, const char * outfile);

        static bool WriteBlock(string block, int num_bits, std::ofstream &out);
        static bool WriteImmediate(int immediate, int num_bits, std::ofstream &out);
};

#endif
