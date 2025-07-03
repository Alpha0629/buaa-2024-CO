`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:02:51 11/27/2024 
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
module EXT (
    input [15:0] D_EXT_Imm16,
    input [1:0] D_EXT_EXTOp,

    output reg [31:0] D_EXT_EXTImm
);

    always @(*) begin
        case (D_EXT_EXTOp)
            2'b00: D_EXT_EXTImm = {{16{1'b0}},D_EXT_Imm16};  //zero extend
            2'b01: D_EXT_EXTImm = {{16{D_EXT_Imm16[15]}},D_EXT_Imm16};  //sign extend
            2'b10: D_EXT_EXTImm = {D_EXT_Imm16,{16{1'b0}}};  //lui
            default: D_EXT_EXTImm = 32'hffffffff;
        endcase
        
    end
    
endmodule
