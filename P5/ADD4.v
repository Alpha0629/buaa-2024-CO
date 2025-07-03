`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:40:00 11/21/2024 
// Design Name: 
// Module Name:    ADD4 
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
module ADD4 (
    input [31:0] F_ADD4_PC,
    output [31:0] F_ADD4_PC4
);

    assign F_ADD4_PC4 = F_ADD4_PC + 4;
    
endmodule
