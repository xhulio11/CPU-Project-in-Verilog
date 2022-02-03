`timescale 1ns / 1ps

module ROM(
    input [9:0] Addr,
    output reg[31:0] Dout,
    input Clk
    );
	
	reg[31:0]ROM[1023:0];
	
	initial
		begin
		$readmemb("rom.data",ROM);
		end
	
	always@(posedge Clk)begin
		Dout <= ROM[Addr];
	end
endmodule
