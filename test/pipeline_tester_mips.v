`include "../include/constants.vh"
`include "../src/control.v"
`include "../src/cpu.v"

`define clock_period  10
`timescale 1ns/1ps

module cpu_tb;
  integer   i, test, fail;
  reg       clock, reset; 
  reg [0:319]str;
  parameter print = 0;
  cpu cpu0(clock, reset);

     
  always 
     #(`clock_period / 2) clock = ~clock; 

    
  initial begin  
    clock = 1'b0;       
    reset = 1'b0;
    test  = 0;
    fail  = 0;

    // 1.   NOTHING SPECIAL
    str = " NOTHING SPECIAL";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = 1; 
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 2.   FORWARD A FROM EX 
    str = " FORWARD A FROM EX ";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 *
    cpu0.cpu_IMem.data[2] = 32'b000000_00010_00101_00011_00000_100000;  // add $3, $2, $5 forward $2
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd12 && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 3.   FORWARD B FROM EX 
    str = " FORWARD B FROM EX ";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 *
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00010_00011_00000_100000;  // add $3, $4, $2 forward $2
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd11 && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 

    // 4.   FORWARD A & B FROM EX 
    str = " FORWARD A & B FROM EX ";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 *
    cpu0.cpu_IMem.data[2] = 32'b000000_00010_00010_00011_00000_100000;  // add $3, $2, $2 forward $2
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd14 && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    
    // 5.   FORWARD A FROM MEM
    str = " FORWARD A FROM MEM";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 * 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00110_00100_00000_100000;  // add $4, $2, $6 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd13 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 6.   FORWARD B FROM MEM
    str = " FORWARD B FROM MEM";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 * 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00010_00100_00000_100000;  // add $4, $5, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd12 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 7.   FORWARD A & B FROM MEM
    str = " FORWARD A & B FROM MEM";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 *
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00010_00100_00000_100000;  // add $4, $2, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd14 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 

    // 8.   FORWARD A FROM EX INSTEAD OF MEM
    str = " FORWARD A FROM EX INSTEAD OF MEM";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00010_00000_100000;  // add $2, $4, $5 *
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00110_00100_00000_100000;  // add $4, $2, $6 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd15 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 9.   FORWARD B FROM EX INSTEAD OF MEM
    str = " FORWARD B FROM EX INSTEAD OF MEM";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00010_00000_100000;  // add $2, $4, $5 *
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00010_00100_00000_100000;  // add $4, $5, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd14 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 10.  FORWARD A & B FROM EX INSTEAD OF MEM
    str = " FORWARD A & B FROM EX INSTEAD OF MEM";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00010_00000_100000;  // add $2, $4, $5 *
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00010_00100_00000_100000;  // add $4, $2, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd18 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 11.  FORWARD MIX
    str = " FORWARD MIX";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00010_00000_100000;  // add $2, $3, $1 forward $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00010_00101_00011_00000_100000;  // add $3, $2, $5 forward $2
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00011_00100_00000_100000;  // add $4, $2, $3 forward $2, $3 
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd8  && 
        cpu0.cpu_regs.data[3] == 32'd13 && 
        cpu0.cpu_regs.data[4] == 32'd21 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 12.  LW DO NOTHING
    str = " LW DO NOTHING";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    cpu0.cpu_DMem.data[10] = 10; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b100011_01010_00010_0000000000000000;    // lw  $2, 0($10)
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00010_00111_00101_00000_100000;  // add $5, $2, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(12*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd10 && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd17 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 13.  LW FORWARD
    str = " LW FORWARD";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    cpu0.cpu_DMem.data[10] = 10; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b100011_01010_00010_0000000000000000;    // lw  $2, 0($10) *
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00010_00100_00000_100000;  // add $4, $5, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(12*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd10 && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd15 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 14.  LW STALL
    str = " LW STALL";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    cpu0.cpu_DMem.data[10] = 10; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b100011_01010_00010_0000000000000000;    // lw  $2, 0($10) *
    cpu0.cpu_IMem.data[2] = 32'b000000_00010_00101_00011_00000_100000;  // add $3, $2, $5 Stall and forward
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(12*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd10 && 
        cpu0.cpu_regs.data[3] == 32'd15 && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 15.  LW STALL MIX
    str = " LW STALL MIX";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    cpu0.cpu_DMem.data[10] = 10; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b100011_01010_00010_0000000000000000;    // lw  $2, 0($10) 
    cpu0.cpu_IMem.data[2] = 32'b100011_00010_00011_0000000000000000;    // lw  $3, 0($2)  
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00011_00100_00000_100000;  // add $4, $2, $3
    cpu0.cpu_IMem.data[4] = 32'b000000_00011_00100_00101_00000_100000;  // add $5, $3, $4
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(13*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd10 && 
        cpu0.cpu_regs.data[3] == 32'd10 && 
        cpu0.cpu_regs.data[4] == 32'd20 && 
        cpu0.cpu_regs.data[5] == 32'd30 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 16.  SW DO NOTHING
    str = " SW DO NOTHING";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b101011_00001_00001_0000000000000000;    // sw  $1, 0($1) 
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_DMem.data[5] == 32'd5 )     // data memory
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_DMem.data[5] = %2d", cpu0.cpu_DMem.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 17.  SW FORWARD EX OFFSET(MEM)
    str = " SW FORWARD EX OFFSET(MEM)";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b101011_00100_00011_0000000000000000;    // sw  $3, 0($4) 
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_DMem.data[11]== 32'd9 )     // data memory
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_DMem.data[11] = %2d", cpu0.cpu_DMem.data[11]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 18.  SW FORWARD MEM OFFSET(EX)
    str = " SW FORWARD MEM OFFSET(EX)";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b101011_00011_00100_0000000000000000;    // sw  $4, 0($3) 
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_DMem.data[9] == 32'd11 )     // data memory
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_DMem.data[9] = %2d", cpu0.cpu_DMem.data[9]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 19.  ADDI
    str = " ADDI";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b001000_00100_00011_0000000000000001;    // addi $3, $4, 1 
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd5  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 20.  ADDI & SW (FORWARD)
    str = " ADDI & SW (FORWARD)";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b001000_00100_00011_0000000000000001;    // addi $3, $4, 1 
    cpu0.cpu_IMem.data[3] = 32'b101011_00010_00011_0000000000000000;    // sw  $3, 0($2) 
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd5  &&  
        cpu0.cpu_regs.data[5] == 32'd13 &&
        cpu0.cpu_DMem.data[7] == 32'd5)
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_DMem.data[7] = %2d", cpu0.cpu_DMem.data[7]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 21.  SLL
    str = " SLL";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00000_00100_00011_00010_000000;  // sll $3, $4, 2
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd16 && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 22.  SLLV
    str = " SLLV";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00001_00100_00100_00000_000100;  // sllv $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd128&& 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[1] = %2d", cpu0.cpu_regs.data[1]); 
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 

    // 23.  BEQ(-5) NT
    str = " BEQ(-5) NT";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000100_01001_00000_1111111111111011;    // beq $9, $1, -5 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  && 
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end    #(`clock_period) 
    reset = 1'b0; 



    // 24.  BEQ(+2) NT
    str = " BEQ(+2) NT";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000100_01001_00000_0000000000000010;    // beq $9, $1, +2 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  && 
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end    #(`clock_period) 
    reset = 1'b0; 



    // 25.  BEQ(-5)  T
    str = " BEQ(-5)  T";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000100_01001_01010_1111111111111011;    // beq $9, $10, -5 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd5  && 
        cpu0.cpu_regs.data[4] == 32'd6  &&
        cpu0.cpu_regs.data[5] == 32'd7  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd11)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 26.  BEQ(-6)  T
    str = " BEQ(-6)  T";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000100_01001_01010_1111111111111010;    // beq $9, $10, -6 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd4  && 
        cpu0.cpu_regs.data[3] == 32'd5  && 
        cpu0.cpu_regs.data[4] == 32'd6  &&
        cpu0.cpu_regs.data[5] == 32'd7  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd11)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 27.  BEQ(+2)  T
    str = " BEQ(+2)  T";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000100_01001_01010_0000000000000010;    // beq $9, $10, +2 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  &&
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 28.  BEQ(-5) NT NOTHING AFTER BRANCH
    str = " BEQ(-5) NT NOTHING AFTER BRANCH";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000100_01001_00000_1111111111111011;    // beq $9, $10, -5 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00000_00110_00000_100000;  // add $6, $6, $0
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00000_00111_00000_100000;  // add $7, $7, $0
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00000_01000_00000_100000;  // add $8, $8, $0
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  && 
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd8  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end    #(`clock_period) 
    reset = 1'b0; 




    // 29.  BEQ(-5)  T NOTHING AFTER BRANCH
    str = " BEQ(-5)  T NOTHING AFTER BRANCH";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000100_01001_01010_1111111111111011;    // beq $9, $10, -5 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00000_00110_00000_100000;  // add $6, $6, $0
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00000_00111_00000_100000;  // add $7, $7, $0
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00000_01000_00000_100000;  // add $8, $8, $0
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd5  && 
        cpu0.cpu_regs.data[4] == 32'd6  &&
        cpu0.cpu_regs.data[5] == 32'd7  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd8  && 
        cpu0.cpu_regs.data[9] == 32'd11)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 30.  BNE(-5) NT
    str = " BNE(-5) NT";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000101_01001_01010_1111111111111011;    // bne $9, $10, -5 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  && 
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end    #(`clock_period) 
    reset = 1'b0; 



    // 31.  BNE(+2) NT
    str = " BNE(+2) NT";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000101_01001_01010_0000000000000010;    // bne $9, $10, +2 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  && 
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end    #(`clock_period) 
    reset = 1'b0; 



    // 32.  BNE(-5)  T
    str = " BNE(-5)  T";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000101_01001_01011_1111111111111011;    // bne $9, $11, -5 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd5  && 
        cpu0.cpu_regs.data[4] == 32'd6  &&
        cpu0.cpu_regs.data[5] == 32'd7  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd11)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 33.  BNE(-6)  T
    str = " BNE(-6)  T";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000101_01001_01011_1111111111111010;    // bne $9, $11, -6 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd4  && 
        cpu0.cpu_regs.data[3] == 32'd5  && 
        cpu0.cpu_regs.data[4] == 32'd6  &&
        cpu0.cpu_regs.data[5] == 32'd7  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd11)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 34.  BNE(+2)  T
    str = " BNE(+2)  T";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000101_01001_00000_0000000000000010;    // bne $9, $0, +2 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  &&
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 35.  BNE(-5) NT NOTHING AFTER BRANCH
    str = " BNE(-5) NT NOTHING AFTER BRANCH";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000101_01001_01010_1111111111111011;    // bne $9, $10, -5 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00000_00110_00000_100000;  // add $6, $6, $0
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00000_00111_00000_100000;  // add $7, $7, $0
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00000_01000_00000_100000;  // add $8, $8, $0
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  && 
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd8  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end    #(`clock_period) 
    reset = 1'b0; 




    // 36.  BNE(-5)  T NOTHING AFTER BRANCH
    str = " BNE(-5)  T NOTHING AFTER BRANCH";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000101_01001_01011_1111111111111011;    // bne $9, $11, -5 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00000_00110_00000_100000;  // add $6, $6, $0
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00000_00111_00000_100000;  // add $7, $7, $0
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00000_01000_00000_100000;  // add $8, $8, $0
    reset = 1'b1;
    test = test +1;
    #(30*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd5  && 
        cpu0.cpu_regs.data[4] == 32'd6  &&
        cpu0.cpu_regs.data[5] == 32'd7  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd8  && 
        cpu0.cpu_regs.data[9] == 32'd11)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 37.  JUMP+
    str = " JUMP+";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b000010_00000000000000000000000110;      // j 6
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[5] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[6] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd4  &&
        cpu0.cpu_regs.data[5] == 32'd5  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 38.  JUMP-
    str = " JUMP-";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[4] = 32'b000010_00000000000000000000000010;      // j 2 
    cpu0.cpu_IMem.data[5] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[6] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd11 &&
        cpu0.cpu_regs.data[5] == 32'd12 && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd8  && 
        cpu0.cpu_regs.data[9] == 32'd9)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 39.  JUMP+      NOTHING AFTER JUMP    
    str = " JUMP+      NOTHING AFTER JUMP";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b000010_00000000000000000000000110;      // j 6
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00000_00100_00000_100000;  // add $4, $4, $0
    cpu0.cpu_IMem.data[4] = 32'b000000_00101_00000_00101_00000_100000;  // add $5, $5, $0 
    cpu0.cpu_IMem.data[5] = 32'b000000_00110_00000_00110_00000_100000;  // add $6, $6, $0
    cpu0.cpu_IMem.data[6] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd4  &&
        cpu0.cpu_regs.data[5] == 32'd5  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 40.  JUMP-      NOTHING AFTER JUMP    
    str = " JUMP-      NOTHING AFTER JUMP";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[4] = 32'b000010_00000000000000000000000010;      // j 2 
    cpu0.cpu_IMem.data[5] = 32'b000000_00110_00000_00110_00000_100000;  // add $6, $6, $0
    cpu0.cpu_IMem.data[6] = 32'b000000_00111_00000_00111_00000_100000;  // add $7, $7, $0
    cpu0.cpu_IMem.data[7] = 32'b000000_01000_00000_01000_00000_100000;  // add $8, $8, $0
    cpu0.cpu_IMem.data[8] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd11 &&
        cpu0.cpu_regs.data[5] == 32'd12 && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd8  && 
        cpu0.cpu_regs.data[9] == 32'd9)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 41.  JUMP+ | BEQ(+2) NT |RAND|RAND|RAND
    str = " JUMP+ | BEQ(+2) NT |RAND|RAND|RAND";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b000100_00001_00010_0000000000000010;    // beq $1, $2, +2
    cpu0.cpu_IMem.data[3] = 32'b000010_00000000000000000000001000;      // j 8 
    cpu0.cpu_IMem.data[4] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[5] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[9] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd4  &&
        cpu0.cpu_regs.data[5] == 32'd5  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 42.  JUMP+ | BEQ(+2)  T |RAND|RAND|RAND
    str = " JUMP+ | BEQ(+2)  T |RAND|RAND|RAND";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b000100_00001_00001_0000000000000010;    // beq $1, $1, +2 
    cpu0.cpu_IMem.data[3] = 32'b000010_00000000000000000000000010;      // j 8 
    cpu0.cpu_IMem.data[4] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[5] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[9] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd4  &&
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 43.  JUMP+ |RAND| BEQ(+2) NT |RAND|RAND
    str = " JUMP+ |RAND| BEQ(+2) NT |RAND|RAND";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b000100_00001_00010_0000000000000010;    // beq $1, $2, +2
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000010_00000000000000000000001000;      // j 8 
    cpu0.cpu_IMem.data[5] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[9] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  &&
        cpu0.cpu_regs.data[5] == 32'd5  && 
        cpu0.cpu_regs.data[6] == 32'd6  && 
        cpu0.cpu_regs.data[7] == 32'd7  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 




    // 44.  JUMP+ |RAND| BEQ(+2)  T |RAND|RAND
    str = " JUMP+ |RAND| BEQ(+2)  T |RAND|RAND";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b000100_00001_00001_0000000000000010;    // beq $1, $1, +2 
    cpu0.cpu_IMem.data[3] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000010_00000000000000000000001000;      // j 8 
    cpu0.cpu_IMem.data[5] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[9] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd4  &&
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 45.  BEQ(+3) NT FOLLOWED BY LW WITH STALL 
    str = " BEQ(+3) NT FOLLOWED BY LW WITH STALL ";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i;
    cpu0.cpu_DMem.data[10] = 10;  
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000100_00001_00010_0000000000000011;    // beq $1, $2, +3 
    cpu0.cpu_IMem.data[2] = 32'b100011_01010_00011_0000000000000000;    // lw  $3, 0($10) *
    cpu0.cpu_IMem.data[3] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1 Stall and forward
    cpu0.cpu_IMem.data[4] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[5] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[9] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd11 && 
        cpu0.cpu_regs.data[4] == 32'd5  &&
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 46.  BEQ(+3)  T FOLLOWED BY LW WITH STALL 
    str = " BEQ(+3)  T FOLLOWED BY LW WITH STALL ";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i;
    cpu0.cpu_DMem.data[10] = 10;  
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000100_00001_00001_0000000000000011;    // beq $1, $1, +3 
    cpu0.cpu_IMem.data[2] = 32'b100011_01010_00011_0000000000000000;    // lw  $3, 0($10) *
    cpu0.cpu_IMem.data[3] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1 Stall and forward
    cpu0.cpu_IMem.data[4] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[5] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[9] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd3  && 
        cpu0.cpu_regs.data[4] == 32'd4  &&
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 47.  LW STALL & BEQ(+3)  T 
    str = " LW STALL & BEQ(+3)  T ";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i;
    cpu0.cpu_DMem.data[10] = 4;  
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00010_00010_00000_100000;  // add $2, $2, $2
    cpu0.cpu_IMem.data[2] = 32'b100011_01010_00011_0000000000000000;    // lw  $3, 0($10)
    cpu0.cpu_IMem.data[1] = 32'b000100_00011_00010_0000000000000011;    // beq $3, $2, +3 
    cpu0.cpu_IMem.data[4] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[5] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[9] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd4  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  &&
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 


    // 48.  BEQ(+oo)  NT & BEQ(+2)  T 
    str = " BEQ(+oo)  NT & BEQ(+2)  T ";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i;
    cpu0.cpu_DMem.data[10] = 4;  
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000100_00111_00011_0101010101010101;    // beq $7, $3, +..... 
    cpu0.cpu_IMem.data[2] = 32'b000100_00011_00010_0000000000000011;    // beq $3, $2, +2
    cpu0.cpu_IMem.data[3] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1 
    cpu0.cpu_IMem.data[4] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[5] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1 
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[7] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    cpu0.cpu_IMem.data[8] = 32'b000000_01000_00001_01000_00000_100000;  // add $8, $8, $1
    cpu0.cpu_IMem.data[9] = 32'b000000_01001_00001_01001_00000_100000;  // add $9, $9, $1
    reset = 1'b1;
    test = test +1;
    #(34*`clock_period)   
    if (cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd3  && 
        cpu0.cpu_regs.data[4] == 32'd4  &&
        cpu0.cpu_regs.data[5] == 32'd5  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8  && 
        cpu0.cpu_regs.data[8] == 32'd9  && 
        cpu0.cpu_regs.data[9] == 32'd10)
                $display ("%2d [PASS] :  %0s", test, str);
    else  
    begin       $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin    
        $display ("  cpu0.cpu_regs.data[2] = %2d",cpu0.cpu_regs.data[2] ); 
        $display ("  cpu0.cpu_regs.data[3] = %2d",cpu0.cpu_regs.data[3] );   
        $display ("  cpu0.cpu_regs.data[4] = %2d",cpu0.cpu_regs.data[4] ); 
        $display ("  cpu0.cpu_regs.data[5] = %2d",cpu0.cpu_regs.data[5] ); 
        $display ("  cpu0.cpu_regs.data[6] = %2d",cpu0.cpu_regs.data[6] ); 
        $display ("  cpu0.cpu_regs.data[7] = %2d",cpu0.cpu_regs.data[7] ); 
        $display ("  cpu0.cpu_regs.data[8] = %2d",cpu0.cpu_regs.data[8] ); 
        $display ("  cpu0.cpu_regs.data[9] = %2d",cpu0.cpu_regs.data[9] ); 
    end
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 49.  REGFILE READ & WRITE 
    str = " REGFILE READ & WRITE ";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00001_00100_00000_100000;  // add $4, $4, $1
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00010_00101_00000_100000;  // add $5, $5, $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    cpu0.cpu_IMem.data[5] = 32'b000000_00111_00001_00111_00000_100000;  // add $7, $7, $1
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(15*`clock_period)   
    if ( 
        cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd5  && 
        cpu0.cpu_regs.data[5] == 32'd8  && 
        cpu0.cpu_regs.data[6] == 32'd7  && 
        cpu0.cpu_regs.data[7] == 32'd8 )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
        $display ("   cpu0.cpu_regs.data[6] = %2d", cpu0.cpu_regs.data[6]); 
        $display ("   cpu0.cpu_regs.data[7] = %2d", cpu0.cpu_regs.data[7]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 



    // 50.  UNNECESSARY STALLS
    str = " UNNECESSARY STALLS";
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    cpu0.cpu_DMem.data[10] =10; 
    cpu0.cpu_DMem.data[11] =11; 
    cpu0.cpu_DMem.data[12] =12; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00001_00010_00000_100000;  // add $2, $2, $1
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00011_00000_100000;  // add $3, $3, $1
    cpu0.cpu_IMem.data[2] = 32'b100011_01010_00100_0000000000000000;    // lw  $4, 0($10) *
    cpu0.cpu_IMem.data[3] = 32'b100011_01011_00100_0000000000000000;    // lw  $4, 0($11) *
    cpu0.cpu_IMem.data[4] = 32'b100011_01100_00100_0000000000000000;    // lw  $4, 0($12) *
    cpu0.cpu_IMem.data[5] = 32'b000000_00101_00001_00101_00000_100000;  // add $5, $5, $1
    cpu0.cpu_IMem.data[6] = 32'b000000_00110_00001_00110_00000_100000;  // add $6, $6, $1
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(15*`clock_period)   
    if ( 
        cpu0.cpu_regs.data[2] == 32'd3  && 
        cpu0.cpu_regs.data[3] == 32'd4  && 
        cpu0.cpu_regs.data[4] == 32'd12 && 
        cpu0.cpu_regs.data[5] == 32'd6  && 
        cpu0.cpu_regs.data[6] == 32'd7  )
                $display ("%2d [PASS] :  %0s", test, str);
    else  begin $display ("%2d [FAIL] :  %0s", test, str); fail = fail + 1; 
    if (print) begin
        $display ("   cpu0.cpu_regs.data[2] = %2d", cpu0.cpu_regs.data[2]); 
        $display ("   cpu0.cpu_regs.data[3] = %2d", cpu0.cpu_regs.data[3]); 
        $display ("   cpu0.cpu_regs.data[4] = %2d", cpu0.cpu_regs.data[4]); 
        $display ("   cpu0.cpu_regs.data[5] = %2d", cpu0.cpu_regs.data[5]); 
        $display ("   cpu0.cpu_regs.data[6] = %2d", cpu0.cpu_regs.data[6]); 
    end  
    end
    #(`clock_period) 
    reset = 1'b0; 

  $display ("Score = %2d / %2d ", test - fail, test);  

  #(`clock_period)  $finish;

 end 



endmodule
