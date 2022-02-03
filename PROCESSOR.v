`timescale 1ns / 1ps

module PROCESSOR(
	input Clk
    );
	
	// For IFSTAGE
	wire zero,pc_sel,pc_lden,reset;
	// FOR DECSTAGE
	wire rf_wren,rf_wrdata_sel,temp_rf_b_sel;
	// FOR ALUSTAGE
	wire alu_bin_sel,alu_rf_a_sel,mem_wren;
	wire [3:0]alu_func;
	wire [31:0] instr;
	
	FSM fsm(.Instr(instr),.rf_wren(rf_wren),.zero(zero),.pc_lden(pc_lden),.rf_b_sel(temp_rf_b_sel),.rf_wrdata_sel(rf_wrdata_sel),
	.alu_bin_sel(alu_bin_sel),.pc_sel(pc_sel),.alu_func(alu_func),.mem_wren(mem_wren),.alu_rf_a_sel(alu_rf_a_sel));
   
	Datapath datapath(.Clk(Clk),.zero(zero),.pc_sel(pc_sel),.pc_lden(pc_lden),.reset(reset),.rf_wren(rf_wren),
		.rf_wrdata_sel(rf_wrdata_sel),.rf_b_sel(temp_rf_b_sel),.alu_bin_sel(alu_bin_sel),.alu_rf_a_sel(alu_rf_a_sel),.mem_wren(mem_wren),
		.alu_func(alu_func),.Instr(instr));
	

	/*
	always @(*)begin
		$display("============");
		$display("PROCESSOR");
		$display("Instr = %b",instr);
		$display("RF_B_sel = %b",temp_rf_b_sel);
		$display("alu_rf_a_sel = %d",alu_rf_a_sel);
		$display("alu_bin_sel = %d",alu_bin_sel);
		$display("===========");
		end
		*/
endmodule
