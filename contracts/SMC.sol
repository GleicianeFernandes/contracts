// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

contract SMC {
    enum StatesSMC { State1 }

    bool[3][4] public TruthTable;
    bool[3][4] public TruthTableA;
    bool[3][4] public TruthTableB;
    uint public LA1;
    uint public LA2;
    uint public LB1;
    uint public LB2;
    bool public invA;
    bool public invB;
    uint256 public storedData;
    mapping(address => uint256) public balances;

    StatesSMC public myState;

    constructor(bool[12] memory _tt, bool[12] memory _tta) {
        for (uint i = 0; i < 4; i++) {
            for (uint j = 0; j < 3; j++) {
                TruthTable[i][j] = _tt[i * 3 + j];
                TruthTableA[i][j] = _tta[i * 3 + j];
            }
        }
    }

    function receiveTableFromB(bool[3][4] memory _tt) public {
        for (uint i = 0; i < 4; i++) {
            for (uint j = 0; j < 3; j++) {
                TruthTableB[i][j] = _tt[i][j];
            }
        }
    }

    function receiveLinesFromA(uint l1, uint l2) public {
        LA1 = l1;
        LA2 = l2;
    }

    function receiveLinesFromB(uint l1, uint l2) public {
        LB1 = l1;
        LB2 = l2;
    }

    function receiveInversionFromA(bool inv) public {
        invA = inv;
    }

    function receiveInversionFromB(bool inv) public {
        invB = inv;
    }

    function getLine() public view returns (uint) {
        uint linha;
        if ((LA1 == LB1) || (LA1 == LB2)) {
            linha = LA1;
        }
        if ((LA2 == LB1) || (LA2 == LB2)) {
            linha = LA2;
        }
        return linha;
    }

    function getValue() public view returns (bool) {
        uint linha;
        if ((LA1 == LB1) || (LA1 == LB2)) {
            linha = LA1;
        }
        if ((LA2 == LB1) || (LA2 == LB2)) {
            linha = LA2;
        }
        bool r = TruthTableB[linha][2];
        return (r != invA) != invB;
    }
}
