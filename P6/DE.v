`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:01:07 11/28/2024 
// Design Name: 
// Module Name:    DE 
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
module DE(
    input [31:0] M_DE_ALUResult,
    input [31:0] m_data_rdata,
    input lw,
    input lh,
    input lb,

    output reg [31:0] M_DE_ReadData
); 
    
    wire [31:0] m_data_addr;
    assign m_data_addr = M_DE_ALUResult;
    
    always @(*) begin
        if(lw) begin
            M_DE_ReadData = m_data_rdata;
        end

        else if(lh) begin
            if(m_data_addr[1] == 1'b0) begin          //加载低位
                M_DE_ReadData = {{16{m_data_rdata[15]}},{m_data_rdata[15:0]}};
            end

            else if(m_data_addr[1] == 1'b1) begin     //加载高位
                M_DE_ReadData = {{16{m_data_rdata[31]}},{m_data_rdata[31:16]}};
            end
        end

        else if(lb) begin
            if(m_data_addr[1:0] == 2'b00) begin       
                M_DE_ReadData = {{24{m_data_rdata[7]}},{m_data_rdata[7:0]}};
            end

            else if(m_data_addr[1:0] == 2'b01) begin    
                M_DE_ReadData = {{24{m_data_rdata[15]}},{m_data_rdata[15:8]}};
            end

            else if(m_data_addr[1:0] == 2'b10) begin    
                M_DE_ReadData = {{24{m_data_rdata[23]}},{m_data_rdata[23:16]}};
            end

            else if(m_data_addr[1:0] == 2'b11) begin    
                M_DE_ReadData = {{24{m_data_rdata[31]}},{m_data_rdata[31:24]}};
            end
        end
    end


endmodule
