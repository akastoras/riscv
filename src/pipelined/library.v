`include "constants.vh"
`include "config.vh"
// `timescale 1ns/1ps

// ALU. Inputs: inA, inB, op. Output: out. 
// Operations: bitwise and (op = 0)
//             bitwise or  (op = 1)
//             addition (op = 2)
//             subtraction (op = 6)
//             slt  (op = 7)
//             xor (op = 11)
//             nor (op = 12)
module ALU #(parameter N = 32) (output wire [N-1:0] out,  
                                output wire zero,
                                input  signed     [N-1:0] inA, inB,
                                input       [3:0] op, 
                                input [31:0] PC);
  
  assign  out = 
      (op == 4'b0000) ? (inA + inB) : 
      (op == 4'b0001 || op == 4'b1010) ? (inA - inB) : 
      (op == 4'b0010) ? (inA ^ inB) : 
      (op == 4'b0011) ? (inA | inB) : 
      (op == 4'b0100) ? (inA & inB) : 
      (op == 4'b0101) ? (inA << inB) : 
      (op == 4'b0110) ? (inA >> inB) : 
      (op == 4'b0111) ? $signed(inA) >>> inB : // shift right arithmetic
      (op == 4'b1000) ? ( (inA < inB) ? 1 : 0 ) : 
      (op == 4'b1001 || op == 4'b1011) ? ( ($unsigned(inA) < $unsigned(inB)) ? 1 : 0) : 
      (op == 4'b1100) ? (inB << 12) : 
      (op == 4'b1101) ? (PC + inB << 12) : 0;

  assign zero = 
      (op == 4'b0001) ? (out == 0) : //beq, bne
      (op == 4'b1010) ? (out < 0) : //blt, bge
      (op == 4'b1011) ? (out == 1) : 0;//bltu, bgeu
endmodule


// Memory (active 4K words, from 12 address lsbs).
// Read : disable wen, enable ren, address addr, data dout
// Write: enable wen, disable ren, address addr, data din.
module Dmem (input clock, reset, 
               input ren, wen, 
               input [`DATA_BITS-3:0] addr, 
               input [31:0] din, 
               output [31:0] dout);

  reg [31:0] data[0:2**(`DATA_BITS-2)-1];

  assign dout = data[addr];

  always @(ren or wen)
    if (ren & wen)
      $display ("\nMemory ERROR (time %0d): ren and wen both active!\n", $time);

  /*always @(posedge ren or posedge wen) begin
    if (addr[31:12] != 0)
      $display("Memory WARNING (time %0d): address msbs are not zero\n", $time);
  end*/  
  
  /* Write memory in the negative edge of the clock */
   always @(posedge clock)
   begin
          if (wen == 1'b1 && ren==1'b0)
               data[addr] <= din;
   end

`ifdef DATA_HEX
    initial $readmemh(`DATA_HEX, data);
`endif

endmodule

module Imem (input clock, reset, 
               input ren, wen, 
               input  [`TEXT_BITS-3:0] addr, 
               input [31:0] din, 
               output [31:0] dout);

  reg [31:0] data[0:2**(`TEXT_BITS-2)-1];

  assign dout = data[addr];

  always @(ren or wen)
    if (ren & wen)
      $display ("\nMemory ERROR (time %0d): ren and wen both active!\n", $time);

  /*always @(posedge ren or posedge wen) begin
    if (addr[31:12] != 0)
      $display("Memory WARNING (time %0d): address msbs are not zero\n", $time);
  end*/  
  
  /* Write memory in the negative edge of the clock */
   always @(posedge clock)
   begin
          if (wen == 1'b1 && ren==1'b0)
               data[addr] <= din;
   end

`ifdef TEXT_HEX
    initial $readmemh(`TEXT_HEX, data);
`endif

endmodule


// Register File. Read ports: address raA, data rdA, renA
//                            address raB, data rdB, renB
//                Write port: address wa, data wd, enable wen.
module RegFile (input clock, reset,
                input [4:0] raA, raB, wa,
                input wen, 
                input [31:0] wd,
                output reg[31:0] rdA, rdB);
  integer i; 
  reg [31:0] data[31:0];
  
  // The register file is written at the positive edge. Make sure that bypasssing is enabled. 
  always @(posedge clock or negedge reset)
   begin
    if (reset == 1'b0) 
      begin
        rdA <= 0;
        rdB <= 0;
        for (i = 0; i < 32; i = i+1)
          data[i] = i;   // Note that R0 = 0 in MIPS 
      end
    else 
    begin
      rdA <= (wen == 1'b1 && wa == raA && wa != 5'b0) ? wd : data[raA];
      rdB <= (wen == 1'b1 && wa == raB && wa != 5'b0) ? wd : data[raB];
      if (wen == 1'b1 && wa != 5'b0) data[wa] <=  wd;
    end
   end

endmodule

module signExtendUnit(output reg [31:0] out, 
                      input [31:0] imm_i, 
                      input [31:0] imm_s, 
                      input [31:0] imm_b, 
                      input [31:0] imm_u, 
                      input [31:0] imm_j, 
                      input [6:0] opcode);
  always @(*)
  begin
    case (opcode)
    `I_COMP_FORMAT: out = imm_i;
    `I_LOAD_FORMAT: out = imm_i;
    `S_FORMAT: out = imm_s;
    `B_FORMAT: out = imm_b;
    `J_FORMAT: out = imm_j;
    default: out = 32'b0;
    endcase
  end
endmodule

