--*********************************************************************
-- *********************************************************************
-- ** -----------------------------------------------------------------------------**
-- ** dct.v
-- **
-- ** 8x8 discrete Cosine Transform
-- **
-- **
-- **
-- **                  Author: Latha Pillai
-- **                  Senior Applications Engineer
-- **
-- **                  Video Applications
-- **                  Advanced Products Group
-- **                  Xilinx, Inc.
-- **
-- **                  Copyright (c) 2001 Xilinx, Inc.
-- **                  All rights reserved
-- **
-- **                  Date:   Feb. 10, 2002
-- **
-- **                  RESTRICTED RIGHTS LEGEND
-- **
-- **      This software has not been published by the author, and 
-- **      has been disclosed to others for the purpose of enhancing 
-- **      and promoting design productivity in Xilinx products.
-- **
-- **      Therefore use, duplication or disclosure, now and in the 
-- **      future should give consideration to the productivity 
-- **      enhancements afforded the user of this code by the author's 
-- **      efforts.  Thank you for using our products !
-- **
-- ** Disclaimer:  THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY 
-- **              WHATSOEVER AND XILINX SPECIFICALLY DISCLAIMS ANY 
-- **              IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
-- **              A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
-- ** Module: dct8x8 : 
-- ** A 1D-DCT is implemented on the input pixels first. The output of this
-- ** called  the intermediate value is stored in a RAM. The 2nd 1D-DCT operation 
-- ** is done on this stored value to give the final 2D-DCT ouput dct_2d. The 
-- ** inputs are 8 std_logics wide and the 2d-dct ouputs are 9 std_logics wide.
-- ** 1st 1D section
-- ** The input signals are taken one pixel at a time in the order x00 to x07,
-- ** x10 to x07 and so on upto x77. These inputs are fed into a 8 std_logic shift
-- ** register. The outputs of the 8 std_logic shift registers are registered by the 
-- ** div8clk which is the CLK signal divided by 8. This will enable us to 
-- ** register in 8 pixels (one row) at a time. The pixels are paired up in an 
-- ** adder subtractor in the order xk0,xk7:xk1,xk6:xk2,xk5:xk3,xk4. The adder 
-- ** subtractor is tied to CLK. For every clk, the adder/subtractor module 
-- ** alternaltley chooses addtion and subtraction. This selection is done by
-- ** the toggle flop. The ouput of the addsub is fed into a muliplier whose 
-- ** other input is connected to stored values in registers which act as 
-- ** memory. The ouput of the 4 mulipliers are added at every CLK in the 
-- ** final adder. The ouput of the  adder z_out is the 1D-DCT values given 
-- ** out in the order in which the inputs were read in.
-- ** It takes 8 clks to read in the first set of inputs, 1 clk to register 
-- ** inputs,1 clk to do add/sub, 1clk to get absolute value,
-- ** 1 clk for multiplication, 2 clk for the final adder. total = 14 clks to get 
-- ** the 1st z_out value. Every subsequent clk gives out the next z_out value.
-- ** So to get all the 64 values we need  11+63=74 clks.
-- ** Storage / RAM section
-- ** The ouputs z_out of the adder are stored in RAMs. Two RAMs are used so 
-- ** that data write can be continuous. The 1st valid input for the RAM1 is 
-- ** available at the 15th clk. So the RAM1 enable is active after 15 clks. 
-- ** After this the write operation continues for 64 clks . At the 65th clock, 
-- ** since z_out is continuous, we get the next valid z_out_00. This 2nd set of
-- ** valid 1D-DCT coefficients are written into RAM2 which is enabled at 15+64 
-- ** clks. So at 65th clk, RAM1 goes into read mode for the next 64 clks and 
-- ** RAM2 is in write mode. After this for every 64 clks, the read and write 
-- ** switches between the 2 RAMS.
-- ** 2nd 1D-DCT section
-- ** After the 1st 79th clk when RAM1 is full, the 2nd 1d calculations can 
-- ** start. The second 1D implementation is the same as the 1st 1D 
-- ** implementation with the inputs now coming from either RAM1 or RAM2. Also,
-- ** the inputs are read in one column at a time in the order z00 to z70, z10 to 
-- ** z70 upto z77. The oupts from the adder in the 2nd section are the 2D-DCT 
-- ** coeeficients.
-- **********************************************************************
library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
--library virtex; 
--use virtex.components.all; 
--library synplify; 
--use synplify.attributes.all; 
library unisims_ver; -- include this for modelsim simulation
                     -- when using mult18x18


ENTITY dct IS
   PORT (
      CLK                     : IN std_logic;   
      RST                     : IN std_logic;   
      xin                     : IN std_logic_vector(7 downto 0);   --  8 bit input.      
      dct_2d                  : OUT std_logic_vector(11 downto 0);   
      rdy_out                 : OUT std_logic);   
END dct;

ARCHITECTURE logic OF dct IS



-- The max value of a pixel after processing (to make their expected mean to 
-- zero). The max value of a pixel after processing (to make their expected 
-- mean to zero) is 127. If all the values in a row are 127, the max value of 
-- the product terms would be (127*8)*(23170/256) and that of z_out_int would 
-- be (127*8)*23170/65536. This value divided by 2raised to 16 is 
-- equivalent to ignoring the 16 lsb std_logics of the value 

   -- 1D section 

signal xa0_in, xa1_in, xa2_in, xa3_in, 
       xa4_in, xa5_in, xa6_in, xa7_in:           std_logic_vector(7 downto 0);
signal xa0_reg, xa1_reg, xa2_reg, xa3_reg, 
       xa4_reg, xa5_reg, xa6_reg, xa7_reg:       std_logic_vector (8 downto 0);
signal addsub1a_comp,addsub2a_comp,
       addsub3a_comp,addsub4a_comp :             std_logic_vector (7 downto 0);
signal add_sub1a,add_sub2a,add_sub3a,add_sub4a : std_logic_vector (9 downto 0);
signal save_sign1a,save_sign2a,
       save_sign3a,save_sign4a :                 std_logic;
signal xor1a,xor2a,xor3a,xor4a: std_logic;
signal p1a,p2a,p3a,p4a :                         std_logic_vector (18 downto 0);
signal p1a_all,p2a_all,p3a_all,p4a_all :         std_logic_vector (14 downto 0);   -- assign as 36 std_logic wide signal

signal i_wait                   :  std_logic_vector(1 downto 0);   
signal toggleA                  :  std_logic;   
signal z_out_int1               :  std_logic_vector(18 downto 0);   
signal z_out_int2               :  std_logic_vector(18 downto 0);   
signal z_out_int                :  std_logic_vector(18 downto 0);   
signal z_out_rnd                :  std_logic_vector(10 downto 0);   
signal z_out                    :  std_logic_vector(10 downto 0);   
signal indexi                   :  integer;   

   -- clks and counters 
signal cntr12                   :  std_logic_vector(3 downto 0);   
signal cntr8                    :  std_logic_vector(3 downto 0);   
signal cntr79                   :  std_logic_vector(6 downto 0);   
signal wr_cntr                  :  std_logic_vector(6 downto 0);   
signal rd_cntr                  :  std_logic_vector(6 downto 0);   
signal cntr92                   :  std_logic_vector(6 downto 0);  
 
-- memory section 
signal  memory1a, memory2a, memory3a, memory4a: std_logic_vector(7 downto 0);
signal data_out                 :  std_logic_vector(10 downto 0);   
signal en_ram1                  :  std_logic;   
signal en_dct2d                 :  std_logic;   
signal en_ram1reg               :  std_logic;   
signal en_dct2d_reg             :  std_logic;   

   
type ram1a_mem is array (0 to 63) of std_logic_vector(10 downto 0);
signal ram1_mem                 :  ram1a_mem;

   --  add the following to infer block RAM in synlpicity
   --    synthesis syn_ramstyle = "block_ram"  //shd be within /*..*/

   
type ram2a_mem is array (0 to 63) of std_logic_vector(10 downto 0);
signal ram2_mem                 :  ram2a_mem;

   --  add the following to infer block RAM in synlpicity
   --    synthesis syn_ramstyle = "block_ram"  //shd be within /*..*/


   -- 2D section 

signal data_out_final           :  std_logic_vector(10 downto 0);   
signal xb0_in, xb1_in, xb2_in, xb3_in, 
       xb4_in, xb5_in, xb6_in, xb7_in :       std_logic_vector(10 downto 0);
signal xb0_reg, xb1_reg, xb2_reg, xb3_reg, 
       xb4_reg, xb5_reg, xb6_reg, xb7_reg :   std_logic_vector(11 downto 0);
signal add_sub1b,add_sub2b,add_sub3b,add_sub4b: std_logic_vector(11 downto 0);
signal addsub1b_comp,addsub2b_comp,
       addsub3b_comp,addsub4b_comp :          std_logic_vector (10 downto 0);
signal save_sign1b,save_sign2b,save_sign3b,save_sign4b : std_logic;
signal xor1b,xor2b,xor3b,xor4b: std_logic;
signal p1b,p2b,p3b,p4b: std_logic_vector(19 downto 0);
signal p1b_all,p2b_all,p3b_all,p4b_all : std_logic_vector (17 downto 0);
                     -- assign as 36 std_logic wide signal if using mult18x18
signal toggleB                  :  std_logic;   
signal dct2d_int1               :  std_logic_vector(19 downto 0);   
signal dct2d_int2               :  std_logic_vector(19 downto 0);   
signal dct_2d_int               :  std_logic_vector(19 downto 0);   
signal dct_2d_rnd               :  std_logic_vector(11 downto 0);   
   -- rounding of the value

BEGIN

   --  1D-DCT BEGIN 
   -- store  1D-DCT constant coeeficient values for multipliers */
   
   PROCESS (RST, CLK)
   BEGIN
      IF (RST = '1') THEN
         memory1a <= "00000000";    
         memory2a <= "00000000";    
         memory3a <= "00000000";    
         memory4a <= "00000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         CASE indexi IS
            WHEN 0 =>
                     memory1a <= "01011011";    
                     memory2a <= "01011011";    
                     memory3a <= "01011011";    
                     memory4a <= "01011011";    
            WHEN 1 =>
                     memory1a <= "01111110";    
                     memory2a <= "01101010";    
                     memory3a <= "01000111";    
                     memory4a <= "00011001";    
            WHEN 2 =>
                     memory1a <= "01110110";    
                     memory2a <= "00110001";    
                     memory3a <= "10110001";    -- -8'd49; 
                     memory4a <= "11110110";    --  end -8'd118;end
            WHEN 3 =>
                     memory1a <= "01101010";    
                     memory2a <= "10011001";    -- -8'd25;  
                     memory3a <= "11111110";    -- -8'd126; 
                     memory4a <= "11000111";    
            WHEN 4 =>
                     memory1a <= "01011011";    
                     memory2a<= "11011011";    -- -8'd91; 
                     memory3a <= "11011011";    -- -8'd91; 
                     memory4a <= "01011011";    
            WHEN 5 =>
                     memory1a <= "01000111";    
                     memory2a <= "11111110";    -- -8'd126; 
                     memory3a <= "00011001";    
                     memory4a <= "01101010";    
            WHEN 6 =>
                     memory1a <= "00110001";    
                     memory2a <= "11110110";    -- -8'd118; 
                     memory3a <= "01110110";    
                     memory4a <= "10110001";    
            WHEN 7 =>
                     memory1a <= "00011001";    
                     memory2a <= "11000111";    -- -8'd71; 
                     memory3a <= "01101010";    
                     memory4a <= "11111110";    
            WHEN OTHERS =>
                     NULL;
            
            ---8'd126;end
            
         END CASE;
      END IF;
   END PROCESS;

   -- 8-std_logic input shifted 8 times thru a shift register
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         xa0_in <= "00000000";    xa1_in <= "00000000";    
         xa2_in <= "00000000";    xa3_in <= "00000000";    
         xa4_in <= "00000000";    xa5_in <= "00000000";    
         xa6_in <= "00000000";    xa7_in <= "00000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         xa0_in <= xin;    xa1_in <= xa0_in;    
         xa2_in <= xa1_in;    xa3_in <= xa2_in;    
         xa4_in <= xa3_in;    xa5_in <= xa4_in;    
         xa6_in <= xa5_in;    xa7_in <= xa6_in;    
      END IF;
   END PROCESS;

   -- shifted inputs registered every 8th clk (using cntr8)
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         cntr8 <= "0000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (cntr8 < "1000") THEN
            cntr8 <= cntr8 + "0001";    
         ELSE
            cntr8 <= "0001";    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         xa0_reg <= "000000000";    xa1_reg <= "000000000";    
         xa2_reg <= "000000000";    xa3_reg <= "000000000";    
         xa4_reg <= "000000000";    xa5_reg <= "000000000";    
         xa6_reg <= "000000000";    xa7_reg <= "000000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (cntr8 = "1000") THEN
            xa0_reg <= xa0_in(7) & xa0_in;    xa1_reg <= xa1_in(7) & xa1_in;    
            xa2_reg <= xa2_in(7) & xa2_in;    xa3_reg <= xa3_in(7) & xa3_in;    
            xa4_reg <= xa4_in(7) & xa4_in;    xa5_reg <= xa5_in(7) & xa5_in;    
            xa6_reg <= xa6_in(7) & xa6_in;    xa7_reg <= xa7_in(7) & xa7_in;    
         ELSE
            
         END IF;
      END IF;
   END PROCESS;

   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         toggleA <= '0';    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         toggleA <= NOT toggleA;    
      END IF;
   END PROCESS;

   -- adder / subtractor block 
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         add_sub1a <= "0000000000";    
         add_sub2a <= "0000000000";    
         add_sub3a <= "0000000000";    
         add_sub4a <= "0000000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (toggleA = '1') THEN
            add_sub1a <= "0" & (xa7_reg + xa0_reg);    
            add_sub2a <= "0" & (xa6_reg + xa1_reg);    
            add_sub3a <= "0" & (xa5_reg + xa2_reg);    
            add_sub4a <= "0" & (xa4_reg + xa3_reg);    
         ELSE
            IF (toggleA = '0') THEN
               add_sub1a <= "0" & (xa7_reg - xa0_reg);    
               add_sub2a <= "0" & (xa6_reg - xa1_reg);    
               add_sub3a <= "0" & (xa5_reg - xa2_reg);    
               add_sub4a <= "0" & (xa4_reg - xa3_reg);    
            END IF;
         END IF;
      END IF;
   END PROCESS;

--The above if else statement used to get the add_sub signals can also be 
--implemented. The above if else statement used to get the add_sub signals 
-- can also be implemented using the adsu16 library element as follows 
   
   --ADSU8 adsu8_1 (.A(xa0_reg), .B(xa7_reg), .ADD(toggleA), .CI(1'b0), .S(add_sub1a_all), .OFL(add_sub1a_ofl), .CO(open));
   
   --ADSU8 adsu8_2 (.A(xa1_reg), .B(xa6_reg), .ADD(toggleA), .CI(1'b0), .S(add_sub2a_all), .OFL(add_sub1a_ofl), .CO(open));
   
   --ADSU8 adsu8_3 (.A(xa2_reg), .B(xa5_reg), .ADD(toggleA), .CI(1'b0), .S(add_sub3a_all), .OFL(add_sub1a_ofl), .CO(open));
   
   --ADSU8 adsu8_4 (.A(xa3_reg), .B(xa4_reg), .ADD(toggleA), .CI(1'b0), .S(add_sub4a_all), .OFL(add_sub1a_ofl), .CO(open));
   
   -- In addition, Coregen can be used to create adder/subtractor units specific to a particular
   --  In addition, Coregen can be used to create adder/subtractor units specific to a particular
   -- device. The coregen model is then instantiated in the design file. The verilog file from 
   -- coregen can be used along with the design files for simulation and implementation. 
   
   --add_sub adsu8_1 (.A(xa0_reg), .B(xa7_reg), .ADD(toggleA), .CLK(CLK), .Q(add_sub1a));
   
   --add_sub adsu8_2 (.A(xa1_reg), .B(xa6_reg), .ADD(toggleA), .CLK(CLK), .Q(add_sub2a));
   
   --add_sub adsu8_3 (.A(xa2_reg), .B(xa5_reg), .ADD(toggleA), .CLK(CLK), .Q(add_sub3a));
   
   --add_sub adsu8_4 (.A(xa3_reg), .B(xa4_reg), .ADD(toggleA), .CLK(CLK), .Q(add_sub4a));
   
   -- multiply the outputs of the add/sub block with the 8 sets of stored coefficients 
   -- The inputs are shifted thru 8 registers in 8 clk cycles. The ouput of the shift
   --  The inputs are shifted thru 8 registers in 8 clk cycles. The ouput of the shift
   -- registers are registered at the 9th clk. The values are then added or subtracted at the 10th
   -- clk. The first mutiplier output is obtained at the 11th clk. Memoryx[0] shd be accessed
   -- at the 11th clk
   
   --wait state counter 
   PROCESS (RST, CLK)
   BEGIN
      IF (RST = '1') THEN
         i_wait <= "01";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (i_wait /= "00") THEN
            i_wait <= i_wait - "01";    
         ELSE
            i_wait <= "00";    
         END IF;
      END IF;
   END PROCESS;

   -- First valid add_sub appears at the 10th clk (8 clks for shifting inputs,
   
   -- 9th clk for registering shifted input and 10th clk for add_sub
   
   -- to synchronize the i value to the add_sub value, i value is incremented
   
   -- only after 10 clks using i_wait
   
   -- sign and magnitude separated here. magnitude of 9 std_logics is stored in *comp 

P_comp1a: process (RST,CLK)
begin
  if (RST = '1') then
       addsub1a_comp <= (others => '0'); save_sign1a <= '0';
   elsif (rising_edge (CLK)) then
      if(add_sub1a(9) = '0') then
        addsub1a_comp <= add_sub1a(7 downto 0); save_sign1a <= '0';
      else
        addsub1a_comp <= (not(add_sub1a(7 downto 0))) + '1'; save_sign1a <= '1';
      end if;
   end if;
end process P_comp1a;

P_comp2a: process (RST,CLK)
begin
  if (RST = '1') then
       addsub2a_comp <= (others => '0'); save_sign2a <= '0';
   elsif (rising_edge (CLK)) then
      if(add_sub2a(9) = '0') then
        addsub2a_comp <= add_sub2a(7 downto 0); save_sign2a <= '0';
      else
        addsub2a_comp <= (not(add_sub2a(7 downto 0))) + '1'; save_sign2a <= '1';
      end if;
   end if;
end process P_comp2a;

P_comp3a: process (RST,CLK)
begin
  if (RST = '1') then
       addsub3a_comp <= (others => '0'); save_sign3a <= '0';
   elsif (rising_edge (CLK)) then
      if(add_sub3a(9) = '0') then
        addsub3a_comp <= add_sub3a(7 downto 0); save_sign3a <= '0';
      else
        addsub3a_comp <= (not(add_sub3a(7 downto 0))) + '1'; save_sign3a <= '1';
      end if;
   end if;
end process P_comp3a;

P_comp4a: process (RST,CLK)
begin
  if (RST = '1') then
       addsub4a_comp <= (others => '0'); save_sign4a <= '0';
   elsif (rising_edge (CLK)) then
      if(add_sub4a(9) = '0') then
        addsub4a_comp <= add_sub4a(7 downto 0); save_sign4a <= '0';
      else
        addsub4a_comp <= (not(add_sub4a(7 downto 0))) + '1'; save_sign4a <= '1';
      end if;
   end if;
end process P_comp4a;

   p1a_all <= (addsub1a_comp * memory1a(6 downto 0));
   p2a_all <= (addsub2a_comp * memory2a(6 downto 0));
   p3a_all <= (addsub3a_comp * memory3a(6 downto 0));
   p4a_all <= (addsub4a_comp * memory4a(6 downto 0));


   -- The following instantiation can be used while targetting Virtex2 
   --MULT18X18 mult1a (.A({9'b0,addsub1a_comp}), .B({11'b0,memory1a[6:0]}), .P(p1a_all));
   
   --MULT18X18 mult2a (.A({9'b0,addsub2a_comp}), .B({11'b0,memory2a[6:0]}), .P(p2a_all));
   
   --MULT18X18 mult3a (.A({9'b0,addsub3a_comp}), .B({11'b0,memory3a[6:0]}), .P(p3a_all));
   
   --MULT18X18 mult4a (.A({9'b0,addsub4a_comp}), .B({11'b0,memory4a[6:0]}), .P(p4a_all));
   
xor1a <= (save_sign1a) xor (memory1a(7));
xor2a <= (save_sign2a) xor (memory2a(7));
xor3a <= (save_sign3a) xor (memory3a(7));
xor4a <= (save_sign4a) xor (memory4a(7));

P_prodA:process(CLK,RST)
begin
    if (RST = '1') then
    p1a <= (others =>'0'); p2a <= (others =>'0'); 
	  p3a <= (others =>'0'); p4a <= (others =>'0'); indexi<= 7;
    elsif (rising_edge (CLK)) then
       if(i_wait = "00") then
          if (xor1a = '1') then p1a <= not("0000" & p1a_all(14 downto 0)) + '1'; 
          elsif (xor1a = '0') then p1a <= ("0000" & p1a_all(14 downto 0)); end if;
          if (xor2a = '1') then p2a <= not("0000" & p2a_all(14 downto 0)) + '1'; 
          elsif (xor2a = '0') then p2a <= ("0000" & p2a_all(14 downto 0)); end if;
          if (xor3a = '1') then p3a <= not("0000" & p3a_all(14 downto 0)) + '1'; 
          elsif (xor3a = '0') then p3a <= ("0000" & p3a_all(14 downto 0)); end if;
          if (xor4a = '1') then p4a <= not("0000" & p4a_all(14 downto 0)) + '1'; 
          elsif (xor4a = '0') then p4a <= ("0000" & p4a_all(14 downto 0)); end if;

         if (indexi = 7) then
          indexi <= 0;
         else
          indexi <= indexi + 1;
         end if;

       end if;
    end if;
end process P_prodA;

   --always @ (posedge RST or posedge CLK)
   -- always @ (posedge RST or posedge CLK)
   --   begin
   --     if (RST)
   --       begin
   --         p1a <= 19'b0; p2a <= 19'b0; p3a <= 19'b0; p4a <= 19'b0; indexi<= 7;
   --       end
   --     else if (i_wait == 2'b00)
   --       begin
   --         p1a <= (save_sign1a ^ memory1a[7]) ? (-addsub1a_comp * memory1a[6:0]) :(addsub1a_comp * memory1a[6:0]);
   --         p2a <= (save_sign2a ^ memory2a[7]) ? (-addsub2a_comp * memory2a[6:0]) :(addsub2a_comp * memory2a[6:0]);
   --         p3a <= (save_sign3a ^ memory3a[7]) ? (-addsub3a_comp * memory3a[6:0]) :(addsub3a_comp * memory3a[6:0]);
   --         p4a <= (save_sign4a ^ memory4a[7]) ? (-addsub4a_comp * memory4a[6:0]) :(addsub4a_comp * memory4a[6:0]);
   --         if (indexi == 7)
   --           indexi <= 0;
   --         else
   --           indexi <= indexi + 1;
   --       end
   --   end
   
   -- Final adder. Adding the ouputs of the 4 multipliers 
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         z_out_int1 <= "0000000000000000000";    
         z_out_int2 <= "0000000000000000000";    
         z_out_int <= "0000000000000000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         z_out_int1 <= p1a + p2a;    
         z_out_int2 <= p3a + p4a;    
         z_out_int <= z_out_int1 + z_out_int2;    
      END IF;
   END PROCESS;

   z_out_rnd <= (z_out_int(18 downto 8) + "00000000001") WHEN z_out_int(7) = '1' ELSE z_out_int(18 downto 8);

   -- 1 sign std_logic, 11 data std_logic 
   z_out <= z_out_rnd ;

   -- 1D-DCT END 
   -- tranpose memory to store intermediate Z coeeficients 
   -- store the 64 coeeficients in the first 64 locations of the RAM 
   -- first valid adder output is at the 15th clk. (input reg + 8 std_logic SR + add_sub + comp. Signal + reg prod 
   --  first valid adder output is at the 15th clk. (input reg + 8 std_logic SR + add_sub + comp. Signal + reg prod 
   -- + 2 partial prod adds) So the RAM is enabled at the 15th clk)
   
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         cntr12 <= "0000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         cntr12 <= cntr12 + "0001";    
      END IF;
   END PROCESS;

   en_ram1 <= '0' WHEN RST = '1' ELSE '1' WHEN (cntr12 = "1101") ELSE en_ram1 ;

   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         en_ram1reg <= '0';    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         en_ram1reg <= en_ram1;    
      END IF;
   END PROCESS;

   -- After the RAM is enabled, data is written into the RAM1 for 64 clk cycles. Data is written in into
   --  After the RAM is enabled, data is written into the RAM1 for 64 clk cycles. Data is written in into
   -- each consecutive location . After 64 locations are written into, RAM1 goes into read mode and RAM2 goes into
   -- write mode. The cycle then repeats.
   -- For either RAM, data is written into each consecutive location. However , data is read in a different order. If data
   -- is assumed to be written in each row at a time, in an 8x8 matrix, data is read each column at a time. ie., after
   -- the first data is read out, every eight data is read out . Then the 2nd data is read out followed be every 8th.
   -- the write is as follows:
   -- 1w(ram_locn1) 2w(ram_locn2) 3w(ram_locn3) 4w(ram_locn4) 5w(ram_locn5) 6w(ram_locn6) 7w(ram_locn7) 8w(ram_locn8)
   -- 9w(ram_locn9) 10w(ram_locn10) 11w(ram_locn11) 12w(ram_locn12) 13w(ram_locn13) 14w(ram_locn14) 15w(ram_locn15) 16w(ram_locn16)
   -- ..................
   -- 57w(ram_locn57) 58w(ram_locn58) 59w(ram_locn59) 60w(ram_locn60) 61w(ram_locn61) 62w(ram_locn62) 63w(ram_locn63) 64w(ram_locn64)
   -- the read is as follows:
   -- 1r(ram_locn1)  9r(ram_locn2) . . . 57r(ram_locn8)
   -- 2r(ram_locn9) 10r(ram_locn10) . . . 58r(ram_locn16) 
   -- 3r(ram_locn17) 11r(ram_locn18) . . . 59r(ram_locn24)
   -- 4r(ram_locn25) 12r(ram_locn26) . . . 60r(ram_locn32)
   -- 5r(ram_locn33) 13r(ram_locn34) . . . 61r(ram_locn40)
   -- 6r(ram_locn41) 14r(ram_locn42) . . . 62r(ram_locn48)
   -- 7r(ram_locn49) 15r(ram_locn50) . . . 63r(ram_locn56)
   -- 8r(ram_locn57) 16r(ram_locn58) . . . 64r(ram_locn64)
   -- where "xw" is the xth write and "ram_locnx" is the xth ram location and "xr" is the xth read. Reading 
   -- is advanced by the read counter rd_cntr, nd writing by the write counter wr_cntr. 
   
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         rd_cntr(5 downto 3) <= "111";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (en_ram1reg = '1') THEN
            rd_cntr(5 downto 3) <= rd_cntr(5 downto 3) + "001";    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         rd_cntr(2 downto 0) <= "111";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (en_ram1reg = '1' AND rd_cntr(5 downto 3) = "111") THEN
            rd_cntr(2 downto 0) <= rd_cntr(2 downto 0) + "001";    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         rd_cntr(6) <= '1';    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (en_ram1reg = '1' AND rd_cntr(5 downto 0) = "111111") THEN
            rd_cntr(6) <= NOT rd_cntr(6);    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         wr_cntr <= "1111111";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (en_ram1reg = '1') THEN
            wr_cntr <= wr_cntr + "0000001";    
         ELSE
            wr_cntr <= "0000000";    
         END IF;
      END IF;
   END PROCESS;


-- write function
P_ram1: process (RST,CLK)
begin
if (RST = '1') then
ram1_mem(0 to 63) <= (others => "00000000000");
 elsif (rising_edge (CLK)) then
	if (en_ram1reg = '1' and wr_cntr(6) <= '0' ) then
	  ram1_mem(CONV_INTEGER (wr_cntr(5 downto 0))) <= z_out;
    end if;
 end if;
end process P_ram1;

P_ram2: process (RST,CLK)
begin
if (RST = '1') then
ram2_mem(0 to 63) <= (others => "00000000000");
 elsif (rising_edge (CLK)) then
	if (en_ram1reg = '1' and wr_cntr(6) > '1') then
	  ram2_mem(CONV_INTEGER (wr_cntr(5 downto 0))) <= z_out;
    end if;
 end if;
end process P_ram2;


   PROCESS (CLK)
   BEGIN
      IF (CLK'EVENT AND CLK = '1') THEN
         IF (en_ram1reg = '1' AND rd_cntr(6) = '0') THEN
            data_out <= ram2_mem(CONV_INTEGER (rd_cntr(5 downto 0)));    
         ELSE
            IF (en_ram1reg = '1' AND rd_cntr(6) = '1') THEN
               data_out <= ram1_mem(CONV_INTEGER (rd_cntr(5 downto 0)));    
            ELSE
               data_out <= "00000000000";    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- END MEMORY SECTION 
   -- 2D-DCT implementation same as the 1D-DCT implementation 
   -- First dct coeeficient appears at the output of the RAM1 after
   --  First dct coeeficient appears at the output of the RAM1 after
   -- 15 + 64 clk cycles. So the 2nd DCT operation starts after 79 clk cycles. 
   
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         cntr79 <= "0000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         cntr79 <= cntr79 + "0000001";    
      END IF;
   END PROCESS;
   en_dct2d <= '0' WHEN RST = '1' ELSE '1' WHEN (cntr79 = "1001111") ELSE en_dct2d;

   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         en_dct2d_reg <= '0';    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         en_dct2d_reg <= en_dct2d;    
      END IF;
   END PROCESS;
   data_out_final(10 downto 0) <= data_out ;

   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         xb0_in <= "00000000000";    xb1_in <= "00000000000";    
         xb2_in <= "00000000000";    xb3_in <= "00000000000";    
         xb4_in <= "00000000000";    xb5_in <= "00000000000";    
         xb6_in <= "00000000000";    xb7_in <= "00000000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (en_dct2d_reg = '1') THEN
            xb0_in <= data_out_final;    xb1_in <= xb0_in;    
            xb2_in <= xb1_in;    xb3_in <= xb2_in;    
            xb4_in <= xb3_in;    xb5_in <= xb4_in;    
            xb6_in <= xb5_in;    xb7_in <= xb6_in;    
         ELSE
            IF (en_dct2d_reg = '0') THEN
               xb0_in <= "00000000000";    xb1_in <= "00000000000";    
               xb2_in <= "00000000000";    xb3_in <= "00000000000";    
               xb4_in <= "00000000000";    xb5_in <= "00000000000";    
               xb6_in <= "00000000000";    xb7_in <= "00000000000";    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- register inputs, inputs read in every eighth clk
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         xb0_reg <= "000000000000";    xb1_reg <= "000000000000";    
         xb2_reg <= "000000000000";    xb3_reg <= "000000000000";    
         xb4_reg <= "000000000000";    xb5_reg <= "000000000000";    
         xb6_reg <= "000000000000";    xb7_reg <= "000000000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (cntr8 = "1000") THEN
            xb0_reg <= xb0_in(10) & xb0_in;    
            xb1_reg <= xb1_in(10) & xb1_in;    
            xb2_reg <= xb2_in(10) & xb2_in;    
            xb3_reg <= xb3_in(10) & xb3_in;    
            xb4_reg <= xb4_in(10) & xb4_in;    
            xb5_reg <= xb5_in(10) & xb5_in;    
            xb6_reg <= xb6_in(10) & xb6_in;    
            xb7_reg <= xb7_in(10) & xb7_in;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         toggleB <= '0';    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         toggleB <= NOT toggleB;    
      END IF;
   END PROCESS;

   -- adder / subtractor block 
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         add_sub1b <= "000000000000";    
         add_sub2b <= "000000000000";    
         add_sub3b <= "000000000000";    
         add_sub4b <= "000000000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (toggleB = '1') THEN
            add_sub1b <= xb0_reg + xb7_reg;    
            add_sub2b <= xb1_reg + xb6_reg;    
            add_sub3b <= xb2_reg + xb5_reg;    
            add_sub4b <= xb3_reg + xb4_reg;    
         ELSE
            IF (toggleB = '0') THEN
               add_sub1b <= xb7_reg - xb0_reg;    
               add_sub2b <= xb6_reg - xb1_reg;    
               add_sub3b <= xb5_reg - xb2_reg;    
               add_sub4b <= xb4_reg - xb3_reg;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

P_comp1b: process (RST,CLK)
begin
  if (RST = '1') then
       addsub1b_comp <= (others => '0'); save_sign1b <= '0';
   elsif (rising_edge (CLK)) then
      if(add_sub1b(11) = '0') then
        addsub1b_comp <= add_sub1b(10 downto 0); save_sign1b <= '0';
      else
        addsub1b_comp <= (not(add_sub1b(10 downto 0))) + '1'; save_sign1b <= '1';
      end if;
   end if;
end process P_comp1b;

P_comp2b: process (RST,CLK)
begin
  if (RST = '1') then
       addsub2b_comp <= (others => '0'); save_sign2b <= '0';
   elsif (rising_edge (CLK)) then
      if(add_sub2b(11) = '0') then
        addsub2b_comp <= add_sub2b(10 downto 0); save_sign2b <= '0';
      else
        addsub2b_comp <= (not(add_sub2b(10 downto 0))) + '1'; save_sign2b <= '1';
      end if;
   end if;
end process P_comp2b;


P_comp3b: process (RST,CLK)
begin
  if (RST = '1') then
       addsub3b_comp <= (others => '0'); save_sign3b <= '0';
   elsif (rising_edge (CLK)) then
      if(add_sub3b(11) = '0') then
        addsub3b_comp <= add_sub3b(10 downto 0); save_sign3b <= '0';
      else
        addsub3b_comp <= (not(add_sub3b(10 downto 0))) + '1'; save_sign3b <= '1';
      end if;
   end if;
end process P_comp3b;

P_comp4b: process (RST,CLK)
begin
  if (RST = '1') then
       addsub4b_comp <= (others => '0'); save_sign4b <= '0';
   elsif (rising_edge (CLK)) then
      if(add_sub4b(11) = '0') then
        addsub4b_comp <= add_sub4b(10 downto 0); save_sign4b <= '0';
      else
        addsub4b_comp <= (not(add_sub4b(10 downto 0))) + '1'; save_sign4b <= '1';
      end if;
   end if;
end process P_comp4b;


   p1b_all <= (addsub1b_comp * memory1a(6 downto 0)) ;
   p2b_all <= (addsub2b_comp * memory2a(6 downto 0)) ;
   p3b_all <= (addsub3b_comp * memory3a(6 downto 0)) ;
   p4b_all <= (addsub4b_comp * memory4a(6 downto 0)) ;


   -- The following instantiation can be used while targetting Virtex2 
   --MULT18X18 mult1b (.A({9'b0,addsub1b_comp}), .B({11'b0,memory1a[6:0]}), .P(p1b_all));
   
   --MULT18X18 mult2b (.A({9'b0,addsub2b_comp}), .B({11'b0,memory2a[6:0]}), .P(p2b_all));
   
   --MULT18X18 mult3b (.A({9'b0,addsub3b_comp}), .B({11'b0,memory3a[6:0]}), .P(p3b_all));
   
   --MULT18X18 mult4b (.A({9'b0,addsub4b_comp}), .B({11'b0,memory4a[6:0]}), .P(p4b_all));
   


xor1b <= (save_sign1b) xor (memory1a(7));
xor2b <= (save_sign2b) xor (memory2a(7));
xor3b <= (save_sign3b) xor (memory3a(7));
xor4b <= (save_sign4b) xor (memory4a(7));

P_prodB: process(CLK,RST)
begin
    if (RST = '1') then
     p1b <= (others =>'0'); p2b <= (others =>'0'); 
     p3b <= (others =>'0'); p4b <= (others =>'0'); 
    elsif (rising_edge (CLK)) then
       if(i_wait = "00") then
          if (xor1b = '1') then p1b <= not("00" & p1b_all(17 downto 0)) + '1'; 
          elsif (xor1b = '0') then p1b <= ("00" & p1b_all(17 downto 0)); end if;
          if (xor2b = '1') then p2b <= not("00" & p2b_all(17 downto 0)) + '1'; 
          elsif (xor2b = '0') then p2b <= ("00" & p2b_all(17 downto 0)); end if;
          if (xor3b = '1') then p3b <= not("00" & p3b_all(17 downto 0)) + '1'; 
          elsif (xor3b = '0') then p3b <= ("00" & p3b_all(17 downto 0)); end if;
          if (xor4b = '1') then p4b <= not("00" & p4b_all(17 downto 0)) + '1'; 
          elsif (xor4b = '0') then p4b <= ("00" & p4b_all(17 downto 0)); end if;
       end if;
    end if;
end process P_prodB;

   --always @ (posedge RST or posedge CLK)
   -- always @ (posedge RST or posedge CLK)
   --   begin
   --     if (RST)
   --       begin
   --         p1b <= 16'b0; p2b <= 16'b0; p3b <= 16'b0; p4b <= 16'b0; //indexj<= 7;
   --       end
   --     else if (i_wait == 2'b00)
   --       begin
   --         p1b <= (save_sign1b ^ memory1a[7]) ? (-addsub1b_comp * memory1a[6:0]) :(addsub1b_comp * memory1a[6:0]);
   --         p2b <= (save_sign2b ^ memory2a[7]) ? (-addsub2b_comp * memory2a[6:0]) :(addsub2b_comp * memory2a[6:0]);
   --         p3b <= (save_sign3b ^ memory3a[7]) ? (-addsub3b_comp * memory3a[6:0]) :(addsub3b_comp * memory3a[6:0]);
   --         p4b <= (save_sign4b ^ memory4a[7]) ? (-addsub4b_comp * memory4a[6:0]) :(addsub4b_comp * memory4a[6:0]);
   --       end
   --   end
   -- 
   
   -- The above if else statement used to get the add_sub signals can also be implemented using  the adsu16 library element as follows 
   --ADSU16 adsu16_5 (.A({8'b0,xb0_reg}), .B({8'b0,xb7_reg}), .ADD(toggleB), .CI(1'b0), .S(add_sub1b), .OFL(open), .CO(open));
   
   --ADSU16 adsu16_6 (.A({8'b0,xb1_reg}), .B({8'b0,xb6_reg}), .ADD(toggleB), .CI(1'b0), .S(add_sub2b), .OFL(open), .CO(open));
   
   --ADSU16 adsu16_7 (.A({8'b0,xb2_reg}), .B({8'b0,xb5_reg}), .ADD(toggleB), .CI(1'b0), .S(add_sub3b), .OFL(open), .CO(open));
   
   --ADSU16 adsu16_8 (.A({8'b0,xb3_reg}), .B({8'b0,xb4_reg}), .ADD(toggleB), .CI(1'b0), .S(add_sub4b), .OFL(open), .CO(open));
   
   -- multiply the outputs of the add/sub block with the 8 sets of stored coefficients 
   -- Final adder. Adding the ouputs of the 4 multipliers 
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         dct2d_int1 <= "00000000000000000000";    
         dct2d_int2 <= "00000000000000000000";    
         dct_2d_int <= "00000000000000000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         dct2d_int1 <= p1b + p2b;    
         dct2d_int2 <= p3b + p4b;    
         dct_2d_int <= dct2d_int1 + dct2d_int2;    
      END IF;
   END PROCESS;
   dct_2d_rnd <= dct_2d_int(19 downto 8) ;
   dct_2d <= (dct_2d_rnd + "000000000001") WHEN dct_2d_int(7) = '1' ELSE dct_2d_rnd;

   -- The first 1D-DCT output becomes valid after 14 +64 clk cycles. For the first 
   --  The first 1D-DCT output becomes valid after 14 +64 clk cycles. For the first 
   -- 2D-DCT output to be valid it takes 78 + 1clk to write into the ram + 1clk to 
   -- write out of the ram + 8 clks to shift in the 1D-DCT values + 1clk to register 
   -- the 1D-DCT values + 1clk to add/sub + 1clk to take compliment + 1 clk for 
   -- multiplying +  2clks to add product. So the 2D-DCT output will be valid 
   -- at the 94th clk. rdy_out goes high at 93rd clk so that the first data is valid
   -- for the next block
   
   PROCESS (CLK, RST)
   BEGIN
      IF (RST = '1') THEN
         cntr92 <= "0000000";    
      ELSIF (CLK'EVENT AND CLK = '1') THEN
         IF (cntr92 < "1011110") THEN
            cntr92 <= cntr92 + "0000001";    
         ELSE
            cntr92 <= cntr92;    
         END IF;
      END IF;
   END PROCESS;
   rdy_out <= '1' WHEN (cntr92 = "1011110") ELSE '0';

END logic;
