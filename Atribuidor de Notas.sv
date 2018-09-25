// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

parameter NINSTR_BITS = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NINSTR_BITS-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++) lcd_registrador[i] <= i+i*16;
  end
always_comb begin
	

end
always_comb begin
	int numero1;
	int numero2;
	int numero;
	logic sinal1;
	logic sinal2;
	logic sinal;
	logic carry_1;
	logic carry_2;
	logic carry_3;
	logic carry_4;
	logic R;
	
	sinal1 <= SWI[3];
	sinal2 <= SWI[7];
	numero1 <= SWI[2:0];
	numero2 <= SWI[6:4];
	
	if(sinal1 == sinal2) begin
		sinal <= sinal1;
		numero <= numero1 + numero2;
	end
	else if(numero1 > numero2) begin
		sinal <= sinal1;
		numero <= numero1 - numero2;
	end
	else begin 
		sinal <= sinal2;
		numero <= numero2 - numero1;
	end
	SEG[7] <= sinal;	
	LED[3:0] <= numero;

	
	carry_1 <= SWI[0] & SWI[4];
	case(carry_1)
		1: begin
			R <= SWI[1] ^ carry_1;
			carry_2 <= (SWI[1] & carry_1) | (SWI[5] & R);
		end
		0: begin

			carry_2 <= SWI[1] & SWI[5];
		end
	endcase
	case(carry_2)
		1: begin
			R <= SWI[2] ^ carry_2;
			carry_3 <= (SWI[2] & carry_2) | (SWI[6] & R);
		end
		0: begin
			carry_3 <= SWI[2] & SWI[6];
		end
	endcase
	LED[7] <= carry_3;

	case(numero)
		0: begin
			SEG[0] <= 1;
			SEG[1] <= 1;
			SEG[2] <= 1;
			SEG[3] <= 1;
			SEG[4] <= 1;
			SEG[5] <= 1;
			SEG[6] <= 0;
		end
		1: begin
			SEG[0] <= 0;
			SEG[1] <= 1;
			SEG[2] <= 1;
			SEG[6:3] <= 0;
		end		
		2: begin	
			SEG[0] <= 1;
			SEG[1] <= 1;
			SEG[2] <= 0;
			SEG[3] <= 1;
			SEG[4] <= 1;
			SEG[5] <= 0;
			SEG[6] <= 1;
		end	
		3: begin	
			SEG[0] <= 1;
			SEG[1] <= 1;
			SEG[2] <= 1;
			SEG[3] <= 1;
			SEG[4] <= 0;
			SEG[5] <= 0;
			SEG[6] <= 1;
		end
		4: begin
			SEG[0] <= 0;
			SEG[1] <= 1;
			SEG[2] <= 1;
			SEG[3] <= 0;
			SEG[4] <= 0;
			SEG[5] <= 1;
			SEG[6] <= 1;
		end
		5: begin
			SEG[0] <= 1;
			SEG[1] <= 0;
			SEG[2] <= 1;
			SEG[3] <= 1;
			SEG[4] <= 0;
			SEG[5] <= 1;
			SEG[6] <= 1;
		end
		6: begin
			SEG[0] <= 1;
			SEG[1] <= 0;
			SEG[2] <= 1;
			SEG[3] <= 1;
			SEG[4] <= 1;
			SEG[5] <= 1;
			SEG[6] <= 1;
		end
		7: begin
			SEG[0] <= 1;
			SEG[1] <= 1;
			SEG[2] <= 1;
			SEG[6:3] <= 0;
		end
		default: SEG[6:0] <= 0;
	endcase
	end
endmodule
