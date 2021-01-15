----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2019 05:45:42 PM
-- Design Name: 
-- Module Name: Round_Robin - Behavioral
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

entity Round_Robin is
  Port (clk,rst: in STD_LOGIC;
        ReqA, ReqB, ReqC: in STD_LOGIC;
        Data: in STD_LOGIC_VECTOR(7 downto 0);
        Address: in STD_LOGIC_VECTOR(11 downto 0);
        AckA, AckB, AckC: out STD_LOGIC;
        EnA1,EnA2,EnB1,EnB2,EnC1,EnC2: out STD_LOGIC);
--        triA1, triA2, triB1, triB2, triC1, triC2: out STD_LOGIC);

end Round_Robin;

architecture Behavioral of Round_Robin is

component counter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           count_rst: in STD_LOGIC;
           count_int: out INTEGER;
           count : out STD_LOGIC);
end component;

type StateType is(Idle, Grant_A, Grant_B, Grant_C);
signal CurrentState, NextState: StateType;
signal times_up: STD_LOGIC:='0';
signal times: INTEGER;--:=0;
signal counter_rst: STD_LOGIC:='0';

begin

count_a: counter port map(clk=>clk, rst=>rst, count_int=>times, count=>times_up, count_rst => counter_rst);


-- Counter Reset
          process(clk)
              begin
                if(rst = '1') then
                    counter_rst <= '0';
                elsif(rising_edge(clk)) then
                   if(CurrentState/=NextState) then
                   -- When we change states we reset our counter
                      counter_rst <= '1';
                   else
                      counter_rst <= '0';
                   end if;
                end if;
          end process;
          
          
--process (clk,times_up)
--    begin
--       if (rst='1') then
--           times <= 0;
--           times_up <= '0';
--       elsif (rising_edge(clk)) then
----            if(count_rst = '1') then
----                temp_int <= 0;
----            else
--                if(times = 63) then
--                    times <= 0;
--                    times_up <= '1';
--                else
--                    times <= times + 1;
--                    times_up <= '0';
----                end if;
--            end if;
--       end if;
--end process;
          
          
--next state logic
process(clk,rst,times_up,CurrentState,NextState)--,CurrentState,ReqA,ReqB,ReqC,times_up)
    begin
    if(rst = '1') then
--        counter_rst <= '0';
        NextState <= Idle;   
    elsif(rising_edge(clk)) then
--                   if(CurrentState/=NextState) then
--                   -- When we change states we reset our counter
--                      counter_rst <= '1';
--                      NextState <= NextState;
--                   else
--                      counter_rst <= '0';
----                      CurrentState <= NextState;
--                   end if;
        case CurrentState is
    -- State Idle
            when Idle =>
                if(ReqA='1') then
                    NextState <= Grant_A;     
                elsif(ReqA='0' and ReqB='1') then
                    NextState <= Grant_B; 
                elsif(ReqA='0' and ReqB='0' and ReqC='1') then
                    NextState <= Grant_C;
                else
                    NextState <= Idle; 
                end if;
    -- State Grant_A
             when Grant_A =>
                if(times_up = '0') then 
                -- before the 64 clock cycles are over
                    if(ReqA = '0') then 
                    -- when ReqA turns off before the 64 clock cycles are over
                        if(ReqB='1') then
                            NextState <= Grant_B; 
                        elsif(ReqB='0' and ReqC='1') then--(ReqC='1') then
                            NextState <= Grant_C; 
                        else
                            NextState <= Idle; 
                        end if;
                    end if;
                else  -- when we reached the 64 clock cycles
                    if(ReqA='1' and ReqB='0' and ReqC='0') then
                        NextState <= Grant_A; 
                    elsif(ReqB='1') then
                        NextState <= Grant_B; 
                    elsif(ReqB='0' and ReqC='1') then 
                        NextState <= Grant_C; 
                    else
                        NextState <= Idle;
                    end if;
                end if;
    -- State Grant_B
             when Grant_B =>
                if(times_up = '0') then
                    if(ReqB = '0') then
                        if(ReqA='1') then
                            NextState <= Grant_A; 
                        elsif(ReqA='0' and ReqC='1') then
                            NextState <= Grant_C; 
                        else
                            NextState <= Idle; 
                        end if;
                    end if;
                else
                    if(ReqA='1' and(ReqB='0' or ReqC='0')) then --and (ReqB='1' nand ReqC='1')) then
                        NextState <= Grant_A; 
                    elsif(ReqA='0' and ReqB='1' and ReqC='0') then
                        NextState <= Grant_B; 
                    elsif((ReqA='0' and ReqC='1') or (ReqB='1' and ReqC='1')) then --(ReqA='1' and ReqB='1' and ReqC='1')) then 
                        NextState <= Grant_C; 
                    else
                        NextState <= Idle;
                    end if;
                end if;
    -- State Grant_C
             when Grant_C =>
                if(times_up = '0') then
--                if(ReqA='1' and ReqC='1') then
--                            NextState <= Grant_A; 
--                            end if;
                    if(ReqC = '0') then
                        if(ReqA='1') then
                            NextState <= Grant_A; 
                        elsif(ReqA = '0' and ReqB='1') then
                            NextState <= Grant_B; 
                        else
                            NextState <= Idle; 
                        end if;
                    end if;
                else
                    if(ReqA='1') then
                        NextState <= Grant_A; 
                    elsif(ReqA='0' and ReqB='1') then
                        NextState <= Grant_B; 
                    elsif(ReqA='0' and ReqB='0' and ReqC='1') then 
                        NextState <= Grant_C; 
                    else
                        NextState <= Idle;
                    end if;
                end if;
            end case;
            end if;
          end process;
          
          
-- Current State Logic
          process(clk,rst,NextState)
            begin
                if(rst='1') then
                    CurrentState <= Idle;
                elsif(rising_edge(clk)) then
                    CurrentState <= NextState;
                end if;
          end process;
          
          
--output logic
       with CurrentState select
           AckA <= '1' when Grant_A,
                   '0' when others;
       with CurrentState select
           EnA1 <= '1' when Grant_A,
                   '0' when others;
       with CurrentState select
           EnA2 <= '1' when Grant_A,
                   '0' when others;
       with CurrentState select       
           AckB <= '1' when Grant_B,
                   '0' when others;
       with CurrentState select
           EnB1 <= '1' when Grant_B,
                   '0' when others;
       with CurrentState select
           EnB2 <= '1' when Grant_B,
                   '0' when others;
       with CurrentState select
           AckC <= '1' when Grant_C,
                   '0' when others;
       with CurrentState select
           EnC1 <= '1' when Grant_C,
                   '0' when others;
       with CurrentState select
           EnC2 <= '1' when Grant_C,
                   '0' when others;
                   
                   
-- tri-state buffers


                
end Behavioral;


















----next state logic
--process(CurrentState,WeA,WeB,WeC,times_up)--,CurrentState,times_up)
--    begin
--        case CurrentState is
--    -- State Idle
--            when Idle =>
--                if(WeA='1') then
--                    NextState <= Grant_A;
--                elsif(WeA='0' and WeB='1') then
--                    NextState <= Grant_B;
--                elsif(WeA='0' and WeB='0' and WeC='1') then
--                    NextState <= Grant_C;
--                else
--                    NextState <= Idle;
--                end if;
--    -- State Grant_A
--             when Grant_A =>
--                if(WeA='1') then
--                    NextState <= Grant_A;
--                elsif(WeA='0' and WeB='1') then
--                    NextState <= Grant_B;
--                elsif(WeA='0' and WeB='0' and WeC='1') then
--                    NextState <= Grant_C;
--                else
--                    NextState <= Idle;
--                end if;
--    -- State Grant_B
--             when Grant_B =>
--                if(WeA='1') then
--                    NextState <= Grant_A;
--                elsif(WeA='0' and WeB='1') then
--                    NextState <= Grant_B;
--                elsif(WeA='0' and WeB='0' and WeC='1') then
--                    NextState <= Grant_C;
--                else
--                    NextState <= Idle;
--                end if;
--    -- State Grant_C
--             when Grant_C =>
--                if(WeA='1') then
--                    NextState <= Grant_A;
--                elsif(WeA='0' and WeB='1') then
--                    NextState <= Grant_B;
--                elsif(WeA='0' and WeB='0' and WeC='1') then
--                    NextState <= Grant_C;
--                else
--                    NextState <= Idle;
--                end if;
--             end case;
--          end process;
          
---- Current State Logic
--          process(clk,rst,NextState,times_up)
--            begin
--                if(rst='1') then
--                    CurrentState <= Idle;
--                elsif(rising_edge(clk)) then
--                    if(times_up = '0') then
--                    CurrentState <= NextState;
--                    end if;
--                end if;
--          end process;
          
----output logic
--       with CurrentState select
--           AckA <= '1' when Grant_A,
--                   '0' when others;
--       with CurrentState select       
--           AckB <= '1' when Grant_B,
--                   '0' when others;
--       with CurrentState select
--           AckC <= '1' when Grant_C,
--                   '0' when others;

                
--end Behavioral;













----next state and output logic
--process(CurrentState,WeA,WeB,WeC)
--    begin
--        case CurrentState is
--    -- State Idle
--            when Idle =>
--                    AckA <= '0';
--                    AckB <= '0';
--                    AckC <= '0';
--                if(WeA='1') then
--                    NextState <= Grant_A;
--                elsif(WeA='0' and WeB='1') then
--                    NextState <= Grant_B;
--                elsif(WeA='0' and WeB='0' and WeC='1') then
--                    NextState <= Grant_C;
--                else
--                    NextState <= Idle; 
--                end if;
--    -- State Grant_A
--             when Grant_A =>
--                    AckA <= '1';
--                    AckB <= '0';
--                    AckC <= '0';
--                if(WeA='1') then
--                    NextState <= Grant_A;
--                elsif(WeA='0' and WeB='1') then
--                    NextState <= Grant_B;
--                elsif(WeA='0' and WeB='0' and WeC='1') then
--                    NextState <= Grant_C;
--                else
--                    NextState <= Idle;
--                end if;
--    -- State Grant_B
--             when Grant_B =>
--                    AckA <= '0';
--                    AckB <= '1';
--                    AckC <= '0';
--                if(WeA='1') then
--                    NextState <= Grant_A;
--                elsif(WeA='0' and WeB='1') then
--                    NextState <= Grant_B;
--                elsif(WeA='0' and WeB='0' and WeC='1') then
--                    NextState <= Grant_C;
--                else
--                    NextState <= Idle;
--                end if;
--    -- State Grant_C
--             when Grant_C =>
--                    AckA <= '0';
--                    AckB <= '0';
--                    AckC <= '1';
--                if(WeA='1') then
--                    NextState <= Grant_A;
--                elsif(WeA='0' and WeB='1') then
--                    NextState <= Grant_B;
--                elsif(WeA='0' and WeB='0' and WeC='1') then
--                    NextState <= Grant_C;
--                else
--                    NextState <= Idle;
--                end if;
--             end case;
--          end process;
          
---- Current State Logic
--          process(clk,rst,NextState)
--            begin
--                if(rst='1') then
--                    CurrentState <= Idle;
--                elsif(rising_edge(clk)) then
--                    CurrentState <= NextState;
--                end if;
--          end process;
          
                
--end Behavioral;