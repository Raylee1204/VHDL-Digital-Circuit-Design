Library IEEE;
Use IEEE.std_logic_1164.all;



Entity Mealy_Ex is
	port( Input,CK:in std_logic ;
			PState:out integer range 0 to 9;
			Output:out std_logic);
End Mealy_Ex;

Architecture FSM of Mealy_Ex is
	Type states is (s0, s1, s2, s3);
	signal PS: states := s0;
Begin	
	Process(CK)
		Variable NS: states := s0;
	Begin	
		if Rising_Edge(CK) Then 
			case PS is
				when s0 =>
					if Input ='1' Then
						NS := s1;
						PState <= 1;
						Output <= '0';
					Else
						NS := s3;
						PState <= 3;
						Output <= '0';
					End if;
				when s1 =>
					if Input ='1' Then
						NS := s2;
						PState <= 2;
						Output <= '1';
					Else
						NS := s1;
						PState <= 1;
						Output <= '0';
					End if;
				when s2 =>
					if Input ='1' Then
						NS := s3;
						PState <= 3;
						Output <= '0';
					Else
						NS := s1;
						PState <= 1;
						Output <= '0';
					End if;
				when s3 =>
					if Input ='1' Then
						NS := s0;
						PState <= 0;
						Output <= '1';
					Else
						NS := s1;
						PState <= 3;
						Output <= '0';
					End if;
				when others => null;
			End Case;
		End if;
		PS <= NS;
	End process;
End FSM;
