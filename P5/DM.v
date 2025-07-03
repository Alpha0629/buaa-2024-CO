`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:44:40 11/21/2024 
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
module DM (
    input Clk,
    input Reset,

    input [31:0] M_DM_ALUResult,
    input [31:0] M_DM_WriteData,
    input [31:0] M_DM_PC,
    input MemWrite,

    output [31:0] M_DM_ReadData
);
    
    reg [31:0] RAM [0:3071];
    wire [31:0] addr;
    integer i;

    assign addr = M_DM_ALUResult;

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
                RAM[addr[13:2]] <= M_DM_WriteData;
                $display("%d@%h: *%h <= %h", $time, M_DM_PC, addr, M_DM_WriteData);
            end
        end
    end

	assign M_DM_ReadData = RAM[addr[13:2]];

endmodule