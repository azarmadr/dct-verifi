--********************************************************************* 
-- ********************************************************************* 
-- ** -----------------------------------------------------------------------------** 
-- ** idct.v 
-- ** 
-- ** 8x8 Inverse Discrete Cosine Transform 
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
-- ** Module: idct8x8  
-- ** A 1D-IDCT is implemented on the input dct values. The output of this called 
-- ** the intermediate value is stored in a RAM. The 2nd 1D-IDCT operation is done ** on this stored value to give the final 2D-IDCT output idct_2d. The inputs are ** 9 bits wide and the 2d-idct outputs are 8 bits wide. 
-- ** 1st 1D section 
-- ** The input signals are taken one pixel at a time in the order x00 to x07, 
-- ** x10 to x07 and so on up to x77. These inputs are fed into a 8 bit shift  
-- ** register. The outputs of the 8 bit shift registers are registered at every  
-- ** 8th clock .This will enable us to register in 8 pixels (one row) at atime.  
-- ** The pixels are fed into a multiplier whose other input is connected to stored  
-- ** values in registers which act as memory. The outputs of the 8 multipliers are  
-- ** added at every CLK in the final adder. The ouput of the adder z_out is the  
-- ** 1D-IDCT values given out in the order in which the inputs were read in. 
-- ** It takes 8 clks to read in the first set of inputs, 1 clk to get the absolute  
-- ** value of the input, 1 clk for multiplication, 2 clk for the final adder.  
-- ** total = 12 clks to get the 1st z_out value. Every subsequent clk gives out 
-- **  the next z_out value. So to get all the 64 values we need 12+64=76 clks. 
-- ** Storage / RAM section 
-- ** The outputs z_out of the adder are stored in RAMs. Two RAMs are used so that  
-- ** data write can be continuous. The 1st valid input for the RAM1 is available  
-- ** at the 12th clk. So the RAM1 enable is active after 11 clks. After this the  
-- ** write operation continues for 64 clks . At the 65th clock, since z_out is  
-- ** continuous, we get the next valid z_out_00. This 2nd set of valid 1D-DCT  
-- ** coefficients are written into RAM2 which is enabled at 12+64 clks. 
-- ** So at 65th clk, RAM1 goes into read mode for the next 64 clks and RAM2 is in  
-- ** write mode. After this for every 64 clks, the read and write switches between  
-- ** the 2 RAMS. 
-- ** 2nd 1D-IDCT section 
-- ** After the 1st 76th clk when RAM1 is full, the 2nd 1d calculations can start. 
-- ** The second 1D implementation is the same as the 1st 1D implementation with  
-- ** the inputs now coming from either RAM1 or RAM2. Also, the inputs are read in  
-- ** one column at a time in the order z00 to z70, z10 to z70 up to z77. The  
-- ** outputs from the adder in the 2nd section are the 2D-IDCT coefficients. 
-- ********************************************************************** 
 
library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
--use IEEE.numeric_std.all; 
--library virtex;  
--use virtex.components.all;  
--library synplify;  
--use synplify.attributes.all;  
library unisims_ver; -- include this for modelsim simulation 
                     -- when using mult18x18 
--library UNISIM; 
--use UNISIM.VComponents.all; 
 
ENTITY idct IS 
   PORT ( 
      CLK                     : IN std_logic;    
      RST                     : IN std_logic;    
      rdy_in                  : IN std_logic;    
      dct_2d                  : IN std_logic_vector(11 downto 0);    
      idct_2d                 : OUT std_logic_vector(7 downto 0));    
END idct; 
 
ARCHITECTURE logic OF idct IS 
 
 
   -- The max value of a pixel after processing (to make their expected mean to zero) 
--  The max value of a pixel after processing (to make their expected mean to zero) 
-- is 2047. If all the values in a row are 2047, the max value of the product terms 
-- would be (127*2)*23170 and that of z_out_int would be (2047*8)*23170=235,407,20 which  
-- is a 25 bit binary. This value divided by 2raised to 16 
-- is equivalent to ignoring the 16 lsb bits of the value  
-- 1D section  
signal xa0_in, xa1_in, xa2_in, xa3_in, 
       xa4_in, xa5_in, xa6_in, xa7_in:     std_logic_vector(11 downto 0); 
signal xa0_reg, xa1_reg, xa2_reg, xa3_reg,  
       xa4_reg, xa5_reg, xa6_reg, xa7_reg: std_logic_vector (11 downto 0); 
signal xa0_reg_comp,xa1_reg_comp,xa2_reg_comp, 
       xa3_reg_comp, xa4_reg_comp,xa5_reg_comp, 
       xa6_reg_comp,xa7_reg_comp: std_logic_vector (10 downto 0); 
signal xa0_reg_sign,xa1_reg_sign,xa2_reg_sign,xa3_reg_sign, 
       xa4_reg_sign,xa5_reg_sign,xa6_reg_sign,xa7_reg_sign: std_logic; 
signal xor1a,xor2a,xor3a,xor4a,xor5a,xor6a,xor7a,xor8a: std_logic; 
 
signal p1a,p2a,p3a,p4a,p5a,p6a,p7a,p8a : std_logic_vector (21 downto 0); 
signal p1a_all,p2a_all,p3a_all,p4a_all, 
       p5a_all,p6a_all,p7a_all,p8a_all: std_logic_vector (17 downto 0); 
                  -- assign as 36 bit wide signal if using mult18x18 
 
   signal z_out_int1               :  std_logic_vector(21 downto 0);    
   signal z_out_int2               :  std_logic_vector(21 downto 0);    
   signal z_out_int3               :  std_logic_vector(21 downto 0);    
   signal z_out_int4               :  std_logic_vector(21 downto 0);    
   signal z_out_int                :  std_logic_vector(21 downto 0);    
   signal z_out_rnd                :  std_logic_vector(10 downto 0);    
   signal z_out                    :  std_logic_vector(10 downto 0);    
   signal indexi_val               :  std_logic_vector(2 downto 0);    
 
   -- clks and counters  
   signal cntr11                   :  std_logic_vector(3 downto 0);    
   signal cntr8                    :  std_logic_vector(3 downto 0);    
   signal prod_en1                 :  std_logic_vector(3 downto 0);    
   signal cntr80                   :  std_logic_vector(6 downto 0);    
   signal wr_cntr                  :  std_logic_vector(6 downto 0);    
   signal rd_cntr                  :  std_logic_vector(6 downto 0);    
 
 
 
   -- memory section  
 
  signal memory1a, memory2a, memory3a, memory4a, 
       memory5a, memory6a, memory7a, memory8a: std_logic_vector(7 downto 0); 
 
   
   type ram1a_mem IS ARRAY (63 downto 0) OF std_logic_vector(10 downto 0); 
   signal ram1_mem                 :  ram1a_mem;      
 --  add the following to infer block RAM in synlpicity 
 
    
   type ram2a_mem IS ARRAY (63 downto 0) OF std_logic_vector(10 downto 0); 
   signal ram2_mem                 :  ram2a_mem; 
     --  add the following to infer block RAM in synlpicity 
 
 
   signal data_out                 :  std_logic_vector(10 downto 0);    
   signal data_out_pipe1           :  std_logic_vector(10 downto 0);    
   signal en_ram1                  :  std_logic;    
   signal en_dct2d                 :  std_logic;    
   signal en_ram1reg               :  std_logic;    
   signal en_dct2d_reg             :  std_logic;    
   -- 2D section  
   signal data_out_final           :  std_logic_vector(10 downto 0);  
 
signal xb0_in, xb1_in, xb2_in, xb3_in,  
       xb4_in, xb5_in, xb6_in, xb7_in: std_logic_vector(10 downto 0); 
signal xb0_reg, xb1_reg, xb2_reg, xb3_reg,  
       xb4_reg, xb5_reg, xb6_reg, xb7_reg: std_logic_vector(10 downto 0); 
signal xb0_reg_comp,xb1_reg_comp,xb2_reg_comp, 
       xb3_reg_comp, xb4_reg_comp,xb5_reg_comp, 
       xb6_reg_comp,xb7_reg_comp: std_logic_vector (9 downto 0); 
signal xb0_reg_sign,xb1_reg_sign,xb2_reg_sign,xb3_reg_sign, 
       xb4_reg_sign,xb5_reg_sign,xb6_reg_sign,xb7_reg_sign: std_logic; 
signal xor1b,xor2b,xor3b,xor4b,xor5b,xor6b,xor7b,xor8b: std_logic; 
signal p1b,p2b,p3b,p4b,p5b,p6b,p7b,p8b : std_logic_vector (15 downto 0); 
signal p1b_all,p2b_all,p3b_all,p4b_all, 
       p5b_all,p6b_all,p7b_all,p8b_all: std_logic_vector (16 downto 0); 
     -- assign as 36 bit wide signal if using mult18x18 
   
   signal idct_2d_int1             :  std_logic_vector(19 downto 0);    
   signal idct_2d_int2             :  std_logic_vector(19 downto 0);    
   signal idct_2d_int3             :  std_logic_vector(19 downto 0);    
   signal idct_2d_int4             :  std_logic_vector(19 downto 0);    
   signal idct_2d_int              :  std_logic_vector(19 downto 0);    
 
BEGIN 
 
   --wire[7:0] idct_2d_rnd; 
    
   --  1D-DCT BEGIN  
   -- store  1D-DCT constant coeeficient values for multipliers */ 
    
   PROCESS (RST, CLK) 
   BEGIN 
      IF (RST = '1') THEN 
         memory1a &lt;= "00000000";    memory2a &lt;= "00000000";     
         memory3a &lt;= "00000000";    memory4a &lt;= "00000000";     
         memory5a &lt;= "00000000";    memory6a &lt;= "00000000";     
         memory7a &lt;= "00000000";    memory8a &lt;= "00000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         CASE indexi_val IS 
            WHEN "000" => 
                     memory1a &lt;= "01011011";     
                     memory2a &lt;= "01111110";     
                     memory3a &lt;= "01110110";     
                     memory4a &lt;= "01101010";     
                     memory5a &lt;= "01011011";     
                     memory6a &lt;= "01000111";     
                     memory7a &lt;= "00110001";     
                     memory8a &lt;= "00011001";     
            WHEN "001" => 
                     memory1a &lt;= "01011011";     
                     memory2a &lt;= "01101010";     
                     memory3a &lt;= "00110001";     
                     memory4a &lt;= "10011001";     
                     memory5a &lt;= "11011011";     
                     memory6a &lt;= "11111110";     
                     memory7a &lt;= "11110110";     
                     memory8a &lt;= "11000111";     
            WHEN "010" => 
                     memory1a &lt;= "01011011";     
                     memory2a &lt;= "01000111";     
                     memory3a &lt;= "10110001";     
                     memory4a &lt;= "11111110";     
                     memory5a &lt;= "11011011";     
                     memory6a &lt;= "00011001";     
                     memory7a &lt;= "01110110";     
                     memory8a &lt;= "01101010";     
            WHEN "011" => 
                     memory1a &lt;= "01011011";     
                     memory2a &lt;= "00011001";     
                     memory3a &lt;= "11110110";     
                     memory4a &lt;= "11000111";     
                     memory5a &lt;= "01011011";     
                     memory6a &lt;= "01101010";     
                     memory7a &lt;= "10110001";     
                     memory8a &lt;= "11111110";     
            WHEN "111" => 
                     memory1a &lt;= "01011011";     
                     memory2a &lt;= "11111110";     
                     memory3a &lt;= "01110110";     
                     memory4a &lt;= "11101010";     
                     memory5a &lt;= "01011011";     
                     memory6a &lt;= "11000111";     
                     memory7a &lt;= "00110001";     
                     memory8a &lt;= "10011001";     
            WHEN "110" => 
                     memory1a &lt;= "01011011";     
                     memory2a &lt;= "11101010";     
                     memory3a &lt;= "00110001";     
                     memory4a &lt;= "00011001";     
                     memory5a &lt;= "11011011";     
                     memory6a &lt;= "01111110";     
                     memory7a &lt;= "11110110";     
                     memory8a &lt;= "01000111";     
            WHEN "101" => 
                     memory1a &lt;= "01011011";     
                     memory2a &lt;= "11000111";     
                     memory3a &lt;= "10110001";     
                     memory4a &lt;= "01111110";     
                     memory5a &lt;= "11011011";     
                     memory6a &lt;= "10011001";     
                     memory7a &lt;= "01110110";     
                     memory8a &lt;= "11101010";     
            WHEN "100" => 
                     memory1a &lt;= "01011011";     
                     memory2a &lt;= "10011001";     
                     memory3a &lt;= "11110110";     
                     memory4a &lt;= "01000111";     
                     memory5a &lt;= "01011011";     
                     memory6a &lt;= "11101010";     
                     memory7a &lt;= "10110001";     
                     memory8a &lt;= "01111110";     
            WHEN OTHERS => 
                     NULL; 
             
         END CASE; 
      END IF; 
   END PROCESS; 
 
   -- 8-bit input shifted 8 times thru a shift register 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         xa0_in &lt;= "000000000000";    xa1_in &lt;= "000000000000";     
         xa2_in &lt;= "000000000000";    xa3_in &lt;= "000000000000";     
         xa4_in &lt;= "000000000000";    xa5_in &lt;= "000000000000";     
         xa6_in &lt;= "000000000000";    xa7_in &lt;= "000000000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (rdy_in = '1') THEN 
            xa0_in &lt;= dct_2d;    xa1_in &lt;= xa0_in;     
            xa2_in &lt;= xa1_in;    xa3_in &lt;= xa2_in;     
            xa4_in &lt;= xa3_in;    xa5_in &lt;= xa4_in;     
            xa6_in &lt;= xa5_in;    xa7_in &lt;= xa6_in;     
         ELSE 
            xa0_in &lt;= "000000000000";    xa1_in &lt;= "000000000000";     
            xa2_in &lt;= "000000000000";    xa3_in &lt;= "000000000000";     
            xa4_in &lt;= "000000000000";    xa5_in &lt;= "000000000000";     
            xa6_in &lt;= "000000000000";    xa7_in &lt;= "000000000000";     
         END IF; 
      END IF; 
   END PROCESS; 
 
   -- shifted inputs registered every 8th clk (using cntr8) 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         cntr8 &lt;= "0000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (rdy_in = '1') THEN 
            IF (cntr8 &lt; "1000") THEN 
               cntr8 &lt;= cntr8 + "0001";     
            ELSE 
               cntr8 &lt;= "0001";     
            END IF; 
         ELSE 
            cntr8 &lt;= "0000";     
         END IF; 
      END IF; 
   END PROCESS; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         prod_en1 &lt;= "0000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (rdy_in = '1') THEN 
            IF (prod_en1 &lt; "1001") THEN 
               prod_en1 &lt;= prod_en1 + "0001";     
            ELSE 
               prod_en1 &lt;= "1001";     
            END IF; 
         END IF; 
      END IF; 
   END PROCESS; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         xa0_reg &lt;= "000000000000";  xa1_reg &lt;= "000000000000";     
         xa2_reg &lt;= "000000000000";  xa3_reg &lt;= "000000000000";     
         xa4_reg &lt;= "000000000000";  xa5_reg &lt;= "000000000000";     
         xa6_reg &lt;= "000000000000";  xa7_reg &lt;= "000000000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (cntr8 = "1000") THEN 
            xa0_reg &lt;= xa0_in;  xa1_reg &lt;= xa1_in;     
            xa2_reg &lt;= xa2_in;  xa3_reg &lt;= xa3_in;     
            xa4_reg &lt;= xa4_in;  xa5_reg &lt;= xa5_in;     
            xa6_reg &lt;= xa6_in;  xa7_reg &lt;= xa7_in;     
         ELSE 
             
         END IF; 
      END IF; 
   END PROCESS; 
 
   -- take absolute value of signals  
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         xa0_reg_comp &lt;= "00000000000";    xa1_reg_comp &lt;= "00000000000";     
         xa2_reg_comp &lt;= "00000000000";    xa3_reg_comp &lt;= "00000000000";     
         xa4_reg_comp &lt;= "00000000000";    xa5_reg_comp &lt;= "00000000000";     
         xa6_reg_comp &lt;= "00000000000";    xa7_reg_comp &lt;= "00000000000";     
         xa0_reg_sign &lt;= '0';   xa1_reg_sign &lt;= '0';     
         xa2_reg_sign &lt;= '0';   xa3_reg_sign &lt;= '0';     
         xa4_reg_sign &lt;= '0';   xa5_reg_sign &lt;= '0';     
         xa6_reg_sign &lt;= '0';   xa7_reg_sign &lt;= '0';     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
       if (xa0_reg(11) = '0') then  xa0_reg_comp &lt;= xa0_reg(10 downto 0); 
       else xa0_reg_comp &lt;= not(xa0_reg(10 downto 0)) + '1'; end if; 
       if (xa1_reg(11) = '0') then  xa1_reg_comp &lt;= xa1_reg(10 downto 0); 
       else xa1_reg_comp &lt;= not(xa1_reg(10 downto 0)) + '1'; end if; 
       if (xa2_reg(11) = '0') then  xa2_reg_comp &lt;= xa2_reg(10 downto 0); 
       else xa2_reg_comp &lt;= not(xa2_reg(10 downto 0)) + '1'; end if; 
       if (xa3_reg(11) = '0') then  xa3_reg_comp &lt;= xa3_reg(10 downto 0); 
       else xa3_reg_comp &lt;= not(xa3_reg(10 downto 0)) + '1'; end if; 
       if (xa4_reg(11) = '0') then  xa4_reg_comp &lt;= xa4_reg(10 downto 0); 
       else xa4_reg_comp &lt;= not(xa4_reg(10 downto 0)) + '1'; end if; 
       if (xa5_reg(11) = '0') then  xa5_reg_comp &lt;= xa5_reg(10 downto 0); 
       else xa5_reg_comp &lt;= not(xa5_reg(10 downto 0)) + '1'; end if; 
       if (xa6_reg(11) = '0') then  xa6_reg_comp &lt;= xa6_reg(10 downto 0); 
       else xa6_reg_comp &lt;= not(xa6_reg(10 downto 0)) + '1'; end if; 
       if (xa7_reg(11) = '0') then  xa7_reg_comp &lt;= xa7_reg(10 downto 0);  
       else xa7_reg_comp &lt;= not(xa7_reg(10 downto 0)) + '1'; end if; 
 
       xa0_reg_sign &lt;= xa0_reg(11); xa1_reg_sign &lt;= xa1_reg(11); 
       xa2_reg_sign &lt;= xa2_reg(11); xa3_reg_sign &lt;= xa3_reg(11); 
       xa4_reg_sign &lt;= xa4_reg(11); xa5_reg_sign &lt;= xa5_reg(11); 
       xa6_reg_sign &lt;= xa6_reg(11); xa7_reg_sign &lt;= xa7_reg(11); 
 
      END IF; 
   END PROCESS; 
 
   -- multiply the outputs of the add/sub block with the 8 sets of stored coefficients  
   -- The inputs are shifted thru 8 registers in 8 clk cycles. The ouput of the shift 
   --  The inputs are shifted thru 8 registers in 8 clk cycles. The ouput of the shift 
   -- registers are registered at the 9th clk. The values are then added or subtracted at the 10th 
   -- clk. The first mutiplier output is obtained at the 11th clk. Memoryx[0] shd be accessed 
   -- at the 11th clk 
    
   --wait state counter  
   -- First valid add_sub appears at the 10th clk (8 clks for shifting inputs, 
    
   -- 9th clk for registering shifted input and 10th clk for add_sub 
    
   -- to synchronize the i value to the add_sub value, i value is incremented 
    
-- only after 10 clks using i_wait 
 
    
   -- max value for p1a = 2047*126. = 18 bits  
   p1a_all &lt;= xa7_reg_comp(10 downto 0) * memory1a(6 downto 0) ; 
   p2a_all &lt;= xa6_reg_comp(10 downto 0) * memory2a(6 downto 0) ; 
   p3a_all &lt;= xa5_reg_comp(10 downto 0) * memory3a(6 downto 0) ; 
   p4a_all &lt;= xa4_reg_comp(10 downto 0) * memory4a(6 downto 0) ; 
   p5a_all &lt;= xa3_reg_comp(10 downto 0) * memory5a(6 downto 0) ; 
   p6a_all &lt;= xa2_reg_comp(10 downto 0) * memory6a(6 downto 0) ; 
   p7a_all &lt;= xa1_reg_comp(10 downto 0) * memory7a(6 downto 0) ; 
   p8a_all &lt;= xa0_reg_comp(10 downto 0) * memory8a(6 downto 0) ; 
 
 
   -- The following instantiation can be used while targetting Virtex2  
   --MULT18X18 mult1a (.A({10'b0,xa7_reg_comp[7:0]}), .B({11'b0,memory1a[6:0]}), .P(p1a_all)); 
    
   --MULT18X18 mult2a (.A({10'b0,xa6_reg_comp[7:0]}), .B({11'b0,memory2a[6:0]}), .P(p2a_all)); 
    
   --MULT18X18 mult3a (.A({10'b0,xa5_reg_comp[7:0]}), .B({11'b0,memory3a[6:0]}), .P(p3a_all)); 
    
   --MULT18X18 mult4a (.A({10'b0,xa4_reg_comp[7:0]}), .B({11'b0,memory4a[6:0]}), .P(p4a_all)); 
    
   --MULT18X18 mult5a (.A({10'b0,xa3_reg_comp[7:0]}), .B({11'b0,memory5a[6:0]}), .P(p5a_all)); 
    
   --MULT18X18 mult6a (.A({10'b0,xa2_reg_comp[7:0]}), .B({11'b0,memory6a[6:0]}), .P(p6a_all)); 
    
   --MULT18X18 mult7a (.A({10'b0,xa1_reg_comp[7:0]}), .B({11'b0,memory7a[6:0]}), .P(p7a_all)); 
    
   --MULT18X18 mult8a (.A({10'b0,xa0_reg_comp[7:0]}), .B({11'b0,memory8a[6:0]}), .P(p8a_all)); 
 
xor1a &lt;= (xa7_reg_sign) xor (memory1a(7)); 
xor2a &lt;= (xa6_reg_sign) xor (memory2a(7)); 
xor3a &lt;= (xa5_reg_sign) xor (memory3a(7)); 
xor4a &lt;= (xa4_reg_sign) xor (memory4a(7)); 
xor5a &lt;= (xa3_reg_sign) xor (memory5a(7)); 
xor6a &lt;= (xa2_reg_sign) xor (memory6a(7)); 
xor7a &lt;= (xa1_reg_sign) xor (memory7a(7)); 
xor8a &lt;= (xa0_reg_sign) xor (memory8a(7)); 
    
   PROCESS (RST, CLK) 
   BEGIN 
      IF (RST = '1') THEN 
         p1a &lt;= "0000000000000000000000";     
         p2a &lt;= "0000000000000000000000";     
         p3a &lt;= "0000000000000000000000";     
         p4a &lt;= "0000000000000000000000";     
         p5a &lt;= "0000000000000000000000";     
         p6a &lt;= "0000000000000000000000";     
         p7a &lt;= "0000000000000000000000";     
         p8a &lt;= "0000000000000000000000";     
         indexi_val &lt;= "000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (rdy_in = '1' AND prod_en1 = "1001") THEN 
          if (xor1a = '1') then p1a &lt;= not("000000" & p1a_all(15 downto 0)) + '1';  
          elsif (xor1a = '0') then p1a &lt;= ("000000" & p1a_all(15 downto 0)); end if; 
          if (xor2a = '1') then p2a &lt;= not("000000" & p2a_all(15 downto 0)) + '1';  
          elsif (xor2a = '0') then p2a &lt;= ("000000" & p2a_all(15 downto 0)); end if; 
          if (xor3a = '1') then p3a &lt;= not("000000" & p3a_all(15 downto 0)) + '1';  
          elsif (xor3a = '0') then p3a &lt;= ("000000" & p3a_all(15 downto 0)); end if; 
          if (xor4a = '1') then p4a &lt;= not("000000" & p4a_all(15 downto 0)) + '1';  
          elsif (xor4a = '0') then p4a &lt;= ("000000" & p4a_all(15 downto 0)); end if; 
          if (xor5a = '1') then p5a &lt;= not("000000" & p5a_all(15 downto 0)) + '1';  
          elsif (xor5a = '0') then p5a &lt;= ("000000" & p5a_all(15 downto 0)); end if; 
          if (xor6a = '1') then p6a &lt;= not("000000" & p6a_all(15 downto 0)) + '1';  
          elsif (xor6a = '0') then p6a &lt;= ("000000" & p6a_all(15 downto 0)); end if; 
          if (xor7a = '1') then p7a &lt;= not("000000" & p7a_all(15 downto 0)) + '1';  
          elsif (xor7a = '0') then p7a &lt;= ("000000" & p7a_all(15 downto 0)); end if; 
          if (xor8a = '1') then p8a &lt;= not("000000" & p8a_all(15 downto 0)) + '1';  
          elsif (xor8a = '0') then p8a &lt;= ("000000" & p8a_all(15 downto 0)); end if; 
            IF (indexi_val = "111") THEN 
               indexi_val &lt;= "000";     
            ELSE 
               indexi_val &lt;= indexi_val + "001";     
            END IF; 
         ELSE 
            p1a &lt;= "0000000000000000000000";     
            p2a &lt;= "0000000000000000000000";     
            p3a &lt;= "0000000000000000000000";     
            p4a &lt;= "0000000000000000000000";     
            p5a &lt;= "0000000000000000000000";     
            p6a &lt;= "0000000000000000000000";     
            p7a &lt;= "0000000000000000000000";     
            p8a &lt;= "0000000000000000000000";     
         END IF; 
      END IF; 
   END PROCESS; 
 
   -- Final adder. Adding the ouputs of the 4 multipliers  
   -- max value for z_out_int = 2047*126*8 = 2063376 = 21 bits  
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         z_out_int1 &lt;= "0000000000000000000000";     
         z_out_int2 &lt;= "0000000000000000000000";     
         z_out_int3 &lt;= "0000000000000000000000";     
         z_out_int4 &lt;= "0000000000000000000000";     
         z_out_int &lt;= "0000000000000000000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         z_out_int1 &lt;= p1a + p2a;     
         z_out_int2 &lt;= p3a + p4a;     
         z_out_int3 &lt;= p5a + p6a;     
         z_out_int4 &lt;= p7a + p8a;     
         z_out_int &lt;= z_out_int1 + z_out_int2 + z_out_int3 + z_out_int4;     
      END IF; 
   END PROCESS; 
   -- rounding of the value 
    
   -- max value for a 1D-DCT output is "11111111"*126*8/256=1004. 
   --  max value for a 1D-DCT output is "11111111"*126*8/256=1004. 
   -- To represent this we need only 10 bits, plus 1 bit for sign  
   z_out_rnd &lt;= z_out_int(18 downto 8) ; 
   z_out &lt;= (z_out_rnd + "00000000001") WHEN z_out_int(7) = '1' ELSE z_out_rnd; 
  
 
   -- 1D-DCT END  
   -- tranpose memory to store intermediate Z coefficients  
   -- store the 64 coefficients in the first 64 locations of the RAM  
   -- first valid final (product) adder ouput is at the 13th clk. 8clk SR 
   --  first valid final (product) adder ouput is at the 13th clk. 8clk SR 
   -- + 1 clk reg + 1 clk comp + 1 clk prod. + 2 clks summing. 
   -- So the RAM is enabled at the 11th clk)  
    
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         cntr11 &lt;= "0000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (rdy_in = '1') THEN 
            cntr11 &lt;= cntr11 + "0001";     
         END IF; 
      END IF; 
   END PROCESS; 
 
   en_ram1 &lt;= '0' WHEN RST = '1' ELSE '1' WHEN (cntr11 = "1100") ELSE en_ram1; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         en_ram1reg &lt;= '0';     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         en_ram1reg &lt;= en_ram1;     
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
         rd_cntr(5 downto 3) &lt;= "111";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (en_ram1reg = '1') THEN 
            rd_cntr(5 downto 3) &lt;= rd_cntr(5 downto 3) + "001";     
         END IF; 
      END IF; 
   END PROCESS; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         rd_cntr(2 downto 0) &lt;= "111";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (en_ram1reg = '1' AND rd_cntr(5 downto 3) = "111") THEN 
            rd_cntr(2 downto 0) &lt;= rd_cntr(2 downto 0) + "001";     
         END IF; 
      END IF; 
   END PROCESS; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         rd_cntr(6) &lt;= '1';     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (en_ram1reg = '1' AND rd_cntr(5 downto 0) = "111111") THEN 
            rd_cntr(6) &lt;= NOT rd_cntr(6);     
         END IF; 
      END IF; 
   END PROCESS; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         wr_cntr &lt;= "1111111";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (en_ram1reg = '1') THEN 
            wr_cntr &lt;= wr_cntr + "0000001";     
         ELSE 
            wr_cntr &lt;= "0000000";     
         END IF; 
      END IF; 
   END PROCESS; 
 
-- write function 
P_ram1: process (RST,CLK) 
begin 
if (RST = '1') then 
ram1_mem(63 downto 0) &lt;= (others => "00000000000"); 
 elsif (rising_edge (CLK)) then 
	if (en_ram1reg = '1' and wr_cntr(6) = '0' ) then 
	  ram1_mem(CONV_INTEGER (wr_cntr(5 downto 0))) &lt;= z_out; 
    end if; 
 end if; 
end process P_ram1; 
 
P_ram2: process (RST,CLK) 
begin 
if (RST = '1') then 
ram2_mem(63 downto 0) &lt;= (others => "00000000000"); 
 elsif (rising_edge (CLK)) then 
	if (en_ram1reg = '1' and wr_cntr(6) = '1') then 
	  ram2_mem(CONV_INTEGER (wr_cntr(5 downto 0))) &lt;= z_out; 
    end if; 
 end if; 
end process P_ram2; 
 
-- read function 
P_ramout: process (RST,CLK) 
begin 
if (RST = '1') then 
data_out &lt;= (others => '0'); 
 elsif (rising_edge (CLK)) then 
	if (en_ram1reg = '1' and rd_cntr(6) = '0') then 
	    data_out &lt;= ram2_mem(CONV_INTEGER (rd_cntr(5 downto 0))); 
      elsif (en_ram1reg = '1' and rd_cntr(6) = '1') then 
          data_out &lt;= ram1_mem(conv_integer (rd_cntr(5 downto 0))); 
      elsif (en_ram1reg = '0') then 
          data_out &lt;= (others => '0'); 
      end if; 
   end if; 
end process P_ramout; 
 
 
   -- END MEMORY SECTION  
   -- 2D-DCT implementation same as the 1D-DCT implementation  
   -- First dct coeeficient appears at the output of the RAM1 after 13clk + 1clk ram in + 64  
   --  First dct coeeficient appears at the output of the RAM1 after 13clk + 1clk ram in + 64  
   -- clk cycles + 1clk ram out. including the 1 pipestage, the 2nd DCT operation starts after  
   -- 16 +  64 clk cycles. Pipe stages are added to match the timing with the cntr8 counter  
    
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         data_out_pipe1 &lt;= "00000000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         data_out_pipe1 &lt;= data_out;     
      END IF; 
   END PROCESS; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         cntr80 &lt;= "0000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (rdy_in = '1') THEN 
            cntr80 &lt;= cntr80 + "0000001";     
         END IF; 
      END IF; 
   END PROCESS; 
 
   en_dct2d &lt;= '0' WHEN RST = '1' ELSE '1' WHEN (cntr80 = "1001111") ELSE en_dct2d; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         en_dct2d_reg &lt;= '0';     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         en_dct2d_reg &lt;= en_dct2d;     
      END IF; 
   END PROCESS; 
   data_out_final(10 downto 0) &lt;= data_out_pipe1 ; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         xb0_in &lt;= "00000000000";    xb1_in &lt;= "00000000000";     
         xb2_in &lt;= "00000000000";    xb3_in &lt;= "00000000000";     
         xb4_in &lt;= "00000000000";    xb5_in &lt;= "00000000000";     
         xb6_in &lt;= "00000000000";    xb7_in &lt;= "00000000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (en_dct2d_reg = '1') THEN 
            xb0_in &lt;= data_out_final;    xb1_in &lt;= xb0_in;     
            xb2_in &lt;= xb1_in;    xb3_in &lt;= xb2_in;     
            xb4_in &lt;= xb3_in;    xb5_in &lt;= xb4_in;     
            xb6_in &lt;= xb5_in;    xb7_in &lt;= xb6_in;     
         ELSE 
            IF (en_dct2d_reg = '0') THEN 
               xb0_in &lt;= "00000000000";    xb1_in &lt;= "00000000000";     
               xb2_in &lt;= "00000000000";    xb3_in &lt;= "00000000000";     
               xb4_in &lt;= "00000000000";    xb5_in &lt;= "00000000000";     
               xb6_in &lt;= "00000000000";    xb7_in &lt;= "00000000000";     
            END IF; 
         END IF; 
      END IF; 
   END PROCESS; 
 
   -- register inputs, inputs read in every eighth clk 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         xb0_reg &lt;= "00000000000";    xb1_reg &lt;= "00000000000";     
         xb2_reg &lt;= "00000000000";    xb3_reg &lt;= "00000000000";     
         xb4_reg &lt;= "00000000000";    xb5_reg &lt;= "00000000000";     
         xb6_reg &lt;= "00000000000";    xb7_reg &lt;= "00000000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (cntr8 = "1000") THEN 
            xb0_reg &lt;= xb0_in;    xb1_reg &lt;= xb1_in;     
            xb2_reg &lt;= xb2_in;    xb3_reg &lt;= xb3_in;     
            xb4_reg &lt;= xb4_in;    xb5_reg &lt;= xb5_in;     
            xb6_reg &lt;= xb6_in;    xb7_reg &lt;= xb7_in;     
         END IF; 
      END IF; 
   END PROCESS; 
 
 
   -- take absolute value of signals  
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         xb0_reg_comp &lt;= "0000000000";    xb1_reg_comp &lt;= "0000000000";     
         xb2_reg_comp &lt;= "0000000000";    xb3_reg_comp &lt;= "0000000000";     
         xb4_reg_comp &lt;= "0000000000";    xb5_reg_comp &lt;= "0000000000";     
         xb6_reg_comp &lt;= "0000000000";    xb7_reg_comp &lt;= "0000000000";     
         xb0_reg_sign &lt;= '0';    xb1_reg_sign &lt;= '0';     
         xb2_reg_sign &lt;= '0';    xb3_reg_sign &lt;= '0';     
         xb4_reg_sign &lt;= '0';    xb5_reg_sign &lt;= '0';     
         xb6_reg_sign &lt;= '0';    xb7_reg_sign &lt;= '0';     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
       if (xb0_reg(10) = '0') then  xb0_reg_comp &lt;= xb0_reg(9 downto 0); 
       else xb0_reg_comp &lt;= not(xb0_reg(9 downto 0)) + '1'; end if; 
       if (xb1_reg(10) = '0') then  xb1_reg_comp &lt;= xb1_reg(9 downto 0); 
       else xb1_reg_comp &lt;= not(xb1_reg(9 downto 0)) + '1'; end if; 
       if (xb2_reg(10) = '0') then  xb2_reg_comp &lt;= xb2_reg(9 downto 0); 
       else xb2_reg_comp &lt;= not(xb2_reg(9 downto 0)) + '1'; end if; 
       if (xb3_reg(10) = '0') then  xb3_reg_comp &lt;= xb3_reg(9 downto 0); 
       else xb3_reg_comp &lt;= not(xb3_reg(9 downto 0)) + '1'; end if; 
       if (xb4_reg(10) = '0') then  xb4_reg_comp &lt;= xb4_reg(9 downto 0); 
       else xb4_reg_comp &lt;= not(xb4_reg(9 downto 0)) + '1'; end if; 
       if (xb5_reg(10) = '0') then  xb5_reg_comp &lt;= xb5_reg(9 downto 0); 
       else xb5_reg_comp &lt;= not(xb5_reg(9 downto 0)) + '1'; end if; 
       if (xb6_reg(10) = '0') then  xb6_reg_comp &lt;= xb6_reg(9 downto 0); 
       else xb6_reg_comp &lt;= not(xb6_reg(9 downto 0)) + '1'; end if; 
       if (xb7_reg(10) = '0') then  xb7_reg_comp &lt;= xb7_reg(9 downto 0); 
       else xb7_reg_comp &lt;= not(xb7_reg(9 downto 0)) + '1'; end if; 
 
       xb0_reg_sign &lt;= xb0_reg(10); xb1_reg_sign &lt;= xb1_reg(10); 
       xb2_reg_sign &lt;= xb2_reg(10); xb3_reg_sign &lt;= xb3_reg(10); 
       xb4_reg_sign &lt;= xb4_reg(10); xb5_reg_sign &lt;= xb5_reg(10); 
       xb6_reg_sign &lt;= xb6_reg(10); xb7_reg_sign &lt;= xb7_reg(10); 
 
      END IF; 
   END PROCESS; 
 
   -- 10 bits * 7 bits = 16 bits  
   p1b_all &lt;= xb7_reg_comp(9 downto 0) * memory1a(6 downto 0) ; 
   p2b_all &lt;= xb6_reg_comp(9 downto 0) * memory2a(6 downto 0) ; 
   p3b_all &lt;= xb5_reg_comp(9 downto 0) * memory3a(6 downto 0) ; 
   p4b_all &lt;= xb4_reg_comp(9 downto 0) * memory4a(6 downto 0) ; 
   p5b_all &lt;= xb3_reg_comp(9 downto 0) * memory5a(6 downto 0) ; 
   p6b_all &lt;= xb2_reg_comp(9 downto 0) * memory6a(6 downto 0) ; 
   p7b_all &lt;= xb1_reg_comp(9 downto 0) * memory7a(6 downto 0) ; 
   p8b_all &lt;= xb0_reg_comp(9 downto 0) * memory8a(6 downto 0) ; 
 
 
   -- The following instantiation can be used while targetting Virtex2  
   --MULT18X18 mult1b (.A({10'b0,xb7_reg_comp[7:0]}), .B({11'b0,memory1a[6:0]}), .P(p1b_all)); 
   
   --MULT18X18 mult2b (.A({10'b0,xb6_reg_comp[7:0]}), .B({11'b0,memory2a[6:0]}), .P(p2b_all)); 
    
   --MULT18X18 mult3b (.A({10'b0,xb5_reg_comp[7:0]}), .B({11'b0,memory3a[6:0]}), .P(p3b_all)); 
    
   --MULT18X18 mult4b (.A({10'b0,xb4_reg_comp[7:0]}), .B({11'b0,memory4a[6:0]}), .P(p4b_all)); 
    
   --MULT18X18 mult5b (.A({10'b0,xb3_reg_comp[7:0]}), .B({11'b0,memory5a[6:0]}), .P(p5b_all)); 
    
   --MULT18X18 mult6b (.A({10'b0,xb2_reg_comp[7:0]}), .B({11'b0,memory6a[6:0]}), .P(p6b_all)); 
    
   --MULT18X18 mult7b (.A({10'b0,xb1_reg_comp[7:0]}), .B({11'b0,memory7a[6:0]}), .P(p7b_all)); 
    
   --MULT18X18 mult8b (.A({10'b0,xb0_reg_comp[7:0]}), .B({11'b0,memory8a[6:0]}), .P(p8b_all)); 
    
   -- multiply the outputs of the add/sub block with the 8 sets of stored coefficients  
 
xor1b &lt;= (xb7_reg_sign) xor (memory1a(7)); 
xor2b &lt;= (xb6_reg_sign) xor (memory2a(7)); 
xor3b &lt;= (xb5_reg_sign) xor (memory3a(7)); 
xor4b &lt;= (xb4_reg_sign) xor (memory4a(7)); 
xor5b &lt;= (xb3_reg_sign) xor (memory5a(7)); 
xor6b &lt;= (xb2_reg_sign) xor (memory6a(7)); 
xor7b &lt;= (xb1_reg_sign) xor (memory7a(7)); 
xor8b &lt;= (xb0_reg_sign) xor (memory8a(7)); 
 
   PROCESS (RST, CLK) 
   BEGIN 
      IF (RST = '1') THEN 
         p1b &lt;= "0000000000000000";    p2b &lt;= "0000000000000000";     
         p3b &lt;= "0000000000000000";    p4b &lt;= "0000000000000000";     
         p5b &lt;= "0000000000000000";    p6b &lt;= "0000000000000000";     
         p7b &lt;= "0000000000000000";    p8b &lt;= "0000000000000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         IF (rdy_in = '1' AND prod_en1 = "1001") THEN 
          if (xor1b = '1') then p1b &lt;= not('0' & p1b_all(14 downto 0)) + '1';  
          elsif (xor1b = '0') then p1b &lt;= ('0' & p1b_all(14 downto 0)); end if; 
          if (xor2b = '1') then p2b &lt;= not('0' & p2b_all(14 downto 0)) + '1';  
          elsif (xor2b = '0') then p2b &lt;= ('0' & p2b_all(14 downto 0)); end if; 
          if (xor3b = '1') then p3b &lt;= not('0' & p3b_all(14 downto 0)) + '1';  
          elsif (xor3b = '0') then p3b &lt;= ('0' & p3b_all(14 downto 0)); end if; 
          if (xor4b = '1') then p4b &lt;= not('0' & p4b_all(14 downto 0)) + '1';  
          elsif (xor4b = '0') then p4b &lt;= ('0' & p4b_all(14 downto 0)); end if; 
          if (xor5b = '1') then p5b &lt;= not('0' & p5b_all(14 downto 0)) + '1';  
          elsif (xor5b = '0') then p5b &lt;= ('0' & p5b_all(14 downto 0)); end if; 
          if (xor6b = '1') then p6b &lt;= not('0' & p6b_all(14 downto 0)) + '1';  
          elsif (xor6b = '0') then p6b &lt;= ('0' & p6b_all(14 downto 0)); end if; 
          if (xor7b = '1') then p7b &lt;= not('0' & p7b_all(14 downto 0)) + '1';  
          elsif (xor7b = '0') then p7b &lt;= ('0' & p7b_all(14 downto 0)); end if; 
          if (xor8b = '1') then p8b &lt;= not('0' & p8b_all(14 downto 0)) + '1';  
          elsif (xor8b = '0') then p8b &lt;= ('0' & p8b_all(14 downto 0)); end if; 
         ELSE 
            p1b &lt;= "0000000000000000";     
            p2b &lt;= "0000000000000000";     
            p3b &lt;= "0000000000000000";     
            p4b &lt;= "0000000000000000";     
            p5b &lt;= "0000000000000000";     
            p6b &lt;= "0000000000000000";     
            p7b &lt;= "0000000000000000";     
            p8b &lt;= "0000000000000000";     
         END IF; 
      END IF; 
   END PROCESS; 
 
   PROCESS (CLK, RST) 
   BEGIN 
      IF (RST = '1') THEN 
         idct_2d_int1 &lt;= "00000000000000000000";     
         idct_2d_int2 &lt;= "00000000000000000000";     
         idct_2d_int3 &lt;= "00000000000000000000";     
         idct_2d_int4 &lt;= "00000000000000000000";     
         idct_2d_int &lt;= "00000000000000000000";     
      ELSIF (CLK'EVENT AND CLK = '1') THEN 
         idct_2d_int1 &lt;= "0000" & (p1b + p2b);     
         idct_2d_int2 &lt;= "0000" & (p3b + p4b);     
         idct_2d_int3 &lt;= "0000" & (p5b + p6b);     
         idct_2d_int4 &lt;= "0000" & (p7b + p8b);     
         idct_2d_int &lt;= idct_2d_int1 + idct_2d_int2 + idct_2d_int3 + idct_2d_int4;     
      END IF; 
   END PROCESS; 
   -- max value for a input signal to dct is "11111111". 
   --  max value for a input signal to dct is "11111111". 
   -- To represent this we need only 8 bits, plus 1 bit for sign  
    
   --assign idct_2d = idct_2d_int[16:8]; 
   idct_2d &lt;= idct_2d_int(19) & idct_2d_int(14 downto 8) ; 
   --assign idct_2d = idct_2d_int[7] ? (idct_2d_rnd + 1'b1) : idct_2d_rnd; 
 
END logic; 
