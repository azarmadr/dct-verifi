/********************************************************************** 
** -----------------------------------------------------------------------------** 
** idct.v 
** 
** 8x8 Inverse Discrete Cosine Transform 
** 
** 
** 
**                  Author: Latha Pillai 
**                  Senior Applications Engineer 
** 
**                  Video Applications 
**                  Advanced Products Group 
**                  Xilinx, Inc. 
** 
**                  Copyright (c) 2001 Xilinx, Inc. 
**                  All rights reserved 
** 
**                  Date:   Feb. 10, 2002 
** 
**                  RESTRICTED RIGHTS LEGEND 
** 
**      This software has not been published by the author, and  
**      has been disclosed to others for the purpose of enhancing  
**      and promoting design productivity in Xilinx products. 
** 
**      Therefore use, duplication or disclosure, now and in the  
**      future should give consideration to the productivity  
**      enhancements afforded the user of this code by the author's  
**      efforts.  Thank you for using our products ! 
** 
** Disclaimer:  THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY  
**              WHATSOEVER AND XILINX SPECIFICALLY DISCLAIMS ANY  
**              IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR 
**              A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT. 
 
# Module: idct8x8  
1. A 1D-IDCT is implemented on the input dct values
2. The output of this called the intermediate value is stored in a RAM
3. The 2nd 1D-IDCT operation is done on this stored value to give the final 2D-IDCT output idct_2d
4. The inputs are 9 bits wide and the 2d-idct outputs are 8 bits wide

## 1st 1D section 
The input signals are taken one pixel at a time in the order x00 to x07, x10 to x07 and so on up to x77
These inputs are fed into a 8 bit shift  register
The outputs of the 8 bit shift registers are registered at every  8th clock .This will enable us to register in 8 pixels (one row) at atime
 The pixels are fed into a multiplier whose other input is connected to stored  values in registers which act as memory
The outputs of the 8 multipliers are  added at every CLK in the final adder
The ouput of the adder z_out is the  1D-IDCT values given out in the order in which the inputs were read in
 It takes 8 clks to read in the first set of inputs, 1 clk to get the absolute  value of the input, 1 clk for multiplication, 2 clk for the final adder
 total = 12 clks to get the 1st z_out value
Every subsequent clk gives out the next z_out value
So to get all the 64 values we need 12+64=76 clks

## Storage / RAM section 
The outputs z_out of the adder are stored in RAMs
Two RAMs are used so that  data write can be continuous
The 1st valid input for the RAM1 is available  at the 12th clk
So the RAM1 enable is active after 11 clks
After this the  write operation continues for 64 clks 
At the 65th clock, since z_out is  continuous, we get the next valid z_out_00
This 2nd set of valid 1D-DCT  coefficients are written into RAM2 which is enabled at 12+64 clks
 So at 65th clk, RAM1 goes into read mode for the next 64 clks and RAM2 is in  write mode
After this for every 64 clks, the read and write switches between  the 2 RAMS

## 2nd 1D-IDCT section 
After the 1st 76th clk when RAM1 is full, the 2nd 1d calculations can start
 The second 1D implementation is the same as the 1st 1D implementation with  the inputs now coming from either RAM1 or RAM2
Also, the inputs are read in  one column at a time in the order z00 to z70, z10 to z70 up to z77
The  outputs from the adder in the 2nd section are the 2D-IDCT coefficients

***********************************************************************/ 
`timescale 1ns/1ps 
 
module idct ( CLK, RST, rdy_in, dct_2d,idct_2d); 
output [7:0] idct_2d; 
input CLK, RST,rdy_in; 
input[11:0] dct_2d; 
wire[7:0] idct_2d; 
 
/* constants */ 
reg[7:0] memory1a, memory2a, memory3a, memory4a; 
reg[7:0] memory5a, memory6a, memory7a, memory8a; 
 
/* 1D section */ 
/* The max value of a pixel after processing (to make their expected mean to zero) 
is 2047. If all the values in a row are 2047, the max value of the product terms 
would be (127*2)*23170 and that of z_out_int would be (2047*8)*23170=235,407,20 which  
is a 25 bit binary. This value divided by 2raised to 16 
is equivalent to ignoring the 16 lsb bits of the value */ 
reg[11:0] xa0_in, xa1_in, xa2_in, xa3_in, xa4_in, xa5_in, xa6_in, xa7_in; 
reg[11:0] xa0_reg, xa1_reg, xa2_reg, xa3_reg, xa4_reg, xa5_reg, xa6_reg, xa7_reg; 
reg[10:0] xa0_reg_comp, xa1_reg_comp, xa2_reg_comp, xa3_reg_comp,  
         xa4_reg_comp, xa5_reg_comp, xa6_reg_comp, xa7_reg_comp; 
reg xa0_reg_sign, xa1_reg_sign, xa2_reg_sign, xa3_reg_sign,  
           xa4_reg_sign, xa5_reg_sign, xa6_reg_sign, xa7_reg_sign; 
reg[21:0] p1a,p2a,p3a,p4a,p5a,p6a,p7a,p8a; 
wire[35:0] p1a_all,p2a_all,p3a_all,p4a_all,p5a_all,p6a_all,p7a_all,p8a_all; 
reg[21:0] z_out_int1, z_out_int2, z_out_int3; 
reg[21:0] z_out_int4;  
reg[21:0] z_out_int; 
wire[10:0] z_out_rnd; 
wire[10:0] z_out; 
reg[2:0] indexi_val; 
 
/* clks and counters */ 
reg[3:0] cntr11 ; 
reg[3:0] cntr8, prod_en1; 
reg[6:0] cntr80; 
reg[6:0] wr_cntr,rd_cntr; 
reg[10:0] ram1_mem[63:0],ram2_mem[63:0]; // add the following to infer block RAM in synlpicity 
                                         //    synthesis syn_ramstyle = "block_ram"    
 
/* memory section */ 
reg[10:0] data_out; 
reg[10:0] data_out_pipe1; 
wire en_ram1,en_dct2d; 
reg en_ram1reg,en_dct2d_reg; 
 
/* 2D section */ 
wire[10:0] data_out_final; 
reg[10:0] xb0_in, xb1_in, xb2_in, xb3_in, xb4_in, xb5_in, xb6_in, xb7_in; 
reg[10:0] xb0_reg, xb1_reg, xb2_reg, xb3_reg, xb4_reg, xb5_reg, xb6_reg, xb7_reg; 
reg[9:0] xb0_reg_comp, xb1_reg_comp, xb2_reg_comp, xb3_reg_comp,  
         xb4_reg_comp, xb5_reg_comp, xb6_reg_comp, xb7_reg_comp; 
reg xb0_reg_sign, xb1_reg_sign, xb2_reg_sign, xb3_reg_sign,  
    xb4_reg_sign, xb5_reg_sign, xb6_reg_sign, xb7_reg_sign; 
 
reg[15:0] p1b,p2b,p3b,p4b,p5b,p6b,p7b,p8b; 
wire[35:0] p1b_all,p2b_all,p3b_all,p4b_all,p5b_all,p6b_all,p7b_all,p8b_all; 
reg[19:0] idct_2d_int1,idct_2d_int2,idct_2d_int3,idct_2d_int4; 
reg[19:0] idct_2d_int; 
//wire[7:0] idct_2d_rnd; 
 
/*  1D-DCT BEGIN */ 
 
// store  1D-DCT constant coeeficient values for multipliers */ 
 
always @ (posedge RST or posedge CLK) 
   begin 
   if (RST) 
       begin 
       memory1a <= 8'd0; memory2a <= 8'd0; memory3a <= 8'd0; memory4a <= 8'd0; 
       memory5a <= 8'd0; memory6a <= 8'd0; memory7a <= 8'd0; memory8a <= 8'd0; 
       end 
   else 
       begin 
	     case (indexi_val) 
       3'b000 : begin memory1a <= 8'd91; memory2a <= 8'd126;  
                      memory3a <= 8'd118; memory4a <= 8'd106; 
                      memory5a <= 8'd91; memory6a <= 8'd71;  
                      memory7a <= 8'd49; memory8a <= 8'd25;end 
          
       3'b001 : begin memory1a <= 8'd91; memory2a <= 8'd106;   
                      memory3a <= 8'd49;   
                      memory4a[7] <= 1'd1; memory4a[6:0] <= 7'd25; 
                      memory5a[7] <= 1'd1;memory5a[6:0] <= 7'd91;  
                      memory6a[7] <= 1'd1;memory6a[6:0] <= 7'd126; 
                      memory7a[7] <= 1'd1;memory7a[6:0] <= 7'd118;  
                      memory8a[7] <= 1'd1;memory8a[6:0] <= 7'd71;end 
          
       3'b010 : begin memory1a <= 8'd91; memory2a <= 8'd71;   
                      memory3a[7] <= 1'd1;memory3a[6:0] <= 7'd49;  
                      memory4a[7] <= 1'd1;memory4a[6:0] <= 7'd126; 
                      memory5a[7] <= 1'd1;memory5a[6:0] <= 7'd91;  
                      memory6a <= 8'd25;  
                      memory7a <= 8'd118; memory8a <= 8'd106;end 
 
       3'b011 : begin memory1a <= 8'd91; memory2a <= 8'd25;   
                      memory3a[7] <= 1'd1;memory3a[6:0] <= 7'd118;  
                      memory4a[7] <= 1'd1;memory4a[6:0] <= 7'd71; 
                      memory5a <= 8'd91;  
                      memory6a <= 8'd106;  
                      memory7a[7] <= 1'd1;memory7a[6:0] <= 7'd49;  
                      memory8a[7] <= 1'd1;memory8a[6:0] <= 7'd126;end 
          
       3'b111 : begin memory1a <= 8'd91;  
                      memory2a[7] <= 1'd1;memory2a[6:0] <= 7'd126;  
                      memory3a <= 8'd118;  
                      memory4a[7] <= 1'd1;memory4a[6:0] <= 7'd106; 
                      memory5a <= 8'd91;  
                      memory6a[7] <= 1'd1;memory6a[6:0] <= 7'd71;  
                      memory7a <= 8'd49;  
                      memory8a[7] <= 1'd1;memory8a[6:0] <= 7'd25;end 
          
       3'b110 : begin memory1a <= 8'd91;  
                      memory2a[7] <= 1'd1;memory2a[6:0] <= 7'd106;   
                      memory3a <= 8'd49;   
                      memory4a <= 8'd25; 
                      memory5a[7] <= 1'd1;memory5a[6:0] <= 7'd91;  
                      memory6a <= 8'd126;  
                      memory7a[7] <= 1'd1;memory7a[6:0] <= 7'd118;  
                      memory8a <= 8'd71;end 
          
       3'b101 : begin memory1a <= 8'd91;  
                      memory2a[7] <= 1'd1;memory2a[6:0] <= 7'd71;   
                      memory3a[7] <= 1'd1;memory3a[6:0] <= 7'd49;  
                      memory4a <= 8'd126; 
                      memory5a[7] <= 1'd1;memory5a[6:0] <= 7'd91;  
                      memory6a[7] <= 1'd1;memory6a[6:0] <= 7'd25;  
                      memory7a <= 8'd118;  
                      memory8a[7] <= 1'd1;memory8a[6:0] <= 7'd106;end 
 
       3'b100 : begin memory1a <= 8'd91;  
                      memory2a[7] <= 1'd1;memory2a[6:0] <= 7'd25;   
                      memory3a[7] <= 1'd1;memory3a[6:0] <= 7'd118;  
                      memory4a <= 8'd71; 
                      memory5a <= 8'd91;  
                      memory6a[7] <= 1'd1;memory6a[6:0] <= 7'd106;  
                      memory7a[7] <= 1'd1;memory7a[6:0] <= 7'd49;  
                      memory8a <= 8'd126;end 
       
       endcase 
      end 
end 
 
 
/* 8-bit input shifted 8 times thru a shift register*/ 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       xa0_in <= 12'b0; xa1_in <= 12'b0; xa2_in <= 12'b0; xa3_in <= 12'b0; 
       xa4_in <= 12'b0; xa5_in <= 12'b0; xa6_in <= 12'b0; xa7_in <= 12'b0; 
       end 
   else if (rdy_in == 1'b1) 
       begin 
       xa0_in <= dct_2d; xa1_in <= xa0_in; xa2_in <= xa1_in; xa3_in <= xa2_in; 
       xa4_in <= xa3_in; xa5_in <= xa4_in; xa6_in <= xa5_in; xa7_in <= xa6_in; 
       end 
   else  
       begin 
       xa0_in <= 12'b0; xa1_in <= 12'b0; xa2_in <= 12'b0; xa3_in <= 12'b0; 
       xa4_in <= 12'b0; xa5_in <= 12'b0; xa6_in <= 12'b0; xa7_in <= 12'b0; 
       end 
   end 
 
/* shifted inputs registered every 8th clk (using cntr8)*/ 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       cntr8 <= 4'b0; 
       end 
   else if(rdy_in == 1'b1) 
       begin 
       if (cntr8 < 4'b1000) 
           begin 
           cntr8 <= cntr8 + 1; 
           end 
       else  
           begin 
           cntr8 <= 4'b001; 
           end 
       end 
   else  cntr8 <= 4'b0; 
 
   end 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       prod_en1 <= 4'b0000; 
       end 
   else if(rdy_in == 1'b1) 
       begin 
           if (prod_en1 < 4'b1001) 
           begin 
           prod_en1 <= prod_en1 + 1; 
           end 
       else  
           begin 
           prod_en1 <= 4'b1001; 
           end 
       end 
   end 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       xa0_reg <= 12'b0; xa1_reg <= 12'b0; xa2_reg <= 12'b0; xa3_reg <= 12'b0; 
       xa4_reg <= 12'b0; xa5_reg <= 12'b0; xa6_reg <= 12'b0; xa7_reg <= 12'b0; 
       end 
   else if (cntr8 == 4'b1000) 
       begin  
       xa0_reg <= xa0_in; xa1_reg <= xa1_in; xa2_reg <= xa2_in; xa3_reg <= xa3_in; 
       xa4_reg <= xa4_in; xa5_reg <= xa5_in; xa6_reg <= xa6_in; xa7_reg <= xa7_in; 
       end 
   else  
       begin 
       end 
   end 
/* take absolute value of signals */ 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       xa0_reg_comp <= 11'b0; xa1_reg_comp <= 11'b0; xa2_reg_comp <= 11'b0; xa3_reg_comp <= 11'b0; 
       xa4_reg_comp <= 11'b0; xa5_reg_comp <= 11'b0; xa6_reg_comp <= 11'b0; xa7_reg_comp <= 11'b0; 
       xa0_reg_sign <= 1'b0; xa1_reg_sign <= 1'b0; xa2_reg_sign <= 1'b0; xa3_reg_sign <= 1'b0; 
       xa4_reg_sign <= 1'b0; xa5_reg_sign <= 1'b0; xa6_reg_sign <= 1'b0; xa7_reg_sign <= 1'b0; 
       end 
   else  
       begin  
       xa0_reg_sign <= xa0_reg[11]; 
       xa0_reg_comp[10:0] <= (xa0_reg[11]) ? (-xa0_reg) : xa0_reg[10:0];  
       xa1_reg_sign <= xa1_reg[11]; 
       xa1_reg_comp[10:0] <= (xa1_reg[11]) ? (-xa1_reg) : xa1_reg[10:0];  
       xa2_reg_sign <= xa2_reg[11]; 
       xa2_reg_comp[10:0] <= (xa2_reg[11]) ? (-xa2_reg) : xa2_reg[10:0];  
       xa3_reg_sign <= xa3_reg[11]; 
       xa3_reg_comp[10:0] <= (xa3_reg[11]) ? (-xa3_reg) : xa3_reg[10:0]; 
       xa4_reg_sign <= xa4_reg[11]; 
       xa4_reg_comp[10:0] <= (xa4_reg[11]) ? (-xa4_reg) : xa4_reg[10:0];  
       xa5_reg_sign <= xa5_reg[11]; 
       xa5_reg_comp[10:0] <= (xa5_reg[11]) ? (-xa5_reg) : xa5_reg[10:0];  
       xa6_reg_sign <= xa6_reg[11]; 
       xa6_reg_comp[10:0] <= (xa6_reg[11]) ? (-xa6_reg) : xa6_reg[10:0];  
       xa7_reg_sign <= xa7_reg[11]; 
       xa7_reg_comp[10:0] <= (xa7_reg[11]) ? (-xa7_reg) : xa7_reg[10:0]; 
       end 
   end 
 
 
/* multiply the outputs of the add/sub block with the 8 sets of stored coefficients */ 
/* The inputs are shifted thru 8 registers in 8 clk cycles. The ouput of the shift 
registers are registered at the 9th clk. The values are then added or subtracted at the 10th 
clk. The first mutiplier output is obtained at the 11th clk. Memoryx[0] shd be accessed 
at the 11th clk*/ 
 
/*wait state counter */ 
// First valid add_sub appears at the 10th clk (8 clks for shifting inputs, 
// 9th clk for registering shifted input and 10th clk for add_sub 
// to synchronize the i value to the add_sub value, i value is incremented 
// only after 10 clks using i_wait 
/* max value for p1a = 2047*126. = 18 bits */ 
 
     assign p1a_all = xa7_reg_comp[10:0] * memory1a[6:0];/*11bits * 7bits = 18bits */ 
     assign p2a_all = xa6_reg_comp[10:0] * memory2a[6:0]; 
     assign p3a_all = xa5_reg_comp[10:0] * memory3a[6:0]; 
     assign p4a_all = xa4_reg_comp[10:0] * memory4a[6:0]; 
     assign p5a_all = xa3_reg_comp[10:0] * memory5a[6:0]; 
     assign p6a_all = xa2_reg_comp[10:0] * memory6a[6:0]; 
     assign p7a_all = xa1_reg_comp[10:0] * memory7a[6:0]; 
     assign p8a_all = xa0_reg_comp[10:0] * memory8a[6:0]; 
 
/* The following instantiation can be used while targetting Virtex2 */ 
//MULT18X18 mult1a (.A({10'b0,xa7_reg_comp[7:0]}), .B({11'b0,memory1a[6:0]}), .P(p1a_all)); 
//MULT18X18 mult2a (.A({10'b0,xa6_reg_comp[7:0]}), .B({11'b0,memory2a[6:0]}), .P(p2a_all)); 
//MULT18X18 mult3a (.A({10'b0,xa5_reg_comp[7:0]}), .B({11'b0,memory3a[6:0]}), .P(p3a_all)); 
//MULT18X18 mult4a (.A({10'b0,xa4_reg_comp[7:0]}), .B({11'b0,memory4a[6:0]}), .P(p4a_all)); 
//MULT18X18 mult5a (.A({10'b0,xa3_reg_comp[7:0]}), .B({11'b0,memory5a[6:0]}), .P(p5a_all)); 
//MULT18X18 mult6a (.A({10'b0,xa2_reg_comp[7:0]}), .B({11'b0,memory6a[6:0]}), .P(p6a_all)); 
//MULT18X18 mult7a (.A({10'b0,xa1_reg_comp[7:0]}), .B({11'b0,memory7a[6:0]}), .P(p7a_all)); 
//MULT18X18 mult8a (.A({10'b0,xa0_reg_comp[7:0]}), .B({11'b0,memory8a[6:0]}), .P(p8a_all)); 
 
always @ (posedge RST or posedge CLK) 
  begin 
    if (RST) 
      begin 
        p1a <= 21'b0; p2a <= 21'b0; p3a <= 21'b0; p4a <= 21'b0;  
        p5a <= 21'b0; p6a <= 21'b0; p7a <= 21'b0; p8a <= 21'b0; 
        indexi_val <= 3'b000; 
      end 
    else if (rdy_in == 1'b1 && prod_en1 == 4'b1001) 
        begin 
        p1a <= (xa7_reg_sign ^ memory1a[7])?(-p1a_all[17:0]):(p1a_all[17:0]); 
        p2a <= (xa6_reg_sign ^ memory2a[7])?(-p2a_all[17:0]):(p2a_all[17:0]); 
        p3a <= (xa5_reg_sign ^ memory3a[7])?(-p3a_all[17:0]):(p3a_all[17:0]); 
        p4a <= (xa4_reg_sign ^ memory4a[7])?(-p4a_all[17:0]):(p4a_all[17:0]); 
        p5a <= (xa3_reg_sign ^ memory5a[7])?(-p5a_all[17:0]):(p5a_all[17:0]); 
        p6a <= (xa2_reg_sign ^ memory6a[7])?(-p6a_all[17:0]):(p6a_all[17:0]); 
        p7a <= (xa1_reg_sign ^ memory7a[7])?(-p7a_all[17:0]):(p7a_all[17:0]); 
        p8a <= (xa0_reg_sign ^ memory8a[7])?(-p8a_all[17:0]):(p8a_all[17:0]); 
        if (indexi_val == 3'b111) 
          indexi_val <= 3'b000; 
        else  
          indexi_val <= indexi_val + 1'b1; 
        end 
   else 
        begin 
        p1a <= 21'b0; p2a <= 21'b0; p3a <= 21'b0; p4a <= 21'b0;  
        p5a <= 21'b0; p6a <= 21'b0; p7a <= 21'b0; p8a <= 21'b0; 
        end 
  end 
 
 
/* Final adder. Adding the ouputs of the 4 multipliers */ 
/* max value for z_out_int = 2047*126*8 = 2063376 = 21 bits */ 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       z_out_int1 <= 21'b0; z_out_int2 <= 21'b0; z_out_int3 <= 21'b0; 
       z_out_int4 <= 21'b0; z_out_int <= 21'b0; 
       end 
   else 
       begin 
       z_out_int1 <= (p1a + p2a); 
       z_out_int2 <= (p3a + p4a); 
       z_out_int3 <= (p5a + p6a); 
       z_out_int4 <= (p7a + p8a); 
       z_out_int  <= (z_out_int1 + z_out_int2 + z_out_int3 + z_out_int4); 
       end 
   end 
 
// rounding of the value 
/* max value for a 1D-DCT output is "11111111"*126*8/256=1004. 
To represent this we need only 10 bits, plus 1 bit for sign */ 
 
assign z_out_rnd = z_out_int[18:8]; 
assign z_out = z_out_int[7] ? (z_out_rnd + 1'b1) : z_out_rnd; 
 
/* 1D-DCT END */ 
 
/* tranpose memory to store intermediate Z coefficients */ 
/* store the 64 coefficients in the first 64 locations of the RAM */ 
/* first valid final (product) adder ouput is at the 13th clk. 8clk SR 
+ 1 clk reg + 1 clk comp + 1 clk prod. + 2 clks summing. 
So the RAM is enabled at the 11th clk) */ 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       cntr11 <= 4'b0; 
       end 
   else if (rdy_in == 1'b1) 
       begin 
       cntr11 <= cntr11 + 1; 
       end 
   end 
 
/* enable RAM at the 14th clk after RST goes inactive */ 
 
assign en_ram1 = RST ? 1'b0 : (cntr11== 4'b1100) ? 1'b1 : en_ram1; 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
	   en_ram1reg <= 1'b0; 
       end 
   else 
       begin 
       en_ram1reg <= en_ram1 ; 
       end 
   end 
 
/* After the RAM is enabled, data is written into the RAM1 for 64 clk cycles. Data is written in into 
each consecutive location . After 64 locations are written into, RAM1 goes into read mode and RAM2 goes into 
write mode. The cycle then repeats. 
For either RAM, data is written into each consecutive location. However , data is read in a different order. If data 
is assumed to be written in each row at a time, in an 8x8 matrix, data is read each column at a time. ie., after 
the first data is read out, every eight data is read out . Then the 2nd data is read out followed be every 8th. 
 
the write is as follows: 
1w(ram_locn1) 2w(ram_locn2) 3w(ram_locn3) 4w(ram_locn4) 5w(ram_locn5) 6w(ram_locn6) 7w(ram_locn7) 8w(ram_locn8) 
9w(ram_locn9) 10w(ram_locn10) 11w(ram_locn11) 12w(ram_locn12) 13w(ram_locn13) 14w(ram_locn14) 15w(ram_locn15) 16w(ram_locn16) 
.................. 
57w(ram_locn57) 58w(ram_locn58) 59w(ram_locn59) 60w(ram_locn60) 61w(ram_locn61) 62w(ram_locn62) 63w(ram_locn63) 64w(ram_locn64) 
 
the read is as follows: 
1r(ram_locn1)  9r(ram_locn2) . . . 57r(ram_locn8) 
2r(ram_locn9) 10r(ram_locn10) . . . 58r(ram_locn16)  
3r(ram_locn17) 11r(ram_locn18) . . . 59r(ram_locn24) 
4r(ram_locn25) 12r(ram_locn26) . . . 60r(ram_locn32) 
5r(ram_locn33) 13r(ram_locn34) . . . 61r(ram_locn40) 
6r(ram_locn41) 14r(ram_locn42) . . . 62r(ram_locn48) 
7r(ram_locn49) 15r(ram_locn50) . . . 63r(ram_locn56) 
8r(ram_locn57) 16r(ram_locn58) . . . 64r(ram_locn64) 
 
where "xw" is the xth write and "ram_locnx" is the xth ram location and "xr" is the xth read. Reading  
is advanced by the read counter rd_cntr, nd writing by the write counter wr_cntr. */ 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
	   rd_cntr[5:3] <= 3'b111; 
       end 
   else 
       begin  
	   if (en_ram1reg == 1'b1) 
	       rd_cntr[5:3] <= rd_cntr[5:3] + 1; 
	   end 
   end 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
	   rd_cntr[2:0] <= 3'b111; 
       end 
   else 
       begin  
	   if (en_ram1reg == 1'b1 && rd_cntr[5:3] == 3'b111) 
	       rd_cntr[2:0] <= rd_cntr[2:0] + 1; 
       end 
   end 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
	   rd_cntr[6] <= 1'b1; 
       end 
   else 
       begin  
       if (en_ram1reg == 1'b1 && rd_cntr[5:0] == 6'b111111) 
          rd_cntr[6] <= ~rd_cntr[6]; 
       end 
   end 
 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       wr_cntr <= 7'b1111111; 
       end 
   else begin 
       if (en_ram1reg == 1'b1) 
          wr_cntr <= wr_cntr + 1; 
	   else  
	      wr_cntr <= 7'b0; 
       end 
   end 
 
initial 
begin 
ram2_mem[0] <= 16'b0; ram2_mem[1] <= 16'b0; ram2_mem[2] <= 16'b0; ram2_mem[3] <= 16'b0; ram2_mem[4] <= 16'b0; 
ram2_mem[5] <= 16'b0; ram2_mem[6] <= 16'b0; ram2_mem[7] <= 16'b0; ram2_mem[8] <= 16'b0; ram2_mem[9] <= 16'b0; 
ram2_mem[10] <= 16'b0; ram2_mem[11] <= 16'b0; ram2_mem[12] <= 16'b0; ram2_mem[13] <= 16'b0; ram2_mem[14] <= 16'b0; 
ram2_mem[15] <= 16'b0; ram2_mem[16] <= 16'b0; ram2_mem[17] <= 16'b0; ram2_mem[18] <= 16'b0; ram2_mem[19] <= 16'b0; 
ram2_mem[20] <= 16'b0; ram2_mem[21] <= 16'b0; ram2_mem[22] <= 16'b0; ram2_mem[23] <= 16'b0; ram2_mem[24] <= 16'b0; 
ram2_mem[25] <= 16'b0; ram2_mem[26] <= 16'b0; ram2_mem[27] <= 16'b0; ram2_mem[28] <= 16'b0; ram2_mem[29] <= 16'b0; 
ram2_mem[30] <= 16'b0; ram2_mem[31] <= 16'b0; ram2_mem[32] <= 16'b0; ram2_mem[33] <= 16'b0; ram2_mem[34] <= 16'b0; 
ram2_mem[35] <= 16'b0; ram2_mem[36] <= 16'b0; ram2_mem[37] <= 16'b0; ram2_mem[38] <= 16'b0; ram2_mem[39] <= 16'b0; 
ram2_mem[40] <= 16'b0; ram2_mem[41] <= 16'b0; ram2_mem[42] <= 16'b0; ram2_mem[43] <= 16'b0; ram2_mem[44] <= 16'b0; 
ram2_mem[45] <= 16'b0; ram2_mem[46] <= 16'b0; ram2_mem[47] <= 16'b0; ram2_mem[48] <= 16'b0; ram2_mem[49] <= 16'b0; 
ram2_mem[50] <= 16'b0; ram2_mem[51] <= 16'b0; ram2_mem[52] <= 16'b0; ram2_mem[53] <= 16'b0; ram2_mem[54] <= 16'b0; 
ram2_mem[55] <= 16'b0; ram2_mem[56] <= 16'b0; ram2_mem[57] <= 16'b0; ram2_mem[58] <= 16'b0; ram2_mem[59] <= 16'b0; 
ram2_mem[60] <= 16'b0; ram2_mem[61] <= 16'b0; ram2_mem[62] <= 16'b0; ram2_mem[63] <= 16'b0; 
  
ram1_mem[0] <= 16'b0; ram1_mem[1] <= 16'b0; ram1_mem[2] <= 16'b0; ram1_mem[3] <= 16'b0; ram1_mem[4] <= 16'b0; 
ram1_mem[5] <= 16'b0; ram1_mem[6] <= 16'b0; ram1_mem[7] <= 16'b0; ram1_mem[8] <= 16'b0; ram1_mem[9] <= 16'b0; 
ram1_mem[10] <= 16'b0; ram1_mem[11] <= 16'b0; ram1_mem[12] <= 16'b0; ram1_mem[13] <= 16'b0; ram1_mem[14] <= 16'b0; 
ram1_mem[15] <= 16'b0; ram1_mem[16] <= 16'b0; ram1_mem[17] <= 16'b0; ram1_mem[18] <= 16'b0; ram1_mem[19] <= 16'b0; 
ram1_mem[20] <= 16'b0; ram1_mem[21] <= 16'b0; ram1_mem[22] <= 16'b0; ram1_mem[23] <= 16'b0; ram1_mem[24] <= 16'b0; 
ram1_mem[25] <= 16'b0; ram1_mem[26] <= 16'b0; ram1_mem[27] <= 16'b0; ram1_mem[28] <= 16'b0; ram1_mem[29] <= 16'b0; 
ram1_mem[30] <= 16'b0; ram1_mem[31] <= 16'b0; ram1_mem[32] <= 16'b0; ram1_mem[33] <= 16'b0; ram1_mem[34] <= 16'b0; 
ram1_mem[35] <= 16'b0; ram1_mem[36] <= 16'b0; ram1_mem[37] <= 16'b0; ram1_mem[38] <= 16'b0; ram1_mem[39] <= 16'b0; 
ram1_mem[40] <= 16'b0; ram1_mem[41] <= 16'b0; ram1_mem[42] <= 16'b0; ram1_mem[43] <= 16'b0; ram1_mem[44] <= 16'b0; 
ram1_mem[45] <= 16'b0; ram1_mem[46] <= 16'b0; ram1_mem[47] <= 16'b0; ram1_mem[48] <= 16'b0; ram1_mem[49] <= 16'b0; 
ram1_mem[50] <= 16'b0; ram1_mem[51] <= 16'b0; ram1_mem[52] <= 16'b0; ram1_mem[53] <= 16'b0; ram1_mem[54] <= 16'b0; 
ram1_mem[55] <= 16'b0; ram1_mem[56] <= 16'b0; ram1_mem[57] <= 16'b0; ram1_mem[58] <= 16'b0; ram1_mem[59] <= 16'b0; 
ram1_mem[60] <= 16'b0; ram1_mem[61] <= 16'b0; ram1_mem[62] <= 16'b0; ram1_mem[63] <= 16'b0; 
  
end 
 
always @ (posedge CLK) 
if (en_ram1reg == 1'b1 && wr_cntr[6] == 1'b0) 
ram1_mem[wr_cntr[5:0]] <= z_out; 
 
 
always @ (posedge CLK) 
if (en_ram1reg == 1'b1 && wr_cntr[6] == 1'b1) 
ram2_mem[wr_cntr[5:0]] <= z_out; 
 
always @ (posedge CLK) 
begin 
if (en_ram1reg == 1'b1 && rd_cntr[6] == 1'b0) 
  data_out <= ram2_mem[rd_cntr[5:0]]; 
 
else if (en_ram1reg == 1'b1 && rd_cntr[6] == 1'b1) 
  data_out <= ram1_mem[rd_cntr[5:0]]; 
else data_out <= 11'b0; 
end 
 
 
/* END MEMORY SECTION */ 
 
/* 2D-DCT implementation same as the 1D-DCT implementation */ 
 
/* First dct coeeficient appears at the output of the RAM1 after 13clk + 1clk ram in + 64  
clk cycles + 1clk ram out. including the 1 pipestage, the 2nd DCT operation starts after  
16 +  64 clk cycles. Pipe stages are added to match the timing with the cntr8 counter */ 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       data_out_pipe1 <= 11'b0; 
       end 
   else 
       begin 
       data_out_pipe1 <= data_out; 
       end 
   end 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       cntr80 <= 7'b0; 
       end 
   else if (rdy_in ==1'b1) 
       begin 
       cntr80 <= cntr80 + 1; 
      end 
   end 
 
assign en_dct2d = RST ? 1'b0 : (cntr80== 7'b1001111) ? 1'b1 : en_dct2d; 
 
always @ (posedge CLK or posedge RST) 
        begin 
          if (RST) 
              begin  en_dct2d_reg <= 1'b0; end 
          else 
              begin  en_dct2d_reg <= en_dct2d ; end 
        end 
 
assign data_out_final[10:0] = data_out_pipe1; 
 
always @ (posedge CLK or posedge RST ) 
   begin 
   if (RST) 
       begin 
       xb0_in <= 11'b0; xb1_in <= 11'b0; xb2_in <= 11'b0; xb3_in <= 11'b0; 
       xb4_in <= 11'b0; xb5_in <= 11'b0; xb6_in <= 11'b0; xb7_in <= 11'b0; 
       end 
   else if (en_dct2d_reg == 1'b1)  
       begin 
       xb0_in <= data_out_final; xb1_in <= xb0_in; xb2_in <= xb1_in; xb3_in <= xb2_in; 
       xb4_in <= xb3_in; xb5_in <= xb4_in; xb6_in <= xb5_in; xb7_in <= xb6_in; 
       end 
   else if (en_dct2d_reg == 1'b0) 
       begin 
       xb0_in <= 11'b0; xb1_in <= 11'b0; xb2_in <= 11'b0; xb3_in <= 11'b0; 
       xb4_in <= 11'b0; xb5_in <= 11'b0; xb6_in <= 11'b0; xb7_in <= 11'b0; 
       end 
   end 
 
/* register inputs, inputs read in every eighth clk*/ 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       xb0_reg <= 11'b0; xb1_reg <= 11'b0; xb2_reg <= 11'b0; xb3_reg <= 11'b0; 
       xb4_reg <= 11'b0; xb5_reg <= 11'b0; xb6_reg <= 11'b0; xb7_reg <= 11'b0; 
       end 
   else if (cntr8 == 4'b1000) 
       begin 
       xb0_reg <= xb0_in; xb1_reg <= xb1_in; xb2_reg <= xb2_in; xb3_reg <= xb3_in; 
       xb4_reg <= xb4_in; xb5_reg <= xb5_in; xb6_reg <= xb6_in; xb7_reg <= xb7_in; 
       end 
   end 
 
/* take absolute value of signals */ 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       xb0_reg_comp <= 10'b0; xb1_reg_comp <= 10'b0; xb2_reg_comp <= 10'b0; xb3_reg_comp <= 10'b0; 
       xb4_reg_comp <= 10'b0; xb5_reg_comp <= 10'b0; xb6_reg_comp <= 10'b0; xb7_reg_comp <= 10'b0; 
       xb0_reg_sign <= 1'b0; xb1_reg_sign <= 1'b0; xb2_reg_sign <= 1'b0; xb3_reg_sign <= 1'b0; 
       xb4_reg_sign <= 1'b0; xb5_reg_sign <= 1'b0; xb6_reg_sign <= 1'b0; xb7_reg_sign <= 1'b0; 
       end 
   else  
       begin  
       xb0_reg_sign <= xb0_reg[10]; 
       xb0_reg_comp[9:0] <= (xb0_reg[10]) ? (-xb0_reg) : xb0_reg[9:0];  
       xb1_reg_sign <= xb1_reg[10]; 
       xb1_reg_comp[9:0] <= (xb1_reg[10]) ? (-xb1_reg) : xb1_reg[9:0];  
       xb2_reg_sign <= xb2_reg[10]; 
       xb2_reg_comp[9:0] <= (xb2_reg[10]) ? (-xb2_reg) : xb2_reg[9:0];  
       xb3_reg_sign <= xb3_reg[10]; 
       xb3_reg_comp[9:0] <= (xb3_reg[10]) ? (-xb3_reg) : xb3_reg[9:0]; 
       xb4_reg_sign <= xb4_reg[10]; 
       xb4_reg_comp[9:0] <= (xb4_reg[10]) ? (-xb4_reg) : xb4_reg[9:0];  
       xb5_reg_sign <= xb5_reg[10]; 
       xb5_reg_comp[9:0] <= (xb5_reg[10]) ? (-xb5_reg) : xb5_reg[9:0];  
       xb6_reg_sign <= xb6_reg[10]; 
       xb6_reg_comp[9:0] <= (xb6_reg[10]) ? (-xb6_reg) : xb6_reg[9:0];  
       xb7_reg_sign <= xb7_reg[10]; 
       xb7_reg_comp[9:0] <= (xb7_reg[10]) ? (-xb7_reg) : xb7_reg[9:0]; 
       end 
   end 
 
/* 10 bits * 7 bits = 16 bits */ 
     assign p1b_all = xb7_reg_comp[9:0] * memory1a[6:0]; 
     assign p2b_all = xb6_reg_comp[9:0] * memory2a[6:0]; 
     assign p3b_all = xb5_reg_comp[9:0] * memory3a[6:0]; 
     assign p4b_all = xb4_reg_comp[9:0] * memory4a[6:0]; 
     assign p5b_all = xb3_reg_comp[9:0] * memory5a[6:0]; 
     assign p6b_all = xb2_reg_comp[9:0] * memory6a[6:0]; 
     assign p7b_all = xb1_reg_comp[9:0] * memory7a[6:0]; 
     assign p8b_all = xb0_reg_comp[9:0] * memory8a[6:0]; 
 
/* The following instantiation can be used while targetting Virtex2 */ 
//MULT18X18 mult1b (.A({10'b0,xb7_reg_comp[7:0]}), .B({11'b0,memory1a[6:0]}), .P(p1b_all)); 
//MULT18X18 mult2b (.A({10'b0,xb6_reg_comp[7:0]}), .B({11'b0,memory2a[6:0]}), .P(p2b_all)); 
//MULT18X18 mult3b (.A({10'b0,xb5_reg_comp[7:0]}), .B({11'b0,memory3a[6:0]}), .P(p3b_all)); 
//MULT18X18 mult4b (.A({10'b0,xb4_reg_comp[7:0]}), .B({11'b0,memory4a[6:0]}), .P(p4b_all)); 
//MULT18X18 mult5b (.A({10'b0,xb3_reg_comp[7:0]}), .B({11'b0,memory5a[6:0]}), .P(p5b_all)); 
//MULT18X18 mult6b (.A({10'b0,xb2_reg_comp[7:0]}), .B({11'b0,memory6a[6:0]}), .P(p6b_all)); 
//MULT18X18 mult7b (.A({10'b0,xb1_reg_comp[7:0]}), .B({11'b0,memory7a[6:0]}), .P(p7b_all)); 
//MULT18X18 mult8b (.A({10'b0,xb0_reg_comp[7:0]}), .B({11'b0,memory8a[6:0]}), .P(p8b_all)); 
 
 
/* multiply the outputs of the add/sub block with the 8 sets of stored coefficients */ 
 
always @ (posedge RST or posedge CLK) 
  begin 
    if (RST) 
      begin 
        p1b <= 19'b0; p2b <= 19'b0; p3b <= 19'b0; p4b <= 19'b0;  
        p5b <= 19'b0; p6b <= 19'b0; p7b <= 19'b0; p8b <= 19'b0; 
      end 
    else if (rdy_in == 1'b1 && prod_en1 == 4'b1001) 
        begin 
        p1b <= (xb7_reg_sign ^ memory1a[7])?(-p1b_all[15:0]):(p1b_all[15:0]); 
        p2b <= (xb6_reg_sign ^ memory2a[7])?(-p2b_all[15:0]):(p2b_all[15:0]); 
        p3b <= (xb5_reg_sign ^ memory3a[7])?(-p3b_all[15:0]):(p3b_all[15:0]); 
        p4b <= (xb4_reg_sign ^ memory4a[7])?(-p4b_all[15:0]):(p4b_all[15:0]); 
        p5b <= (xb3_reg_sign ^ memory5a[7])?(-p5b_all[15:0]):(p5b_all[15:0]); 
        p6b <= (xb2_reg_sign ^ memory6a[7])?(-p6b_all[15:0]):(p6b_all[15:0]); 
        p7b <= (xb1_reg_sign ^ memory7a[7])?(-p7b_all[15:0]):(p7b_all[15:0]); 
        p8b <= (xb0_reg_sign ^ memory8a[7])?(-p8b_all[15:0]):(p8b_all[15:0]); 
        end 
    else 
        begin 
        p1b <= 19'b0; p2b <= 19'b0; p3b <= 19'b0; p4b <= 19'b0;  
        p5b <= 19'b0; p6b <= 19'b0; p7b <= 19'b0; p8b <= 19'b0; 
        end 
         
  end 
 
 
always @ (posedge CLK or posedge RST) 
   begin 
   if (RST) 
       begin 
       idct_2d_int1 <= 20'b0; idct_2d_int2 <= 20'b0; idct_2d_int3 <= 20'b0; 
       idct_2d_int4 <= 20'b0; idct_2d_int <= 20'b0; 
       end 
   else 
       begin 
       idct_2d_int1 <= (p1b + p2b); 
       idct_2d_int2 <= (p3b + p4b); 
       idct_2d_int3 <= (p5b + p6b); 
       idct_2d_int4 <= (p7b + p8b); 
       idct_2d_int <= (idct_2d_int1 + idct_2d_int2 + idct_2d_int3 + idct_2d_int4); 
       end 
   end 
 
/* max value for a input signal to dct is "11111111". 
To represent this we need only 8 bits, plus 1 bit for sign */ 
 
//assign idct_2d = idct_2d_int[16:8]; 
assign idct_2d = {idct_2d_int[19],idct_2d_int[14:8]}; 
//assign idct_2d = idct_2d_int[7] ? (idct_2d_rnd + 1'b1) : idct_2d_rnd; 
 
endmodule 
 
//module MULT18X18 (A, B, P); // synthesis syn_black_box 
/*input[17:0]  A; 
input[17:0]  B; 
output[35:0] P; 
endmodule*/ 
