`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:04:42 12/01/2024 
// Design Name: 
// Module Name:    Adventure 
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
module Adventure (
    input [31:0] D_Instr,
    input [31:0] E_Instr,
    input [31:0] M_Instr,
    input [31:0] W_Instr,

    input [4:0] E_A3,
    input [4:0] M_A3,
    input [4:0] W_A3,

    input Busy,   //来自乘除法单元的输入信号

    output PC_Enable,
    output RegD_Enable,
    output RegE_Clr,

    output [3:0] MFRD1D,
    output [3:0] MFRD2D,
    output [3:0] MFALUAE,
    output [3:0] MFALUBE,
    output [3:0] MFWDM   
);
    
    //Prepare Unit//
    wire [4:0] D_RS, D_RT;
    assign D_RS = D_Instr[25:21];
    assign D_RT = D_Instr[20:16];

    wire [4:0] E_RS, E_RT;
    assign E_RS = E_Instr[25:21];
    assign E_RT = E_Instr[20:16];

    wire [4:0] M_RS, M_RT;
    assign M_RS = M_Instr[25:21];
    assign M_RT = M_Instr[20:16];

    wire [4:0] W_RS, W_RT;
    assign W_RS = W_Instr[25:21];
    assign W_RT = W_Instr[20:16];

    
    wire Tuse_RS0,Tuse_RS1,Tuse_RT0,Tuse_RT1,Tuse_RT2;
    wire [1:0] Tnew_E,Tnew_M,Tnew_W;

    wire [2:0] E_MRFWD, M_MRFWD,W_MRFWD;
    wire E_RegWrite,M_RegWrite,W_RegWrite;

    wire muldiv,Start;

    Controller D_controller(
        //input
        .Instr(D_Instr),

        //output
        .muldiv(muldiv),

        .Tuse_RS0(Tuse_RS0),
        .Tuse_RS1(Tuse_RS1),
        .Tuse_RT0(Tuse_RT0),
        .Tuse_RT1(Tuse_RT1),
        .Tuse_RT2(Tuse_RT2)
    );

    Controller E_controller(
        //input
        .Instr(E_Instr),

        //output
        .Start(Start),

        .Tnew_E(Tnew_E),
        .MRFWD(E_MRFWD),
        .RegWrite(E_RegWrite)
    );

    Controller M_controller(
        //input
        .Instr(M_Instr),

        //output
        .Tnew_M(Tnew_M),
        .MRFWD(M_MRFWD),
        .RegWrite(M_RegWrite)
    );

    Controller W_controller(
        //input
        .Instr(W_Instr),

        //output
        .Tnew_W(Tnew_W),
        .MRFWD(W_MRFWD),
        .RegWrite(W_RegWrite)
    );

    //Stop Unit//
    wire Stall_RS0_E1, Stall_RS0_E2, Stall_RS0_M1, Stall_RS1_E2;
    wire Stall_RT0_E1, Stall_RT0,E2, Stall_RT0_M1, Stall_RT1_E2;
    wire Stall_RS, Stall_RT,Stall_MulDiv;
    wire Stall;

    assign Stall_RS0_E1 = ((Tuse_RS0) && (Tnew_E == 2'b01) && (D_RS == E_A3) && (D_RS != 5'b00000) && (E_RegWrite == 1'b1)) ? 1'b1 : 1'b0;
    assign Stall_RS0_E2 = ((Tuse_RS0) && (Tnew_E == 2'b10) && (D_RS == E_A3) && (D_RS != 5'b00000) && (E_RegWrite == 1'b1)) ? 1'b1 : 1'b0;
    assign Stall_RS0_M1 = ((Tuse_RS0) && (Tnew_M == 2'b01) && (D_RS == M_A3) && (D_RS != 5'b00000) && (M_RegWrite == 1'b1)) ? 1'b1 : 1'b0;
    assign Stall_RS1_E2 = ((Tuse_RS1) && (Tnew_E == 2'b10) && (D_RS == E_A3) && (D_RS != 5'b00000) && (E_RegWrite == 1'b1)) ? 1'b1 : 1'b0;

    assign Stall_RT0_E1 = ((Tuse_RT0) && (Tnew_E == 2'b01) && (D_RT == E_A3) && (D_RT != 5'b00000) && (E_RegWrite == 1'b1)) ? 1'b1 : 1'b0;
    assign Stall_RT0_E2 = ((Tuse_RT0) && (Tnew_E == 2'b10) && (D_RT == E_A3) && (D_RT != 5'b00000) && (E_RegWrite == 1'b1)) ? 1'b1 : 1'b0;
    assign Stall_RT0_M1 = ((Tuse_RT0) && (Tnew_M == 2'b01) && (D_RT == M_A3) && (D_RT != 5'b00000) && (M_RegWrite == 1'b1)) ? 1'b1 : 1'b0;
    assign Stall_RT1_E2 = ((Tuse_RT1) && (Tnew_E == 2'b10) && (D_RT == E_A3) && (D_RT != 5'b00000) && (E_RegWrite == 1'b1)) ? 1'b1 : 1'b0;

    assign Stall_RS = (Stall_RS0_E1 | Stall_RS0_E2 | Stall_RS0_M1 | Stall_RS1_E2);
    assign Stall_RT = (Stall_RT0_E1 | Stall_RT0_E2 | Stall_RT0_M1 | Stall_RT1_E2);

    assign Stall_MulDiv = (muldiv) && (Start | Busy);

    assign Stall = (Stall_RS | Stall_RT | Stall_MulDiv);

    assign PC_Enable    = (!Stall);
    assign RegD_Enable  = (!Stall);
    assign RegE_Clr     = (Stall);


    //Forward Unit//
    assign MFRD1D = ((D_RS == E_A3) && (D_RS != 5'b00000) && (E_RegWrite == 1'b1) && (E_MRFWD == 3'b010)) ? 4'b1010 :   //E_PC8
                    ((D_RS == M_A3) && (D_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b010)) ? 4'b1001 :   //M_PC8
                    ((D_RS == M_A3) && (D_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b000)) ? 4'b1000 :   //M_ALU
                    ((D_RS == M_A3) && (D_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b011)) ? 4'b0111 :   //M_HI
                    ((D_RS == M_A3) && (D_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b100)) ? 4'b0110 :   //M_LO
                    ((D_RS == W_A3) && (D_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b010)) ? 4'b0101 :   //W_PC8
                    ((D_RS == W_A3) && (D_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b001)) ? 4'b0100 :   //W_DM
                    ((D_RS == W_A3) && (D_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b000)) ? 4'b0011 :   //W_ALU
                    ((D_RS == W_A3) && (D_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b011)) ? 4'b0010 :   //W_HI
                    ((D_RS == W_A3) && (D_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b100)) ? 4'b0001 :   4'b0000;   //W_LO

    assign MFRD2D = ((D_RT == E_A3) && (D_RT != 5'b00000) && (E_RegWrite == 1'b1) && (E_MRFWD == 3'b010)) ? 4'b1010 :   //E_PC8
                    ((D_RT == M_A3) && (D_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b010)) ? 4'b1001 :   //M_PC8
                    ((D_RT == M_A3) && (D_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b000)) ? 4'b1000 :   //M_ALU
                    ((D_RT == M_A3) && (D_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b011)) ? 4'b0111 :   //M_HI
                    ((D_RT == M_A3) && (D_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b100)) ? 4'b0110 :   //M_LO
                    ((D_RT == W_A3) && (D_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b010)) ? 4'b0101 :   //W_PC8
                    ((D_RT == W_A3) && (D_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b001)) ? 4'b0100 :   //W_DM
                    ((D_RT == W_A3) && (D_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b000)) ? 4'b0011 :   //W_ALU
                    ((D_RT == W_A3) && (D_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b011)) ? 4'b0010 :   //W_HI
                    ((D_RT == W_A3) && (D_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b100)) ? 4'b0001 :   4'b0000;   //W_LO


    assign MFALUAE = ((E_RS == M_A3) && (E_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b010)) ? 4'b0101 :      //M_PC8
                     ((E_RS == M_A3) && (E_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b000)) ? 4'b0100 :      //M_ALU
                     ((E_RS == M_A3) && (E_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b011)) ? 4'b0011 :      //M_HI
                     ((E_RS == M_A3) && (E_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b100)) ? 4'b0010 :      //M_LO
                     ((E_RS == W_A3) && (E_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b001)) ? 4'b0001 : 4'b0000;    //W_DM

    assign MFALUBE = ((E_RT == M_A3) && (E_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b010)) ? 4'b0101 :      //M_PC8
                     ((E_RT == M_A3) && (E_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b000)) ? 4'b0100 :      //M_ALU
                     ((E_RT == M_A3) && (E_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b011)) ? 4'b0011 :      //M_HI
                     ((E_RT == M_A3) && (E_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 3'b100)) ? 4'b0010 :      //M_LO
                     ((E_RT == W_A3) && (E_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b001)) ? 4'b0001 : 4'b0000;    //W_DM

   
    assign MFWDM = ((M_RT == W_A3) && (M_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 3'b001)) ? 4'b0001 : 4'b0000;   //W_DM

endmodule