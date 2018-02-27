#include "Assembler.h"
#include <iostream>
Assembler::Assembler(char * isa_filepath)
{
    Tokenizer isa;
    char token[255];
    
    isa.Open(isa_filepath);
    isa.Reset();
    bool good = isa.FindToken("lut_size");
    if(!good){
      std::cout << "lut_size bad" << std::endl;
      std::cout << "Bad ISA file." << std::endl;
      exit(0);
    }
    int lut_size = isa.GetInt();
    lut.resize(lut_size);
    isa.Reset();
    good = isa.FindToken("function_keyword");
    if(!good){
      std::cout << "function_keyword bad" << std::endl;
      std::cout << "Bad ISA file." << std::endl;
      exit(0);
    }
 
    isa.GetToken(token);
    function_keyword = token;
    isa.Reset();
    good = isa.FindToken("opcodes");
    if(!good){
      std::cout << "opcodes bad" << std::endl;
      std::cout << "Bad ISA file." << std::endl;
      exit(0);
    }
    int num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char op[255], code[255];
        isa.GetToken(op);
        isa.GetToken(code);
        this->instructions[string(op)] = string(code);
    }
    isa.Reset();
    good = isa.FindToken("branch");
    if(!good){
      std::cout << "branch bad" << std::endl;
      std::cout << "Bad ISA file." << std::endl;
      exit(0);
    }
    num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char br[255];
        isa.GetToken(br);
        this->branch_instructions.insert(string(br));
    }

    isa.Reset();
    good = isa.FindToken("no_op");
    if(!good){
      
      std::cout << "noop bad" << std::endl;
      std::cout << "Bad ISA file." << std::endl;
      exit(0);
    }

    num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char noop[255];
        isa.GetToken(noop);
        this->no_ops.insert(string(noop));
    }
    isa.Reset();
    good = isa.FindToken("immediate");
    if(!good){
      
      std::cout << "immediate bad" << std::endl;
      std::cout << "Bad ISA file." << std::endl;
      exit(0);
    }
    num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char imm[255];
        isa.GetToken(imm);
        this->immediate_insts.insert(string(imm));
    }

    isa.Reset();
    good = isa.FindToken("registers");
    if(!good){
      std::cout << "registers bad" << std::endl;
      std::cout << "Bad ISA file." << std::endl;
      exit(0);
    }
    num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char reg[255], code[255];
        isa.GetToken(reg);
        isa.GetToken(code);
        this->registers[string(reg)] = string(code);
    }

    isa.Reset();
    good = isa.FindToken("sugar");
    if(!good){
      return; 
    }
    num = isa.GetInt();
    isa.SkipLine();
    for(int i = 0; i < num; ++i)
    {
        char op[255], code[255];
        isa.GetToken(op);
        isa.GetToken(code);
        this->sugar[string(op)] = string(code);
    }
    isa.Close();
}

bool Assembler::Assemble(const char * infile, const char * outfile)
{
    std::ofstream out(outfile, std::ofstream::out);
    Tokenizer t;
    t.Open(infile);
    std::unordered_map<string, int> labels = GenerateLookupTable(t);
    t.Reset();
    out << "// Lookup Table values\n\n";
    for(int i = 0; i < lut.size(); ++i)
    {
        Assembler::WriteImmediate(lut[i], 8, out);
        out << "\t// LUT[" << i << "] = " << (int)lut[i] << "\n";
    }
    out << "\n\n // Machine Code\n\n";    
    char i[255], op[255];
    string inst, operand;
    t.FindToken(function_keyword.c_str());
    t.SkipLine();
    bool check = t.GetToken(i);
    while(check)
    {
        inst = i;   
        if(instructions.count(inst) == 1)
        {
            Assembler::WriteBlock(instructions[inst], 4, out);
        } else if (sugar.count(inst) == 1)
        {
            Assembler::WriteBlock(sugar[inst], 9, out);
            t.SkipLine();
            check = t.GetToken(i);
            continue;
        } else {
            string l_temp = inst;
            l_temp.back() = '\0';
            string l = l_temp.c_str();
            if(labels.count(l) == 1){
              t.SkipLine();
              check = t.GetToken(i);
              continue;
            } else {
              std::cout << "Invalid instruction: " << inst << " on line " << t.GetLineNum() << std::endl;
              return false;
            }
        }
        if(no_ops.count(inst) == 1) 
        {
            out << "_";
            Assembler::WriteImmediate(0, 5, out);
            out << "\t// " << inst << '\n';
            t.SkipLine();
            check = t.GetToken(i);
            continue;
        }

        check = t.GetToken(op);
        operand = op;
        if(registers.count(operand) == 1)
        {
            out << "_";
            Assembler::WriteBlock(registers[operand], 5, out);
        } else if (branch_instructions.count(inst) == 1){
            out << "_";
            Assembler::WriteImmediate(labels[operand], 5, out);
        } else if (immediate_insts.count(inst) == 1)
        {
            out << "_";
            Assembler::WriteImmediate(stoi(operand), 5, out);
        } else{
          std::cout << "invalid operand: " << operand << " on line " << t.GetLineNum() << std::endl;
          return false; 
        }
        out << "\t// " << inst << " " << operand << '\n';
        
        t.SkipLine();
        check = t.GetToken(i);   
    }
    t.Close();
    out.close();
    return true;
}

std::unordered_map<string, int> Assembler::GenerateLookupTable(Tokenizer &t)
{
    int num_labels = 0;
    std::unordered_map<string, int> labels_index;
    std::vector<string> labels;
    char label[255];
    while(t.FindToken("jmp"))
    {
        int line = t.GetLineNum();
        t.GetToken(label);
        labels_index[string(label)] = num_labels;
        labels.push_back(string(label));
        lut[num_labels++] = line;
    }

    t.Reset();
    while(t.FindToken("brneg"))
    {
        int line = t.GetLineNum();
        t.GetToken(label);
        labels_index[string(label)] = num_labels;
        labels.push_back(string(label));
        lut[num_labels++] = line;
    }

    t.Reset();
    while(t.FindToken("brz"))
    {
        int line = t.GetLineNum();
        t.GetToken(label);
        labels_index[string(label)] = num_labels;
        labels.push_back(string(label));
        lut[num_labels++] = line;
    }

    char check[255];
    for(int i = 0; i < num_labels; ++i)
    {
        t.Reset();
        string label = labels[i];
        label += ":";
        if(!t.FindToken(label.c_str())){
          cout << "Invalid label: " << label << endl;
          continue;
        }
        t.SkipLine();
        bool good = t.GetToken(check);
        while(good && instructions.count(string(check)) != 1){
          t.SkipLine();
          good = t.GetToken(check);
        }
        int label_num = t.GetLineNum();
        lut[i] = label_num - lut[i];
    }
    return labels_index;
}

bool Assembler::WriteBlock(string b, int num_bits, std::ofstream &out)
{
    const char * block = b.c_str();
    for(int i = 0; i < num_bits; ++i)
    {
        out << block[i];
    }

    return true;
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
     
    return Assembler::WriteBlock(string(bin), num_bits, out);
}
