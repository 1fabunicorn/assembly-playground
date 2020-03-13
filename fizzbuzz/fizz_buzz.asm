	; Nova Trauben
	; My implentation of Fizz Buzz is NASM assembly

	; Compile with: nasm -f elf fizz_buzz.asm
	; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 fizz_buzz.o -o fizz_buzz
	; Run with: ./fizz_buzz

	%include 'functions.asm'; needed for printing output

	SECTION  .data
	Fizz     db      'Fizz', 0h
	Buzz     db      'Buzz', 0h
	FizzBuzz db      'FizzBuzz', 0h

	SECTION .text

	global _start

_start:
	mov  eax, 1; eax will be our counter var
	call loop

loop:

	;    check for fizzbuzz
	call div3
	call div5
	call print_results
	call check_if_done

	; checks what the remainder of ecx  /  3
	; if yes, ebx is 1

div3:
	push eax; push registers to the stack
	mov  ecx, 3; divisor
	mov  edx, 0; clear registor where result will live
	div  ecx; call div function

	pop eax
	cmp edx, 0; see if remainder of counter / 3 = 0
	JE  is_div_3
	JNE not_div_3

is_div_3:
	mov ebx, 1
	ret

not_div_3:
	mov ebx, 0
	ret

	; checks what the remainder of ecx  /  5
	; if yes, edx is 1
	; otherwise its 0

div5:
	push eax; push registers to the stack that we use in the routine
	mov  ecx, 5; diviser
	mov  edx, 0; clear registor where result will live
	div  ecx; call div function

	pop eax; put if div3 flag back into ebx
	cmp edx, 0
	JE  is_div_5
	JNE not_div_5

is_div_5:
	mov edx, 1
	ret

not_div_5:
	mov edx, 0
	ret

	; checks the value of adx and abx
	; if adx & abx = 1, print fizzbuzz
	; if ebx = 1, Fizz
	; if edx = 1, Buzz
	; if both 0, print value in acx

print_results:
	push ecx
	push eax
	mov  ecx, 0; clear ecx
	add  ecx, ebx
	add  ecx, edx
	cmp  ecx, 2; if true, fizzbuzz
	pop  eax
	pop  ecx
	JE   is_fizz_buzz
	JNE  not_fizz_buzz

is_fizz_buzz:
	call fizzbuzz
	ret

not_fizz_buzz:
	cmp ebx, 1; if true, fizz
	JE  call_fizz
	JNE test_for_buzz

call_fizz:
	call fizz
	ret

test_for_buzz:
	cmp edx, 1; if true buzz
	JE  call_buzz
	JNE call_print_num; if we gotten to this point, then we know number is not fizz, buzz, or fizzbuzz. just print the current loop number

call_buzz:
	call buzz
	ret

call_print_num:
	call printNum
	ret

check_if_done:
	inc eax; add one to loop counter
	cmp eax, 100; see if loop var has gotten to 100, then exit
	JE  quit; if equal, jump to quit
	JNE loop; otherwise jump to loop

fizz:
	push eax; push counter var to stack
	mov  eax, Fizz
	call sprintLF; eax is incremented by one here :)
	pop  eax
	ret

buzz:
	push eax
	mov  eax, Buzz
	call sprintLF
	pop  eax
	ret

fizzbuzz:
	push eax
	mov  eax, FizzBuzz
	call sprintLF
	pop  eax
	ret

printNum:
	call iprintLF
	ret

