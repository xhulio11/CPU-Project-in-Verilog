`timescale 1ns / 1ps

module Register_File_RF(
    input [4:0] Adr1,
    input [4:0] Adr2,
    input [4:0] Awr,
    output reg[31:0] Dout1,
    output reg[31:0] Dout2,
    input [31:0] Din,
    input WrEn,
    input Clk
    );
	integer j;
	genvar i;
	
	wire [31:0]Temp_Dout[31:0];
	reg W_E [31:0];
	
	
	initial begin
		W_E[0] = 1'b1;
	end
	
	// Writing only in the first time R0 Register with 0
	// Creating the R0 Register
	Register register1 (.Clk(Clk),.WE(W_E[0]),.Data(32'd0),.Dout(Temp_Dout[0]));
	// Creating 31 Registers
	for(i = 1; i < 32; i = i + 1)begin:loop
		Register register2 (.Clk(Clk),.WE(W_E[i]),.Data(Din),.Dout(Temp_Dout[i]));
	end:loop
	
	// Assigning to Dout1 and Dout2 the Data from a spesific register
	always @(Adr1,Adr2) begin
		Dout1 = Temp_Dout[Adr1];
		Dout2 = Temp_Dout[Adr2];
	end
	
	// Wrting Data to a specific register
	always @(Awr or Din)begin
		//Reseting Write Enable of the register to 0
		for (j = 0; j < 32; j = j + 1)begin:loop2
				W_E[j] = 0;
		end:loop2
		
		if(WrEn && Awr != 4'b0000)begin
			W_E[Awr] = 1'b1;
		end
		$display("==========================");
		$display("WrEn = %d, Awr = %d",WrEn,Awr);
		$display("Din = %d",Din);
		for(j = 0; j < 19; j = j + 1)begin:lo
		$display("Reg %d = %b",j,Temp_Dout[j]);
		$display("WE %d = %b",j,W_E[j]);
		end:lo
		$display("==========================\n");
	end
	

endmodule
