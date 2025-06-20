//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Yuan
// 
// Create Date: 2025/06/20 13:29:55
// Design Name: Register File
// Module Name: RF
// Project Name: CPU_3_ver620
// Target Devices: NULL
// Tool Versions: NULL
// Description: 
//      A simple register file module for a CPU.
//      Follows MIPs architecture conventions.
//      Contains 32 registers, each 32 bits wide.
//      Supports read and write operations.
// !    Supports write in first half cycle and read in second half cycle.
// Dependencies: NULL
// 
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments:
// ! Always make sure to check for zero register (register 0) to avoid writing to it.
//////////////////////////////////////////////////////////////////////////////////


module RF (
    input wire clk,
    input wire [31:0] ReadAddr1,
    input wire [31:0] ReadAddr2,
    input wire [31:0] WriteAddr,
    input wire [31:0] WriteData,
    input wire RegWr,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2,
    output reg Exception_RF  // Exception for Register File 
);
  reg [0:31] r[31:0];  // Register array
  always @(posedge clk) begin
    if (WriteAddr == 0) begin
      Exception_RF <= 1;  // Attempt to write to zero register
    end else if (RegWr && WriteAddr != 0) begin
      Exception_RF <= 0;  // No exception
      r[WriteAddr] <= WriteData;
    end
  end
  always @(negedge clk) begin
    ReadData1 <= r[ReadAddr1];
    ReadData2 <= r[ReadAddr2];
  end
endmodule
