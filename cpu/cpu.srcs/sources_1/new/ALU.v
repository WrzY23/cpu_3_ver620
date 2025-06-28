//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Yuan
// 
// Create Date: 2025/06/20 13:54:10
// Design Name: Algorithmic Logic Unit (ALU)
// Module Name: ALU
// Project Name: CPU_3_ver620
// Target Devices: NULL
// Tool Versions: NULL
// Description: 
//      This module implements the Algorithmic Logic Unit (ALU) for a CPU.
//      It supports plus, minus, and bitwise operations.
// Dependencies: NULL
// 
// Revision:1
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

/////////////////////
// ALUOp
// 00000: add
// 00001: sub
// 00010: slt
// 00011: sltu
// 00100: and
// 00101: nor
// 00110: or
// 00111: xor
// 01000: sll
// 01001: srl
// 01010: sra
// 01011: lui
// 01100: andn
// 01101: orn
// 01110: mul  // TODO:后续改为单独模块处理
// 01111: div  // TODO:后续改为单独模块处理
// TODO addu subu
/////////////////////
module ALU (
    // CONF
    input wire [4:0] ALUOp,
    // INPUT
    input wire [31:0] A,
    input wire [31:0] B,
    // OUTPUT
    output wire [31:0] Result,
    // EXCEPT
    output wire ALUExp
    // output reg Zero  //? 由于采用了提前分支预测，或许不需要zero
);

  // RESULTS
  wire [31:0] add_sub_res;
  wire [31:0] slt_res;
  wire [31:0] sltu_res;
  wire [31:0] and_res;
  wire [31:0] nor_res;
  wire [31:0] or_res;
  wire [31:0] xor_res;
  wire [31:0] sll_res;
  wire [31:0] sr_res;
  wire [31:0] lui_res;
  wire [31:0] mul_res;  // temp
  wire [31:0] andn_res;
  wire [31:0] orn_res;
  wire [63:0] sr64_result;
  wire [63:0] mul64_res;  // temp
  wire [31:0] div_res;  // temp

  // OVERFLOWS & EXCEPTIONS
  wire        add_ovf;
  wire        sub_ovf;
  wire        div_exc;


  // 32BIT ADDER
  wire [31:0] adder_a;
  wire [31:0] adder_b;
  wire        adder_cin;
  wire [31:0] adder_res;
  wire        adder_cout;

  assign adder_a = A;
  assign adder_b = (ALUOp == 5'b0001 | ALUOp == 5'b0010 | ALUOp == 5'b0011) ? ~B : B;
  assign adder_cin = (ALUOp == 5'b0001 | ALUOp == 5'b0010 | ALUOp == 5'b0011) ? 1'b1 : 1'b0;
  assign {adder_cout, adder_res} = adder_a + adder_b + adder_cin;


  // ADD, SUB  
  assign add_sub_res = adder_res;
  assign add_exc = (adder_a[31] ~^ adder_b[31]) & (adder_a[31] ^ adder_res[31]);
  assign sub_exc = (adder_a[31] ^ adder_b[31]) | (adder_a[31] ^ adder_res[31]);

  // SLT 
  assign slt_res = {31'b0, ((A[31] & ~B[31]) | ((A[31] ~^ B[31]) & A[31]))};

  // SLTU 
  assign sltu_res = {31'b0, ~adder_cout};

  // AND 
  assign and_res = A & B;

  // OR 
  assign or_res = A | B;

  // ANDN  
  assign andn_res = A & ~B;

  // ORN 
  assign orn_res = A | ~B;

  // NOR 
  assign nor_res = ~(A | B);

  // XOR 
  assign xor_res = A ^ B;

  // LUI 
  assign lui_res = B;

  // SLL 
  assign sll_res = A << B;

  // SRL, SRA 
  assign sr64_result = {{32{(ALUOp == 5'b1010) & A[31]}}, A[31:0]} >> B[4:0];
  assign sr_res = sr64_result[31:0];

  // MUL  //TODO
  assign mul64_res = A * B;
  assign mul_res = mul64_res[31:0];

  // DIV  //TODO
  assign div_res = A / B;
  assign div_exc = (B == 32'b0);

  // ALU result
  assign Result = ({32{ALUOp == 5'b00000}} & add_sub_res
                |{32{ALUOp == 5'b00100}} & add_sub_res
                |{32{ALUOp == 5'b00010}} & slt_res
                |{32{ALUOp == 5'b00011}} & sltu_res
                |{32{ALUOp == 5'b00100}} & and_res
                |{32{ALUOp == 5'b00101}} & nor_res
                |{32{ALUOp == 5'b00110}} & or_res
                |{32{ALUOp == 5'b00111}} & xor_res
                |{32{ALUOp == 5'b01000}} & sll_res
                |{32{ALUOp == 5'b01001}} & sr_res
                |{32{ALUOp == 5'b01010}} & sr_res
                |{32{ALUOp == 5'b01011}} & lui_res
                |{32{ALUOp == 5'b01100}} & andn_res
                |{32{ALUOp == 5'b01101}} & orn_res
                |{32{ALUOp == 5'b01110}} & mul_res
                |{32{ALUOp == 5'b01111}} & div_res);

  // ALU exceptions
  assign ALUExp = ({1{ALUOp == 5'b00000}} & add_ovf
                |{1{ALUOp == 5'b00001}} & sub_ovf
                |{1{ALUOp == 5'b01111}} & div_exc);


endmodule
