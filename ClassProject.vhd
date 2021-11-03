library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;


entity ClassProject is
    Port ( clk : in STD_LOGIC;
           btn1 : in STD_LOGIC;
           btn2 : in STD_LOGIC;
           btn3 : in STD_LOGIC;
           LS : in STD_LOGIC;
           RWE : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR(7 DOWNTO 0);--Data on switches
           LED : out std_logic_vector(6 downto 0);
           an : out std_logic_vector(3 downto 0)          
           );
end ClassProject;

architecture Behavioral of ClassProject is
    type state_type is (F1,F2,F3,MR1,MR2,MF2,MF3); 
    signal state : state_type ;
    
    component Project is
    Port ( clock : in STD_LOGIC;
           kkey : in STD_LOGIC;
           ppulse : out STD_LOGIC);
    end component;
    
    --List of signals
    signal press1 : std_logic;
    signal press2 : std_logic;
    signal press3 : std_logic;
    signal reset : std_logic;
    signal LED_out: std_logic_vector(3 downto 0) := "0000";
    signal refresh: std_logic_vector(19 downto 0);
    signal led_act: std_logic_vector(1 downto 0) := "00";
    signal F: std_logic_vector(3 downto 0) := "0000";
    signal FPH: std_logic_vector(3 downto 0) := "0000";
    signal m : std_logic_vector(1 downto 0) := "00";
    signal mp : std_logic_vector(1 downto 0) := "00";
    
    begin
    pulse1: Project port map(clock => clk, kkey => btn1, ppulse => press1);
    pulse2: Project port map(clock => clk, kkey => btn2, ppulse => press2);
    pulse3: Project port map(clock => clk, kkey => btn3, ppulse => press3);

    
    process(clk)
    begin
    if(rising_edge(clk)) then
        refresh <= refresh + 1;
    end if;
    
    end process;
    
    process(led_out)
        begin
    case LED_OUT is
        when "0000" => LED <= "0000001";--"0"
        when "0001" => LED <= "1001111";--"1"
        when "0010" => LED <= "0010010";--"2"
        when "0011" => LED <= "0000110";--"3"
        when "0100" => LED <= "1001100";--"4"
        when "0101" => LED <= "0100100";--"5"
        when "0110" => LED <= "0100000";--"6"
        when "0111" => LED <= "0001111";--"7"
        when "1000" => LED <= "0000000";--"8"
        when "1001" => LED <= "0000100";--"9"
        when "1010" => LED <= "0000010";--"A"
        when "1011" => LED <= "1100000";--"B"
        when "1100" => LED <= "0110001";--"C"
        when "1101" => LED <= "1000010";--"D"
        when "1110" => LED <= "0110000";--"E"
        when "1111" => LED <= "0111000";--"F"
    end case;
    end process;
    
    LED_act <= refresh(19 downto 18);
    process(LED_ACT)
    begin
        case LED_ACT is
            when "00" =>
                an <= "1110"; 
                    LED_out <= F(3 downto 0);
                    
            when "01" =>
                --Always F for floor
                an <= "1101";
                LED_out <= "1111";
                
            when "10" =>
                an <= "0111";
                if(m = "00") then
                    LED_out <= "0101"; --Prints 5 but looks like an S (stationary)
                elsif(m = "01") then
                    LED_out <= "0001";
                elsif(m = "10") then
                    LED_out <= "0010";
                end if;
                 
            when others =>
                an <= "1111";  
        end case;
    end process;
    
    process (clk)
begin
if rising_edge(clk) then
    if (reset ='1') then
        state <= F1;         
        else
            case state is
            when F1 =>
                F <= "0001";
                M <= "00";         
                if(btn2 = '1') then
                    state <= MF2;
                elsif(btn3 = '1') then
                    state <= MF3;
                end if;           
            when F2 =>
                F <= "0010";
                M <= "00"; 
                if(btn1 = '1') then
                    state <= MR1;
                    
                elsif(btn3 = '1') then
                    state <= MF3;
                end if;
            when F3 =>
                F <= "0011";
                M <= "00"; 
                if(btn1 = '1') then
                    state <= MR1;
                elsif(btn2 = '1') then
                    state <= MR2;
                end if;
            when MF2 =>
                M <= "01";
                if(LS = '1') then
                    state <= F2;
                end if; 
            when MF3 =>
                M <= "01";
                if(LS = '1') then
                    state <= F3;
                end if; 
            when MR1 =>
                M <= "10";
                if(LS = '1') then
                    state <= F1;
                end if; 
            when MR2 =>
                M <= "10";
                if(LS = '1') then
                    state <= F2;
                end if; 
            end case;
            end if;
        end if;
    end process;
end Behavioral;
