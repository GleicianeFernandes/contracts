#!/usr/bin/python3

from brownie import *
import brownie 
import random

def getLinearTable(TT):
    linearTable=[]
    for row in TT:
        linearTable.extend(row)
    return linearTable

def function_and(a,b):
    return a and b

def function_or(a,b):
    return a or b

def function_greater(a,b):
    return (a==1) and (b==0)

def shuffle(T):
    rows_position = [0,1,2,3]
    random.shuffle(rows_position)
    shuffleT =[]
    for position in rows_position:
        shuffleT.append([_ for _ in T[position]])
    return (shuffleT,rows_position)

def inversion(T,column):
    inversion_bit = bool(random.getrandbits(1))
    for row in T:
        row[column] = row[column]^inversion_bit
    return inversion_bit

def getChoice():
    choice = bool(random.getrandbits(1))
    return choice

def randomPermutation(TT):
    (TT_permuted, rows_position) = shuffle(TT)
    return TT_permuted

def inversionOfColumns(TT, firstColumn, secondColumn):
    firstInversionBit = inversion(TT, firstColumn)
    secondInversionBit = inversion(TT, secondColumn)
    return (firstInversionBit, secondInversionBit, TT)

def getRows(TT, inversionBit, choice):
    rows = [0,0]
    index = 0

    for i in range(len(TT)):
        if (TT[i][1]^inversionBit) == choice: 
            rows[index] = i 
            index = index + 1

    return rows

def showTruthTable(TT):
    for row in TT: print(row)

def main(): 
    TruthTable = [  [False,False,False],
                    [False,True,False],
                    [True,False,False],
                    [True,True,False]
    ]

    # Initial truth table
    print('>>>INITIAL TRUTH TABLE<<<')
    showTruthTable(TruthTable)

    # Choose function
    function = function_and

    # Entity A
    ## 1.1: Random permutation (A)
    TT_A = randomPermutation(TruthTable)

    ## 1.2: Inversion of columns 
    (b1_A, b3_A, TT_A) = inversionOfColumns(TT_A, 0, 2)
    print('\n\n>>>FINAL TT_A<<<')
    showTruthTable(TT_A)

    print('\n\n>>>SEND TT_A TO SMART CONTRACT<<<')
    smartContract = SMC.deploy(getLinearTable(TruthTable), getLinearTable(TT_A), {'from': accounts[0]})

    # Entity B
    TT_A_from_SMC = smartContract.getTTA.call({'from': accounts[1]})

    ## 4.1: Random permutation (B)
    TT_B = randomPermutation(TT_A_from_SMC)

    ## 4.2: Inversion of columns
    (b2_B, b3_B, TT_B) = inversionOfColumns(TT_B, 1, 2)
    print('\n\n>>>FINAL TT_B<<<')
    showTruthTable(TT_B)

    print('\n\n>>>SEND TT_B TO SMART CONTRACT<<<')
    smartContract.receiveTableFromB(TT_B, {'from': accounts[1]})

    # Choose  and send lines to smart contract
    read_TTA = smartContract.getTTB.call({'from': accounts[0]})
    read_TTB = TT_B
    A_choice = getChoice()
    B_choice = getChoice()

    A_rows = getRows(read_TTA, b1_A, A_choice)
    B_rows = getRows(read_TTB, b2_B, B_choice)

    print('\n\n>>>SEND LINES TO SMART CONTRACT<<<')
    smartContract.receiveLinesFromA(A_rows[0], A_rows[1], {'from': accounts[0]})
    smartContract.receiveLinesFromB(B_rows[0], B_rows[1], {'from': accounts[1]})

    # Send inversions to smart contract
    print('\n\n>>>SEND INVERSION TO SMART CONTRACT<<<')
    smartContract.receiveInversionFromA(b3_A, {'from': accounts[0]})
    smartContract.receiveInversionFromB(b3_B, {'from': accounts[1]})

    # Evaluate
    A_result = smartContract.getValue.call({'from': accounts[0]})
    B_result = smartContract.getValue.call({'from': accounts[1]})
    print('>>>>>>FINAL RESULT: {result} <<<<<<'.format(result = A_result == function(A_choice, B_choice)))