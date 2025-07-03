`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:02:38 11/27/2024 
// Design Name: 
// Module Name:    CMP 
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
module CMP (
    input [31:0] D_CMP_A,
    input [31:0] D_CMP_B,

    output D_CMP_Beq,
    output D_CMP_Bne
);
    
    assign D_CMP_Beq = (D_CMP_A == D_CMP_B) ? 1'b1 : 1'b0;     //jump while equal
    assign D_CMP_Bne = (D_CMP_A != D_CMP_B) ? 1'b1 : 1'b0;     //jump while not equal

endmodule