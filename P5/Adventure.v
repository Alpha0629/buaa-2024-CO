`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:40:38 11/21/2024 
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

    output PC_Enable,
    output RegD_Enable,
    output RegE_Clr,

    output [2:0] MFRD1D,
    output [2:0] MFRD2D,
    output [2:0] MFALUAE,
    output [2:0] MFALUBE,
    output [2:0] MFWDM   
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

    wire [1:0] E_MRFWD, M_MRFWD, W_MRFWD;
    wire E_RegWrite,M_RegWrite,W_RegWrite;

    Controller D_controller(
        //input
        .Instr(D_Instr),

        //output
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
    wire Stall_RS, Stall_RT;
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

    assign Stall = (Stall_RS | Stall_RT);

    assign PC_Enable    = (!Stall);
    assign RegD_Enable  = (!Stall);
    assign RegE_Clr     = (Stall);


    //Forward Unit//
    assign MFRD1D = ((D_RS == E_A3) && (D_RS != 5'b00000) && (E_RegWrite == 1'b1) && (E_MRFWD == 2'b10)) ? 3'b110 :
                    ((D_RS == M_A3) && (D_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 2'b10)) ? 3'b101 :
                    ((D_RS == M_A3) && (D_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 2'b00)) ? 3'b100 :
                    ((D_RS == W_A3) && (D_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 2'b10)) ? 3'b011 :
                    ((D_RS == W_A3) && (D_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 2'b01)) ? 3'b010 :
                    ((D_RS == W_A3) && (D_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 2'b00)) ? 3'b001 : 3'b000;

    assign MFRD2D = ((D_RT == E_A3) && (D_RT != 5'b00000) && (E_RegWrite == 1'b1) && (E_MRFWD == 2'b10)) ? 3'b110 :
                    ((D_RT == M_A3) && (D_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 2'b10)) ? 3'b101 :
                    ((D_RT == M_A3) && (D_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 2'b00)) ? 3'b100 :
                    ((D_RT == W_A3) && (D_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 2'b10)) ? 3'b011 :
                    ((D_RT == W_A3) && (D_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 2'b01)) ? 3'b010 :
                    ((D_RT == W_A3) && (D_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 2'b00)) ? 3'b001 : 3'b000;

    assign MFALUAE = ((E_RS == M_A3) && (E_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 2'b10)) ? 3'b011:
                     ((E_RS == M_A3) && (E_RS != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 2'b00)) ? 3'b010 :
                     ((E_RS == W_A3) && (E_RS != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 2'b01)) ? 3'b001 : 3'b000;

    assign MFALUBE = ((E_RT == M_A3) && (E_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 2'b10)) ? 3'b011:
                     ((E_RT == M_A3) && (E_RT != 5'b00000) && (M_RegWrite == 1'b1) && (M_MRFWD == 2'b00)) ? 3'b010 :
                     ((E_RT == W_A3) && (E_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 2'b01)) ? 3'b001 : 3'b000;

    assign MFWDM = ((M_RT == W_A3) && (M_RT != 5'b00000) && (W_RegWrite == 1'b1) && (W_MRFWD == 2'b01)) ? 3'b001 : 3'b000;

endmodule