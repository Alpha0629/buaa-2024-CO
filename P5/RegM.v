`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:37 11/21/2024 
// Design Name: 
// Module Name:    RegM 
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
module RegM (
    input Clk,
    input Reset,

    input [31:0] E_RegM_Instr,
    input [31:0] E_RegM_PC,

    input [31:0] E_RegM_ALUResult,
    input [31:0] E_RegM_WriteData,
    input [4:0] E_RegM_A3,


    output reg [31:0] M_RegM_Instr,
    output reg [31:0] M_RegM_PC,

    output reg [31:0] M_RegM_ALUResult,
    output reg [31:0] M_RegM_WriteData,
    output reg [4:0] M_RegM_A3
);

    initial begin
        M_RegM_Instr <= 32'h0000_0000;
        M_RegM_PC <= 32'h00003000;

        M_RegM_ALUResult <= 32'h0000_0000;
        M_RegM_WriteData <= 32'h0000_0000;
        M_RegM_A3 <= 5'b00000;
    end
    
    always @(posedge Clk) begin
        if(Reset) begin
            M_RegM_Instr <= 32'h0000_0000;
            M_RegM_PC <= 32'h0000_3000;

            M_RegM_ALUResult <= 32'h0000_0000;
            M_RegM_WriteData <= 32'h0000_0000;
            M_RegM_A3 <= 5'b00000;
        end

        else begin
            M_RegM_Instr <= E_RegM_Instr;
            M_RegM_PC <= E_RegM_PC;

            M_RegM_ALUResult <= E_RegM_ALUResult;
            M_RegM_WriteData <= E_RegM_WriteData;
            M_RegM_A3 <= E_RegM_A3;
        end
        
    end
    
endmodule