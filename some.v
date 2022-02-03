`timescale 1ns / 1ps

module DECSTAGE(
    input [31:0] Instr, ALU_out,MEM_out,
	 input RF_WrEn,RF_WrData_sel,RF_B_sel,
	 input Clk,
	 output reg [31:0]Immed,
	 output [31:0] RF_A,RF_B
    ); 
	 
	wire [5:0]Opcode,func;
	wire [4:0]rs,rd,rt;
	wire [15:0]Immediate ;
	/*
		Decoding instruction in:
		- Opcode
		- rs,rd,rt
		- func
		- Immediate
	*/
	assign Opcode = Instr[31:26];
	assign rs = Instr[25:21];
	assign rd = Instr[20:16];
	assign rt = Instr[15:11];
	assign func = Instr[5:0];
	assign Immediate = Instr[15:0];
	
	// Needed variables for always block
	reg [4:0]adr2;
	reg [31:0]din;
	// Creating the Register File with 32 registers
	Register_File_RF rgf_RF (.Adr1(rs),.Adr2(adr2),.Awr(rd),.Dout1(RF_A),.Dout2(RF_B),.Din(din),.WrEn(RF_WrEn),.Clk(Clk));
	
	
	always @(ALU_out,MEM_out,RF_WrEn,RF_WrData_sel,RF_B_sel,Opcode,rd,rt,Immediate)begin
		$display("==========================");
		$display("---------DECSTAGE---------");
		// MUX for rd/rt
		if (RF_B_sel)begin
			$display("I am in rd");
			adr2 = rd;
		end else begin
			$display("I am in rt");
			adr2 = rt;
			$display("adr1 = %d, adr2 = %d",rs,adr2);
		end
	
		// MUX for ALU_out/MEM_out
		if (RF_WrData_sel)begin
			din = ALU_out;
		end else begin
			din = MEM_out;
		end
	
		// Selecting the Operation for the Immediate
		// SignExtend(Immediate)
		if (Opcode == 6'b111000 || Opcode == 6'b110000 || Opcode ==6'b000111 ||Opcode == 6'b001111 || Opcode == 6'b011111)begin
			Immed = {{16{Immediate[15]}}, Immediate[15:0]};
		
		// Immediate << 16 (zeroFill)
		end else if (Opcode == 6'b111001)begin
			Immed = {{Immediate[15:0]},{16{1'b0}}};
		
		// ZeroFill(Immediate) 
		end else if (Opcode == 6'b110010 || Opcode == 6'b110011)begin
			Immed = {{16{1'b0}},Immediate[15:0]};
		
		// SignExtend(Immediate)<<2
		end else if (Opcode ==6'b111111 || Opcode == 6'b000000 || Opcode == 6'b000001)begin
			Immed = {{16{Immediate[15]}},Immediate[15:0]}<<2;
		
		// ZeroFill(Immediate) (7 downto 0)
		end else if (Opcode == 6'b000011)begin
			Immed = {{16'b000000000000000000000000},Immediate[7:0]};
		end
		$display(" Instr = %b",Instr);
		$display("rd = %d,RF_B_sel = %d,RF_WrData_sel=%d, ALU_OUT = %d",rd,RF_B_sel,RF_WrData_sel,ALU_out);
		$display("A = %b, B = %b, Immed = %b",RF_A, RF_B, Immed);
		$display("==========================\n");
	end
		
endmodule
