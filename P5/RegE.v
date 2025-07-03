`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:48:44 11/21/2024 
// Design Name: 
// Module Name:    RegE 
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
module RegE (
    input Clk,
    input Reset,
    input E_RegE_Clr,

    input [31:0] D_RegE_Instr,
    input [31:0] D_RegE_PC,

    input [31:0] D_RegE_RD1,
    input [31:0] D_RegE_RD2,
    input [4:0] D_RegE_A3,
    input [31:0] D_RegE_EXTImm,

    
    output reg [31:0] E_RegE_Instr,
    output reg [31:0] E_RegE_PC,

    output reg [31:0] E_RegE_RD1,
    output reg [31:0] E_RegE_RD2,
    output reg [4:0] E_RegE_A3,
    output reg [31:0] E_RegE_EXTImm

);

    initial begin
        E_RegE_Instr <= 32'h0000_0000;
        E_RegE_PC <= 32'h00003000;

        E_RegE_RD1 <= 32'h0000_0000;
        E_RegE_RD2 <= 32'h0000_0000;
        E_RegE_A3 <= 5'b00000;
        E_RegE_EXTImm <= 32'h0000_0000;
    end
    
    always @(posedge Clk) begin
        if(Reset || E_RegE_Clr) begin
            E_RegE_Instr <= 32'h0000_0000;
            E_RegE_PC <= 32'h00003000;

            E_RegE_RD1 <= 32'h0000_0000;
            E_RegE_RD2 <= 32'h0000_0000;
            E_RegE_A3 <= 5'b00000;
            E_RegE_EXTImm <= 32'h0000_0000;
        end

        else begin
            E_RegE_Instr <= D_RegE_Instr;
            E_RegE_PC <= D_RegE_PC;

            E_RegE_RD1 <= D_RegE_RD1;
            E_RegE_RD2 <= D_RegE_RD2;
            E_RegE_A3 <= D_RegE_A3;
            E_RegE_EXTImm <= D_RegE_EXTImm;
        end 
    end
    
endmodule