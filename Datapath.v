`timescale 1ns / 1ps

module Datapath(
	input Clk,zero,
	// For IFSTAGE
	input pc_sel,pc_lden,reset,
	// FOR DECSTAGE
	input rf_wren,rf_wrdata_sel,rf_b_sel,
	// FOR ALUSTAGE
	input alu_bin_sel,alu_rf_a_sel,mem_wren,
	input [3:0]alu_func,
	output [31:0]Instr
    );
	// IFSTAGE wires
	/*---------------------------------------------------------------------------------------------------------*/
	wire [31:0] instr,pc_imme;
	assign Instr = instr;
	IFSTAGE ifstage(.PC_Immed(pc_imme),.PC_sel(pc_sel),.PC_LdEn(pc_lden),.Reset(reset),.Clk(Clk),.Instr(instr));
	
	/*---------------------------------------------------------------------------------------------------------*/
	// DECSTAGE wires
	wire [31:0]alu_out;
	wire [31:0]mem_dataout;
	wire [31:0]rf_A,rf_B;
	DECSTAGE decstage (.Instr(instr), .ALU_out(alu_out),.MEM_out(mem_dataout),.RF_WrEn(rf_wren),.RF_WrData_sel(rf_wrdata_sel),
								 .RF_B_sel(rf_b_sel),.Immed(pc_imme),.RF_A(rf_A),.RF_B(rf_B),.Clk(Clk));
	/*---------------------------------------------------------------------------------------------------------*/
	// ALUSTAGE wires

	ALUSTAGE alu(.RF_A(rf_A),.RF_B(rf_B),.ALU_RF_A_sel(alu_rf_a_sel),.Immed(pc_imme),.ALU_Bin_sel(alu_bin_sel),
	.ALU_func(alu_func),.ALU_out(alu_out),.Zero(zero));
	/*---------------------------------------------------------------------------------------------------------*/
	//MEMSTAGE wires

	MEMSTAGE memstage(.ALU_MEM_Addr(alu_out[11:2]),.MEM_DataIn(rf_A),.MEM_DataOut(mem_dataout),.Clk(Clk),.Mem_WrEn(mem_wren));
	/*---------------------------------------------------------------------------------------------------------*/

endmodule
