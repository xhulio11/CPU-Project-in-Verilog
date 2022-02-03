`timescale 1ns / 1ps
module DECSTAGE;

	// Inputs
	reg [31:0] Instr;
	reg [31:0] ALU_out;
	reg [31:0] MEM_out;
	reg RF_WrEn;
	reg RF_WrData_sel;
	reg RF_B_sel;
	reg Clk;

	// Outputs
	wire [31:0] Immed;
	wire [31:0] RF_A;
	wire [31:0] RF_B;

	// Instantiate the Unit Under Test (UUT)
	DECSTAGE uut (
		.Instr(Instr), 
		.ALU_out(ALU_out), 
		.MEM_out(MEM_out), 
		.RF_WrEn(RF_WrEn), 
		.RF_WrData_sel(RF_WrData_sel), 
		.RF_B_sel(RF_B_sel), 
		.Clk(Clk), 
		.Immed(Immed), 
		.RF_A(RF_A), 
		.RF_B(RF_B)
	);
	
	always #10 Clk = ~Clk;
	
	initial begin
		// Initialize Inputs
		Clk = 0;
		// Wait 100 ns for global reset to finish
      Instr = 0; 
		RF_B_sel = 1;
		RF_WrEn = 1;
		#20
		Instr[31:0] = 32'b1000_0000_0000_0000_0000_0000_0000_1011;
		RF_B_sel = 1;
		RF_WrEn = 1;
		// Add stimulus here

	end
      
endmodule

