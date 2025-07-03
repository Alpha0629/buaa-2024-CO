`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:13:32 12/01/2024 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);

    wire [31:0] D_Instr,E_Instr,M_Instr,W_Instr;
    wire [4:0] E_A3,M_A3;//W_A3
    wire [3:0] MFRD1D,MFRD2D,MFALUAE,MFALUBE,MFWDM;
    wire PC_Enable,RegD_Enable,RegE_Clr;
    wire Busy;


    Datapath Datapath(
        //input
        .Clk(clk),
        .Reset(reset),

        .PC_Enable(PC_Enable),
        .RegD_Enable(RegD_Enable),
        .RegE_Clr(RegE_Clr),

        .MFRD1D(MFRD1D),
        .MFRD2D(MFRD2D),
        .MFALUAE(MFALUAE),
        .MFALUBE(MFALUBE),
        .MFWDM(MFWDM),

        .i_inst_raddr(i_inst_rdata),
        .m_data_rdata(m_data_rdata),

        //output
        .D_Instr(D_Instr),
        .E_Instr(E_Instr),
        .M_Instr(M_Instr),
        .W_Instr(W_Instr),

        .E_A3(E_A3),
        .M_A3(M_A3),
        .W_A3(w_grf_addr),

        .Busy(Busy),
    
        .i_inst_addr(i_inst_addr),

        .m_data_addr(m_data_addr),
        .m_data_byteen(m_data_byteen),
        .m_data_wdata(m_data_wdata),
        .m_inst_addr(m_inst_addr),

        .w_grf_we(w_grf_we),           //W_RegWrite
        .w_grf_addr(w_grf_addr),   //W_A3
        .w_grf_wdata(w_grf_wdata), //W_RFWD
        .w_inst_addr(w_inst_addr)  //W_PC
    );

    Adventure adventure(
        //input
        .D_Instr(D_Instr),
        .E_Instr(E_Instr),
        .M_Instr(M_Instr),
        .W_Instr(W_Instr),

        .E_A3(E_A3),
        .M_A3(M_A3),
        .W_A3(w_grf_addr),

        .Busy(Busy),   //来自乘除法单元的输入信号


        //output
        .PC_Enable(PC_Enable),
        .RegD_Enable(RegD_Enable),
        .RegE_Clr(RegE_Clr),

        .MFRD1D(MFRD1D),
        .MFRD2D(MFRD2D),
        .MFALUAE(MFALUAE),
        .MFALUBE(MFALUBE),
        .MFWDM(MFWDM) 
    );

endmodule