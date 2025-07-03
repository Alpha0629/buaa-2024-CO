`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:01:44 11/27/2024 
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
    input [2:0] E_ALU_ALUOp,

    output reg [31:0] E_ALU_ALUResult
);

    always @(*) begin
        case (E_ALU_ALUOp)
            3'b000: E_ALU_ALUResult = E_ALU_A + E_ALU_B;
            3'b001: E_ALU_ALUResult = E_ALU_A - E_ALU_B;
            3'b010: E_ALU_ALUResult = E_ALU_A & E_ALU_B;
            3'b011: E_ALU_ALUResult = E_ALU_A | E_ALU_B;
            3'b100: E_ALU_ALUResult = $signed(E_ALU_A) < $signed(E_ALU_B);     //slt
            3'b101: E_ALU_ALUResult = E_ALU_A < E_ALU_B;                       //sltu
            default: E_ALU_ALUResult = 32'hffffffff;
        endcase
    end
    
endmodule