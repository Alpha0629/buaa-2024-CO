`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:12:11 12/01/2024 
// Design Name: 
// Module Name:    Datapath 
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
module Datapath (
    input Clk,
    input Reset,

    input PC_Enable,
    input RegD_Enable,
    input RegE_Clr,

    input [3:0] MFRD1D,
    input [3:0] MFRD2D,
    input [3:0] MFALUAE,
    input [3:0] MFALUBE,
    input [3:0] MFWDM,

    input [31:0] i_inst_raddr,
    input [31:0] m_data_rdata,


    output [31:0] D_Instr,
    output [31:0] E_Instr,
    output [31:0] M_Instr,
    output [31:0] W_Instr,

    output [4:0] E_A3,
    output [4:0] M_A3,
    output [4:0] W_A3,

    output Busy,
    
    output [31:0] i_inst_addr,

    output [31:0] m_data_addr,
    output [3:0] m_data_byteen,
    output [31:0] m_data_wdata,
    output [31:0] m_inst_addr,

    output w_grf_we,           //W_RegWrite
    output [4:0] w_grf_addr,   //W_A3
    output [31:0] w_grf_wdata, //W_RFWD
    output [31:0] w_inst_addr  //W_PC
);

    wire [31:0] F_NextPC,/*F_PC,F_Instr,*/F_PC4,D_NPC,D_PC,E_PC,M_PC;//W_PC
    wire [31:0] D_RD1,D_RD2,D_FRD1,D_FRD2,D_EXTImm,E_FRD1,E_FRD2,E_EXTImm,E_FALUA,E_FALUB,E_ALUB,E_ALUResult,M_ALUResult,M_WriteData,M_FWD,M_ReadData,W_ALUResult,W_ReadData;//W_RFWD
    wire [31:0] E_HI,E_LO,M_HI,M_LO,W_HI,W_LO;
    wire MPC,Beq,Bne,/*W_RegWrite,*/MALUB,MemWrite;
    wire Start;
    wire lw,lh,lb,sw,sh,sb;
    wire [1:0] MulDiv_Type,MulDiv_Write;
    wire [1:0] EXTOp,MRFWA;
    wire [2:0] NPCOp,ALUOp,W_MRFWD;
    wire [4:0] D_A3;
    
    //F
    PC pc(
        //input
        .Clk(Clk),
        .Reset(Reset),
        .F_PC_Enable(PC_Enable),

        .F_PC_NextPC(F_NextPC), //next pc

        //output
        .F_PC_PC(i_inst_addr) //current pc
    );

    /*IM im(
        //input
        .F_IM_PC(F_PC),

        //output
        .F_IM_Instr(F_Instr)
    );*/


    ADD4 add4(
        //input
        .F_ADD4_PC(i_inst_addr),

        //output
        .F_ADD4_PC4(F_PC4)
    );

    MPC mpc(
        //input
        .MPC(MPC),
        .NPC(D_NPC),
        .PC4(F_PC4),

        //output
        .NextPC(F_NextPC)
    );


    //D
    RegD regd(
        //input
        .Clk(Clk),
        .Reset(Reset),
        .D_RegD_Enable(RegD_Enable),

        .F_RegD_Instr(i_inst_raddr),
        .F_RegD_PC(i_inst_addr),

        //output
        .D_RegD_Instr(D_Instr),
        .D_RegD_PC(D_PC)
    );

    Controller D_CU(
        //input
        .Instr(D_Instr),

        //output
        .MPC(MPC),
        .NPCOp(NPCOp),
        .EXTOp(EXTOp),
        .MRFWA(MRFWA)
    );

    GRF grf(
        //input
        .Clk(Clk),
        .Reset(Reset),

        .D_GRF_A1(D_Instr[25:21]),
        .D_GRF_A2(D_Instr[20:16]),
        .D_GRF_A3(w_grf_addr),        //W_A3
    
        .D_GRF_RegWrite(w_grf_we),    //W_RegWrite
        .D_GRF_RFWD(w_grf_wdata),     //W_RFWD
        .D_GRF_PC(w_inst_addr),       //W_PC

        //output
        .D_GRF_RD1(D_RD1),
        .D_GRF_RD2(D_RD2)
    );

    MRFWA mrfwa(
        //input
        .D_Instr20_16(D_Instr[20:16]),
        .D_Instr15_11(D_Instr[15:11]),
        .D_MRFWA(MRFWA),

        //output
        .A3(D_A3)
    );

    EXT ext(
        //input
        .D_EXT_Imm16(D_Instr[15:0]),
        .D_EXT_EXTOp(EXTOp),

        //output
        .D_EXT_EXTImm(D_EXTImm)
    );

    MFRD1D mfrd1d(
        //input
        .D_RD1(D_RD1),
        .W_LO(W_LO),
        .W_HI(W_HI),
        .W_ALUResult(W_ALUResult),
        .W_ReadData(W_ReadData),
        .W_PC(w_inst_addr),
        .M_LO(M_LO),
        .M_HI(M_HI),
        .M_ALUResult(M_ALUResult),
        .M_PC(M_PC),
        .E_PC(E_PC),

        .MFRD1D(MFRD1D),

        //output
        .D_FRD1(D_FRD1)
    );

    MFRD2D mfrd2d(
        //input
        .D_RD2(D_RD2),
        .W_LO(W_LO),
        .W_HI(W_HI),
        .W_ALUResult(W_ALUResult),
        .W_ReadData(W_ReadData),
        .W_PC(w_inst_addr),
        .M_LO(M_LO),
        .M_HI(M_HI),
        .M_ALUResult(M_ALUResult),
        .M_PC(M_PC),
        .E_PC(E_PC),

        .MFRD2D(MFRD2D),

        //output
        .D_FRD2(D_FRD2)
    );

    CMP cmp(
        //input
        .D_CMP_A(D_FRD1),
        .D_CMP_B(D_FRD2),

        //output
        .D_CMP_Beq(Beq),
        .D_CMP_Bne(Bne)
    );

    NPC npc(
        //input
        .D_NPC_PC(D_PC),
        .D_NPC_Imm26(D_Instr[25:0]),
        .D_NPC_Imm16(D_Instr[15:0]),
        .D_NPC_RA(D_FRD1),
        .D_NPC_Beq(Beq),
        .D_NPC_Bne(Bne),
        .NPCOp(NPCOp),

        //output
        .D_NPC_NPC(D_NPC)
    );
    

    //E
    RegE rege(
        //input
        .Clk(Clk),
        .Reset(Reset),
        .E_RegE_Clr(RegE_Clr),

        .D_RegE_Instr(D_Instr),
        .D_RegE_PC(D_PC),

        .D_RegE_RD1(D_FRD1),
        .D_RegE_RD2(D_FRD2),
        .D_RegE_A3(D_A3),
        .D_RegE_EXTImm(D_EXTImm),


        //output
        .E_RegE_Instr(E_Instr),
        .E_RegE_PC(E_PC),

        .E_RegE_RD1(E_FRD1),
        .E_RegE_RD2(E_FRD2),
        .E_RegE_A3(E_A3),
        .E_RegE_EXTImm(E_EXTImm)
    );

    Controller E_CU(
        //input
        .Instr(E_Instr),
        
        //output
        .MALUB(MALUB),
        .ALUOp(ALUOp),
        .Start(Start),
        .MulDiv_Type(MulDiv_Type),
        .MulDiv_Write(MulDiv_Write)
    );

    MFALUAE mfaluae(
        //input
        .E_RD1(E_FRD1),
        .W_ReadData(W_ReadData),
        .M_LO(M_LO),
        .M_HI(M_HI),
        .M_ALUResult(M_ALUResult),
        .M_PC(M_PC),
        .MFALUAE(MFALUAE),

        //output
        .E_FALUA(E_FALUA)
    );

    MFALUBE mfalube(
        //input
        .E_RD2(E_FRD2),
        .W_ReadData(W_ReadData),
        .M_LO(M_LO),
        .M_HI(M_HI),
        .M_ALUResult(M_ALUResult),
        .M_PC(M_PC),
        .MFALUBE(MFALUBE),

        //output
        .E_FALUB(E_FALUB)
    );

    MALUB malub(
        //input
        .E_FALUB(E_FALUB),
        .E_EXTImm(E_EXTImm),
        .E_MALUB(MALUB),


        //output
        .ALUB(E_ALUB)
    );

    ALU alu(
        //input
        .E_ALU_A(E_FALUA),
        .E_ALU_B(E_ALUB),
        .E_ALU_ALUOp(ALUOp),


        //output
        .E_ALU_ALUResult(E_ALUResult)
    );

    MulDiv muldiv(
        .Clk(Clk),
        .Reset(Reset),

        .E_MulDiv_A(E_FALUA),
        .E_MulDiv_B(E_ALUB),
        .E_MulDiv_Type(MulDiv_Type),         //乘除法计算指令类型:mult,multu,div,divu
        .E_MulDiv_Start(Start),
        .E_MulDiv_Write(MulDiv_Write),       //写hi,lo指令:mthi,mtlo
    

        .E_MulDiv_HI(E_HI),
        .E_MulDiv_LO(E_LO),
        .E_MulDiv_Busy(Busy)
    );


    //M
    RegM regm(
        //input
        .Clk(Clk),
        .Reset(Reset),

        .E_RegM_Instr(E_Instr),
        .E_RegM_PC(E_PC),

        .E_RegM_ALUResult(E_ALUResult),
        .E_RegM_HI(E_HI),
        .E_RegM_LO(E_LO),
        .E_RegM_WriteData(E_FALUB),
        .E_RegM_A3(E_A3),

        //output
        .M_RegM_Instr(M_Instr),
        .M_RegM_PC(M_PC),

        .M_RegM_ALUResult(M_ALUResult),
        .M_RegM_HI(M_HI),
        .M_RegM_LO(M_LO),
        .M_RegM_WriteData(M_WriteData),
        .M_RegM_A3(M_A3)
    );
    
    Controller M_CU(
        //input
        .Instr(M_Instr),

        //output
        .MemWrite(MemWrite),
        .lw(lw),
        .lh(lh),
        .lb(lb),
        .sw(sw),
        .sh(sh),
        .sb(sb)
    );

    MFWDM mfwdm(
        //input
        .M_WriteData(M_WriteData),
        .W_ReadData(W_ReadData),
        .MFWDM(MFWDM),

        //output
        .M_FWD(M_FWD)
    );

    BE be(
        //input
        .M_BE_ALUResult(M_ALUResult),
        .M_BE_WriteData(M_FWD),
        .M_BE_PC(M_PC),
        .MemWrite(MemWrite),
        .sw(sw),
        .sh(sh),
        .sb(sb),

        //output
        .m_data_addr(m_data_addr),
        .m_data_wdata(m_data_wdata),
        .m_data_byteen(m_data_byteen),
        .m_inst_addr(m_inst_addr)
    );
    
    /*DM dm(
        //input
        .Clk(Clk),
        .Reset(Reset),

        .M_DM_ALUResult(M_ALUResult),
        .M_DM_WriteData(M_FWD),
        .M_DM_PC(M_PC),
        .MemWrite(MemWrite),

        //output
        .M_DM_ReadData(M_ReadData)
    );*/

    DE de(
        //input
        .M_DE_ALUResult(M_ALUResult),
        .m_data_rdata(m_data_rdata),
        .lw(lw),
        .lh(lh),
        .lb(lb),

        //output
        .M_DE_ReadData(M_ReadData)
    );


    //W
    RegW regw(
        //input
        .Clk(Clk),
        .Reset(Reset),

        .M_RegW_Instr(M_Instr),
        .M_RegW_PC(M_PC),

        .M_RegW_ALUResult(M_ALUResult),
        .M_RegW_HI(M_HI),
        .M_RegW_LO(M_LO),
        .M_RegW_ReadData(M_ReadData),
        .M_RegW_A3(M_A3),

        //output
        .W_RegW_Instr(W_Instr),
        .W_RegW_PC(w_inst_addr),            //W_PC

        .W_RegW_ALUResult(W_ALUResult),
        .W_RegW_HI(W_HI),
        .W_RegW_LO(W_LO),
        .W_RegW_ReadData(W_ReadData),
        .W_RegW_A3(w_grf_addr)             //W_A3
    );

    Controller W_CU(
        //input
        .Instr(W_Instr),

        //output
        .RegWrite(w_grf_we),     //W_RegWrite
        .MRFWD(W_MRFWD)
    );

    MRFWD mrfwd(
        //input
        .W_ALUResult(W_ALUResult),
        .W_ReadData(W_ReadData),
        .W_PC(w_inst_addr),      //W_PC
        .W_HI(W_HI),
        .W_LO(W_LO),
        .W_MRFWD(W_MRFWD),

        //output
        .RFWD(w_grf_wdata)       //W_RFWD
    );

endmodule
