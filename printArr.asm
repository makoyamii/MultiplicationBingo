    .text
    .globl printArr
    printArr: # subroutine for printing the array 
    
    #initialize counters 
    li $t0, 0      # Outer loop counter (rows)
    li $t1, 0      # Inner loop counter (columns)
    li $t2, 6      # Number of rows
    li $t3, 6      # Number of columns
    # Print new line
    li $v0, 4          # System call code for print string
    la $a0, newline    # Load address of newline string
    syscall
    li   $v0, 4          
    la   $a0, rowSeparator    
    syscall
    # Print new line
    li $v0, 4          # System call code for print string
    la $a0, newline    # Load address of newline string
    syscall
    outerLoopPrint:
        # Inner loop (print array elements)
        move $t1, $zero  # Reset inner loop counter

    innerLoopPrint:
        # Calculate array index
        mul $t4, $t0, $t3   # t4 = row * num columns
        add $t4, $t4, $t1   # t4 = row * num columns + column

        # Calculate memory offset
        mul $t5, $t4, 4     # Multiply by 4 (size of each word)
        lw $t6, array($t5)

      #Print the lines in between columns
      li   $v0, 4          
      la   $a0, columnSeparator    
      syscall

      bgtu	$t6, 9, skipExtraSpace
      #add extra space
      # Print space between elements
      li $v0, 4          # System call code for print string
      la $a0, space      # Load address of space string
      syscall
      skipExtraSpace: #skip if the element is 2 digits

      # Print array element
      li   $v0, 1          
      move   $a0, $t6  
      syscall
      # Print space between elements
      li   $v0, 4          # System call code for print string
      la   $a0, space      # Load address of space string
      syscall

      #Print the lines in between columns
      li   $v0, 4          
      la   $a0, columnSeparator    
      syscall
      # Increment inner loop counter
      addi   $t1, $t1, 1

      # Check if inner loop counter reached number of columns
      bne   $t1, $t3, innerLoopPrint

      # Print new line
      li   $v0, 4          # System call code for print string
      la   $a0, newline    # Load address of newline string
      syscall
      li   $v0, 4          
      la   $a0, rowSeparator    
      syscall
      # Print new line
      li   $v0, 4          # System call code for print string
      la   $a0, newline    # Load address of newline string
      syscall

      # Increment outer loop counter
      addi   $t0, $t0, 1

      # Check if outer loop counter reached number of rows
      bne   $t0, $t2, outerLoopPrint
      
      jr $ra  #return to main function