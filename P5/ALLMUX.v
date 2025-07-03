`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:41:52 11/21/2024 
// Design Name: 
// Module Name:    ALLMUX 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//Regular MUX// 
module MPC (
    input MPC,
    input [31:0] NPC,
    input [31:0] PC4,

    output [31:0] NextPC
);

    assign NextPC = (MPC == 1'b1) ? (NPC) : (PC4);
    
endmodule

module MRFWA (
    input [4:0] D_Instr20_16,
    input [4:0] D_Instr15_11,
    input [1:0] D_MRFWA,

    output [4:0] A3
);
    wire [4:0] rt,rd;
    assign rt = D_Instr20_16;
    assign rd = D_Instr15_11;


    assign A3 = (D_MRFWA == 2'b10) ? (5'd31) : 
                (D_MRFWA == 2'b01) ? (rd)    : (rt);
    
endmodule

module MALUB (
    input [31:0] E_FALUB,
    input [31:0] E_EXTImm,
    input E_MALUB,

    output [31:0] ALUB
);
    
    assign ALUB = (E_MALUB == 1'b1) ? (E_EXTImm) : (E_FALUB);
    
endmodule

module MRFWD (
    input [31:0] W_ALUResult,
    input [31:0] W_ReadData,
    input [31:0] W_PC,
    input [1:0] W_MRFWD,
    
    output [31:0] RFWD
);

    assign RFWD = (W_MRFWD == 2'b10) ? (W_PC + 32'd8) :
                  (W_MRFWD == 2'b01) ? (W_ReadData)   : (W_ALUResult);
    
endmodule


//Forward MUX//
module MFRD1D (
    input [31:0] D_RD1,
    input [31:0] W_ALUResult,
    input [31:0] W_ReadData,
    input [31:0] W_PC,
    input [31:0] M_ALUResult,
    input [31:0] M_PC,
    input [31:0] E_PC,
    input [2:0] MFRD1D,

    output [31:0] D_FRD1
);

    assign D_FRD1 = (MFRD1D == 3'b110) ? (E_PC + 32'd8) :
                    (MFRD1D == 3'b101) ? (M_PC + 32'd8) :
                    (MFRD1D == 3'b100) ? (M_ALUResult)  :
                    (MFRD1D == 3'b011) ? (W_PC + 32'd8) :
                    (MFRD1D == 3'b010) ? (W_ReadData)   :
                    (MFRD1D == 3'b001) ? (W_ALUResult)  : (D_RD1); 
    
endmodule

module MFRD2D (
    input [31:0] D_RD2,
    input [31:0] W_ALUResult,
    input [31:0] W_ReadData,
    input [31:0] W_PC,
    input [31:0] M_ALUResult,
    input [31:0] M_PC,
    input [31:0] E_PC,
    input [2:0] MFRD2D,

    output [31:0] D_FRD2
);
    
    assign D_FRD2 = (MFRD2D == 3'b110) ? (E_PC + 32'd8) :
                    (MFRD2D == 3'b101) ? (M_PC + 32'd8) :
                    (MFRD2D == 3'b100) ? (M_ALUResult)  :
                    (MFRD2D == 3'b011) ? (W_PC + 32'd8) :
                    (MFRD2D == 3'b010) ? (W_ReadData)   :
                    (MFRD2D == 3'b001) ? (W_ALUResult)  : (D_RD2);
endmodule

module MFALUAE (
    input [31:0] E_RD1,
    input [31:0] W_ReadData,
    input [31:0] M_ALUResult,
    input [31:0] M_PC,
    input [2:0] MFALUAE,

    output [31:0] E_FALUA
);

    assign E_FALUA = (MFALUAE == 3'b011) ? (M_PC + 32'd8) :
                     (MFALUAE == 3'b010) ? (M_ALUResult) :
                     (MFALUAE == 3'b001) ? (W_ReadData)  : (E_RD1);
    
endmodule

module MFALUBE (
    input [31:0] E_RD2,
    input [31:0] W_ReadData,
    input [31:0] M_ALUResult,
    input [31:0] M_PC,
    input [2:0] MFALUBE,

    output [31:0] E_FALUB
);
    
    assign E_FALUB = (MFALUBE == 3'b011) ? (M_PC + 32'd8) :
                     (MFALUBE == 3'b010) ? (M_ALUResult) :
                     (MFALUBE == 3'b001) ? (W_ReadData)  : (E_RD2);

endmodule

module MFWDM (
    input [31:0] M_WriteData,
    input [31:0] W_ReadData,
    input [2:0] MFWDM,

    output [31:0] M_FWD
);

    assign M_FWD = (MFWDM == 3'b001) ? (W_ReadData) : (M_WriteData);
    
endmodule