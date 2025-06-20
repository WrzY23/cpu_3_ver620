//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University Electronic Engineering
// Engineer: Yuan
// 
// Create Date: 2025/06/20 12:59:46
// Design Name: Data Memory
// Module Name: DM
// Project Name: CPU_3_ver620
// Target Devices: NULL
// Tool Versions: NULL
// Description: 
//      A simple Data Memory which can store MEM_SIZE*32 bits of data.
//        
// Dependencies: NULL
// 
// Revision:1
// Revision 0.01 - File Created
// Additional Comments:
// ! 理论上应该避免一个周期内同时进行读和写操作
// ! 假如如此使用，本模块将在同一个Address上进行读和写操作
// ! ReadData读到原值，并被写入新值
// TODO: 当前支持的是word读写，byte读、bit读该怎么做
//////////////////////////////////////////////////////////////////////////////////
module DM (
    input wire clk,
    input wire [31:0] Address,
    input wire [31:0] WriteData,
    input wire MemWr,
    input wire MemRead,
    output reg [31:0] ReadData,
    output reg Exception_DM  // Exception for Data Memory
);
  parameter MEM_SIZE = 1024 * 1024;
  reg [31:0] data_array[0:MEM_SIZE-1];  // 以1word=4byte=32bit为单位读取，以mod4=0 Byte为地址访问
  initial begin
    $readmemh("prog.mem", data_array);  // 初始化内存
  end
  always @(posedge clk) begin
    if (MemRead && Address < MEM_SIZE) begin
      ReadData <= data_array[Address];
    end
    if (MemWr && Address < MEM_SIZE) begin
      data_array[Address] <= WriteData;
    end
    if (Address >= MEM_SIZE) begin
      Exception_DM <= 1;  // 地址越界异常
    end else begin
      Exception_DM <= 0;  // 无异常
    end
  end
endmodule
