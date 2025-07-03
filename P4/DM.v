`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:39 10/29/2024 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input [31:0] ALUResult,
    input [31:0] WriteData,
    input [31:0] PC,
    input MemWrite,
    input Clk,
    input Reset,
    output [31:0] ReadData
    );

    reg [31:0] RAM [0:3071];
    integer i;

	 wire [31:0] addr;
	 assign addr = ALUResult;	
		
    initial begin
        for(i = 0;i < 3072;i = i+1)
            RAM[i] = 32'd0;
    end

    always @(posedge Clk) begin
        if(Reset) begin
            for(i = 0;i < 3072;i = i+1)
                RAM[i] <= 32'd0;
        end

        else begin
            if(MemWrite) begin
                RAM[addr[13:2]] <= WriteData;
                $display("@%h: *%h <= %h", PC, addr , WriteData);
            end
        end
    end

    assign ReadData = RAM[addr[13:2]];


endmodule