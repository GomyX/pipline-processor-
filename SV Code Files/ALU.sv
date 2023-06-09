module ALU(input logic [31:0] SrcA, SrcB,
           input logic [2:0] ALUControl,
           
           output logic [31:0] ALUResult,
           output logic [3:0] ALUFlags);

//Add --> 000
//SUB --> 001
//AND --> 010
//OR  --> 011
//EOR --> 100
//BIC --> 110

 logic N, Z, C, V;
 logic [31:0] condinvb;
 logic [32:0] sum;
 assign condinvb = ALUControl[0] ? ~SrcB : SrcB;
 assign sum = SrcA + condinvb + ALUControl[0];

 always_comb
 casex (ALUControl[2:0])
 3'b00?: ALUResult = sum;
 3'b010: ALUResult = SrcA & SrcB;
 3'b011: ALUResult = SrcA | SrcB;
 3'b100: ALUResult = SrcA ^ SrcB;
 3'b110: ALUResult = SrcA & ~SrcB;
 endcase

 assign N = ALUResult[31];
 assign Z = (ALUResult == 32'b0);
 assign C = (ALUControl[2:1] == 2'b00) & sum[32];
 assign V = (ALUControl[2:1] == 2'b00) & ~(SrcA[31] ^ SrcB[31] ^ ALUControl[0]) & (SrcA[31] ^ sum[31]);
 assign ALUFlags = {N, Z, C, V};
endmodule
