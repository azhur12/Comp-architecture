`include "util.v"
`include "Control_Unit.v"
`include "ALU.v"

module mips_cpu(clk, pc, pc_new, instruction_memory_a, instruction_memory_rd, data_memory_a, data_memory_rd, data_memory_we, data_memory_wd,
                register_a1, register_a2, register_a3, register_we3, register_wd3, register_rd1, register_rd2);
  // сигнал синхронизации
  input clk;
  // текущее значение регистра PC
  inout [31:0] pc;
  // новое значение регистра PC (адрес следующей команды)
  output [31:0] pc_new;
  // we для памяти данных
  output data_memory_we;
  // адреса памяти и данные для записи памяти данных
  output [31:0] instruction_memory_a, data_memory_a, data_memory_wd;
  // данные, полученные в результате чтения из памяти
  inout [31:0] instruction_memory_rd, data_memory_rd;
  // we3 для регистрового файла
  output register_we3;
  // номера регистров
  output [4:0] register_a1, register_a2, register_a3;
  // данные для записи в регистровый файл
  output [31:0] register_wd3;
  // данные, полученные в результате чтения из регистрового файла
  inout [31:0] register_rd1, register_rd2;
  
  assign instruction_memory_a = pc;
  wire [31:0] PCPlus4;
  assign PCPlus4 = pc + 4;

  wire [5:0] opcode;
  wire [5:0] funct;
  wire [15:0] imm;
  wire [4:0] f_15to11;
  wire memToReg, memWrite, regDST, Branch, ALUSrc, RegWrite;
  wire [2:0] ALUControl;
  wire [4:0] f_20to16;
  assign opcode = instruction_memory_rd[31:26];
  assign funct = instruction_memory_rd[5:0];
  assign register_a1 = instruction_memory_rd[25:21];
  assign register_a2 = instruction_memory_rd[20:16];
  assign imm = instruction_memory_rd[15:0];
  assign f_20to16 = instruction_memory_rd[20:16];
  assign f_15to11 = instruction_memory_rd[15:11];

  ctr_unit control_unit(opcode, funct, memToReg, data_memory_we, Branch, ALUControl, ALUSrc, regDST, register_we3);

  
  wire [4:0] WriteReg;
  mux2_5 mux2_5_name(register_a2, f_15to11, regDST , register_a3);


  wire [31:0] extend_imm;
  wire [31:0] shl_imm;
  sign_extend sign_extend_name(imm, extend_imm); //расширяем с 16 бит до 32
  shl_2 shl_2_name(extend_imm, shl_imm); // сдвигаем 

  wire [31:0] PCBranch;
  assign PCBranch = PCPlus4 + shl_imm;

  wire [31:0] SrcB;
  mux2_32 mux2_32_2(register_rd2, extend_imm, ALUsrc, SrcB);

  wire [31:0] ALUResult;
  wire Zero;
  alu alu_name(register_rd1, SrcB, ALUControl, ALUResult, Zero);

  assign data_memory_a = ALUResult;
  wire PCSrc;
  assign PCSrc = Branch & Zero;

  assign data_memory_wd = register_rd2;

  wire [31:0] ReadData;

  wire [31:0] Result;
  mux2_32 mux2_32_3(data_memory_a, data_memory_rd, memToReg, register_wd3);
  
  mux2_32 mux2_32_1(PCPlus4, PCBranch, PCSrc, pc_new);

endmodule