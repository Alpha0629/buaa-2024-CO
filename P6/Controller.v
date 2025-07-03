`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:01:58 11/27/2024 
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
    `define and 6'b100100
    `define or 6'b100101
    `define slt 6'b101010
    `define sltu 6'b101011
    `define jr 6'b001000
    `define nop 6'b000000

    `define mult 6'b011000
    `define multu 6'b011001
    `define div 6'b011010
    `define divu 6'b011011
    `define mfhi 6'b010000
    `define mflo 6'b010010
    `define mthi 6'b010001
    `define mtlo 6'b010011

`define addi 6'b001000
`define andi 6'b001100
`define ori 6'b001101
`define lw 6'b100011
`define lh 6'b100001
`define lb 6'b100000
`define sw 6'b101011
`define sh 6'b101001
`define sb 6'b101000
`define beq 6'b000100
`define bne 6'b000101
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
    output [2:0] ALUOp,      //
    output MemWrite,
    output [2:0] MRFWD,  

    output lw,
    output lh,
    output lb,
    output sw,
    output sh,
    output sb,

    output Start,
    output [1:0] MulDiv_Type,
    output [1:0] MulDiv_Write,
    output muldiv,
    
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

    wire add,sub,andd,orr,slt,sltu,addi,andi,ori,beq,bne,lui,jal,jr,nop;
    wire  mult,multu,div,divu,mfhi,mflo,mthi,mtlo;
    //wire lw,lh,lb,sw,sh,sb;

    assign add  = ((opcode == `Rtype) && (funct == `add)) ? 1'b1 : 1'b0;
    assign sub  = ((opcode == `Rtype) && (funct == `sub)) ? 1'b1 : 1'b0;
    assign andd  = ((opcode == `Rtype) && (funct == `and)) ? 1'b1 : 1'b0;
    assign orr   = ((opcode == `Rtype) && (funct == `or))  ? 1'b1 : 1'b0;
    assign slt  = ((opcode == `Rtype) && (funct == `slt)) ? 1'b1 : 1'b0;
    assign sltu = ((opcode == `Rtype) && (funct == `sltu))? 1'b1 : 1'b0;
    assign addi =  (opcode == `addi)                      ? 1'b1 : 1'b0;
    assign andi =  (opcode == `andi)                      ? 1'b1 : 1'b0;
    assign ori  =  (opcode == `ori)                       ? 1'b1 : 1'b0;

    //special judgement
    assign lw   =  (opcode == `lw)                        ? 1'b1 : 1'b0;
    assign lh   =  (opcode == `lh)                        ? 1'b1 : 1'b0;
    assign lb   =  (opcode == `lb)                        ? 1'b1 : 1'b0;
    assign sw   =  (opcode == `sw)                        ? 1'b1 : 1'b0;
    assign sh   =  (opcode == `sh)                        ? 1'b1 : 1'b0;
    assign sb   =  (opcode == `sb)                        ? 1'b1 : 1'b0;


    //regular judgement
    assign beq  =  (opcode == `beq)                       ? 1'b1 : 1'b0;
    assign bne  =  (opcode == `bne)                       ? 1'b1 : 1'b0;
    assign lui  =  (opcode == `lui)                       ? 1'b1 : 1'b0;
    assign jal  =  (opcode == `jal)                       ? 1'b1 : 1'b0;
    assign jr   = ((opcode == `Rtype) && (funct == `jr))  ? 1'b1 : 1'b0;
    assign nop = ((opcode == `Rtype) && (funct == `nop)) ? 1'b1 : 1'b0;

    assign mult = ((opcode == `Rtype) && (funct == `mult))    ? 1'b1 : 1'b0;
    assign multu = ((opcode == `Rtype) && (funct == `multu))  ? 1'b1 : 1'b0;
    assign div = ((opcode == `Rtype) && (funct == `div))      ? 1'b1 : 1'b0;
    assign divu = ((opcode == `Rtype) && (funct == `divu))    ? 1'b1 : 1'b0;
    assign mfhi = ((opcode == `Rtype) && (funct == `mfhi))    ? 1'b1 : 1'b0;
    assign mflo = ((opcode == `Rtype) && (funct == `mflo))    ? 1'b1 : 1'b0;
    assign mthi = ((opcode == `Rtype) && (funct == `mthi))    ? 1'b1 : 1'b0;
    assign mtlo = ((opcode == `Rtype) && (funct == `mtlo))    ? 1'b1 : 1'b0;

    assign muldiv = (mult |  multu | div | divu | mfhi | mflo | mthi | mtlo) ? 1'b1 : 1'b0;

    assign MPC = (beq | bne | jal | jr) ? 1'b1 : 1'b0;
    assign NPCOp = (beq) ? 3'b001 :
                   (bne) ? 3'b010 :
                   (jal) ? 3'b011 :
                   (jr)  ? 3'b100 : 3'b000;

    assign EXTOp = (andi | ori)                           ? 2'b00 :                           //zero extend
                   (addi | lw | lh | lb | sw | sh | sb | sub)  ? 2'b01 :                           //sign extend
                   (lui)                                  ? 2'b10 : 2'b00;                    //lui
    
    assign MRFWA = (addi | andi | ori | lui | lw | lh | lb)                           ? 2'b00 :         //write $rd
                   (add | sub | andd | orr | slt | sltu | mfhi | mflo)                ? 2'b01 :         //write $rt
                   (jal)                                                              ? 2'b10 : 2'b00;  //write $31

    assign RegWrite = (add | sub | andd | orr | slt | sltu | addi | andi | ori | lw | lh | lb | lui | jal | mfhi | mflo) ? 1'b1 : 1'b0;

    assign MALUB = (add | sub | andd | orr | slt | sltu | mult |  multu | div | divu)        ? 1'b0 :                    //select ALUB from GRF
                   (addi | andi | ori | lw | lh | lb | sw | sh | sb | lui)                   ? 1'b1 : 1'b0;              //select ALUB from EXT

    assign ALUOp = (add | addi | lw | sw)  ? 3'b000 :                       //add
                   (sub)                   ? 3'b001 :                        //sub
                   (andd | andi)           ? 3'b010 :                        //and 
                   (orr | ori | lui)       ? 3'b011 :                        //or
                   (slt)                   ? 3'b100 :            
                   (sltu)                  ? 3'b101 : 3'b000;                

    assign MemWrite = (sw | sh | sb) ? 1'b1 : 1'b0;

    assign MRFWD = (add | sub | andd | orr | slt | sltu | addi | andi | ori | lui) ? 3'b000 :    //select WriteData from ALU module
                   (lw | lh | lb)                                                  ? 3'b001 :    //select WriteData from DM module
                   (jal)                                                           ? 3'b010 :    //select WriteData from PC8
                   (mfhi)                                                          ? 3'b011 :    //select WriteData from HI
                   (mflo)                                                          ? 3'b100 : 3'b000;   //select WriteData from LO


    assign Start = (mult | multu | div | divu) ? 1'b1 : 1'b0;

    assign MulDiv_Type = (mult)      ? 2'b00 :
                         (multu)     ? 2'b01 :
                         (div)       ? 2'b10 : 
                         (divu)      ? 2'b11 : 2'b00;

    assign MulDiv_Write = (mthi) ? 2'b01 : 
                          (mtlo) ? 2'b10 : 2'b00;



    
    assign Tuse_RS0 = (beq | bne | jr)                                                                                                                     ? 1'b1 : 1'b0;
    assign Tuse_RS1 = (add | sub | andd | orr | slt | sltu | addi | andi | ori |  lw | lh | lb | sw | sh | sb | mult | multu | div | divu | mthi | mtlo)   ? 1'b1 : 1'b0;
    assign Tuse_RT0 = (beq | bne)                                                                                                                          ? 1'b1 : 1'b0;
    assign Tuse_RT1 = (add | sub | andd | orr | slt | sltu | mult | multu | div | divu)                                                                    ? 1'b1 : 1'b0;
    assign Tuse_RT2 = (sw | sh | sb)                                                                                                    				        ? 1'b1 : 1'b0;



    assign Tnew_E = (lw | lh | lb)                                                                 ? 2'b10 :
                    (add | sub |  andd | orr | slt | sltu | addi | andi | ori | lui | mfhi | mflo) ? 2'b01 : 
                    (jal)                                                                          ? 2'b00 : 2'b00;


    assign Tnew_M = (Tnew_E != 2'b00) ? (Tnew_E - 2'b01) : 2'b00;
    assign Tnew_W = (Tnew_M != 2'b00) ? (Tnew_M - 2'b01) : 2'b00;

    
endmodule