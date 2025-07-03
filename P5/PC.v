`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:47:27 11/21/2024 
// Design Name: 
// Module Name:    PC 
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
module PC (
    input Clk,
    input Reset,
    input F_PC_Enable,

    input [31:0] F_PC_NextPC, //next pc

    output reg [31:0] F_PC_PC //current pc
);
    
    initial begin
        F_PC_PC <= 32'h00003000;
    end
    
    always @(posedge Clk) begin
        if(Reset) begin
            F_PC_PC <= 32'h00003000;
        end
        
        else begin
            if(F_PC_Enable) begin
                F_PC_PC <= F_PC_NextPC;
            end
        end
    end

endmodule