`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:46:39 11/21/2024 
// Design Name: 
// Module Name:    NPC 
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
`define beq 3'b001
`define jal 3'b010
`define jr 3'b011
module NPC (
    input [31:0] D_NPC_PC,
    input [25:0] D_NPC_Imm26,
    input [15:0] D_NPC_Imm16,
    input [31:0] D_NPC_RA,
    input D_NPC_Zero,
    input [2:0] NPCOp,

    output reg [31:0] D_NPC_NPC
);
    always @(*) begin
        case(NPCOp) 
            `beq: begin   
                if(D_NPC_Zero) begin
                    D_NPC_NPC = D_NPC_PC + 32'd4 + {{14{D_NPC_Imm16[15]}}, D_NPC_Imm16, 2'b00};
                end

                else begin
                    D_NPC_NPC = D_NPC_PC + 32'd8;
                end
            end
            
            `jal: begin   
                D_NPC_NPC = {{D_NPC_PC[31:28]},{D_NPC_Imm26},{2'b0}};
            end

            `jr: begin   
                D_NPC_NPC = D_NPC_RA;
            end

            default: begin
                D_NPC_NPC = 32'h12345678;
            end

        endcase
    end


endmodule
