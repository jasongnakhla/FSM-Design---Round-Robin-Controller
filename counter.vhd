----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2019 07:36:10 PM
-- Design Name: 
-- Module Name: counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           count_rst: in STD_LOGIC;
           count_int: out INTEGER:=0;
           count : out STD_LOGIC);
end counter;

architecture Behavioral of counter is
signal temp_int: INTEGER;--:=0; 
signal temp: STD_LOGIC:='0';
begin
process (clk,temp)
    begin
       if (rst='1') then
           temp_int <= 0;
           temp <= '0';
       elsif (rising_edge(clk)) then
--            if(count_rst = '1') then
--                temp_int <= 0;
--            else
                if(temp_int = 60) then
                    temp_int <= 0;
                    temp <= '1';
                elsif(count_rst = '1') then
                    temp_int <= 0;
                else
                    temp_int <= temp_int + 1;
                    temp <= '0';
                end if;
            end if;
--       end if;
end process;
count_int <= temp_int;
count <= temp;

end Behavioral;


















--           temp <= temp + 1;
--           if (A='1') then
--               if (temp /= 63) then
--                temp <= temp + 1;
--               end if;
--           elsif (A='0' and B='1') then
--               if (temp /= 63) then
--                temp <= temp + 1;
--               end if;
--           elsif (A='0' and B='0' and C='1') then
--               if (temp /= 63) then
--                temp <= temp + 1;
--               end if;
--           end if;