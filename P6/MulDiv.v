`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:52:30 11/27/2024 
// Design Name: 
// Module Name:    MulDiv 
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
`define mult 2'b00 
`define multu 2'b01
`define div 2'b10
`define divu 2'b11

`define mthi 2'b01
`define mtlo 2'b10
module MulDiv(
    input Clk,
    input Reset,

    input [31:0] E_MulDiv_A,
    input [31:0] E_MulDiv_B,
    input [1:0] E_MulDiv_Type,        //乘除法计算指令类型:mult,multu,div,divu
    input E_MulDiv_Start,
    input [1:0] E_MulDiv_Write,       //写hi,lo指令:mthi,mtlo
    

    output [31:0] E_MulDiv_HI,
    output [31:0] E_MulDiv_LO,
    output reg E_MulDiv_Busy
    );

    reg [31:0] HI,LO,hi,lo;
    reg [3:0] Mult_Period,Div_Period;

    assign E_MulDiv_HI = HI;
    assign E_MulDiv_LO = LO;
    
    initial begin
        E_MulDiv_Busy = 1'b0;
        HI = 32'h0000_0000;
        LO = 32'h0000_0000;
        
        hi = 32'h0000_0000;
        lo = 32'h0000_0000;
        
        Mult_Period = 4'b0000;
        Div_Period = 4'b0000;
    end

    always @(posedge Clk) begin
        if(Reset) begin
            E_MulDiv_Busy <= 1'b0;
            HI <= 32'h0000_0000;
            LO <= 32'h0000_0000;

            hi <= 32'h0000_0000;
            lo <= 32'h0000_0000;
        
            Mult_Period <= 4'b0000;
            Div_Period <= 4'b0000;
        end

        else begin
            if(E_MulDiv_Start) begin
                if(E_MulDiv_Type == `mult) begin
                    {hi,lo} <= $signed(E_MulDiv_A) * $signed(E_MulDiv_B);
                    Mult_Period <= Mult_Period + 4'd1;
                    E_MulDiv_Busy <= 1'b1; 
                end

                else if(E_MulDiv_Type == `multu) begin
                    {hi,lo} <= (E_MulDiv_A) * (E_MulDiv_B);
                    Mult_Period <= Mult_Period + 4'd1;
                    E_MulDiv_Busy <= 1'b1; 
                end

                else if(E_MulDiv_Type == `div) begin
                    hi <= $signed(E_MulDiv_A) % $signed(E_MulDiv_B);
                    lo <= $signed(E_MulDiv_A) / $signed(E_MulDiv_B);
                    Div_Period <= Div_Period + 4'd1;
                    E_MulDiv_Busy <= 1'b1; 
                end

                else if(E_MulDiv_Type == `divu) begin
                    hi <= (E_MulDiv_A) % (E_MulDiv_B);
                    lo <= (E_MulDiv_A) / (E_MulDiv_B);
                    Div_Period <= Div_Period + 4'd1;
                    E_MulDiv_Busy <= 1'b1; 
                end
            end

            if(Mult_Period == 4'd5) begin
                HI <= hi;
                LO <= lo;
                Mult_Period <= 4'd0;
                E_MulDiv_Busy <= 1'b0; 
            end
            else if(Mult_Period > 4'd0) begin
                Mult_Period <= Mult_Period + 4'd1;
            end

            if(Div_Period == 4'd10) begin
                HI <= hi;
                LO <= lo;
                Div_Period <= 4'd0;
                E_MulDiv_Busy <= 1'b0; 
            end
            else if(Div_Period > 4'd0) begin
                Div_Period <= Div_Period + 4'd1;
            end


            if(E_MulDiv_Write == `mthi) begin
                HI <= E_MulDiv_A;              //HI <- GPR[rs]
            end

            else if(E_MulDiv_Write == `mtlo) begin
                LO <= E_MulDiv_A;              //LO <- GPR[rs]
            end
        end
    end
endmodule