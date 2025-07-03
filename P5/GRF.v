`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:45:50 11/21/2024 
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
module GRF (
    input Clk,
    input Reset,

    input [4:0] D_GRF_A1,
    input [4:0] D_GRF_A2,
    input [4:0] D_GRF_A3,
    
    input D_GRF_RegWrite,
    input [31:0] D_GRF_RFWD,
    input [31:0] D_GRF_PC,

    output [31:0] D_GRF_RD1,
    output [31:0] D_GRF_RD2
);
    
    reg [31:0] GRF [31:0];
    integer i;

    initial begin
        for(i=0;i<32;i=i+1) begin
            GRF[i] = 32'd0;
        end
    end


    always @(posedge Clk) begin
        if(Reset) begin
            for(i=0;i<32;i=i+1) begin
            GRF[i] <= 32'd0;
            end
        end

        else if(D_GRF_RegWrite && D_GRF_A3 != 5'd0) begin
            GRF[D_GRF_A3] <= D_GRF_RFWD;
            $display("%d@%h: $%d <= %h", $time, D_GRF_PC, D_GRF_A3, D_GRF_RFWD);
        end
    end
	 
	 assign D_GRF_RD1 = GRF[D_GRF_A1];
	 assign D_GRF_RD2 = GRF[D_GRF_A2];

endmodule