Library IEEE;
Use IEEE.std_logic_1164.all;



Entity Debouncing2 is
	port( Din,CK:in std_logic ;
			Dout:out std_logic);
End Debouncing2;

Architecture ARCH of Debouncing2 is
Begin	
	Process(CK)
		Variable TMP:integer range 0 to 9;
	Begin	
		if Rising_Edge(CK) Then 
			if Din ='1' Then
				TMP := 0;
				Dout <= '1';
			Else
				TMP := TMP + 1;
				If TMP = 4 Then
					TMP := 0;
					Dout <= '0';
				End if;
			End if;
		End if;
	End Process;
End ARCH;
