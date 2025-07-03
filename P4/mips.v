`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:19:36 10/29/2024 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );

    wire [31:0] Instr;
	 wire [2:0] NPCOp;
    wire [1:0] EXTOp,RegDst,ALUOp,MemtoReg;
    wire RegWrite,ALUSrc,MemWrite;


    Datapath Datapath(
        //input
        .Clk(clk),
        .Reset(reset),
        .NPCOp(NPCOp),
        .EXTOp(EXTOp),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),

        //output
        .Instr(Instr)
    );

    Controller Controller(
        //input
        .opcode(Instr[31:26]),
        .funct(Instr[5:0]),

        //output
        .NPCOp(NPCOp),
        .EXTOp(EXTOp),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg)
    );
	 
endmodule
