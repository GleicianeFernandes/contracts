pragma solidity >=0.4.25 <0.6.0;

contract SMC {
  enum StatesSMC { State1}

  bool[3][4] TruthTable;
  bool[3][4] TruthTableA;
  bool[3][4] TruthTableB;
  uint LA1;
  uint LA2;
  uint LB1;
  uint LB2;
  bool invA;
  bool invB;

  StatesSMC myState;
    
  

  constructor(bool[12] memory _tt, bool[12] memory _tta) public {
    for (uint i=0;i<4;i++) {
       for (uint j=0;j<3;j++) {
	   TruthTable[i][j]  = _tt[i*3+j];
	   TruthTableA[i][j]  = _tta[i*3+j];
       }
    }  
  }


  function receiveTableFromB(bool[3][4] memory _tt) public {
   for (uint i=0;i<4;i++) {
       for (uint j=0;j<3;j++) {
	   TruthTableB[i][j]  = _tt[i][j];
       }
    }  
  }

  function receiveLinesFromA(uint l1, uint l2) public {
  	   LA1=l1;
	   LA2=l2;
  }

  function receiveLinesFromB(uint l1, uint l2) public {
  	   LB1=l1;
	   LB2=l2;
  }

  function receiveInversionFromA(bool inv) public {
  	   invA=inv;
  }

  function receiveInversionFromB(bool inv) public {
  	   invB=inv;
  }


  function getLine() public returns (uint) {
           uint linha;
	   bool r;
  	   if ((LA1==LB1) || (LA1==LB2)) {
	      linha=LA1;
	   }
	   if ((LA2==LB1) || (LA2==LB2)) {
	      linha=LA2;
	   }
	   return linha;
  }



  function getValue() public returns (bool) {
  	   uint linha;
	   bool r;
  	   if ((LA1==LB1) || (LA1==LB2)) {
	      linha=LA1;
	   }
	   if ((LA2==LB1) || (LA2==LB2)) {
	      linha=LA2;
	   }
	   r = TruthTableB[linha][2];
	   return (r != invA) != invB;
  }
  

  // gets TT uploaded by A
  function getTTA() public returns (bool[3][4] memory) {
	   return TruthTableA;
  }

  //get TT uploaded by B
  function getTTB() public returns (bool[3][4] memory) {
	   return TruthTableB;
  }

  
  
}
