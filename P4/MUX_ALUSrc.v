`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:44 10/29/2024 
// Design Name: 
// Module Name:    MUX_ALUSrc 
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
module MUX_ALUSrc(
    input [31:0] RD2,
    input [31:0] EXTImm,
    input ALUSrc,
    output reg [31:0] SrcB
    );

    always @(*) begin
        case(ALUSrc)
            1'b0: begin
                SrcB = RD2;
            end

            1'b1: begin
                SrcB = EXTImm;
            end
        endcase
    end


endmodule
