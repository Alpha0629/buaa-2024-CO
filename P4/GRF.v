`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:50:26 10/29/2024 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input Clk,
    input Reset,
    input RegWrite,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    input [31:0] PC,
    output [31:0] RD1,
    output [31:0] RD2
    );

    reg [31:0] GRF [31:0];
    integer i;

    initial begin
        for(i = 0;i <= 31;i=i+1) 
            GRF[i] = 32'd0;
    end

    always @(posedge Clk) begin
        if(Reset) begin
            for(i = 0;i <= 31;i=i+1)
					GRF[i] <= 32'd0;     
        end

        else begin
            if(RegWrite && A3 != 5'd0) begin
                //
                GRF[A3] <= WD;
                $display("@%h: $%d <= %h", PC, A3, WD);
            end
        end 
    end

    assign RD1 = GRF[A1];
    assign RD2 = GRF[A2];


endmodule