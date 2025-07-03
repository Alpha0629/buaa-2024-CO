`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:05 10/29/2024 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [15:0] Imm16,
    input [1:0] EXTOp,
    output reg [31:0] EXTImm
    );

    always @(*) begin
        case(EXTOp)
            2'b00:  EXTImm = {{16{1'b0}},Imm16};
            2'b01:  EXTImm = {{16{Imm16[15]}},Imm16};
            2'b10:  EXTImm = {Imm16,{16{1'b0}}};
            default:  EXTImm = 32'h12345678;
        endcase
    end


endmodule