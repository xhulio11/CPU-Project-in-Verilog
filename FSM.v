`timescale 1ns / 1ps

module FSM(
    input [31:0] Instr,
	 input zero,
	 output reg pc_lden,rf_b_sel,rf_wrdata_sel,alu_bin_sel,pc_sel,rf_wren,
	 output reg [3:0]alu_func,
	 output reg mem_wren,alu_rf_a_sel
    );
	 
	wire [5:0]opcode = Instr[31:26];
	wire [3:0]func = Instr[3:0];
	
	// ALWAYS BLOCK FOR PC
	always @(opcode)begin
		$display("============");
		$display("Instr = %b",Instr);
		$display("Opcode = %b",opcode);
		if(Instr == 32'b00000000000000000000000000000000)begin
			pc_lden = 1;
			pc_sel = 0;
		end else	begin		
			pc_lden = 1;
			// b
			if (opcode == 6'b111111)begin
				pc_sel = 1;
			//beq
			end else if(opcode == 6'b000000)begin
				rf_b_sel = 1; // Choose rd instead of rt
				alu_bin_sel = 0; // Choose RF_B in ALU instead of Immed
				alu_func = 4'b0001; // Choose to do RF[rs] - RF[rd] 
				
				if(zero)begin // RF[rs] == RF[rd]
					pc_sel = 1;
				end else begin
					pc_sel = 0;
				end
			//bne
			end else if(opcode == 6'b000001)begin
				rf_b_sel = 1; // Choose rd instead of rt
				alu_bin_sel = 0; // Choose RF_B in ALU instead of Immed
				alu_func = 4'b0001; // Choose to do RF[rs] - RF[rd]
				
				if(~zero)begin
					pc_sel = 1;
				end else begin
					pc_sel = 0;
				end
			// if another opcode 
			end else begin
				pc_sel = 0;
			end
		end
	end
	
	
	//ALWAYS BLOCK FOR Opcode == 100000 => ALU Instruction
	always @(opcode,func)begin
		if (opcode == 6'b100000)begin
			$display("I am in FSM->ALU");
			alu_func = func;
			alu_bin_sel = 0; // Choose RF_B in ALU instead of Immed
			rf_b_sel = 0; // Choose rt instead of rd
			rf_wrdata_sel = 1; // Choose ALU_out instead of MEM_out 
			alu_rf_a_sel = 0; // Choose RF_a in ALU instead of 0
			rf_wren = 1; // Enable writing 
			$display("alu_rf_a_sel = %d",alu_rf_a_sel);
			$display("rf_wren = %d",rf_wren);

		/*  Operation:            li                     lui          */
		end else if (opcode == 6'b111000 || opcode == 6'b111001)begin
			$display("I AM IN FSM -> li ");
			alu_rf_a_sel = 1;
			alu_bin_sel = 1; //Choose Immed instead of RF_B in ALU
			alu_func = 4'b0000; // Choose add(+) in ALU operation 
			rf_b_sel = 1; // Choose rd instead of rt
			rf_wrdata_sel = 1; // Choose ALU_out instead of MEM_out
			rf_wren = 1;
			
		/*Operation: addi */
		end else if (opcode == 6'b110000)begin
			$display("I AM IN FSM -> addi");
			alu_rf_a_sel = 0;
			alu_bin_sel = 1; //Choose Immed instead of RF_B in ALU
			alu_func = 4'b0000; // Choose add(+) in ALU operation 
			rf_b_sel = 1; // Choose rd instead of rt
			rf_wrdata_sel = 1; // Choose ALU_out instead of MEM_out
			rf_wren = 1;
			
		/* Operation: andi */
		end else if(opcode == 6'b110010)begin
			$display("I AM IN FSM -> andi ");
			$display("opcode = %b",opcode);
		   alu_rf_a_sel = 0; // Choose RF_A instead of 0
			alu_bin_sel = 1; //Choose Immed instead of RF_B in ALU
			alu_func = 4'b0010; // Choose & in ALU operation 
			rf_b_sel = 1; // Choose rd instead of rt
			rf_wrdata_sel = 1; // Choose ALU_out instead of MEM_out
			rf_wren = 1;
			
		/* Operation: ori */
		end else if(opcode == 6'b110011)begin
			$display("I AM IN FSM -> ori ");
			$display("opcode = %b",opcode);
			alu_rf_a_sel = 1;
			alu_bin_sel = 1; //Choose Immed instead of RF_B in ALU
			alu_func = 4'b0011; // Choose | in ALU operation 
			rf_b_sel = 1; // Choose rd instead of rt
			rf_wrdata_sel = 1; // Choose ALU_out instead of MEM_out
			rf_wren = 1;
		/* Operation: lb */
		
		end else if(opcode == 6'b000011)begin
			$display("I AM IN FSM -> lb ");
			alu_rf_a_sel = 1;
			mem_wren = 0; // Choose not to write in MEM
			alu_bin_sel = 1; // Choose Immed instead of RF_B in ALU
			alu_func = 4'b0000; // Choose add(+) in ALU
			rf_b_sel = 1; // Choose rd instead of rt
			rf_wrdata_sel = 0; // Choose MEM_out instead of ALU_out
			rf_wren = 1;
			//mem_dataout2 = {{23'b00000000000000000000000},mem_dataout[7:0]};
		
		/* Operation: sb*/
		end else if(opcode == 6'b000111)begin
			$display("I AM IN FSM -> sb ");
			alu_rf_a_sel = 1;
			mem_wren = 1; // Choose to write in MEM
			alu_bin_sel = 1; // CHoose Immed instead of RF_B in ALU
			alu_func = 4'b0000; // Choose add(+) in ALU
			rf_b_sel = 1; // Choose rd instead of rt
			rf_wrdata_sel = 1; // Choose ALU_out instead of MEM_out
			rf_wren = 1;
			//mem_datain = {{23'b00000000000000000000000},rf_B[7:0]};
		
		/* Operation: lw*/
		end else if(opcode == 6'b001111)begin
			$display("I AM IN FSM -> lw ");
		   alu_rf_a_sel = 1;
			mem_wren = 0; // Choose to write in MEM
			alu_bin_sel = 1; // CHoose Immed instead of RF_B in ALU
			alu_func = 4'b0000; // Choose add(+) in ALU
			rf_b_sel = 1; // Choose rd instead of rt
			rf_wrdata_sel = 0; // Choose ALU_out instead of MEM_out
			rf_wren = 1;
		
		/* Operation: sw */
		end else if(opcode == 6'b011111)begin
			$display("I AM IN FSM -> sw ");
			alu_rf_a_sel = 1;
			mem_wren = 1; // Choose to write in MEM
			alu_bin_sel = 1; // CHoose Immed instead of RF_B in ALU
			alu_func = 4'b0000; // Choose add(+) in ALU
			rf_b_sel = 1; // Choose rd instead of rt
			rf_wrdata_sel = 0; // Choose ALU_out instead of MEM_out
			rf_wren = 1;
			//mem_datain = rf_B; 
		end else begin
			rf_wren = 0;
		end
		$display("alu_rf_a_sel = %d",alu_rf_a_sel);
		$display("rf_wren = %d",rf_wren);
		$display("============\n");
	end

endmodule
