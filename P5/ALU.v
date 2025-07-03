`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:57 11/21/2024 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] E_ALU_A,
    input [31:0] E_ALU_B,
    input [1:0] E_ALU_ALUOp,

    output reg [31:0] E_ALU_ALUResult
);

    always @(*) begin
        case (E_ALU_ALUOp)
            2'b00: E_ALU_ALUResult = E_ALU_A + E_ALU_B;
            2'b01: E_ALU_ALUResult = E_ALU_A - E_ALU_B;
            2'b10: E_ALU_ALUResult = E_ALU_A | E_ALU_B;
            default: E_ALU_ALUResult = 32'hffffffff;
        endcase
    end
    
endmodule
