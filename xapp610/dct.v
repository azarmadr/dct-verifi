
/**********************************************************************
** -----------------------------------------------------------------------------**
** dct.v
**
** 8x8 discrete Cosine Transform
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
** Module: dct8x8 : 

** A 1D-DCT is implemented on the input pixels first. The output of this
** called  the intermediate value is stored in a RAM. The 2nd 1D-DCT operation 
** is done on this stored value to give the final 2D-DCT ouput dct_2d. The 
** inputs are 8 bits wide and the 2d-dct ouputs are 9 bits wide.
** 1st 1D section
** The input signals are taken one pixel at a time in the order x00 to x07,
** x10 to x07 and so on upto x77. These inputs are fed into a 8 bit shift
** register. The outputs of the 8 bit shift registers are registered by the 
** div8clk which is the CLK signal divided by 8. This will enable us to 
** register in 8 pixels (one row) at a time. The pixels are paired up in an 
** adder subtractor in the order xk0,xk7:xk1,xk6:xk2,xk5:xk3,xk4. The adder 
** subtractor is tied to CLK. For every clk, the adder/subtractor module 
** alternaltley chooses addtion and subtraction. This selection is done by
** the toggle flop. The ouput of the addsub is fed into a muliplier whose 
** other input is connected to stored values in registers which act as 
** memory. The ouput of the 4 mulipliers are added at every CLK in the 
** final adder. The ouput of the  adder z_out is the 1D-DCT values given 
** out in the order in which the inputs were read in.

** It takes 8 clks to read in the first set of inputs, 1 clk to register 
** inputs,1 clk to do add/sub, 1clk to get absolute value,
** 1 clk for multiplication, 2 clk for the final adder. total = 14 clks to get 
** the 1st z_out value. Every subsequent clk gives out the next z_out value.
** So to get all the 64 values we need  11+63=74 clks.
** Storage / RAM section
** The ouputs z_out of the adder are stored in RAMs. Two RAMs are used so 
** that data write can be continuous. The 1st valid input for the RAM1 is 
** available at the 15th clk. So the RAM1 enable is active after 15 clks. 
** After this the write operation continues for 64 clks . At the 65th clock, 
** since z_out is continuous, we get the next valid z_out_00. This 2nd set of
** valid 1D-DCT coefficients are written into RAM2 which is enabled at 15+64 
** clks. So at 65th clk, RAM1 goes into read mode for the next 64 clks and 
** RAM2 is in write mode. After this for every 64 clks, the read and write 
** switches between the 2 RAMS.
** 2nd 1D-DCT section
** After the 1st 79th clk when RAM1 is full, the 2nd 1d calculations can 
** start. The second 1D implementation is the same as the 1st 1D 
** implementation with the inputs now coming from either RAM1 or RAM2. Also,
** the inputs are read in one column at a time in the order z00 to z70, z10 to 
** z70 upto z77. The oupts from the adder in the 2nd section are the 2D-DCT 
** coeeficients.
***********************************************************************/

`timescale 100ps/1ps

module dct ( CLK, RST, xin,dct_2d,rdy_out);
output [11:0] dct_2d;
input CLK, RST;
input[7:0] xin; /* input */
output rdy_out;
wire[11:0] dct_2d;

/* constants */

reg[7:0] memory1a, memory2a, memory3a, memory4a;

/* 1D section */
/* The max value of a pixel after processing (to make their expected mean to zero)
is 127. If all the values in a row are 127, the max value of the product terms
would be (127*8)*(23170/256) and that of z_out_int would be (127*8)*23170/65536.
This value divided by 2raised to 16 is equivalent to ignoring the 16 lsb bits of the value */

reg[7:0] xa0_in, xa1_in, xa2_in, xa3_in, xa4_in, xa5_in, xa6_in, xa7_in;
reg[8:0] xa0_reg, xa1_reg, xa2_reg, xa3_reg, xa4_reg, xa5_reg, xa6_reg, xa7_reg;
reg[7:0] addsub1a_comp,addsub2a_comp,addsub3a_comp,addsub4a_comp;
reg[9:0] add_sub1a,add_sub2a,add_sub3a,add_sub4a;
reg save_sign1a, save_sign2a, save_sign3a, save_sign4a;
reg[18:0] p1a,p2a,p3a,p4a;
wire[35:0] p1a_all,p2a_all,p3a_all,p4a_all;
reg[1:0] i_wait;
reg toggleA;
reg[18:0] z_out_int1,z_out_int2;
reg[18:0] z_out_int;
wire[10:0] z_out_rnd;
wire[10:0] z_out;
integer indexi;

/* clks and counters */
reg[3:0] cntr12 ;
reg[3:0] cntr8;
reg[6:0] cntr79;
reg[6:0] wr_cntr,rd_cntr;
reg[6:0] cntr92;

/* memory section */
reg[10:0] data_out;
wire en_ram1,en_dct2d;
reg en_ram1reg,en_dct2d_reg;
reg[10:0] ram1_mem[63:0],ram2_mem[63:0]; // add the following to infer block RAM in synlpicity
                                         //    synthesis syn_ramstyle = "block_ram"  //shd be within /*..*/
/* 2D section */
wire[10:0] data_out_final;
reg[10:0] xb0_in, xb1_in, xb2_in, xb3_in, xb4_in, xb5_in, xb6_in, xb7_in;
reg[11:0] xb0_reg, xb1_reg, xb2_reg, xb3_reg, xb4_reg, xb5_reg, xb6_reg, xb7_reg;
reg[11:0] add_sub1b,add_sub2b,add_sub3b,add_sub4b;
reg[10:0] addsub1b_comp,addsub2b_comp,addsub3b_comp,addsub4b_comp;
reg save_sign1b, save_sign2b, save_sign3b, save_sign4b;
reg[19:0] p1b,p2b,p3b,p4b;
wire[35:0] p1b_all,p2b_all,p3b_all,p4b_all;
reg toggleB;
reg[19:0] dct2d_int1,dct2d_int2;
reg[19:0] dct_2d_int;
wire[11:0] dct_2d_rnd;

/*  1D-DCT BEGIN */

// store  1D-DCT constant coeeficient values for multipliers */

always @ (posedge RST or posedge CLK)
   begin
   if (RST)
       begin
       memory1a <= 8'd0; memory2a <= 8'd0; memory3a <= 8'd0; memory4a <= 8'd0;
       end
   else
       begin
	     case (indexi)
         0 : begin memory1a <= 8'd91; 
                   memory2a <= 8'd91; 
                   memory3a <= 8'd91; 
                   memory4a <= 8'd91;end
         1 : begin memory1a <= 8'd126; 
                   memory2a <= 8'd106;  
                   memory3a <= 8'd71;  
                   memory4a <= 8'd25;end
         2 : begin memory1a <= 8'd118; 
                   memory2a <= 8'd49;  
                   memory3a[7] <= 1'b1; memory3a[6:0] <= 7'd49;//-8'd49; 
                   memory4a[7] <= 1'b1; memory4a[6:0] <= 7'd118;// end -8'd118;end
                   end
         3 : begin memory1a <= 8'd106; 
                   memory2a[7] <= 1'b1; memory2a[6:0] <= 7'd25;//-8'd25;  
                   memory3a[7] <= 1'b1; memory3a[6:0] <= 7'd126;//-8'd126; 
                   memory4a[7] <= 1'b1; memory4a[6:0] <= 7'd71;end//-8'd71;end
         4 : begin memory1a <= 8'd91; 
                   memory2a[7] <= 1'b1; memory2a[6:0] <= 7'd91;//-8'd91; 
                   memory3a[7] <= 1'b1; memory3a[6:0] <= 7'd91;//-8'd91; 
                   memory4a <= 8'd91;end
         5 : begin memory1a <= 8'd71; 
                   memory2a[7] <= 1'b1; memory2a[6:0] <= 7'd126;//-8'd126; 
                   memory3a <= 8'd25;   
                   memory4a <= 8'd106;end
         6 : begin memory1a <= 8'd49; 
                   memory2a[7] <= 1'b1; memory2a[6:0] <= 7'd118;//-8'd118; 
                   memory3a <= 8'd118;  
                   memory4a[7] <= 1'b1; memory4a[6:0] <= 7'd49;end//-8'd49;end
         7 : begin memory1a <= 8'd25;  
                   memory2a[7] <= 1'b1; memory2a[6:0] <= 7'd71;//-8'd71; 
                   memory3a <= 8'd106;  
                   memory4a[7] <= 1'b1; memory4a[6:0] <= 7'd126;end//-8'd126;end
       endcase
      end
end


/* 8-bit input shifted 8 times thru a shift register*/
always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       xa0_in <= 8'b0; xa1_in <= 8'b0; xa2_in <= 8'b0; xa3_in <= 8'b0;
       xa4_in <= 8'b0; xa5_in <= 8'b0; xa6_in <= 8'b0; xa7_in <= 8'b0;
       end
   else
       begin
       xa0_in <= xin; xa1_in <= xa0_in; xa2_in <= xa1_in; xa3_in <= xa2_in;
       xa4_in <= xa3_in; xa5_in <= xa4_in; xa6_in <= xa5_in; xa7_in <= xa6_in;
       end
   end

/* shifted inputs registered every 8th clk (using cntr8)*/

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       cntr8 <= 4'b0;
       end
   else if (cntr8 < 4'b1000)
       begin
       cntr8 <= cntr8 + 1;
       end
   else 
       begin
       cntr8 <= 4'b0001;
       end
   end

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       xa0_reg <= 9'b0; xa1_reg <= 9'b0; xa2_reg <= 9'b0; xa3_reg <= 9'b0;
       xa4_reg <= 9'b0; xa5_reg <= 9'b0; xa6_reg <= 9'b0; xa7_reg <= 9'b0;
       end
   else if (cntr8 == 4'b1000)
       begin 
       xa0_reg <= {xa0_in[7],xa0_in}; xa1_reg <= {xa1_in[7],xa1_in}; 
       xa2_reg <= {xa2_in[7],xa2_in}; xa3_reg <= {xa3_in[7],xa3_in};
       xa4_reg <= {xa4_in[7],xa4_in}; xa5_reg <= {xa5_in[7],xa5_in}; 
       xa6_reg <= {xa6_in[7],xa6_in}; xa7_reg <= {xa7_in[7],xa7_in};
       end
   else 
       begin
       end
   end

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       toggleA <= 1'b0;
       end
   else 
       begin 
       toggleA <= ~toggleA;
       end
   end


/* adder / subtractor block */

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       add_sub1a <= 10'b0; add_sub2a <= 10'b0; add_sub3a <= 10'b0; add_sub4a <= 10'b0;
       end
   else
       begin
       if (toggleA == 1'b1)
	         begin
           add_sub1a <= (xa7_reg + xa0_reg); 
           add_sub2a <= (xa6_reg + xa1_reg);
           add_sub3a <= (xa5_reg + xa2_reg); 
           add_sub4a <= (xa4_reg + xa3_reg);
           end
       else if (toggleA == 1'b0)
	         begin
	         add_sub1a <= (xa7_reg - xa0_reg); 
           add_sub2a <= (xa6_reg - xa1_reg);
           add_sub3a <= (xa5_reg - xa2_reg); 
           add_sub4a <= (xa4_reg - xa3_reg);
	         end
       end
   end

/* The above if else statement used to get the add_sub signals can also be implemented 
using the adsu16 library element as follows */

//ADSU8 adsu8_1 (.A(xa0_reg), .B(xa7_reg), .ADD(toggleA), .CI(1'b0), .S(add_sub1a_all), .OFL(add_sub1a_ofl), .CO(open));
//ADSU8 adsu8_2 (.A(xa1_reg), .B(xa6_reg), .ADD(toggleA), .CI(1'b0), .S(add_sub2a_all), .OFL(add_sub1a_ofl), .CO(open));
//ADSU8 adsu8_3 (.A(xa2_reg), .B(xa5_reg), .ADD(toggleA), .CI(1'b0), .S(add_sub3a_all), .OFL(add_sub1a_ofl), .CO(open));
//ADSU8 adsu8_4 (.A(xa3_reg), .B(xa4_reg), .ADD(toggleA), .CI(1'b0), .S(add_sub4a_all), .OFL(add_sub1a_ofl), .CO(open));
/* In addition, Coregen can be used to create adder/subtractor units specific to a particular
device. The coregen model is then instantiated in the design file. The verilog file from 
coregen can be used along with the design files for simulation and implementation. */

//add_sub adsu8_1 (.A(xa0_reg), .B(xa7_reg), .ADD(toggleA), .CLK(CLK), .Q(add_sub1a));
//add_sub adsu8_2 (.A(xa1_reg), .B(xa6_reg), .ADD(toggleA), .CLK(CLK), .Q(add_sub2a));
//add_sub adsu8_3 (.A(xa2_reg), .B(xa5_reg), .ADD(toggleA), .CLK(CLK), .Q(add_sub3a));
//add_sub adsu8_4 (.A(xa3_reg), .B(xa4_reg), .ADD(toggleA), .CLK(CLK), .Q(add_sub4a));

/* multiply the outputs of the add/sub block with the 8 sets of stored coefficients */
/* The inputs are shifted thru 8 registers in 8 clk cycles. The ouput of the shift
registers are registered at the 9th clk. The values are then added or subtracted at the 10th
clk. The first mutiplier output is obtained at the 11th clk. Memoryx[0] shd be accessed
at the 11th clk*/

/*wait state counter */

always @ (posedge RST or posedge CLK)
   begin
   if (RST)
       begin
       i_wait <= 2'b01;
       end
   else  if (i_wait != 2'b00)
      begin
      i_wait  <= i_wait - 1;
      end
   else
      begin
      i_wait  <= 2'b00;
      end
   end

// First valid add_sub appears at the 10th clk (8 clks for shifting inputs,
// 9th clk for registering shifted input and 10th clk for add_sub
// to synchronize the i value to the add_sub value, i value is incremented
// only after 10 clks using i_wait
/* sign and magnitude separated here. magnitude of 9 bits is stored in *comp */

always @ (posedge RST or posedge CLK)
begin
    if (RST)
       begin  
         addsub1a_comp <= 9'b0; save_sign1a <= 1'b0;
       end
    else 
       begin
       case (add_sub1a[9])
       1'b0: begin 
              addsub1a_comp <= add_sub1a; save_sign1a <= 1'b0; 
              end
       1'b1: begin 
              addsub1a_comp <= (-add_sub1a) ; save_sign1a <= 1'b1; 
              end 
       endcase
       end
end

always @ (posedge RST or posedge CLK)
begin
    if (RST)
       begin  
         addsub2a_comp <= 9'b0; save_sign2a <= 1'b0;
       end
    else 
       begin
       case (add_sub2a[9])
       1'b0: begin 
              addsub2a_comp <= add_sub2a; save_sign2a <= 1'b0;
              end
       1'b1: begin 
              addsub2a_comp <= (-add_sub2a) ; save_sign2a <= 1'b1; 
              end 
       endcase
       end
end

always @ (posedge RST or posedge CLK)
begin
    if (RST)
       begin  
         addsub3a_comp <= 9'b0; save_sign3a <= 1'b0; 
       end
    else 
       begin
       case (add_sub3a[9])
       1'b0: begin 
              addsub3a_comp <= add_sub3a; save_sign3a <= 1'b0; 
              end
       1'b1: begin 
              addsub3a_comp <= (-add_sub3a); save_sign3a <= 1'b1; 
              end 
       endcase
       end
end

always @ (posedge RST or posedge CLK)
begin
    if (RST)
       begin  
         addsub4a_comp <= 9'b0; save_sign4a <= 1'b0; 
       end
    else 
       begin
       case (add_sub4a[9])
       1'b0: begin 
              addsub4a_comp <= add_sub4a; save_sign4a <= 1'b0; 
              end
       1'b1: begin 
              addsub4a_comp <= (-add_sub4a); save_sign4a <= 1'b1; 
              end 
       endcase
       end
end

     assign p1a_all = addsub1a_comp * memory1a[6:0];/* 9 bits * 7 bits = 16 bits*/
     assign p2a_all = addsub2a_comp * memory2a[6:0];
     assign p3a_all = addsub3a_comp * memory3a[6:0];
     assign p4a_all = addsub4a_comp * memory4a[6:0];

/* The following instantiation can be used while targetting Virtex2 */
//MULT18X18 mult1a (.A({9'b0,addsub1a_comp}), .B({11'b0,memory1a[6:0]}), .P(p1a_all));
//MULT18X18 mult2a (.A({9'b0,addsub2a_comp}), .B({11'b0,memory2a[6:0]}), .P(p2a_all));
//MULT18X18 mult3a (.A({9'b0,addsub3a_comp}), .B({11'b0,memory3a[6:0]}), .P(p3a_all));
//MULT18X18 mult4a (.A({9'b0,addsub4a_comp}), .B({11'b0,memory4a[6:0]}), .P(p4a_all));

always @ (posedge RST or posedge CLK)
  begin
    if (RST)
      begin
        p1a <= 18'b0; p2a <= 18'b0; p3a <= 18'b0; p4a <= 18'b0; indexi<= 7;
      end /* p*a is extended to one more bit to take into acoount the sign */
    else if (i_wait == 2'b00)
      begin
   
        
        p1a <= (save_sign1a ^ memory1a[7]) ? (-p1a_all[15:0]) :(p1a_all[15:0]);
        p2a <= (save_sign2a ^ memory2a[7]) ? (-p2a_all[15:0]) :(p2a_all[15:0]);
        p3a <= (save_sign3a ^ memory3a[7]) ? (-p3a_all[15:0]) :(p3a_all[15:0]);
        p4a <= (save_sign4a ^ memory4a[7]) ? (-p4a_all[15:0]) :(p4a_all[15:0]);
        

        if (indexi == 7)
          indexi <= 0;
        else
          indexi <= indexi + 1;
        end
  end


/*always @ (posedge RST or posedge CLK)
  begin
    if (RST)
      begin
        p1a <= 19'b0; p2a <= 19'b0; p3a <= 19'b0; p4a <= 19'b0; indexi<= 7;
      end
    else if (i_wait == 2'b00)
      begin
        p1a <= (save_sign1a ^ memory1a[7]) ? (-addsub1a_comp * memory1a[6:0]) :(addsub1a_comp * memory1a[6:0]);
        p2a <= (save_sign2a ^ memory2a[7]) ? (-addsub2a_comp * memory2a[6:0]) :(addsub2a_comp * memory2a[6:0]);
        p3a <= (save_sign3a ^ memory3a[7]) ? (-addsub3a_comp * memory3a[6:0]) :(addsub3a_comp * memory3a[6:0]);
        p4a <= (save_sign4a ^ memory4a[7]) ? (-addsub4a_comp * memory4a[6:0]) :(addsub4a_comp * memory4a[6:0]);
        if (indexi == 7)
          indexi <= 0;
        else
          indexi <= indexi + 1;
      end
  end*/

/* Final adder. Adding the ouputs of the 4 multipliers */

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       z_out_int1 <= 19'b0; z_out_int2 <= 19'b0; z_out_int <= 19'b0;
       end
   else
       begin
       z_out_int1 <= (p1a + p2a);
       z_out_int2 <= (p3a + p4a);
       z_out_int <= (z_out_int1 + z_out_int2);
       end
   end

// rounding of the value

assign z_out_rnd = z_out_int[7] ? (z_out_int[18:8] + 1'b1) : z_out_int[18:8];

/* 1 sign bit, 11 data bit */
assign z_out = z_out_rnd;

/* 1D-DCT END */

/* tranpose memory to store intermediate Z coeeficients */
/* store the 64 coeeficients in the first 64 locations of the RAM */
/* first valid adder output is at the 15th clk. (input reg + 8 bit SR + add_sub + comp. Signal + reg prod 
+ 2 partial prod adds) So the RAM is enabled at the 15th clk)*/

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       cntr12 <= 4'b0;
       end
   else
       begin
       cntr12 <= cntr12 + 1;
       end
   end

/* enable RAM at the 14th clk after RST goes inactive */

assign en_ram1 = RST ? 1'b0 : (cntr12== 4'b1101) ? 1'b1 : en_ram1;

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

/* First dct coeeficient appears at the output of the RAM1 after
15 + 64 clk cycles. So the 2nd DCT operation starts after 79 clk cycles. */
always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       cntr79 <= 7'b0;
       end
   else
       begin
       cntr79 <= cntr79 + 1;
      end
   end

assign en_dct2d = RST ? 1'b0 : (cntr79 == 7'b1001111) ? 1'b1 : en_dct2d;

always @ (posedge CLK or posedge RST)
        begin
          if (RST)
              begin  en_dct2d_reg <= 1'b0; end
          else
              begin  en_dct2d_reg <= en_dct2d ; end
        end

assign data_out_final[10:0] = data_out;

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
       xb0_reg <= 12'b0; xb1_reg <= 12'b0; xb2_reg <= 12'b0; xb3_reg <= 12'b0;
       xb4_reg <= 12'b0; xb5_reg <= 12'b0; xb6_reg <= 12'b0; xb7_reg <= 12'b0;
       end
   else if (cntr8 == 4'b1000)
       begin
       xb0_reg <= {xb0_in[10],xb0_in}; xb1_reg <= {xb1_in[10],xb1_in}; 
       xb2_reg <= {xb2_in[10],xb2_in}; xb3_reg <= {xb3_in[10],xb3_in};
       xb4_reg <= {xb4_in[10],xb4_in}; xb5_reg <= {xb5_in[10],xb5_in}; 
       xb6_reg <= {xb6_in[10],xb6_in}; xb7_reg <= {xb7_in[10],xb7_in};
       end
   end

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       toggleB <= 1'b0;
       end
   else 
       begin 
       toggleB <= ~toggleB;
       end
   end

/* adder / subtractor block */

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       add_sub1b <= 12'b0; add_sub2b <= 12'b0; add_sub3b <= 12'b0; add_sub4b <= 12'b0;
       end
   else
       begin
	       if (toggleB == 1'b1)
	          begin
            add_sub1b <= (xb0_reg + xb7_reg); add_sub2b <= (xb1_reg + xb6_reg);
            add_sub3b <= (xb2_reg + xb5_reg); add_sub4b <= (xb3_reg + xb4_reg);
            end
	       else if (toggleB == 1'b0)
	          begin
	          add_sub1b <= (xb7_reg - xb0_reg); add_sub2b <= (xb6_reg - xb1_reg);
            add_sub3b <= (xb5_reg - xb2_reg); add_sub4b <= (xb4_reg - xb3_reg);
	          end
       end
   end

always @ (posedge RST or posedge CLK)
begin
    if (RST)
       begin  
         addsub1b_comp <= 11'b0; save_sign1b <= 1'b0;
       end
    else 
       begin
       case (add_sub1b[11])
       1'b0: begin 
              addsub1b_comp <= add_sub1b; save_sign1b <= 1'b0; 
              end
       1'b1: begin 
              addsub1b_comp <= (-add_sub1b) ; save_sign1b <= 1'b1; 
              end 
       endcase
       end
end

always @ (posedge RST or posedge CLK)
begin
    if (RST)
       begin  
         addsub2b_comp <= 11'b0; save_sign2b <= 1'b0;
       end
    else 
       begin
       case (add_sub2b[11])
       1'b0: begin 
              addsub2b_comp <= add_sub2b; save_sign2b <= 1'b0; 
              end
       1'b1: begin 
              addsub2b_comp <= (-add_sub2b) ; save_sign2b <= 1'b1; 
              end 
       endcase
       end
end

always @ (posedge RST or posedge CLK)
begin
    if (RST)
       begin  
         addsub3b_comp <= 11'b0; save_sign3b <= 1'b0;
       end
    else 
       begin
       case (add_sub3b[11])
       1'b0: begin 
              addsub3b_comp <= add_sub3b; save_sign3b <= 1'b0; 
              end
       1'b1: begin 
              addsub3b_comp <= (-add_sub3b) ; save_sign3b <= 1'b1; 
              end 
       endcase
       end
end

always @ (posedge RST or posedge CLK)
begin
    if (RST)
       begin  
         addsub4b_comp <= 11'b0; save_sign4b <= 1'b0;
       end
    else 
       begin
       case (add_sub4b[11])
       1'b0: begin 
              addsub4b_comp <= add_sub4b; save_sign4b <= 1'b0; 
              end
       1'b1: begin 
              addsub4b_comp <= (-add_sub4b) ; save_sign4b <= 1'b1; 
              end 
       endcase
       end
end

     assign p1b_all = addsub1b_comp * memory1a[6:0];
     assign p2b_all = addsub2b_comp * memory2a[6:0];
     assign p3b_all = addsub3b_comp * memory3a[6:0];
     assign p4b_all = addsub4b_comp * memory4a[6:0];

/* The following instantiation can be used while targetting Virtex2 */
//MULT18X18 mult1b (.A({9'b0,addsub1b_comp}), .B({11'b0,memory1a[6:0]}), .P(p1b_all));
//MULT18X18 mult2b (.A({9'b0,addsub2b_comp}), .B({11'b0,memory2a[6:0]}), .P(p2b_all));
//MULT18X18 mult3b (.A({9'b0,addsub3b_comp}), .B({11'b0,memory3a[6:0]}), .P(p3b_all));
//MULT18X18 mult4b (.A({9'b0,addsub4b_comp}), .B({11'b0,memory4a[6:0]}), .P(p4b_all));

always @ (posedge RST or posedge CLK)
  begin
    if (RST)
      begin
        p1b <= 20'b0; p2b <= 20'b0; p3b <= 20'b0; p4b <= 20'b0; 
      end
    else if (i_wait == 2'b00)
      begin
  
        
        p1b <= (save_sign1b ^ memory1a[7]) ? (-p1b_all[17:0]) :(p1b_all[17:0]);
        p2b <= (save_sign2b ^ memory2a[7]) ? (-p2b_all[17:0]) :(p2b_all[17:0]);
        p3b <= (save_sign3b ^ memory3a[7]) ? (-p3b_all[17:0]) :(p3b_all[17:0]);
        p4b <= (save_sign4b ^ memory4a[7]) ? (-p4b_all[17:0]) :(p4b_all[17:0]);
        end
  end
/*always @ (posedge RST or posedge CLK)
  begin
    if (RST)
      begin
        p1b <= 16'b0; p2b <= 16'b0; p3b <= 16'b0; p4b <= 16'b0; //indexj<= 7;
      end
    else if (i_wait == 2'b00)
      begin
        p1b <= (save_sign1b ^ memory1a[7]) ? (-addsub1b_comp * memory1a[6:0]) :(addsub1b_comp * memory1a[6:0]);
        p2b <= (save_sign2b ^ memory2a[7]) ? (-addsub2b_comp * memory2a[6:0]) :(addsub2b_comp * memory2a[6:0]);
        p3b <= (save_sign3b ^ memory3a[7]) ? (-addsub3b_comp * memory3a[6:0]) :(addsub3b_comp * memory3a[6:0]);
        p4b <= (save_sign4b ^ memory4a[7]) ? (-addsub4b_comp * memory4a[6:0]) :(addsub4b_comp * memory4a[6:0]);
      end
  end

*/
/* The above if else statement used to get the add_sub signals can also be implemented using  the adsu16 library element as follows */

//ADSU16 adsu16_5 (.A({8'b0,xb0_reg}), .B({8'b0,xb7_reg}), .ADD(toggleB), .CI(1'b0), .S(add_sub1b), .OFL(open), .CO(open));
//ADSU16 adsu16_6 (.A({8'b0,xb1_reg}), .B({8'b0,xb6_reg}), .ADD(toggleB), .CI(1'b0), .S(add_sub2b), .OFL(open), .CO(open));
//ADSU16 adsu16_7 (.A({8'b0,xb2_reg}), .B({8'b0,xb5_reg}), .ADD(toggleB), .CI(1'b0), .S(add_sub3b), .OFL(open), .CO(open));
//ADSU16 adsu16_8 (.A({8'b0,xb3_reg}), .B({8'b0,xb4_reg}), .ADD(toggleB), .CI(1'b0), .S(add_sub4b), .OFL(open), .CO(open));

/* multiply the outputs of the add/sub block with the 8 sets of stored coefficients */

/* Final adder. Adding the ouputs of the 4 multipliers */

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       dct2d_int1 <= 20'b0; dct2d_int2 <= 20'b0; dct_2d_int <= 20'b0;
       end
   else
       begin
       dct2d_int1 <= (p1b + p2b);
       dct2d_int2 <= (p3b + p4b);
       dct_2d_int <= (dct2d_int1 + dct2d_int2);
       end
   end

assign dct_2d_rnd = dct_2d_int[19:8];
assign dct_2d = dct_2d_int[7] ? (dct_2d_rnd + 1'b1) : dct_2d_rnd;

/* The first 1D-DCT output becomes valid after 14 +64 clk cycles. For the first 
2D-DCT output to be valid it takes 78 + 1clk to write into the ram + 1clk to 
write out of the ram + 8 clks to shift in the 1D-DCT values + 1clk to register 
the 1D-DCT values + 1clk to add/sub + 1clk to take compliment + 1 clk for 
multiplying +  2clks to add product. So the 2D-DCT output will be valid 
at the 94th clk. rdy_out goes high at 93rd clk so that the first data is valid
for the next block*/

always @ (posedge CLK or posedge RST)
   begin
   if (RST)
       begin
       cntr92 <= 8'b0;
       end
   else if (cntr92 < 8'b1011110)
       begin
       cntr92 <= cntr92 + 1;
       end
   else 
       begin
       cntr92 <= cntr92;
       end
   end

assign rdy_out = (cntr92 == 8'b1011110) ? 1'b1 : 1'b0;

endmodule
//module ADSU8 (A, B, ADD,CI,S,OFL,CO); // synthesis syn_black_box
/*input[7:0]  A,B;
input       ADD,CI;
output[7:0] S;
output      OFL,CO;
endmodule*/

//module MULT18X18 (A, B, P); // synthesis syn_black_box
/*input[17:0]  A;
input[17:0]  B;
output[35:0] P;
endmodule*/
