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

module ternary_min(a[1:0], b[1:0], out[1:0]);
  input  [1:0] a;
  input  [1:0] b;
  output [1:0] out;

  wire out_or_gate1;
  wire and_gate1_out;
  wire out_or_gate2;
  wire and_gate2_out;

  or_gate  or_gate1(a[0], b[0], out_or_gate1);
  or_gate  or_gate2(a[1], b[1], out_or_gate2);
  and_gate and_gate1(a[0], b[0], and_gate1_out);
  and_gate and_gate3(a[1], b[1], out[1]);
  and_gate and_gate2(out_or_gate1, out_or_gate2, and_gate2_out);
  or_gate  or_gate3(and_gate2_out, and_gate1_out, out[0]);
endmodule

module ternary_max(a[1:0], b[1:0], out[1:0]);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;
   
  wire out_or_gate1; 
  wire out_and_gate1;
  or_gate or_gate1(a[0], b[0], out_or_gate1);
  or_gate or_gate2(a[1], b[1], out[1]);
  and_gate and_gate1(out_or_gate1, out[1], out_and_gate1);
  xor_gate xor_gate1(out_or_gate1, out_and_gate1, out[0]);

endmodule

module ternary_any(a[1:0], b[1:0], out[1:0]);


  input [1:0] a;
  input [1:0] b;
  output [1:0] out;

  wire out_or_gate1;
  wire out_or_gate2;
  wire out_or_gate3;
  wire out_and_gate_ors;

  or_gate or_gate1(a[1], b[1], out_or_gate1);
  or_gate or_gate2(a[0], a[1], out_or_gate2);
  or_gate or_gate3(b[0], b[1], out_or_gate3);
  and_gate and_gate1(out_or_gate2, out_or_gate3, out_and_gate_ors);
  and_gate and_gate2(out_or_gate1, out_and_gate_ors, out[1]);

  wire not_out_a0;
  wire not_out_a1;
  wire not_out_b0;
  wire not_out_b1;
  
  not_gate not_gate1(a[0], not_out_a0);
  not_gate not_gate2(a[1], not_out_a1);
  not_gate not_gate3(b[0], not_out_b0);
  not_gate not_gate4(b[1], not_out_b1);

  wire out_and_gate01;
  wire out_and_gate02;
  wire out_and_gate03;

  and_gate and_gate01(a[0], b[0], out_and_gate01);
  and_gate and_gate02(not_out_a0, not_out_a1, out_and_gate02);
  and_gate and_gate03(b[1], out_and_gate02, out_and_gate03);

  wire out_or_gate01;

  or_gate or_gate_01(out_and_gate01, out_and_gate03, out_or_gate01);

  wire out_and_gate04;
  wire out_and_gate05;

  and_gate and_gate04(not_out_b0, not_out_b1, out_and_gate04);
  and_gate and_gate05(a[1], out_and_gate04, out_and_gate05);

  or_gate or_gate02(out_or_gate01, out_and_gate05, out[0]);
endmodule

module ternary_consensus(a[1:0], b[1:0], out[1:0]);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;
  
  wire out_or_gate1;
  wire out_or_gate2;
  wire out_not_gate1;
  wire out_or_gate3;
  

  and_gate and_gate1(a[1], b[1], out[1]);
  or_gate or_gate1(a[0], b[0], out_or_gate1);
  or_gate or_gate2(a[1], b[1], out_or_gate2);
  or_gate or_gate3(out_or_gate1, out_or_gate2, out_or_gate3);

  not_gate not_gate1(out[1], out_not_gate1);
  and_gate and_gate2(out_or_gate3, out_not_gate1, out[0]);
endmodule

module testbench();
  reg [1:0] a;
  reg [1:0] b;
  wire [1:0] c;
  ternary_max test_out(a,b,c);

  initial begin
    $dumpfile("./ternary_max_test.vcd");
    $dumpvars;
  end

  initial begin
    a = 0;
    b = 0;
    #1;

    a = 0;
    b = 1;
    #1;

    a = 0;
    b = 2;
    #1;

    a = 1;
    b = 0;
    #1;

    a = 1;
    b = 1;
    #1;

    a = 1;
    b = 2;
    #1;

    a = 2;
    b = 0;
    #1;

    a = 2;
    b = 1;
    #1;

    a = 2;
    b = 2;
    #1;
  end
endmodule