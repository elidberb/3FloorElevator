

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Motor is
    Port ( 
           clk  : in std_logic;           
           Pin1 : out STD_LOGIC;
           Pin2 : out STD_LOGIC;
           Pin3 : out STD_LOGIC;
           Pin4 : out STD_LOGIC;         
           M : in STD_logic_vector(1 downto 0) := "00";
           o_clk : out std_logic
           ); 
end Motor;

architecture Behavioral of Motor is
    type state_type is (A,AB,B,BC,C,CD,D,AD,off); 
    signal state : state_type ;
    signal reset : std_logic;
    signal nclk  : std_logic;
    component CDiv IS
	   PORT ( Cin	: IN 	STD_LOGIC ;
	           Cout : OUT STD_LOGIC ) ;
       END component ;
begin
    clk1 : CDiv port map(cin => clk, cout => nclk);
    
    process(nclk)
    begin
        if rising_edge(nclk) then
             if (reset ='1') then
                state <= AB;      
             else             
             state <= AD;             
                case state is
                    when AB =>
                        Pin1 <= '1';
                        Pin2 <= '1';
                        Pin3 <= '0';
                        Pin4 <= '0';
                        if (M = "01") then
                            state <= BC;
                        elsif (M = "10") then
                            state <= AD;
                        end if;
                     when BC =>
                        Pin1 <= '0';
                        Pin2 <= '1';
                        Pin3 <= '1';
                        Pin4 <= '0';
                        if (M = "01") then
                            state <= CD;
                        elsif (M = "10") then
                            state <= AB;
                        end if;
                     when CD =>
                        Pin1 <= '0';
                        Pin2 <= '0';
                        Pin3 <= '1';
                        Pin4 <= '1';
                        if (M = "01") then
                            state <= AD;
                        elsif (M = "10") then
                            state <= BC;
                        end if;
                     when AD =>
                        Pin1 <= '1';
                        Pin2 <= '0';
                        Pin3 <= '0';
                        Pin4 <= '1';
                        if (M = "01") then
                            state <= AB;
                        elsif (M = "10") then
                            state <= CD;
                        end if;
                     when off =>
                     when others =>
                        Pin1 <= '0';
                        Pin2 <= '0';
                        Pin3 <= '0';
                        Pin4 <= '0';
                end case;
                end if;
        end if;
    end process;
    
    o_clk <= nclk;
end Behavioral;
