`timescale 1ns / 1ps

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] Op,
    output reg[31:0] Out,
    output reg Zero
    );
	
	
	reg temp;
	reg [31:0] temp_32;
	
	/* 
		Implementation of ALU with else-if conditions.
		Controlling based on Op input what's the operation
		we need to execute.
	*/
	
	always @(*)begin

		// Add Operation
		if(Op == 4'b0000)begin
			Out = A + B;
			
		// Sub Operation
		end else if (Op == 4'b0001)begin
			Out = A - B;
			
		// And Operation
		end else if (Op == 4'b0010)begin
			Out = A & B;
			
		// Or Operation
		end else if (Op == 4'b0011)begin
			$display("ALU");
			$display("I am in OR");
			Out = A | B;
			
		// Reversal Operation
		end else if (Op == 4'b0100)begin
			Out = !A;
		
		// Arithmetic Right Shift Operation
		end else if (Op == 4'b1000)begin
			temp = A[31];          // Storing MSB of A
			temp_32 = A>>1;        // Shifting
			temp_32[31] = temp;    // Assigning the MSB which was stored
			Out = temp_32;
		
		// Logic Right Shift Operation
		end else if (Op == 4'b1010)begin
			Out = A>>1;
		
		// Logic Left Shift Operation
		end else if (Op == 4'b1001)begin
			Out = A<<1;
		
		// Circular Left Shift Operation
		end else if (Op == 4'b1100)begin
			temp = A[31];          // Storing MSB of A
			temp_32 = A<<1;        // Shifting
			temp_32[0] = temp;     // Assigning the MSB which was stored in the LSB
			Out = temp_32;
			
		// Circular Right Shift Operation
		end else if (Op == 4'b1101)begin
			temp = A[0];           // Storing MSB of A
			temp_32 = A>>1;        // Shifting
			temp_32[31] = temp;    // Assigning the LSB which was stored in the MSB 
			Out = temp_32;
		end
		$display("==================");
		$display("func = %b",Op);
		$display("A = %d, B = %d",A, B);
		$display("Alu Out = %d",Out);
		$display("==================\n");
	end
	
	always @(*)
	if (Out == 32'd0)begin
		Zero = 1;
	end else begin
		Zero = 0;
	end
	
endmodule
