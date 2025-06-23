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

module Decoder(
    input [31:0] ReadInstruction,
    input [31:0] ReadAddress, //pc
    output wire [4:0] ReadAddr_1,
    output wire [4:0] ReadAddr_2,
    output wire [4:0] WriteAddr, 
    output wire [4:0] Shamt,
    output wire [15:0] Imm,
    output wire [31:0] JAddr,
    output reg ExpOp,
    output reg MemWr,
    output reg MemRead,
    output reg RegWr,
    output reg ALUSrc,
    output reg [1:0] RegDst,   
    output reg MemtoReg,
    output reg PCSrc,
    output reg Jump
);

    wire [5:0] opcode;
    wire [5:0] funct;
    wire [25:0] imm26;
    wire [31:0] pcAdd4;

    assign opcode = ReadInstruction[31:26];
    assign ReadAddr_1 = ReadInstruction[25:21]; 
    assign ReadAddr_2 = ReadInstruction[20:16]; 
    assign Shamt = ReadInstruction[10:6];      
    assign Imm = ReadInstruction[15:0];      
    assign imm26 = ReadInstruction[25:0];    

    assign pcAdd4 = ReadAddress + 32'd4; 
    assign JAddr = {pcAdd4[31:28], imm26, 2'b00};

    assign WriteAddr = (RegDst == 2'b00) ? ReadInstruction[20:16] : // rt
                       (RegDst == 2'b01) ? ReadInstruction[15:11] : // rd
                       (RegDst == 2'b10) ? 5'd31 :                  // $ra (register 31)
                       5'b00000; 

    localparam OP_R_TYPE   = 6'b000000;
    localparam OP_J        = 6'b000010;
    localparam OP_JAL      = 6'b000011;
    localparam OP_BEQ      = 6'b000100;
    localparam OP_ADDI     = 6'b001000;
    localparam OP_ADDIU    = 6'b001001;
    localparam OP_SLTI     = 6'b001010;
    localparam OP_SLTIU    = 6'b001011;
    localparam OP_ANDI     = 6'b001100;
    localparam OP_LUI      = 6'b001111;
    localparam OP_LW       = 6'b100011;
    localparam OP_SW       = 6'b101011;
    localparam FUNCT_ADD   = 6'b100000;
    localparam FUNCT_ADDU  = 6'b100001;
    localparam FUNCT_SUB   = 6'b100010;
    localparam FUNCT_SUBU  = 6'b100011;
    localparam FUNCT_AND   = 6'b100100;
    localparam FUNCT_OR    = 6'b100101;
    localparam FUNCT_XOR   = 6'b100110;
    localparam FUNCT_NOR   = 6'b100111;
    localparam FUNCT_SLL   = 6'b000000;
    localparam FUNCT_SRL   = 6'b000010;
    localparam FUNCT_SRA   = 6'b000011;
    localparam FUNCT_SLT   = 6'b101010;
    localparam FUNCT_SLTU  = 6'b101011;
    localparam FUNCT_JR    = 6'b001000;
    localparam FUNCT_JALR  = 6'b001001;
    localparam FUNCT_MUL   = 6'b000010;

    always @(*) begin
        ExpOp    = 1'b0;
        MemWr    = 1'b0;
        MemRead  = 1'b0;
        RegWr    = 1'b0;
        ALUSrc   = 1'b0;
        RegDst   = 2'b00; 
        MemtoReg = 1'b0;
        PCSrc    = 1'b0;
        Jump     = 1'b0;

        case (opcode)
            OP_R_TYPE: begin
                case (funct)
                    FUNCT_ADD, FUNCT_ADDU, FUNCT_SUB, FUNCT_SUBU,
                    FUNCT_AND, FUNCT_OR, FUNCT_XOR, FUNCT_NOR,
                    FUNCT_SLT, FUNCT_SLTU,
                    FUNCT_SLL, FUNCT_SRL, FUNCT_SRA,
                    FUNCT_MUL: begin
                        RegWr    = 1'b1;
                        RegDst   = 2'b01; 
                        ALUSrc   = 1'b0; 
                        MemtoReg = 1'b0;  
                    end
                    FUNCT_JR: begin
                        Jump     = 1'b1; 
                    end
                    FUNCT_JALR: begin
                        RegWr    = 1'b1;
                        RegDst   = 2'b10; 
                        MemtoReg = 1'b0;  
                        Jump     = 1'b1; 
                    end
                    default: begin
                    end
                endcase
            end
            OP_LW: begin 
                MemRead  = 1'b1;
                RegWr    = 1'b1;
                ALUSrc   = 1'b1;   
                RegDst   = 2'b00;  
                MemtoReg = 1'b1;    
                ExpOp    = 1'b1;   
            end
            OP_SW: begin 
                MemWr    = 1'b1;
                ALUSrc   = 1'b1;   
                ExpOp    = 1'b1;    
            end
            OP_LUI: begin
                RegWr    = 1'b1;
                ALUSrc   = 1'b1;  
                RegDst   = 2'b00;  
                MemtoReg = 1'b0;   
                ExpOp    = 1'b0;   
            end
            OP_ADDI, OP_ADDIU, OP_SLTI, OP_SLTIU: begin
                RegWr    = 1'b1;
                ALUSrc   = 1'b1;    
                RegDst   = 2'b00;   
                MemtoReg = 1'b0;   
                ExpOp    = 1'b1;  
            end
            OP_ANDI: begin
                RegWr    = 1'b1;
                ALUSrc   = 1'b1;   
                RegDst   = 2'b00;  
                MemtoReg = 1'b0;   
                ExpOp    = 1'b0;    
            end
            OP_BEQ: begin
                PCSrc    = 1'b1;   
                ALUSrc   = 1'b0;    
                ExpOp    = 1'b1;  
            end

            OP_J: begin 
                Jump     = 1'b1;
            end
            OP_JAL: begin
                Jump     = 1'b1;
                RegWr    = 1'b1;    
                RegDst   = 2'b10;   
                MemtoReg = 1'b0;   //可能需要修改
            end

            default: begin
            
            end
        endcase
    end

endmodule