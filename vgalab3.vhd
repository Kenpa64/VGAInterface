library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_control is
port(
	mode:	in std_logic;
	clk:	in std_logic;
	reset:	in std_logic;
	vsync:	out std_logic;
	hsync:	out std_logic;
	red:	out std_logic_vector(3 downto 0);
	green:	out std_logic_vector(3 downto 0);
	blue:	out std_logic_vector(3 downto 0)
);
end vga_control;

architecture arch of vga_control is
	constant PPL: integer:= 1280;	-- pixels per line
	constant HFP: integer:= 48;		-- hsync front porch
	constant HBP: integer:= 248;	-- hsync back porch
	constant HRE: integer:= 112;	-- hsync retrace
	constant LIN: integer:= 1024;	-- vertical lines
	constant VFP: integer:= 1;		-- vsync front porch
	constant VBP: integer:= 38;		-- vsync vakc porch
	constant VRE: integer:= 3;		-- vsync retrace

	-- counter variables
	signal count_1688, count_1688_next: unsigned(10 downto 0);
	signal count_1066, count_1066_next: unsigned(10 downto 0);

	-- control variables
	signal h_end, v_end: std_logic;

	begin

	h_end <= '1' when count_1688 = (PPL + HFP + HBP + HRE - 1) else '0';
	v_end <= '1' when count_1066 = (LIN + VFP + VBP + VRE - 1) else '0';

	process (clk, reset)
		begin
		if (reset = '1' and clk'event and clk = '1') then	
			-- Reset signals
			count_1688 <= (others => 0);
			count_1066 <= (others => 0);
			h_end <= '0';
			v_end <= '0';

		elsif (clk'event and clk = '1') then
			count_1688 <= count_1688_next;
				if (h_end = '1') then
					count_1066 <= count_1066_next;
				end if;
		end if;
	end process;

	-- 1688 counter, clock times for horizontal pixels
	counter1688: process (clk, h_end, count_1688)
		begin
		if (clk'event and clk = '1') then
			if (h_end = '1') then
				count_1688_next <= (others => 0);
			else
				count_1688_next <= count_1688 + 1;
			end if;
		else
			count_1688_next <= count_1688; -- Lo podemos quitar
		end if;
	end process;


	counter1066: process (clk, h_end, v_end, count_1066)
		begin
		if (clk'event and clk = '1' and h_end = '1') then
			if (v_end = '1') then
				count_1066_next <= (others => 0);
			else
				count_1066_next <= count_1066 + 1;
			end if;
		else
			count_1066_next <= count_1066; -- Lo podemos quitar
		end if;
	end process;

	signalgen: process (clk, mode, count_1688, count_1066)
		begin
			if (mode = '0') then
		end if;		

end arch;