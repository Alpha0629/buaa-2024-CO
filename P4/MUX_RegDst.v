`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:00:10 10/29/2024 
// Design Name: 
// Module Name:    MUX_RegDst 
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
module MUX_RegDst(
    input [4:0] Instr20_16,
    input [4:0] Instr15_11,
    input [1:0] RegDst,
	 input temp,
    output reg [4:0] A3
    );

    always @(*) begin
        case(RegDst)
            2'b00: begin
                A3 = Instr20_16;
            end

            2'b01: begin
                A3 = Instr15_11;
            end

            2'b10: begin
                A3 = 5'd31;
            end
				
				2'b11: begin
					if(temp) begin
						A3 = Instr20_16;
					end
					
					else begin
						A3 = 5'd31;
					end
				end
        endcase
    end

endmodule