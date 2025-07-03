`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:36 11/21/2024 
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

    output D_CMP_Zero
);
    
    assign D_CMP_Zero = (D_CMP_A == D_CMP_B) ? 1'b1 : 1'b0;

endmodule