#include <iostream>
#include <string>
#include <cstdlib> 

using namespace std;

string toBinary32(unsigned int num) {
    string result = "";
    for (int i = 31; i >= 0; --i) {
        result += (num & (1 << i)) ? '1' : '0';
    }
    return result;
}

int getRegisterNumber(const string& reg) {
    if (reg[0] != 'x') return -1;
    int num = 0;
    for (size_t i = 1; i < reg.size(); ++i) {
        if (reg[i] >= '0' && reg[i] <= '9') {
            num = num * 10 + (reg[i] - '0');
        }
        else {
            return -1;
        }
    }
    return num;
}

void splitOperands(const string& input, string& rd, string& rs1, string& rs2_or_imm) {
    int first = input.find(',');
    int second = input.find(',', first + 1);
    rd = input.substr(0, first);
    rs1 = input.substr(first + 1, second - first - 1);
    if (second != string::npos) {
        rs2_or_imm = input.substr(second + 1);
    }
    else {
        rs2_or_imm = "";
    }

    auto trim = [](string& s) {
        while (!s.empty() && s[0] == ' ') s.erase(0, 1);
        while (!s.empty() && s[s.size() - 1] == ' ') s.pop_back();
        };
    trim(rd); trim(rs1); trim(rs2_or_imm);
}

unsigned int encodeRType(int funct7, int rs2, int rs1, int funct3, int rd, int opcode) {
    return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode;
}

unsigned int encodeIType(int imm, int rs1, int funct3, int rd, int opcode) {
    return ((imm & 0xFFF) << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode;
}

unsigned int encodeBType(int imm, int rs2, int rs1, int funct3, int opcode) {
    int imm_12 = (imm >> 12) & 0x1;
    int imm_10_5 = (imm >> 5) & 0x3F;
    int imm_4_1 = (imm >> 1) & 0xF;
    int imm_11 = (imm >> 11) & 0x1;

    return (imm_12 << 31) | (imm_10_5 << 25) | (rs2 << 20) | (rs1 << 15) |
        (funct3 << 12) | (imm_4_1 << 8) | (imm_11 << 7) | opcode;
}

unsigned int encodeUType(int imm, int rd, int opcode) {
    return (imm & 0xFFFFF000) | (rd << 7) | opcode;
}

unsigned int encodeJType(int imm, int rd, int opcode) {
    int imm_20 = (imm >> 20) & 0x1;
    int imm_10_1 = (imm >> 1) & 0x3FF;
    int imm_11 = (imm >> 11) & 0x1;
    int imm_19_12 = (imm >> 12) & 0xFF;

    return (imm_20 << 31) | (imm_19_12 << 12) | (imm_11 << 20) |
        (imm_10_1 << 21) | (rd << 7) | opcode;
}

void assemble(const string& line) {
    size_t space = line.find(' ');
    if (space == string::npos) {
        cout << "Invalid instruction format.\n";
        return;
    }

    string instr = line.substr(0, space);
    string operands = line.substr(space + 1);

    string rd, rs1, rs2_or_imm;
    splitOperands(operands, rd, rs1, rs2_or_imm);

    int r_rd = getRegisterNumber(rd);
    int r_rs1 = getRegisterNumber(rs1);
    int r_rs2 = -1;
    if (!rs2_or_imm.empty()) {
        r_rs2 = getRegisterNumber(rs2_or_imm);
    }

    int imm = 0;
    if (instr == "lui" || instr == "jal") {
       
        if (rs2_or_imm.empty()) {
            if (rs1.find("0x") == 0 || rs1.find("0X") == 0) {
                imm = strtol(rs1.c_str(), nullptr, 16);
            }
            else {
                imm = strtol(rs1.c_str(), nullptr, 10);
            }
        }
        else {
            if (rs2_or_imm.find("0x") == 0 || rs2_or_imm.find("0X") == 0) {
                imm = strtol(rs2_or_imm.c_str(), nullptr, 16);
            }
            else {
                imm = strtol(rs2_or_imm.c_str(), nullptr, 10);
            }
        }
    }
    else if (!rs2_or_imm.empty() && r_rs2 == -1) {
      
        if (rs2_or_imm.find("0x") == 0 || rs2_or_imm.find("0X") == 0) {
            imm = strtol(rs2_or_imm.c_str(), nullptr, 16);
        }
        else {
            imm = strtol(rs2_or_imm.c_str(), nullptr, 10);
        }
    }

    unsigned int binary = 0;

    if (instr == "add") {
        binary = encodeRType(0b0000000, r_rs2, r_rs1, 0b000, r_rd, 0b0110011);
    }
    else if (instr == "sub") {
        binary = encodeRType(0b0100000, r_rs2, r_rs1, 0b000, r_rd, 0b0110011);
    }
    else if (instr == "and") {
        binary = encodeRType(0b0000000, r_rs2, r_rs1, 0b111, r_rd, 0b0110011);
    }
    else if (instr == "or") {
        binary = encodeRType(0b0000000, r_rs2, r_rs1, 0b110, r_rd, 0b0110011);
    }
    else if (instr == "xor") {
        binary = encodeRType(0b0000000, r_rs2, r_rs1, 0b100, r_rd, 0b0110011);
    }
    else if (instr == "addi") {
        binary = encodeIType(imm, r_rs1, 0b000, r_rd, 0b0010011);
    }
    else if (instr == "andi") {
        binary = encodeIType(imm, r_rs1, 0b111, r_rd, 0b0010011);
    }
    else if (instr == "ori") {
        binary = encodeIType(imm, r_rs1, 0b110, r_rd, 0b0010011);
    }
    else if (instr == "addw") {
        binary = encodeRType(0b0000000, r_rs2, r_rs1, 0b000, r_rd, 0b0111011);
    }
    else if (instr == "bne") {
        binary = encodeBType(imm, r_rs2, r_rs1, 0b001, 0b1100011);
    }
    else if (instr == "jal") {
        binary = encodeJType(imm, r_rd, 0b1101111);
    }
    else if (instr == "lui") {
        binary = encodeUType(imm, r_rd, 0b0110111);
    }
    else {
        cout << "Unsupported instruction.\n";
        return;
    }

    cout << toBinary32(binary) << endl;
}

int main() {
    string line;
    cout << "Enter RISC-V instruction (e.g., add x1, x2, x3):\n";
    while (getline(cin, line)) {
        if (line.empty()) break;
        assemble(line);
    }
    return 0;
}