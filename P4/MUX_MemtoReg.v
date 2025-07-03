`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:12:57 10/29/2024 
// Design Name: 
// Module Name:    MUX_MemtoReg 
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
module MUX_MemtoReg(
    input [31:0] ALUResult,
    input [31:0] ReadData,
    input [31:0] PC4,
    input [1:0] MemtoReg,
    output reg [31:0] WD
    );

    always @(*) begin
        case(MemtoReg)
            2'b00: begin
                WD = ALUResult;
            end

            2'b01: begin
                WD = ReadData;
            end

            2'b10: begin
                WD = PC4;
            end
				
				default: begin
					WD = 32'h12345678;
				end
        endcase

    end

endmodule