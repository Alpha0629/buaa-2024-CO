`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:47:57 11/21/2024 
// Design Name: 
// Module Name:    RegD 
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
module RegD (
    input Clk,
    input Reset,
    input D_RegD_Enable,

    input [31:0] F_RegD_Instr,
    input [31:0] F_RegD_PC,

    output reg [31:0] D_RegD_Instr,
    output reg [31:0] D_RegD_PC
);

    initial begin
        D_RegD_Instr = 32'h0000_0000;
        D_RegD_PC = 32'h0000_3000;
    end
    
    always @(posedge Clk) begin
        if(Reset) begin
            D_RegD_Instr <= 32'h0000_0000;
            D_RegD_PC <= 32'h0000_3000;
        end
        
        else begin
            if(D_RegD_Enable) begin
                D_RegD_Instr <= F_RegD_Instr;
                D_RegD_PC <= F_RegD_PC;
            end
        end
    end
    
endmodule