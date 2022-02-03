`timescale 1ns / 1ps

module ALUSTAGE(
    input [31:0] RF_A,
    input [31:0] RF_B,
    input [31:0] Immed,
	 input ALU_RF_A_sel,
    input ALU_Bin_sel,
    input [3:0] ALU_func,
    output [31:0] ALU_out,
	 output Zero
    );
	reg [31:0]b_alu_input,a_alu_input;
	
	ALU alu(.A(a_alu_input),.B(b_alu_input),.Op(ALU_func),.Out(ALU_out),.Zero(Zero));
	
	always @(*)begin

		if (ALU_Bin_sel == 1)begin
			b_alu_input = Immed;
		end else begin
			b_alu_input = RF_B;
		end
		
		if(ALU_RF_A_sel == 1)begin
			a_alu_input = 0;
		end else begin
			a_alu_input = RF_A;
		end
	end
	
endmodule
