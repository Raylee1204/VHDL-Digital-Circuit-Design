Library IEEE;
Use IEEE.std_logic_1164.all;

Entity Decoder3_8 is
    port(
        EN: in std_logic;
        A: in std_logic_vector(2 downto 0);
        Y: out std_logic_vector(7 downto 0));
End Decoder3_8;

Architecture ARCH of Decoder3_8 is
    Signal TMP: std_logic_vector(3 downto 0);
Begin
    TMP <= EN & A;
    with TMP Select
    Y <= "10000000" when "1111",
			"01000000" when "1110",
			"00100000" when "1101",
			"00010000" when "1100",
			"00001000" when "1011",
			"00000100" when "1010",
			"00000010" when "1001",
			"00000001" when "1000",
			"00000000" when others;
End ARCH;
