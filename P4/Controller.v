`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:27 10/29/2024 
// Design Name: 
// Module Name:    Controller 
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
`define Rtype 6'b000000
    `define add 6'b100000
    `define sub 6'b100010
    `define jr 6'b001000
    `define nop 6'b000000

`define ori 6'b001101
`define lw 6'b100011
`define sw 6'b101011
`define beq 6'b000100
`define lui 6'b001111
`define jal 6'b000011


module Controller(
    input [5:0] opcode,
    input [5:0] funct,
    output reg [2:0] NPCOp,
    output reg [1:0] EXTOp,
    output reg [1:0] RegDst,
    output reg RegWrite,
    output reg ALUSrc,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg [1:0] MemtoReg
    );

    always @(*) begin
        case(opcode)
            `Rtype:
                case(funct)
                    `add: begin
                        NPCOp = 3'b000;
                        EXTOp = 2'b00;
                        RegDst = 2'b01;
                        RegWrite = 1'b1;
                        ALUSrc = 1'b0;
                        ALUOp = 2'b00;
                        MemWrite = 1'b0;
                        MemtoReg = 2'b00;
                    end

                    `sub: begin
                        NPCOp = 3'b000;
                        EXTOp = 2'b00;
                        RegDst = 2'b01;
                        RegWrite = 1'b1;
                        ALUSrc = 1'b0;
                        ALUOp = 2'b01;
                        MemWrite = 1'b0;
                        MemtoReg = 2'b00;
                    end

                    `jr: begin
                        NPCOp = 3'b011;
                        EXTOp = 2'b00;
                        RegDst = 2'b00;
                        RegWrite = 1'b0;
                        ALUSrc = 1'b0;
                        ALUOp = 2'b00;
                        MemWrite = 1'b0;
                        MemtoReg = 2'b00;
                    end

                    `nop: begin
                        NPCOp = 3'b000;
                        EXTOp = 2'b00;
                        RegDst = 2'b00;
                        RegWrite = 1'b0;
                        ALUSrc = 1'b0;
                        ALUOp = 2'b00;
                        MemWrite = 1'b0;
                        MemtoReg = 2'b00;
                    end
                endcase
            
            `ori: begin
                NPCOp = 3'b000;
                EXTOp = 2'b00;
                RegDst = 2'b00;
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 2'b10;
                MemWrite = 1'b0;
                MemtoReg = 2'b00;
            end

            `lw: begin
                NPCOp = 3'b000;
                EXTOp = 2'b01;
                RegDst = 2'b00;
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                MemtoReg = 2'b01;
            end

            `sw: begin
                NPCOp = 3'b000;
                EXTOp = 2'b01;
                RegDst = 2'b00;
                RegWrite = 1'b0;
                ALUSrc = 1'b1;
                ALUOp = 2'b00;
                MemWrite = 1'b1;
                MemtoReg = 2'b00;
            end

            `beq: begin
                NPCOp = 3'b001;
                EXTOp = 2'b00;
                RegDst = 2'b00;
                RegWrite = 1'b0;
                ALUSrc = 1'b0;
                ALUOp = 2'b01;
                MemWrite = 1'b0;
                MemtoReg = 2'b00;
            end

            `lui: begin
                NPCOp = 3'b000;
                EXTOp = 2'b10;
                RegDst = 2'b00;
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 2'b10;
                MemWrite = 1'b0;
                MemtoReg = 2'b00;
            end

            `jal: begin
                NPCOp = 3'b010;
                EXTOp = 2'b00;
                RegDst = 2'b10;
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                MemtoReg = 2'b10;
            end

        endcase

    end

endmodule