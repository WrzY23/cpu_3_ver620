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
// TODO: 不太清楚乘除如何实现
//////////////////////////////////////////////////////////////////////////////////

/////////////////////
// ALUOp
// 000: + signed plus
// 001: - signed minus
// 010: + unsigned plus
// 011: - unsigned minus
// 100: & bitwise and
// 101: | bitwise or
// 110: ^ bitwise xor

/////////////////////
module ALU (
    input wire clk,  // Clock signal;
    input wire [31:0] A,  // First operand
    input wire [31:0] B,  // Second operand
    input wire [2:0] ALUOp,  // ALU operation code
    output reg [31:0] Result,  // ALU result
    output reg Overflow  // Overflow flag
    // output reg Zero  //? 由于采用了提前分支预测，或许不需要zero
);
  always @(posedge clk) begin
    Overflow <= 0;  // Reset overflow flag at the start of each operation
    case (ALUOp)
      3'b000: begin  // Signed plus
        {Overflow, Result} = A + B;
      end
      3'b001: begin  // Signed minus
        {Overflow, Result} = A - B;
      end
      3'b010: begin  // Unsigned plus
        Result   = A + B;
        Overflow = 0;  // No overflow for unsigned addition
      end
      3'b011: begin  // Unsigned minus
        Result   = A - B;
        Overflow = 0;  // No overflow for unsigned subtraction
      end
      3'b100: begin  // Bitwise AND
        Result = A & B;
      end
      3'b101: begin  // Bitwise OR
        Result = A | B;
      end
      3'b110: begin  // Bitwise XOR
        Result = A ^ B;
      end
      default: begin
        Result   = 32'h00000000;  // Default case to avoid latches
        Overflow = 0;  // Reset overflow in default case
      end
    endcase
  end
endmodule
