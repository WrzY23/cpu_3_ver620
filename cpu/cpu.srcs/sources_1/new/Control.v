module Control (
    // INSTRUCTION
    input wire [31:0] instr,
    // CONTROL SIGNALS
    output wire addr1,
    output wire addr2,
    output wire regwr,
    output wire memwr,
    output wire memrd,
    output wire alusrc,
    output wire regdst,
    output wire memtoreg,
    output wire branch,
    output wire jump,
    output wire [4:0] aluop
);


endmodule
