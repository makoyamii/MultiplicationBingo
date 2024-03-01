.include "printArr.asm"
.include "checkArr.asm" 
.include "checkWin.asm"

.data
  	#### array/table############################################
  	array: .word 1, 2, 3, 4, 5, 6
         		.word 7, 8, 9, 10, 12, 14
         		.word 15, 16, 18, 20, 21, 24
         		.word 25, 27, 28, 30, 32, 35
         		.word 36, 40, 42, 45, 48, 49
         		.word 54, 56, 63, 64, 72, 81
  	rows: .word 6
  	columns: .word 6
   columnSeparator: .asciiz "| "
   rowSeparator: .asciiz " ----   ----   ----   ----   ----   ----"
   space: .asciiz " "
   newline: .asciiz "\n"
   ############################################################
   counter:  .word 0
   numOne:  .word 0
   numTwo:  .word 0
   userCount: .word 0
   cpuCount:  .word 0
   product: .word 0
   bool: .word 1 
   ###########################################################
    instructions: .asciiz "\n-----GAME START-----\nThis game tests your knowledge on multiplication. \nYou will be given two values and your task is to manipulate them in a way that gets you a product that corresponds to a square on the board. \nYour goal is to claim 4 squares in a row to win the game. Good luck!\n"
    player: .asciiz "user"
  	prompt1:  .asciiz "The first value is "
  	prompt2:  .asciiz "\nEnter a number from 1 to 9 for the second value: "
  	prompt3:  .asciiz "User has entered an invalid number.\n"
  	prompt4:  .asciiz "\nWhich value would you like to change? "
  	prompt5:  .asciiz "Enter a number from 1 to 9: "
  	prompt6:  .asciiz "Value 1: "
  	prompt7:  .asciiz "Value 2: "
    prompt8:  .asciiz "user"
  	prompt9:  .asciiz "cpu"
    prompt10: .asciiz "The product is: "
    prompt11: .asciiz "\n-----USER TURN-----\n"
    prompt12: .asciiz "\n-----CPU TURN-----\n"
    promptUserErr: .asciiz "\nUser made an error (the value is not on the board), retrying...\n"
    promptCPUErr: .asciiz "\nCPU made an error (the value is not on the board), retrying...\n"
    promptKey: .asciiz "\n\n*Key for board: \n  - USER value: 0\n  - CPU value: -1" 
    promptWinU: .asciiz "\n    THE USER HAS WON    \n"
    promptWinCPU: .asciiz "\n    THE CPU HAS WON    \n"
    
.text
.globl main
main:
        # Display instructions turn
        li $v0, 4
        la $a0, instructions
        syscall
        
        # Display the prompt for the first value
        li $v0, 4
        la $a0, prompt1
        syscall
  getRand:
        # get a random number
        addi  $a0, $a0, 1  #starting value 
        li  $a1, 10        #ending value
        li  $v0, 42        # get rand value in the range
        syscall
        beqz  $a0, getRand # 0 is not a valid number
        li $v0, 1          #print the number (chosen by random)
        syscall
        move $s4, $a0 # S4 IS THE RAND FIRST VALUE
        
        jal printArr #call the print array function
        # Display player turn
        li $v0, 4
        la $a0, prompt11
        syscall
gameStart: # user turn
        #Display the prompt for the second value (maybe use a function because it will need to be
        #looped while the given value is an invalid input)
        li   $v0, 4
        la   $a0, prompt2
        syscall
      
        #Look for user response for the second value
        li   $v0, 5
        syscall
        move   $s5, $v0
      
        #check if s5 is in correct range
        sle    $t7, $s5, $zero    #if <0, invalid
        sgeu   $t8, $s5, 10       #if >= 10, invalid
        seq    $t9  $t7, $t8
        bnez   $t9, notInvalid    # if $t7=1 or $t8=1, invalid
      
        # print and loop again if invalid
        li   $v0, 4
        la   $a0, prompt3
        syscall
        j   gameStart
        
  notInvalid: #continue if not invalid
  
        #print both values to show what the user has chosen
            # print the first and second value
            li   $v0, 4
            la   $a0, prompt6
            syscall
            li   $v0, 1       #System call code for printing an integer
            move   $a0, $s4   # first value
            syscall
            
            li $v0, 4
            la $a0, newline #new line to separate value 1 and 2
            syscall
            
            li   $v0, 4
            la   $a0, prompt7
            syscall
            li   $v0, 1       #System call code for printing an integer
            move   $a0, $s5   #second value
            syscall
        #multiply the two values
        mul $s0, $s4, $s5, #s0 = s4 * s5

        #display the product
          li $v0, 4
          la $a0, newline #new line
          syscall

          #store the results in $t0
          move $t0, $s0

          #display message
          li $v0, 4 
          la $a0, prompt10
          syscall

          #print
          li $v0, 1
          move $a0, $t0
          syscall
        
        
        #check if in the board 
        move $a1, $s0
        jal checkArr
        
        # NOT IN ARRAY
        # if $t9 (in array) is not 1 (true), loop to ask for second value again
        beq $t9, 1, inArr
        li $v0, 4
        la $a0, promptUserErr
        syscall
        j gameStart

        inArr: 
        # IN ARRAY
        li $v0, 4
        la $a0, promptKey # print the key for the array for the first time
        syscall
        
        jal printArr # print the array after the player has made their turn
        # function to check for winner (four in a row) 
        jal checkWin
        #if win 
        beq  $v0, 1, gameEndU
        #print who won, end the loop 
           

  cpuTurn:
        #then change the turn ($t8) # next player chooses the second value
        li    $t8, -1   
        # Initialize temp values
        add  $s6, $zero, $s4
        add  $s7, $zero, $s5
        add  $t0, $zero, $s0 
        
        #display cpu turn
        li $v0, 4
        la $a0, prompt12
        syscall

      # cpu chooses value; it will choose either 1 or 2 and this determines which value exactly it changes
    getRand1or2:
        li $t0, 0
        move $s6, $s4
        move $s7, $s5
        # get a random number
        addi  $a0, $a0, 1  #starting value 
        li  $a1, 3        #ending value
        li  $v0, 42        # get rand value in the range
        syscall
        beqz  $a0, getRand1or2 # 0 is not a valid number
        move $s3, $a0  #put rand val in s3
    
        beq $s3, 1, changeValOne #if the value == 1, then change the first value
        beq $s3, 2, changeValTwo #if the value == 2, then change the second value

    changeValOne: #$s4 is the first value
      #cpu will choose a random number for value one
      # get a random number
      
      addi  $a0, $a0, 1  #starting value 
      li  $a1, 10        #ending value
      li  $v0, 42        # get rand value in the range
      syscall
      beqz  $a0, changeValOne # 0 is not a valid number
      #move $s4, $a0  #put rand val in s4
      move $s6, $a0
      j cpuProduct
      
    changeValTwo: #$s5 is the second value
      #cpu will choose a random number for value two
      # get a random number

      addi  $a0, $a0, 1  #starting value 
      li  $a1, 10        #ending value
      li  $v0, 42        # get rand value in the range
      syscall
      beqz  $a0, changeValTwo # 0 is not a valid number
      #move $s2, $a0  #put rand val in s2
      move $s7, $a0
      j cpuProduct

    #once that's taken care of, find the product
    cpuProduct: 
      # print the first and second value
      li   $v0, 4
      la   $a0, prompt6
      syscall
      li   $v0, 1       #System call code for printing an integer
      move   $a0, $s6   # first value
      syscall

      li $v0, 4
      la $a0, newline #new line to separate value 1 and 2
      syscall

      li   $v0, 4
      la   $a0, prompt7
      syscall
      li   $v0, 1       #System call code for printing an integer
      move   $a0, $s7   #second value
      syscall
    
      # t0 = t1 * t2
      mul $t0, $s6, $s7

      #display the product
      li $v0, 4
      la $a0, newline #new line
      syscall

      #display message
      li $v0, 4 
      la $a0, prompt10
      syscall

      #print
      li $v0, 1
      move $a0, $t0
      syscall

    #loop through the array and see if the product is in the array and if not, choose a value again
    #subroutine in another file. returns v1 as 0 or 1 
      move $a1, $t0
      jal checkArr

      #NOT IN ARRAY
      # if $v1 (in array) is not 1 (true), loop to get value again
      beq $v1, 1, inArrCPU 

      move $t0, $s0
      li $v0, 4
      la $a0, promptCPUErr
      syscall
      j getRand1or2

      inArrCPU:
      # IN ARRAY
      li $v0, 4
      la $a0, promptKey # print the key for the array for the first time
      syscall
      # IN ARRAY
      move $s4, $s6
      move $s5, $s7
      
      jal printArr # print the array after the player has made their turn
      jal checkWin # function to check for winner (four in a row)
      beq  $v0, 1, gameEndCPU
      
  userTurn:
    # changes player to user.
      li  $t8, 0
    # Initialize temp values
      add  $s1, $zero, $s4
      add  $s2, $zero, $s5
      add  $t0, $zero, $s0
    # display the user turn
      li $v0, 4
      la $a0, prompt11
      syscall
    # print the current 2 values (s4, s2)
      li   $v0, 4
      la   $a0, prompt6
      syscall
      li   $v0, 1       #System call code for printing an integer
      move   $a0, $s4   # first value
      syscall
  
      li $v0, 4
      la $a0, newline #new line to separate value 1 and 2
      syscall
  
      li   $v0, 4
      la   $a0, prompt7
      syscall
      li   $v0, 1       #System call code for printing an integer
      move   $a0, $s5   #second value
      syscall
    # ask user which value to change (1 or 2)
      li   $v0, 4
      la   $a0, prompt4
      syscall

      #Look for user response (s3)
      li   $v0, 5
      syscall
      move   $s3, $v0

      #check if s3 is in correct range
      sle    $t7, $s3, $zero    #if <0, invalid
      sgeu   $t8, $s3, 3       #if >= 3, invalid
      seq    $t9  $t7, $t8
      bnez   $t9, notInval    # if $t7=1 or $t8=1, invalid

      # print and loop again if invalid
      li   $v0, 4
      la   $a0, prompt3
      syscall
      j   userTurn
      
      notInval:
      beq $s3, 1, changeValOneUser #if the value == 1, then change the first value
      beq $s3, 2, changeValTwoUser #if the value == 2, then change the second value
      # ask for value (1-9)
      # if invalid, ask again
                changeValOneUser: #s1 is the first value
                    li  $v0, 4
                    la  $a0, prompt5    # print prompt to enter a value from 1-9
                    syscall
                    #Look for user response for the first value
                    li   $v0, 5
                    syscall
                              #move   $s1, $v0 COMMENTED OUT
                    li  $s1, 4
                    move $s1, $v0 # move to temp value
                  
                    #check if s1 is in correct range
                    sle    $t7, $s1, $zero    #if <0, invalid
                    sgeu   $t8, $s1, 10       #if >= 10, invalid
                    seq    $t9  $t7, $t8
                    bnez   $t9, userProduct    # if $t7=1 or $t8=1, then $t9=0, invalid
                  
                    # print and loop again if invalid
                    li   $v0, 4
                    la   $a0, prompt3
                    syscall
                    j   changeValOneUser
                changeValTwoUser: #s2 is the second value
                    li  $v0, 4
                    la  $a0, prompt5    # print prompt to enter a value from 1-9
                    syscall
                    #Look for user response for the second value
                    li   $v0, 5
                    syscall 
                              #move   $s2, $v0 COMMENTED OUT
                    li  $s2, 4
                    move $s2, $v0
                    
                    #check if s2 is in correct range
                    sle    $t7, $s2, $zero    #if <0, invalid
                    sgeu   $t8, $s2, 10       #if >= 10, invalid
                    seq    $t9  $t7, $t8
                    bnez   $t9, userProduct    # if $t7=1 or $t8=1, invalid
                  
                    # print and loop again if invalid
                    li   $v0, 4
                    la   $a0, prompt3
                    syscall
                    j   changeValTwoUser
                
    # multiply the values        
            userProduct: 
              # print the first and second value
              li   $v0, 4
              la   $a0, prompt6
              syscall
              li   $v0, 1       #System call code for printing an integer
              move   $a0, $s1   # first value
              syscall
        
              li $v0, 4
              la $a0, newline #new line to separate value 1 and 2
              syscall
        
              li   $v0, 4
              la   $a0, prompt7
              syscall
              li   $v0, 1       #System call code for printing an integer
              #move   $a0, $s2   #second value
              move   $a0, $s2   #second value
              syscall

              #MULTIPLY 
              mul $t0, $s1, $s2, #s0 = s1 * s2
        
              #display the product 
              li $v0, 4
              la $a0, newline #new line
              syscall
        
              #display message
              li $v0, 4 
              la $a0, prompt10
              syscall
        
              #print
              li $v0, 1
              move $a0, $t0
              syscall
        
            #loop through the array and see if the product is in the array and if not, choose a value again
            #subroutine in another file. returns v1 as 0 or 1 
              move $a1, $t0  # check if the temp multiplied val is in the array
              jal checkArr
        
              # if $v1 (in array) is not 1 (true), loop to get value again
              beq $v1, 1, inArrUser # if in arr, go to print and check four in a row
              # NOT IN ARRAY
              # RESET TEMP VALUES
              move $s1, $s4
              move $s2, $s2
              move $t0, $s0
              li $v0, 4
              la $a0, promptUserErr  # else print the error
              syscall
              j userTurn              # go back to get values again

    #IS IN ARRAY 
    inArrUser:
      move $s4, $s1
      move $s5, $s2
      move $s0, $t0

      # IN ARRAY
      li $v0, 4
      la $a0, promptKey # print the key for the array for the first time
      syscall
      
      jal printArr
      jal checkWin # check if there is a 4 in a row
      beq  $v0, 1, gameEndU
      j cpuTurn

  gameEndU:
    li  $v0, 4
    la  $a0, promptWinU
    syscall  
    j gameEnd
  gameEndCPU:
    li  $v0, 4
    la  $a0, promptWinCPU
    syscall 
  gameEnd:
    li $v0, 10
    syscall