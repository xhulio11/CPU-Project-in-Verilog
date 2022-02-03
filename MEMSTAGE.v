`timescale 1ns / 1ps

module MEMSTAGE(
    input [9:0] ALU_MEM_Addr,
    input [31:0] MEM_DataIn,
    output reg [31:0] MEM_DataOut,
    input Clk,
    input Mem_WrEn
    );
	reg [31:0]RAM[1023:0];
	
	always @(posedge Clk)
	begin
	
		if(Mem_WrEn)
			RAM[ALU_MEM_Addr] = MEM_DataIn;
		else
			MEM_DataOut = RAM[ALU_MEM_Addr];
	end

endmodule
