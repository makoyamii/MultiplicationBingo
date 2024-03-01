    .text
    .globl checkArr
    checkArr: # this subroutine checks if a value exists in the array, and returns $v1 as 1 if it is in the array

      #initialize counters 
      li $v1, 0      # set if in array to false
      li $t7, 0      # temporary check
      li $t0, 0      # Outer loop counter (rows)
      li $t1, 0      # Inner loop counter (columns)
      li $t2, 6      # Number of rows
      li $t3, 6      # Number of columns
      outerLoopCheck:
          # Inner loop (print array elements)
          move $t1, $zero  # Reset inner loop counter

      innerLoopCheck:
          # Calculate array index
          mul $t4, $t0, $t3   # t4 = row * num columns
          add $t4, $t4, $t1   # t4 = row * num columns + column

          # Calculate memory offset
          mul $t5, $t4, 4     # Multiply by 4 (size of each word)
          lw $t6, array($t5)  # current value = $t6

      #if current value = $a1 (value after multiplying), set register $t9 to 1
      seq  $t7, $a1, $t6
      beqz $t7, notInArr          # skip if it's not the multiplied value
      li  $v1, 1                 #this means it's in the array
      sw $t8, array($t5)         #set val to 0 or -1

      #VALID NUMBER, WORKING PROPERLY 
      notInArr: # continue looping through array
      # Increment inner loop counter
      addi   $t1, $t1, 1

      # Check if inner loop counter reached number of columns
      bne   $t1, $t3, innerLoopCheck

      # Increment outer loop counter
      addi   $t0, $t0, 1

      # Check if outer loop counter reached number of rows
      bne   $t0, $t2, outerLoopCheck

      jr $ra  #return to main function
