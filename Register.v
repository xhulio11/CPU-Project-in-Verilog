`timescale 1ns / 1ps

module Register(
    input Clk,
    input [31:0] Data,
    input WE,
    output reg[31:0] Dout
    );
	
	// With every Positive Edge of the Clock
	always @(posedge Clk)begin
		// If Write is Enabled we store the new Data
		if (WE)begin
			Dout <= Data;
		end
	end
		
endmodule

