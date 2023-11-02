module not_gate(in, out);
  
  input wire in;
  output wire out;
  

  supply1 vdd; 
  supply0 gnd; 

  pmos pmos1(out, vdd, in); 
  nmos nmos1(out, gnd, in);
endmodule

module nor_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  supply0 gnd;
  supply1 pwr;

  
  wire pmos1_out;

  pmos pmos1(pmos1_out, pwr, in1);
  pmos pmos2(out, pmos1_out, in2);
  nmos nmos1(out, gnd, in1);
  nmos nmos2(out, gnd, in2);
endmodule

module or_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire nor_out;

  nor_gate nor_gate1(in1, in2, nor_out);
  not_gate not_gate1(nor_out, out);
endmodule

module nand_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  supply0 gnd;
  supply1 pwr;
  
  wire nmos1_out;

  pmos pmos1(out, pwr, in1);
  pmos pmos2(out, pwr, in2);
  nmos nmos1(nmos1_out, gnd, in1);
  nmos nmos2(out, nmos1_out, in2);
endmodule

module and_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire nand_out;

  nand_gate nand_gate1(in1, in2, nand_out);
  not_gate not_gate1(nand_out, out);
endmodule

module xor_gate(in1, in2, out);




  input wire in1;
  input wire in2;
  output wire out;

  wire not_in1;
  wire not_in2;

  wire and_out1;
  wire and_out2;

  wire or_out1;

  not_gate not_gate1(in1, not_in1);
  not_gate not_gate2(in2, not_in2);

  and_gate and_gate1(in1, not_in2, and_out1);
  and_gate and_gate2(not_in1, in2, and_out2);

  or_gate or_gate1(and_out1, and_out2, out);
endmodule

module triple_and_gate(in1, in2, in3, out);
  input wire in1;
  input wire in2;
  input wire in3;
  output wire out;

  wire out_and_gate0;

  and_gate and_gate0(in1, in2, out_and_gate0);
  and_gate and_gate1(out_and_gate0, in3, out);


endmodule

module full_summator(a, b, c_in, c_out, s);
  input wire a;
  input wire b;
  input wire c_in;
  output wire c_out;
  output wire s;

  wire out_xor_ab;
  wire out_xor_abc;
  wire out_and_ab;

  xor_gate xor_gate0(a, b, out_xor_ab);
  xor_gate xor_gate1(out_xor_ab, c_in, s);
  and_gate and_gate0(out_xor_ab, c_in, out_xor_abc);
  and_gate and_gate1(a, b, out_and_ab);
  or_gate or_gate0(out_xor_abc, out_and_ab, c_out);
endmodule

module cascade_summator(a[3:0], b[3:0], c_in, s[3:0]);
  input wire [3:0] a;
  input wire [3:0] b;
  input wire c_in;
  output wire [3:0] s;

  wire [3:0] c_out;

  full_summator full_summator_0(a[0], b[0], c_in, c_out[0], s[0]);
  full_summator full_summator_1(a[1], b[1], c_out[0], c_out[1], s[1]);
  full_summator full_summator_2(a[2], b[2], c_out[1], c_out[2], s[2]);
  full_summator full_summator_3(a[3], b[3], c_out[2], c_out[3], s[3]);
endmodule

module mux(in0, in1, in2, in3, f0, f1, out);
    input wire in0;
    input wire in1;
    input wire in2;
    input wire in3;
    input wire f0;
    input wire f1;
    output wire out;

    wire out_triple_and_gate0;
    wire out_triple_and_gate1;
    wire out_triple_and_gate2;
    wire out_triple_and_gate3;
    wire not_f0;
    wire not_f1;

    not_gate not_gate_f0(f0, not_f0);
    not_gate not_gate_f1(f1, not_f1);

    triple_and_gate triple_and_gate0(in0, not_f0, not_f1, out_triple_and_gate0);
    triple_and_gate triple_and_gate1(in1, f0, not_f1, out_triple_and_gate1);
    triple_and_gate triple_and_gate2(in2, not_f0, f1, out_triple_and_gate2);
    triple_and_gate triple_and_gate3(in3, f0, f1, out_triple_and_gate3);

    wire out_or_gate0;
    wire out_or_gate1;

    or_gate or_gate0(out_triple_and_gate0, out_triple_and_gate1, out_or_gate0);
    or_gate or_gate1(out_triple_and_gate2, out_triple_and_gate3, out_or_gate1);
    or_gate or_gate_out(out_or_gate0, out_or_gate1, out);

endmodule

module choice_mux(a[3:0], b[3:0], f, out[3:0]);
  input [3:0] a;
  input [3:0] b;
  input wire f;
  output [3:0] out;

  wire not_f;
  not_gate not_f1(f, not_f);

  wire out_and_gate_a0;
  wire out_and_gate_a1;
  wire out_and_gate_a2;
  wire out_and_gate_a3;

  and_gate and_gate_a0(a[0], not_f, out_and_gate_a0);
  and_gate and_gate_a1(a[1], not_f, out_and_gate_a1);
  and_gate and_gate_a2(a[2], not_f, out_and_gate_a2);
  and_gate and_gate_a3(a[3], not_f, out_and_gate_a3);

  wire out_and_gate_b0;
  wire out_and_gate_b1;
  wire out_and_gate_b2;
  wire out_and_gate_b3;

  and_gate and_gate_b0(b[0], f, out_and_gate_b0);
  and_gate and_gate_b1(b[1], f, out_and_gate_b1);
  and_gate and_gate_b2(b[2], f, out_and_gate_b2);
  and_gate and_gate_b3(b[3], f, out_and_gate_b3);

  or_gate out_or_gate0(out_and_gate_a0, out_and_gate_b0, out[0]);
  or_gate out_or_gate1(out_and_gate_a1, out_and_gate_b1, out[1]);
  or_gate out_or_gate2(out_and_gate_a2, out_and_gate_b2, out[2]);
  or_gate out_or_gate3(out_and_gate_a3, out_and_gate_b3, out[3]);


endmodule

module mux4(a[3:0], b[3:0], c[3:0], d[3:0], f[1:0], out[3:0]);
    input [3:0] a;
    input [3:0] b;
    input [3:0] c;
    input [3:0] d;
    input [1:0] f;
    output [3:0] out;

    mux mux0(a[0], b[0], c[0], d[0], f[0], f[1], out[0]);
    mux mux1(a[1], b[1], c[1], d[1], f[0], f[1], out[1]);
    mux mux2(a[2], b[2], c[2], d[2], f[0], f[1], out[2]);
    mux mux3(a[3], b[3], c[3], d[3], f[0], f[1], out[3]);
    
endmodule

module bit_or(a[3:0], b[3:0], out[3:0]);
  input [3:0] a;
  input [3:0] b;
  output [3:0] out;

  or_gate or_gate0(a[0], b[0], out[0]);
  or_gate or_gate1(a[1], b[1], out[1]);
  or_gate or_gate2(a[2], b[2], out[2]);
  or_gate or_gate3(a[3], b[3], out[3]);
endmodule

module bit_and(a[3:0], b[3:0], out[3:0]);

  input [3:0] a;
  input [3:0] b;
  output [3:0] out;

  and_gate and_gate0(a[0], b[0], out[0]);
  and_gate and_gate1(a[1], b[1], out[1]);
  and_gate and_gate2(a[2], b[2], out[2]);
  and_gate and_gate3(a[3], b[3], out[3]);
endmodule

module alu(a, b, control, res);
  input [3:0] a, b; // Операнды
  input [2:0] control; // Управляющие сигналы для выбора операции

  output [3:0] res; // Результат

  wire [3:0] invert_b;

  not_gate invert_b0(b[0], invert_b[0]);
  not_gate invert_b1(b[1], invert_b[1]);
  not_gate invert_b2(b[2], invert_b[2]);
  not_gate invert_b3(b[3], invert_b[3]);
  
  wire [3:0] out_choice_mux;
  wire [3:0] out_summator;
  wire [3:0] out_bit_or;
  wire [3:0] out_bit_and;
  supply0 zero;
  
  choice_mux choice_mux_name(b[3:0], invert_b[3:0], control[2], out_choice_mux[3:0]);
  cascade_summator cascade_summator_name(a[3:0], out_choice_mux[3:0], control[2], out_summator[3:0]);
  bit_or bit_or_name(a[3:0], out_choice_mux[3:0], out_bit_or[3:0]);
  bit_and bit_and_name(out_choice_mux[3:0], a[3:0], out_bit_and[3:0]);

  wire not_b;
  not_gate not_b_op(b[3], not_b);
  
  wire out_first_term;
  and_gate first_term(a[3], not_b, out_first_term);

  wire out_invert_impl;
  or_gate invert_impl(a[3], not_b, out_invert_impl);

  wire out_second_term;
  and_gate second_term(out_summator[3], out_invert_impl, out_second_term);

  wire out_res_slt;
  or_gate res_slt(out_first_term, out_second_term, out_res_slt);

  wire [3:0] resSlt = {3'b000, out_res_slt};


  mux4 mux4_name(out_bit_and[3:0], out_bit_or[3:0], out_summator[3:0], resSlt[3:0], control[1:0], res[3:0]);
endmodule

module d_latch(clk, d, we, q);
  input clk; // Сигнал синхронизации
  input d; // Бит для записи в ячейку
  input we; // Необходимо ли перезаписать содержимое ячейки

  output reg q; // Сама ячейка
  // Изначально в ячейке хранится 0
  initial begin
    q <= 0;
  end
  // Значение изменяется на переданное на спаде сигнала синхронизации
  always @ (negedge clk) begin
    if (we) begin
      q <= d;
    end
  end
endmodule

module d4_latch(clk, d, we, q);
    input clk;
    input [3:0] d;
    input we;
    output [3:0] q;

    d_latch d_latch0(clk, d[0], we, q[0]);
    d_latch d_latch1(clk, d[1], we, q[1]);
    d_latch d_latch2(clk, d[2], we, q[2]);
    d_latch d_latch3(clk, d[3], we, q[3]);
endmodule

module decoder1_2(s, z[1:0]);
  input s;
  output [1:0] z;

  not_gate not_gate0(s, z[0]);
  and_gate and_gate0(s, s, z[1]);
endmodule

module decoder2_4(we_addr[1:0], out[3:0]);
  input [1:0] we_addr;
  output [3:0] out;
  
  wire [1:0] y;
  wire [1:0] x;

  decoder1_2 first_decoder1_2(we_addr[0], y[1:0]);
  decoder1_2 second_decoder1_2(we_addr[1], x[1:0]);

  and_gate and_gate0(y[0], x[0], out[0]);
  and_gate and_gate1(y[1], x[0], out[1]);
  and_gate and_gate2(y[0], x[1], out[2]);
  and_gate and_gate3(y[1], x[1], out[3]);
endmodule

module register_file(clk, rd_addr, we_addr, we_data, rd_data);
  input clk; // Сигнал синхронизации
  input [1:0] rd_addr, we_addr; // Номера регистров для чтения и записи
  input [3:0] we_data; // Данные для записи в регистровый файл

  output [3:0] rd_data; // Данные, полученные в результате чтения из регистрового файла
  
  wire [3:0] decode;
  decoder2_4 decoder2_4_name(we_addr[1:0], decode[3:0]);
  
  wire [3:0] rd0;
  wire [3:0] rd1;
  wire [3:0] rd2;
  wire [3:0] rd3;

  d4_latch d4_latch_0(clk, we_data, decode[0], rd0);
  d4_latch d4_latch_1(clk, we_data, decode[1], rd1);
  d4_latch d4_latch_2(clk, we_data, decode[2], rd2);
  d4_latch d4_latch_3(clk, we_data, decode[3], rd3);

  mux4 mux4_name(rd0, rd1, rd2, rd3, rd_addr, rd_data);

endmodule

module calculator(clk, rd_addr, immediate, we_addr, control, rd_data);

  input clk; // Сигнал синхронизации
  input [1:0] rd_addr; // Номер регистра, из которого берется значение первого операнда
  input [3:0] immediate; // Целочисленная константа, выступающая вторым операндом
  input [1:0] we_addr; // Номер регистра, куда производится запись результата операции
  input [2:0] control; // Управляющие сигналы для выбора операции

  output [3:0] rd_data; // Данные из регистра c номером 'rd_addr', подающиеся на выход
  
  wire [3:0] res_alu;

  register_file register_file_name(clk, rd_addr, we_addr, res_alu, rd_data);
  alu alu0(rd_data, immediate, control, res_alu);
endmodule

