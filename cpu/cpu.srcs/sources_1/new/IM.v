//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University Electronic Engineering
// Engineer: Yuan
// 
// Create Date: 2025/06/20 12:59:46
// Design Name: Instruction Memory
// Module Name: IM
// Project Name: CPU_3_ver620
// Target Devices: NULL
// Tool Versions: NULL
// Description: 
//      A simple instruction memory which always gives a 32bit instruction
//      according to the 32bit PC register at the positive edge of the clock.
//      
//      It can store 1024 instructions, each of which is 32 bits long.
//      
//        
// Dependencies: NULL
// 
// Revision:1
// Revision 0.01 - File Created
// Additional Comments:
// 
// TODO: reset might be needed?
// TODO: [0:1023]or[1023:0]?
// 
//////////////////////////////////////////////////////////////////////////////////


module IM (
    input wire clk,
    input wire [31:0] ReadAddress,
    output reg [31:0] ReadInstruction,
    output reg Exception_IM  // Exception for Instruction Memory 
);
  reg [31:0] instruction_array[0:1023];  // 1024 instructions, each 32 bits long
  initial begin
    $readmemh("prog.inst", instruction_array);  // 加载程序
  end
  always @(posedge clk) begin
    if (ReadAddress < 1024) begin
      ReadInstruction <= instruction_array[ReadAddress];
      Exception_IM <= 0;  // 清除异常标志
    end else begin
      Exception_IM <= 1;  // 地址越界异常
      ReadInstruction <= 32'h00000000;  // 返回默认值
    end
  end
endmodule
