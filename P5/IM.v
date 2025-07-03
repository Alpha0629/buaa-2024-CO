`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:46:07 11/21/2024 
// Design Name: 
// Module Name:    IM 
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
module IM (
    input [31:0] F_IM_PC,
    output [31:0] F_IM_Instr
);
    
    reg [31:0] ROM [0:4095];
	wire [31:0] addr;

    initial begin
        $readmemh("code.txt", ROM);
    end

	assign addr = F_IM_PC - 32'h00003000;
    assign F_IM_Instr = ROM[addr[13:2]];   // /4


endmodule