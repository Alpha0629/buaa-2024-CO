`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:11:58 10/29/2024 
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
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [1:0] ALUOp,
    output reg [31:0] ALUResult,
    output Zero
    );
	 
	assign Zero = (SrcA == SrcB) ? 1'b1 : 1'b0;
    
    always @(*) begin
        case(ALUOp)
            2'b00:  ALUResult = SrcA + SrcB;
            2'b01:  ALUResult = SrcA - SrcB;
            2'b10:  ALUResult = SrcA | SrcB;
            default:  ALUResult = 32'h12345678;
        endcase
    end
			
endmodule
