    .text
    .globl checkWin
    checkWin: #loop through the array and see if there is four in a row
      # initialize return value
      li  $v0, 0 # return value = 0 (false)
      ### check horizontal 4 in row ################
      #initialize counters 
      li $t9, 0      # adjacency counter
      li $t7, 0      # temporary check 
      li $t0, 0      # Outer loop counter (rows)
      li $t1, 0      # Inner loop counter (columns)
      li $t2, 6      # Number of rows
      li $t3, 6      # Number of columns
      outerLoopCheckWin:
          # Inner loop (print array elements)
          move $t1, $zero  # Reset inner loop counter
    
      innerLoopCheckWin:
          # Calculate array index
          mul $t4, $t0, $t3   # t4 = row * num columns
          add $t4, $t4, $t1   # t4 = row * num columns + column
    
          # Calculate memory offset
          mul $t5, $t4, 4     # Multiply by 4 (size of each word)
          lw $t6, array($t5)  # current value = $t6
          bne $t6, $t8, counterLoop	# go to counterLoop
          addi $t9, $t9, 1		# add 1 to t9 if the current is also = $t8
      #make another loop 
      counterLoop:
      	#if NEXT value = $t8 (value of user/cpu), increment $t9 
      	add $t5, $t5, 4 # Next value
      	lw $t7, array($t5)  # next value = $t7
      	
      	bne  $t8, $t7, resetVal    # skip if it's not the user/cpu value
      	addi  $t9, $t9, 1          # add 1 to counter
      	blt  $t9, 4, counterLoop   # check if counter (in a row) is 4
      	
      	# the user/cpu has won
      	j  done                    # end the function
      
      resetVal:
      li $t9, 0 #reset the win counter
      # continue looping through array 
      # Increment inner loop counter
      addi   $t1, $t1, 1
      # Check if inner loop counter reached number of columns
      bne   $t1, $t3, innerLoopCheckWin
      # Increment outer loop counter
      addi   $t0, $t0, 1
      # Check if outer loop counter reached number of rows
      bne   $t0, $t2, outerLoopCheckWin



    ### check diagonal 4 in a row ############
    #initialize counters 
    li $t9, 0      # adjacency counter
    li $t7, 0      # temporary check 
    li $t0, 0      # Outer loop counter (rows)
    li $t1, 0      # Inner loop counter (columns)
    li $t2, 6      # Number of rows
    li $t3, 6      # Number of columns
    li $a1, 0		#counter for next row
    li $a2, 0		#counter for next column
    outerLoopCheckWin2:
        # Inner loop (print array elements)
        move $t1, $zero  # Reset inner loop counter

    innerLoopCheckWin2:
        # Calculate array index
        mul $t4, $t0, $t3   # t4 = row * num columns
        add $t4, $t4, $t1   # t4 = row * num columns + column

        # Calculate memory offset
        mul $t5, $t4, 4     # Multiply by 4 (size of each word)
        lw $t6, array($t5)  # current value = $t6
        bne $t6, $t8, counterLoop2	# go to counterLoop
        addi $t9, $t9, 1		# add 1 to t9 if the current is also = $t8
    
    #make another loop 
      addi $a1, $t0, 1	#add 1 to row, column
      addi $a2, $t1, 1
      j skipInitial
    counterLoop2:
      #if NEXT value = $t8 (value of user/cpu), increment $t9 
      addi $a1, $a1, 1	#add 1 to row, column
      addi $a2, $a2, 1
      skipInitial:
      # Calculate array index
        mul $t7, $a1, $t3   # t4 = row * num columns
        add $t7, $t7, $a2   # t4 = row * num columns + column
        # Calculate memory offset
        mul $t5, $t7, 4     # Multiply by 4 (size of each word)

      lw $t7, array($t5)  # next value = $t7

      bne  $t8, $t7, resetVal2    # skip if it's not the user/cpu value
      addi $t9, $t9, 1          # add 1 to counter
      blt  $t9, 4, counterLoop2   # check if counter (in a row) is 4

      # the user/cpu has won
      j  done                    # end the function

    resetVal2:
    li $t9, 0 #reset the win counter
    li $a1, 0		#counter for next row
    li $a2, 0		#counter for next column
    # continue looping through array 
    # Increment inner loop counter
    addi   $t1, $t1, 1
    # Check if inner loop counter reached number of columns
    bne   $t1, $t3, innerLoopCheckWin2
    # Increment outer loop counter
    addi   $t0, $t0, 1
    # Check if outer loop counter reached number of rows
    bne   $t0, $t2, outerLoopCheckWin2



    ### check vertical 4 in row ##########
    #initialize counters 
    li $t9, 0      # adjacency counter
    li $t7, 0      # temporary check 
    li $t0, 0      # Outer loop counter (rows)
    li $t1, 0      # Inner loop counter (columns)
    li $t2, 6      # Number of rows
    li $t3, 6      # Number of columns
    li $a1, 0		#counter for next row
    li $a2, 0		#counter for next column
    outerLoopCheckWin3:
        # Inner loop (print array elements)
        move $t1, $zero  # Reset inner loop counter

    innerLoopCheckWin3:
        # Calculate array index
        mul $t4, $t0, $t3   # t4 = row * num columns
        add $t4, $t4, $t1   # t4 = row * num columns + column

        # Calculate memory offset
        mul $t5, $t4, 4     # Multiply by 4 (size of each word)
        lw $t6, array($t5)  # current value = $t6
        bne $t6, $t8, counterLoop3	# go to counterLoop
        addi $t9, $t9, 1		# add 1 to t9 if the current is also = $t8
    #make another loop 
      addi $a1, $t0, 1	#add 1 to row
      addi $a2, $t1, 0
      j skipInitial2
    counterLoop3:
      #if NEXT value = $t8 (value of user/cpu), increment $t9 
      addi $a1, $a1, 1	#add 1 to row
      addi $a2, $a2, 0
      skipInitial2:
      # Calculate array index
        mul $t7, $a1, $t3   # t4 = row * num columns
        add $t7, $t7, $a2   # t4 = row * num columns + column
        # Calculate memory offset
        mul $t5, $t7, 4     # Multiply by 4 (size of each word)

      #add $t5, $t5, 20 # Next value
      lw $t7, array($t5)  # next value = $t7

      bne  $t8, $t7, resetVal3    # skip if it's not the user/cpu value
      addi $t9, $t9, 1          # add 1 to counter
      blt  $t9, 4, counterLoop3   # check if counter (in a row) is 4

      # the user/cpu has won
      j  done                    # end the function

    resetVal3:
    li $t9, 0 #reset the win counter
    li $a1, 0		#counter for next row
    li $a2, 0		#counter for next column
    # continue looping through array 
    # Increment inner loop counter
    addi   $t1, $t1, 1
    # Check if inner loop counter reached number of columns
    bne   $t1, $t3, innerLoopCheckWin3
    # Increment outer loop counter
    addi   $t0, $t0, 1
    # Check if outer loop counter reached number of rows
    bne   $t0, $t2, outerLoopCheckWin3


    ### check right to left diagonal 4 in a row ############
      #initialize counters 
      li $t9, 0      # adjacency counter
      li $t7, 0      # temporary check 
      li $t0, 0      # Outer loop counter (rows)
      li $t1, 0      # Inner loop counter (columns)
      li $t2, 6      # Number of rows
      li $t3, 6      # Number of columns
      li $a1, 0		#counter for next row
      li $a2, 0		#counter for next column
      li $a3, 0		#temp product
      outerLoopCheckWin4:
          # Inner loop (print array elements)
          move $t1, $zero  # Reset inner loop counter

      innerLoopCheckWin4:
          # Calculate array index
          mul $t4, $t0, $t3   # t4 = row * num columns
          add $t4, $t4, $t1   # t4 = row * num columns + column

          # Calculate memory offset
          mul $t5, $t4, 4     # Multiply by 4 (size of each word)
          lw $t6, array($t5)  # current value = $t6
          bne $t6, $t8, counterLoop4	# go to counterLoop
          addi $t9, $t9, 1		# add 1 to t9 if the current is also = $t8
      #make another loop 
        addi $a1, $t0, 1	#add 1 to row, sub 1 from column
        subi $a2, $t1, 1
        j skipInitial3
      counterLoop4:
        #if NEXT value = $t8 (value of user/cpu), increment $t9 
        addi $a1, $a1, 1	#add 1 to row, sub 1 from column
        subi $a2, $a2, 1
        skipInitial3:
        # Calculate array index
          mul $t7, $a1, $t3   # t4 = row * num columns
          add $t7, $t7, $a2   # t4 = row * num columns + column
          # Calculate memory offset
          mul $t5, $t7, 4     # Multiply by 4 (size of each word)

        lw $t7, array($t5)  # next value = $t7

        bne  $t8, $t7, resetVal4    # skip if it's not the user/cpu value
        addi $t9, $t9, 1          # add 1 to counter
        blt  $t9, 4, counterLoop4   # check if counter (in a row) is 4

        # the user/cpu has won
        j  done                    # end the function

      resetVal4:
      li $t9, 0 #reset the win counter
      li $a1, 0		#counter for next row
      li $a2, 0		#counter for next column
      # continue looping through array 
      # Increment inner loop counter
      addi   $t1, $t1, 1
      # Check if inner loop counter reached number of columns
      bne   $t1, $t3, innerLoopCheckWin4
      # Increment outer loop counter
      addi   $t0, $t0, 1
      # Check if outer loop counter reached number of rows
      bne   $t0, $t2, outerLoopCheckWin4

    

      done:
      blt $t9, 4, doneNotWin
      li $v0, 1 #Set v0 (return value) to 1 (true)
      doneNotWin:
      jr  $ra  #return to main function

    