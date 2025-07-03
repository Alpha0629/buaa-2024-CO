`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:02:09 10/29/2024 
// Design Name: 
// Module Name:    Datapath 
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
module Datapath(
    input Clk,
    input Reset,
    input [2:0] NPCOp,
    input [1:0] EXTOp,
    input [1:0] RegDst,
    input RegWrite,
    input ALUSrc,
    input [1:0] ALUOp,
    input MemWrite,
    input [1:0] MemtoReg,
    output [31:0] Instr
    );

    wire [31:0] PC,PC4,RD1,RD2,EXTImm,ALUResult,ReadData,SrcB,WD;
    wire Zero;
    wire [4:0] A3;


    IFU IFU(
        //input
        .Clk(Clk),
        .Reset(Reset),
        .NPCOp(NPCOp),
        .Zero(Zero),
        .RA(RD1),

        //output
        .Instr(Instr),
        .PC(PC),
        .PC4(PC4)
    );

    GRF GRF(
        //input
        .Clk(Clk),
        .Reset(Reset),
        .RegWrite(RegWrite),
        .A1(Instr[25:21]),
        .A2(Instr[20:16]),
        .A3(A3),
        .WD(WD),
        .PC(PC),

        //output
        .RD1(RD1),
        .RD2(RD2)
    );

    EXT EXT(
        //input
        .Imm16(Instr[15:0]),
        .EXTOp(EXTOp),

        //output
        .EXTImm(EXTImm)
    );

    ALU ALU(
        //input
        .SrcA(RD1),
        .SrcB(SrcB),
        .ALUOp(ALUOp),
        
        //output
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    DM DM(
        //input
        .ALUResult(ALUResult),
        .WriteData(RD2),
        .PC(PC),
        .MemWrite(MemWrite),
        .Clk(Clk),
        .Reset(Reset),

        //output
        .ReadData(ReadData)
    );

    MUX_RegDst MUX_RegDst(
        //input
        .Instr20_16(Instr[20:16]),
        .Instr15_11(Instr[15:11]),
        .RegDst(RegDst),

        //output
        .A3(A3)
    );

    MUX_ALUSrc MUX_ALUSrc(
        //input
        .RD2(RD2),
        .EXTImm(EXTImm),
        .ALUSrc(ALUSrc),

        //output
        .SrcB(SrcB)
    );

    MUX_MemtoReg MUX_MemtoReg(
        //input
        .ALUResult(ALUResult),
        .ReadData(ReadData),
        .PC4(PC4),
        .MemtoReg(MemtoReg),

        //output
        .WD(WD)
    );

endmodule