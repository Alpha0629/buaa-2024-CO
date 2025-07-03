`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:16 10/29/2024 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
    input Clk,
    input Reset,
    input [2:0] NPCOp,//////
    input Zero,
    input [31:0] RA,
    output [31:0] Instr,
    output reg [31:0] PC,
    output [31:0] PC4
    );

    reg [31:0] ROM [0:4095];
	 wire [31:0] addr;

    initial begin
        PC = 32'h00003000;
        $readmemh("code.txt", ROM);
    end

    assign PC4 = PC + 4;
	 assign addr = PC - 32'h00003000;
    assign Instr = ROM[addr[13:2]];

    always @(posedge Clk) begin
        if(Reset) begin
            PC <= 32'h00003000;
        end

        else begin
            case(NPCOp)
                3'b000: begin
                    PC <= PC + 4;
                end

                3'b001: begin
                    if(Zero) begin
                        PC <= {{14{Instr[15]}},{Instr[15:0]},{2'b00}} + PC + 4;
                    end

                    else begin
                        PC <= PC +4;
                    end
                end

                3'b010: begin
                    PC <= {{PC[31:28]},{Instr[25:0]},{2'b0}};
                end

                3'b011: begin
                    PC <= RA;
                end
					 
					 3'b100: begin
						  //PC <= 
					 end
					 
            endcase
        end
    end

endmodule