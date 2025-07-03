`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:58 11/21/2024 
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

module Controller (
    input [31:0] Instr,

    output MPC,        
    output [2:0] NPCOp,
    output [1:0] EXTOp,
    output [1:0] MRFWA,  
    output RegWrite,
    output MALUB,
    output [1:0] ALUOp,
    output MemWrite,
    output [1:0] MRFWD,  

    output Tuse_RS0, 
    output Tuse_RS1, 
    output Tuse_RT0, 
    output Tuse_RT1, 
    output Tuse_RT2,

    output [1:0] Tnew_E, 
    output [1:0] Tnew_M, 
    output [1:0] Tnew_W
);
    wire [5:0] opcode,funct;
    assign opcode = Instr[31:26];
    assign funct = Instr[5:0];

    wire add,sub,ori,lw,sw,beq,lui,jal,jr,nop;
    assign add = ((opcode == `Rtype) && (funct == `add)) ? 1'b1 : 1'b0;
    assign sub = ((opcode == `Rtype) && (funct == `sub)) ? 1'b1 : 1'b0;
    assign ori =  (opcode == `ori)                       ? 1'b1 : 1'b0;
    assign lw  =  (opcode == `lw)                        ? 1'b1 : 1'b0;
    assign sw  =  (opcode == `sw)                        ? 1'b1 : 1'b0;
    assign beq =  (opcode == `beq)                       ? 1'b1 : 1'b0;
    assign lui =  (opcode == `lui)                       ? 1'b1 : 1'b0;
    assign jal =  (opcode == `jal)                       ? 1'b1 : 1'b0;
    assign jr  = ((opcode == `Rtype) && (funct == `jr))  ? 1'b1 : 1'b0;
    assign nop = ((opcode == `Rtype) && (funct == `nop)) ? 1'b1 : 1'b0;


    assign MPC = (beq | jal | jr) ? 1'b1 : 1'b0;
    assign NPCOp = (beq) ? 3'b001 :
                   (jal) ? 3'b010 :
                   (jr)  ? 3'b011 : 3'b000;

    assign EXTOp = (ori)      ? 2'b00 : 
                   (lw | sw)  ? 2'b01 :
                   (lui)      ? 2'b10 : 2'b00;
    
    assign MRFWA = (ori | lui | lw) ? 2'b00 : 
                   (add | sub)      ? 2'b01 :
                   (jal)            ? 2'b10 : 2'b00;

    assign RegWrite = (add | sub | ori | lw | lui | jal) ? 1'b1 : 1'b0;

    assign MALUB = (add | sub)           ? 1'b0 :
                   (ori | lw | sw | lui) ? 1'b1 : 1'b0;

    assign ALUOp = (add | lw | sw) ? 2'b00 :
                   (sub)           ? 2'b01 : 
                   (ori | lui)     ? 2'b10 : 2'b00;

    assign MemWrite = sw ? 1'b1 : 1'b0;

    assign MRFWD = (add | sub | ori | lui) ? 2'b00 :
                   (lw)                    ? 2'b01 : 
                   (jal)                   ? 2'b10 : 2'b00;


    
    assign Tuse_RS0 = (beq | jr)                        ? 1'b1 : 1'b0;
    assign Tuse_RS1 = (add | sub | ori | lw | sw ) ? 1'b1 : 1'b0;
    assign Tuse_RT0 = (beq)                             ? 1'b1 : 1'b0;
    assign Tuse_RT1 = (add | sub)                       ? 1'b1 : 1'b0;
    assign Tuse_RT2 = (sw)                              ? 1'b1 : 1'b0;



    assign Tnew_E = (lw)                    ? 2'b10 :
                    (add | sub | ori | lui) ? 2'b01 : 
                    (jal)                   ? 2'b00 : 2'b00;
    assign Tnew_M = (Tnew_E != 2'b00) ? (Tnew_E - 2'b01) : 2'b00;
    assign Tnew_W = (Tnew_M != 2'b00) ? (Tnew_M - 2'b01) : 2'b00;

    
endmodule