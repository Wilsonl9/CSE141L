#include "Assembler.h"

Assembler::Assembler(char * isa_filepath)
{
    Tokenizer isa;
    isa.Open(isa_filepath);
    isa.FindToken("lut_size");
    int lut_size = isa.GetInt();
    lut.resize(lut_size);
    isa.FindToken("function_keyword");
    isa.GetToken(function_keyword);
    isa.FindToken("opcodes");
    int num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char op[255], code[4];
        isa.GetToken(op);
        isa.GetToken(code);
        this->instructions.insert({op,code});
    }

    isa.FindToken("branch");
    num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char br[255];
        isa.GetToken(br);
        this->branch_instructions.insert(br);
    }

    isa.FindToken("no_op");
    num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char noop[255];
        isa.GetToken(noop);
        this->no_ops.insert(noop);
    }

    isa.FindToken("immediate");
    num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char imm[255];
        isa.GetToken(imm);
        this->immediate_insts.insert(imm);
    }

    isa.FindToken("registers");
    num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char reg[255], code[5];
        isa.GetToken(reg);
        isa.GetToken(code);
        this->registers.insert({reg,code});
    }

    isa.FindToken("sugar");
    num = isa.GetInt();
    for(int i = 0; i < num; ++i)
    {
        char op[255], code[9];
        isa.GetToken(op);
        isa.GetToken(code);
        this->sugar.insert({op,code});
    }
}

bool Assembler::Assemble(const char * infile, const char * outfile)
{
    BitOutputStream out;
    out.open(outfile);
    Tokenizer t;
    t.Open(infile);
    std::unordered_map<char *, int> labels = GenerateLookupTable(t);
    t.Reset();

    for(int i = 0; i < lut.size(); ++i)
    {
        Assembler::WriteImmediate(lut[i], 8, out);
    }
    
    char inst[255], operand[255];
    t.FindToken(function_keyword);
    t.SkipLine();
    bool check = t.GetToken(inst);
    while(check)
    {
        if(instructions.count(inst) == 1)
        {
            Assembler::WriteBlock(instructions[inst], 4, out);
        } else if (sugar.count(inst) == 1)
        {
            Assembler::WriteBlock(sugar[inst], 4, out);
            continue;
        } else return false;

        if(no_ops.count(inst) == 1) 
        {
            Assembler::WriteImmediate(0, 5, out);
        }

        check = t.GetToken(operand);
        if(registers.count(operand) == 1)
        {
            Assembler::WriteBlock(registers[operand], 5, out);
        } else if (branch_instructions.count(inst) == 1){
            Assembler::WriteImmediate(labels[operand], 5, out);
        } else if (immediate_insts.count(inst) == 1)
        {
            Assembler::WriteImmediate(atoi(operand), 5, out);
        } else return false;
        check = t.GetToken(inst);
    }
    t.Close();
    out.close();
}

std::unordered_map<char*, int> GenerateLookupTable(Tokenizer &t)
{
    int num_labels = 0;
    std::unordered_map<char*, int> labels_index;
    std::vector<char*> labels;
    bool check;
    char label[255];
    while((check = t.FindToken("jmp")))
    {
        int line = t.GetLineNum();
        t.GetToken(label);
        labels_index[label] = num_labels;
        labels.push_back(label);
        lut[num_labels++] = line;
    }

    t.Reset();
    while(check = t.FindToken("brneg"))
    {
        int line = t.GetLineNum();
        t.GetToken(label);
        labels_index[label] = num_labels;
        labels.push_back(label);
        lut[num_labels++] = line;
    }

    t.Reset();
    while(check = t.FindToken("brz"))
    {
        int line = t.GetLineNum();
        t.GetToken(label);
        labels_index[label] = num_labels;
        labels.push_back(label);
        lut[num_labels++] = line;
    }

    for(int i = 0; i < num_labels; ++i)
    {
        t.Reset();
        char* label = labels[i];
        t.FindToken(label);
        int label_num = t.GetLineNum() + 1;
        lut[i] = label_num - lut[i];
    }
}

bool Assembler::WriteBlock(char * block, int num_bits, std::ofstream &out)
{
    for(int i = 0; i < num_bits; ++i)
    {
        out << block[i];
    }
}

bool Assembler::WriteImmediate(int immediate, int num_bits, std::ofstream &out)
{
    char bin[num_bits];
    int mask = 1u;
    for(int i = num_bits - 1; i >= 0; --i)
    {
        if(0 == (immediate & mask)) bin[i] = '0';
        else bin[i] = '1';
        mask = mask << 1;
    }

    return Assembler::WriteBlock(bin, num_bits, out);
}