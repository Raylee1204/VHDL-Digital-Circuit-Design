Library IEEE;
Use IEEE.std_logic_1164.all;



Entity Moore_Ex is
	port( Input,CK:in std_logic ;
			PState:out integer range 0 to 9;
			Output:out std_logic);
End Moore_Ex;

Architecture FSM of Moore_Ex is
	Type states is (s0, s1, s2, s3);
	signal PS: states := s0;
Begin	
	Output <='1' when PS = S3 Else '0';
	Process(CK)
		Variable NS: states := s0;
	Begin	
		if Rising_Edge(CK) Then 
			case PS is
				when s0 =>
					if Input ='1' Then
						NS := s1;
						PState <= 1;
					Else
						NS := s2;
						PState <= 2;
					End if;
				when s1 =>
					if Input ='1' Then
						NS := s1;
						PState <= 1;
					Else
						NS := s2;
						PState <= 2;
					End if;
				when s2 =>
					if Input ='1' Then
						NS := s3;
						PState <= 3;
					Else
						NS := s0;
						PState <= 0;
					End if;
				when s3 =>
					if Input ='1' Then
						NS := s0;
						PState <= 0;
					Else
						NS := s3;
						PState <= 3;
					End if;
				when others => null;
			End Case;
		End if;
		PS <= NS;
	End process;
End FSM;
