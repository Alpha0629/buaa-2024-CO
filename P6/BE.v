`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:20:00 11/28/2024 
// Design Name: 
// Module Name:    BE 
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
module BE(
    input [31:0] M_BE_ALUResult,
    input [31:0] M_BE_WriteData,
    input [31:0] M_BE_PC,
    input MemWrite,
    input sw,
    input sh,
    input sb,

    output [31:0] m_data_addr,
    output reg [31:0] m_data_wdata,
    output reg [3:0] m_data_byteen,
    output [31:0] m_inst_addr
);

    initial begin
        m_data_wdata <= 32'd0;
    end
    
    assign m_data_addr = M_BE_ALUResult;
    assign m_inst_addr = M_BE_PC;

    always @(*) begin
        if(MemWrite) begin
            if(sw) begin                               //按字存储
                m_data_byteen = 4'b1111;
                m_data_wdata = M_BE_WriteData;
            end

            else if(sh) begin                           //按半字存储
                if(m_data_addr[1] == 1'b0) begin        //存储于低位
                    m_data_byteen = 4'b0011;
                    m_data_wdata[15:0] = M_BE_WriteData[15:0];
                end

                else if(m_data_addr[1] == 1'b1) begin
                    m_data_byteen = 4'b1100;
                    m_data_wdata[31:16] = M_BE_WriteData[15:0];
                end
            end

            else if(sb) begin                        //按字节存储
                if(m_data_addr[1:0] == 2'b00) begin
                    m_data_byteen = 4'b0001;
                    m_data_wdata[7:0] = M_BE_WriteData[7:0];
                end

                else if(m_data_addr[1:0] == 2'b01) begin
                    m_data_byteen = 4'b0010;
                    m_data_wdata[15:8] = M_BE_WriteData[7:0];
                end

                else if(m_data_addr[1:0] == 2'b10) begin
                    m_data_byteen = 4'b0100;
                    m_data_wdata[23:16] = M_BE_WriteData[7:0];
                end

                else if(m_data_addr[1:0] == 2'b11) begin
                    m_data_byteen = 4'b1000;
                    m_data_wdata[31:24] = M_BE_WriteData[7:0];
                end
            end
        end
		  
		  else begin
				m_data_byteen = 4'b0000;
		  end
    end

endmodule
