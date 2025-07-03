`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:56:38 11/21/2024 
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
module mips (
    input clk,
    input reset
);
    
    wire [31:0] D_Instr,E_Instr,M_Instr,W_Instr;
    wire [4:0] E_A3,M_A3,W_A3;
    wire [2:0] MFRD1D,MFRD2D,MFALUAE,MFALUBE,MFWDM;
    wire PC_Enable,RegD_Enable,RegE_Clr;
    
    Datapath datapath(
        //input
        .Clk(clk),
        .Reset(reset),

        .PC_Enable(PC_Enable),
        .RegD_Enable(RegD_Enable),
        .RegE_Clr(RegE_Clr),

        .MFRD1D(MFRD1D),
        .MFRD2D(MFRD2D),
        .MFALUAE(MFALUAE),
        .MFALUBE(MFALUBE),
        .MFWDM(MFWDM),

        //output
        .D_Instr(D_Instr),
        .E_Instr(E_Instr),
        .M_Instr(M_Instr),
        .W_Instr(W_Instr),

        .E_A3(E_A3),
        .M_A3(M_A3),
        .W_A3(W_A3)
    );

    Adventure adventure(
        //input
        .D_Instr(D_Instr),
        .E_Instr(E_Instr),
        .M_Instr(M_Instr),
        .W_Instr(W_Instr),

        .E_A3(E_A3),
        .M_A3(M_A3),
        .W_A3(W_A3),


        //output
        .PC_Enable(PC_Enable),
        .RegD_Enable(RegD_Enable),
        .RegE_Clr(RegE_Clr),

        .MFRD1D(MFRD1D),
        .MFRD2D(MFRD2D),
        .MFALUAE(MFALUAE),
        .MFALUBE(MFALUBE),
        .MFWDM(MFWDM)
    );

endmodule