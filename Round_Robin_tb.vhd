----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2019 04:01:11 PM
-- Design Name: 
-- Module Name: Round_Robin_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Round_Robin_tb is
--  Port ( );
end Round_Robin_tb;

architecture Behavioral of Round_Robin_tb is

component Round_Robin is
  Port (clk,rst: in STD_LOGIC;
        ReqA, ReqB, ReqC: in STD_LOGIC;
        Data: in STD_LOGIC_VECTOR(7 downto 0);
        Address: in STD_LOGIC_VECTOR(11 downto 0);
        AckA, AckB, AckC: out STD_LOGIC;
        EnA1,EnA2,EnB1,EnB2,EnC1,EnC2: out STD_LOGIC);
end component;

signal clk_int, rst_int, ReqA_int, ReqB_int, ReqC_int, AckA_int, AckB_int, AckC_int, EnA1_int, EnA2_int, EnB1_int, EnB2_int, EnC1_int, EnC2_int, times_int, counter_int: STD_LOGIC;
signal Data_int: STD_LOGIC_VECTOR(7 downto 0);
signal Address_int: STD_LOGIC_VECTOR(11 downto 0);
--signal times_int: INTEGER;
constant cp: time:= 1ns;

begin

uut: Round_Robin port map(clk=>clk_int, rst=>rst_int, ReqA=>ReqA_int, ReqB=>ReqB_int, ReqC=>ReqC_int, Data=>Data_int, Address=>Address_int, AckA=>AckA_int, AckB=>AckB_int, AckC=>AckC_int, EnA1=>EnA1_int, EnA2=>EnA2_int, EnB1=>EnB1_int, EnB2=>EnB2_int, EnC1=>EnC1_int, EnC2=>EnC2_int);--, counter_rst => counter_int); --times_up=> times_int, counter_rst => counter_int);

--clock
process
begin
clk_int <= '0';
wait for cp/2;
clk_int <= '1';
wait for cp/2;
end process;

--reset
process
begin
rst_int <= '1';
wait for cp;
rst_int <= '0';
wait;
end process;

process
begin
ReqA_int <= '0';
ReqB_int <= '0';
ReqC_int <= '0';
wait for cp;
ReqA_int <= '1';
wait for 64*cp;
ReqA_int <= '0';
ReqB_int <= '1';
wait for 60*cp;
ReqB_int <= '0';
ReqC_int <= '1';
wait for 60*cp;
ReqC_int <= '0';
wait for 60*cp;
ReqA_int <= '1';
ReqB_int <= '1';
ReqC_int <= '1';
wait for 200*cp;
ReqA_int <= '1';
wait for 64*cp;
ReqA_int <= '0';
wait for 64*cp;
ReqB_int <= '1';
wait for 64*cp;
ReqB_int <= '0';
wait for 23*cp;
ReqA_int <= '1';
wait for 23*cp;
ReqC_int <= '0'; 
wait for 110*cp;
ReqA_int <= '0';
wait for 67*cp;
ReqC_int <= '1';
wait for 20*cp;
ReqA_int <= '1';
wait for 120*cp;
ReqC_int <= '0';
wait for 70*cp;
ReqA_int <= '0';
wait for cp;
ReqB_int <= '1';
wait for 20*cp;
ReqC_int <= '1';
wait for 85*cp;
    wait;

end process;


end Behavioral;




----A enable
--process
--begin
--WeA_int <= '1';
--wait for 3*cp;
--WeA_int <= '0';
--wait for 2*cp;
--wait;
--end process;

----B enable
--process
--begin
--WeB_int <= '0';
--wait for 11*cp;
--WeB_int <= '1';
--wait for 1*cp;
--WeB_int <= '0';
--wait;
--end process;

----C enable
--process
--begin
--WeC_int <= '0';
--wait for 18*cp;
--WeC_int <= '1';
--wait for 2*cp;
--WeC_int <= '0';
--wait;
--end process;

