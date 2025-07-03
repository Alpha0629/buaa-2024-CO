`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:03:08 12/01/2024 
// Design Name: 
// Module Name:    RegW 
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
module RegW (
    input Clk,
    input Reset,

    input [31:0] M_RegW_Instr,
    input [31:0] M_RegW_PC,

    input [31:0] M_RegW_ALUResult,
    input [31:0] M_RegW_HI,
    input [31:0] M_RegW_LO,
    input [31:0] M_RegW_ReadData,
    input [4:0] M_RegW_A3,


    output reg [31:0] W_RegW_Instr,
    output reg [31:0] W_RegW_PC,

    output reg [31:0] W_RegW_ALUResult,
    output reg [31:0] W_RegW_HI,
    output reg [31:0] W_RegW_LO,
    output reg [31:0] W_RegW_ReadData,
    output reg [4:0] W_RegW_A3
);

    initial begin
        W_RegW_Instr <= 32'h0000_0000;
        W_RegW_PC <= 32'h00003000;

        W_RegW_ALUResult <= 32'h0000_0000;
        W_RegW_HI <= 32'h0000_0000;
        W_RegW_LO <= 32'h0000_0000;
        W_RegW_ReadData <= 32'h0000_0000;
        W_RegW_A3 <= 5'b00000;
    end
    
    always @(posedge Clk) begin
        if(Reset) begin
            W_RegW_Instr <= 32'h0000_0000;
            W_RegW_PC <= 32'h00003000;

            W_RegW_ALUResult <= 32'h0000_0000;
            W_RegW_HI <= 32'h0000_0000;
            W_RegW_LO <= 32'h0000_0000;
            W_RegW_ReadData <= 32'h0000_0000;
            W_RegW_A3 <= 5'b00000;
        end

        else begin
            W_RegW_Instr <= M_RegW_Instr;
            W_RegW_PC <= M_RegW_PC;

            W_RegW_ALUResult <= M_RegW_ALUResult;
            W_RegW_HI <= M_RegW_HI;
            W_RegW_LO <= M_RegW_LO;
            W_RegW_ReadData <= M_RegW_ReadData;
            W_RegW_A3 <= M_RegW_A3;
        end
    end

endmodule