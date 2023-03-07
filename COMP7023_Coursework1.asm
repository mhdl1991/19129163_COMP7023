; Your system must be able to store the following information about badgers in the zoo:
;   Badger ID - 8B - b + 6 digits
;   Name (64 bit) - 64B
;   Home sett (can be any one of Settfield, Badgerton, or Stripeville) - 1B
;   Mass in kg (to the nearest whole kg) - 1B, assuming that badgers are never going to be bigger than 255 kg
;   Number of stripes (in the range from 0 to 255) - 1B
;   Sex (M or F) - 1B
;   Month of birth - 1B
;   Year of birth  - 2B
;   Staff ID of assigned park keeper - 9B - p + 7 digits
;  record size - 88 Bytes/Badger

; Your system must be able to store the following information about staff members in the zoo:
;   Surname 64B
;   First Name 64B
;   Staff ID 9B - p + 7 digits
;   Department 1B (can be any one of Park Keeper, Gift Shop or Cafe)
;   Starting annual salary in GBP  4B (whole GBP  only)
;   Year of joining 2B
;   Email address 64B
; record size - 208 Bytes/Staffer

; This include line is an absolute path to the I/O library. You may wish to change it to suit your own file system.
%INCLUDE "/home/malware/asm/joey_lib_io_v9_release.asm"

GLOBAL main

SECTION .data
	; variables for messages to user
	
	; main menu variables
	str_main_menu DB 10,\
						"Main Menu", 10,\
						" 1. Add Staff Member", 10,\
						" 2. Delete Staff Member", 10,\
						" 3. List All Staff Members", 10,\
						" 4. Add Badger", 10,\
						" 5. Delete Badger", 10,\
						" 6. List All Badgers", 10, \
						" 7. Search for Badger by assigned Staff ID", 10, \
						" 8. Exit", 10,\
						"Please Enter Option 1 - 8", 10, 0
	str_program_exit DB "Program exited normally.", 10, 0
    str_option_selected DB "Option selected: ", 0
    str_invalid_option DB "Invalid option, please try again.", 10, 0				

	; messages to show user when adding a staff member
	str_prompt_staff_full DB "ERROR- Cannot add new staff member. Please delete existing staff member", 10, 0
	str_prompt_staff_wrong_dept DB "ERROR- Invalid value entered for Department ID"
	str_prompt_staff_name DB "Please enter the staff member's name", 10, 0
	str_prompt_staff_surname DB "Please enter the staff member's surname", 10, 0
	str_prompt_staff_id DB "Please enter the staff member's ID", 10, 0
	str_prompt_staff_dept DB "Which department do they work in?", 10, \
							"0 - Park Keeper", 10, \
							"1 - Gift Shop", 10, \
							"2 - Cafe", 10, 0						
	str_prompt_staff_salary DB "Please enter their salary", 10, 0
	str_prompt_staff_year DB "Which year did they join", 10, 0
	str_prompt_staff_mail DB "What's their email address?", 10, 0
	
	str_staff_dept_0 DB "Park Keeper", 0
	str_staff_dept_1 DB "Gift Shop", 0
	str_staff_dept_2 DB "Cafe", 0
	str_staff_dept_ERR DB "Error!", 0
	
	str_number_staff DB "Total number of Staff: ", 10, 0
	
	
	; messages to show when displaying staff member data to user
	str_disp_staff_name DB "Name: ", 0
	str_disp_staff_id DB "ID: ", 0
	str_disp_staff_salary DB "Salary: ", 0
	str_disp_staff_salary_currency DB " GBP", 0
	str_disp_staff_year_join DB "Year of Joining: ", 0
	
	
	; messages to show user when adding a badger
	str_prompt_badg_full DB "ERROR- Cannot add new badger. Please delete existing badger", 10, 0
	str_prompt_badg_name DB "Please enter the badger's name", 10, 0
	str_prompt_badg_id DB "Please give the badger an ID number", 10, 0
	str_prompt_badg_sett DB  "Which setting do they live in?", 10, \
							"0 - Settfield", 10, \
							"1 - Badgerton", 10, \
							"2 - Stripeville", 10, 0
	str_prompt_badg_mass DB "How much does the badger weigh?", 10, 0
	str_prompt_badg_stripes DB "How many stripes does it have? (0 - 255)", 10, 0
	str_prompt_badg_sex DB  "What sex is the badger?", 10, \
							"0 - Male", 10, \
							"1 - Female", 10, \
							"2 - Intersex/Other", 10, 0
	str_prompt_badg_birth_mon  DB  "What month was the badger born", 10, 0
	str_prompt_badg_birth_year  DB  "What year was the badger born", 10, 0
	str_prompt_badg_keeper_id DB "What is the ID of the badger's keeper", 10, 0
	
	
	str_badg_home_0 DB "Settfield", 10, 0
	str_badg_home_1 DB "Badgerton", 10, 0
	str_badg_home_2 DB "Stripeville", 10, 0
	str_badg_home_ERR DB "Error!", 10, 0

	str_badg_sex_0 DB "Male", 10, 0
	str_badg_sex_1 DB "Female", 10, 0
	str_badg_sex_2 DB "Intersex", 10, 0
	str_badg_sex_ERR DB "Error!", 10, 0
	
	
	; Errors for badger and staff ID format
	str_badg_id_ERR DB "ERROR- A Badger's ID should be in the format bXXXXXX", 10,  0
	str_staff_id_ERR DB "ERROR- Staff member's ID should be in the format pXXXXXXX", 10, 0
	
	; IS_DELETED 1B
	;   Surname 64B
	;   First Name 64B
	;   Staff ID 9B
	;   Department 1B (can be any one of Park Keeper, Gift Shop or Cafe)
	;   Starting annual salary in GBP  4B (whole GBP  only)
	;   Year of joining 2B
	;   Email address 64B
	size_delete_flag EQU 1 ; 0 or 1 to denote record is deleted ; currently not used
	size_name_string EQU 64 ; Names are gonna be 64B long.
	; 64 B for surname
	size_staff_id EQU 9 ; p + 7 digits + NULL
	size_dept_id EQU 1 ; 1 Byte
	size_salary EQU 8 ; 8 Btyes
	size_year EQU 2 ; 2 Bytes
	; 64 B for email
	
	size_staff_record EQU size_name_string + size_name_string + size_staff_id + size_dept_id + size_salary + size_year + size_name_string ;210B 
	
	; IS_DELETED 1B 
	;   Name (64 bit) - 64B
	;   Badger ID - 8B - b + 6 digits
	;   Home sett (can be any one of Settfield, Badgerton, or Stripeville) - 1B
	;   Mass in kg (to the nearest whole kg) - 1B, assuming that badgers are never going to be bigger than 255 kg
	;   Number of stripes (in the range from 0 to 255) - 1B
	;   Sex (M or F) - 1B
	;   Month of birth - 1B
	;   Year of birth  - 2B
	;   Staff ID of assigned park keeper - 9B - p + 7 digits + NULL
	
	size_badg_id EQU 8 ; b + 6 digits + NULL
	; 64B name 
	size_badg_home EQU 1
	size_badg_mass EQU 1
	size_num_stripes EQU 1
	size_badg_sex EQU 1
	size_badg_mon EQU 1
	size_badg_yr EQU 2
	; 9B staff ID
	
	size_badg_record EQU size_badg_id + size_name_string + size_badg_home + size_badg_mass + size_num_stripes + size_badg_sex + size_badg_mon + size_badg_yr +size_staff_id ; The total size of the badger comes out to around 88B
	
	badg_keeper_id_offset EQU size_badg_id + size_name_string + size_badg_home + size_badg_mass + size_num_stripes + size_badg_sex + size_badg_mon + size_badg_yr ; gives you the ID of the keeper
	
	max_number_staff EQU 100
	max_number_badg EQU 500
	
	size_staff_array EQU size_staff_record*max_number_staff
	size_badg_array EQU size_badg_record*max_number_badg

	current_number_staff DQ 0 ;keep track of staff
	current_number_badg DQ 0 ;keep track of badgers


SECTION .bss
	arr_staff_members: RESB size_staff_array; 210B/staff, 100 maximum staff members
	arr_badgers: RESB size_badg_array ; 88B/badger, 500 maximum badgers
	buff_generic: RESB 64 ; used for testing IDs. maybe don't need to make it big
SECTION .text

ADD_STAFF_MEMBER:
; START BLOCK	
	; Adds a new staff member into the staff member array
	; We need to check that the array is not full before calling this function. Otherwise buffer overflow will occur.
	; No parameters (we are using the users array as a global)
    PUSH RBX
    PUSH RCX
    PUSH RDX
    PUSH RDI
    PUSH RSI

	MOV RCX, arr_staff_members ; BASE ADDRESS OF STAFF MEMBERS ARRAY
	MOV RAX, QWORD[current_number_staff] ; VALUE OF CURRENT STAFF MEMBERS
	MOV RBX, size_staff_record ; SIZE OF ONE STAFF MEMBER RECORD
	MUL RBX 
	ADD RCX, RAX ; BASE_ADDRESS + (RECORD_SIZE * NUMBER_STAFF) = ADDRESS OF NEXT UNUSED STAFF MEMBER
	.STAFF_MEMBER_READ_NAME:
		; Staff member's name
		MOV RDI, str_prompt_staff_name
		CALL print_string_new
		CALL read_string_new
		MOV RSI, RAX ; address of new string into rsi
		MOV RDI, RCX ; address of memory slot into rdi
		CALL copy_string
		ADD RCX, size_name_string ;64B was reserved for first name
	.STAFF_MEMBER_READ_SURNAME:
		; Staff member's surname
		MOV RDI, str_prompt_staff_surname
		CALL print_string_new
		CALL read_string_new
		MOV RSI, RAX
		MOV RDI, RCX
		CALL copy_string
		ADD RCX, size_name_string ;64B was reserved for surname
	.STAFF_MEMBER_READ_ID:
		; Staff member ID
		MOV RDI, str_prompt_staff_id ; PROMPT USER TO ENTER STAFF ID
		CALL print_string_new ; print message
		CALL read_string_new ; get input from user
		; TEST IF STAFF ID IS IN CORRECT FORMAT.
		.STAFF_ID_FORMAT_CHECK:
			PUSH RSI
			PUSH RAX
			PUSH RBX
			PUSH RCX 

			MOV RSI, RAX ; source- RAX
			MOV RDI, [buff_generic] ; dest- buff_generic
			CALL copy_string ;copy string from RAX into buff_generic

			MOV AL, BYTE[buff_generic] ;
			CMP AL, 0
			JE .STAFF_MEMBER_READ_ID ;hmmm... send user back  if they put in an empty string? 

			MOV RAX, QWORD[RBX] ;8 Bytes of string buffer moved onto RAX

			.STAFF_ID_FIRST_LETTER_CHECK:
			CMP AL, 'p'
			JNE .INCORRECT_STAFF_ID ; MAKE SURE FIRST CHARACTER IS p
			SHR RAX, 8
			
			; The next 7 characters must all be digits
			; counter
			MOV RCX, 7
			.STAFF_ID_FORMAT_CHECK_LOOP:
			;START LOOP
			CMP AL, '0'
			JLE .INCORRECT_STAFF_ID
			CMP AL, '9'
			JGE .INCORRECT_STAFF_ID
			
			SHR RAX, 8
			DEC RCX
			CMP RCX, 0
			JNE .STAFF_ID_FORMAT_CHECK_LOOP
			JMP .STAFF_ID_END_LOOP

			.INCORRECT_STAFF_ID:
			MOV RDI, str_staff_id_ERR
			CALL print_string_new
			CALL print_nl_new
			JMP .STAFF_MEMBER_READ_ID

			.STAFF_ID_END_LOOP:
			;END LOOP
			POP RCX
			POP RBX
			POP RAX
			POP RSI

		MOV RSI, RAX ;source
		MOV RDI, RCX ;destination
		CALL copy_string
		ADD RCX, size_staff_id ; 
	.STAFF_MEMBER_READ_DEPT:
		; Staff member Dept
		MOV RDI, str_prompt_staff_dept
		CALL print_string_new
		CALL read_uint_new
		CMP RAX, 3 ; DEPT. SHOULD BE 0, 1 OR 2
		JL .NOERROR
		.ERROR:
			MOV RDI, str_prompt_staff_wrong_dept
			CALL print_string_new
			JMP .STAFF_MEMBER_READ_DEPT
		.NOERROR:
			MOV RSI, RAX
			MOV BYTE[RCX], AL
			ADD RCX, size_dept_id ; only 1B for the department ID field
	.STAFF_MEMBER_READ_SALARY:
		; Staff member salary
		MOV RDI, str_prompt_staff_salary
		CALL print_string_new
		CALL read_uint_new
		MOV QWORD[RCX], RAX ;copy 8B number into record
		ADD RCX, size_salary ;8B
	.STAFF_MEMBER_READ_YEAR_JOIN:
		; Staff member year of joining
		MOV RDI, str_prompt_staff_year
		CALL print_string_new
		CALL read_uint_new
		MOV RSI, RAX
		MOV DWORD[RCX], EAX
		ADD RCX, size_year ;4B
	.STAFF_MEMBER_READ_EMAIL:
		; Staff member email address
		MOV RDI, str_prompt_staff_mail
		CALL print_string_new
		CALL read_string_new
		MOV RSI, RAX
		MOV RDI, RCX
		CALL copy_string
		ADD RCX, size_name_string 

	; FINALLY ADDED ALL THE STAFF DETAILS
	INC QWORD[current_number_staff]
	POP RSI
    POP RDI    
    POP RDX
    POP RCX
    POP RBX 
	RET
; END BLOCK

ADD_BADGER:
; START BLOCK
	RET
; END BLOCK

PRINT_NUMBER_STAFF:
; START BLOCK
	PUSH RDI
	; No parameters
	; Displays number of users in list (to STDOUT)
	MOV RDI, str_number_staff
	CALL print_string_new
	MOV RDI, [current_number_staff]
	CALL print_uint_new
	CALL print_nl_new
	POP RDI
	RET
;END BLOCK
	
	
LIST_STAFF:
; START BLOCK
	; Takes no parameters (users is global)
	; Lists full details of all users in the array
    PUSH RBX
    PUSH RCX
    PUSH RDX
    PUSH RDI
    PUSH RSI
	
    LEA RSI, [arr_staff_members] ; load base address of the users array into RSI. In other words, RSI points to the users array.
    MOV RCX, [current_number_staff] ; we will use RCX for the counter in our loop
	.START_PRINT_STAFF_LOOP:
		CMP RCX, 0
		JE .END_PRINT_STAFF_LOOP ; if RCX is zero we're at the end of the print staff loop
		
		.PRINT_STAFF_NAME:
			MOV RDI, str_disp_staff_name
			CALL print_string_new
			MOV RDI, RSI ; put the pointer to the current record in RDI, to pass to the print_string_new function
			CALL print_string_new
			MOV RDI, ' '
			CALL print_char_new
			LEA RDI, [RSI + size_name_string] ; surname
			CALL print_string_new
			CALL print_nl_new
		
		.PRINT_STAFF_ID:
			MOV RDI, str_disp_staff_id
			CALL print_string_new
			LEA RDI, [RSI + size_name_string + size_name_string]
			CALL print_string_new
			CALL print_nl_new
			LEA RDI, [RSI + size_name_string + size_name_string + size_staff_id] ;name, surname, id
		
		.START_PRINT_STAFF_DEPT:
			MOVZX RDI, BYTE[RSI + size_name_string + size_name_string + size_staff_id] 
			; PRINT WHICH DEPARTMENT THE STAFF MEMBER WORKS IN.
			.STAFF_DEPT_0:
			CMP RDI, 0
			JNE .STAFF_DEPT_1
			PUSH RDI
			MOV RDI, str_staff_dept_0
			CALL print_string_new
			CALL print_nl_new
			POP RDI
			JMP .END_PRINT_STAFF_DEPT
			
			.STAFF_DEPT_1:
			CMP RDI, 1
			JNE .STAFF_DEPT_2
			PUSH RDI
			MOV RDI, str_staff_dept_1
			CALL print_string_new
			CALL print_nl_new
			POP RDI
			JMP .END_PRINT_STAFF_DEPT
			
			.STAFF_DEPT_2:
			CMP RDI, 2
			JNE .STAFF_DEPT_ERR
			PUSH RDI
			MOV RDI, str_staff_dept_2
			CALL print_string_new
			CALL print_nl_new
			POP RDI
			JMP .END_PRINT_STAFF_DEPT
			
			.STAFF_DEPT_ERR:
			PUSH RDI
			MOV RDI, str_staff_dept_ERR
			CALL print_string_new
			CALL print_nl_new
			POP RDI
			JMP .END_PRINT_STAFF_DEPT
		.END_PRINT_STAFF_DEPT:

		.PRINT_STAFF_SALARY:
			MOV RDI, str_disp_staff_salary ; "Salary: "
			CALL print_string_new
			MOV RDI, QWORD[RSI + size_name_string + size_name_string + size_staff_id + size_dept_id]
			CALL print_uint_new
			MOV RDI, str_disp_staff_salary_currency ; " GBP"
			CALL print_string_new
			CALL print_nl_new
			
		.PRINT_STAFF_YEAR:
			MOV RDI, QWORD[RSI + size_name_string + size_name_string + size_staff_id + size_dept_id + size_salary]
			CALL print_uint_new
			CALL print_nl_new

		.GOTO_NEXT_STAFF:
			ADD RSI, size_staff_record
			DEC RCX
			JMP .START_PRINT_STAFF_LOOP
	.END_PRINT_STAFF_LOOP:
	POP RSI
    POP RDI    
    POP RDX
    POP RCX
    POP RBX 
	RET
; END BLOCK
	
LIST_BADGERS:
	RET
	
DELETE_STAFF:
	RET
	
DELETE_BADGER:
	RET
	
YEARS_OF_SERVICE:
	; yearsOfService = currentYear–yearOfJoining
	; get current year from user
	
	RET
	
AGE_CALCULATION:
	; if (currentMonth – birthMonth) >= 0
	; 	age = thisYear – yearOfBirth
	; else
	; 	age = thisYear – yearOfBirth – 1
	
	; return value must be pushed to EAX
	
	;JG .currentMonthGreaterOrEqual
	;.currentMonthLess:
	
	;.currentMonthGreaterOrEqual:
	
	
	RET
	
STRIPINESS_CALCULATION:
	; stripiness = mass * numberOfStripes
	RET
	
MAIN_MENU_OPTIONS_PROMPT:
    PUSH RDI
    MOV RDI, str_main_menu
    CALL print_string_new
    POP RDI
	RET
	
main:
    mov rbp, rsp; for correct debugging
	;START BLOCK
	.START_MAIN_FUNCTION:
		;compatibility boilerplate
		MOV RBP, RSP
		PUSH RBP
		MOV RBP, RSP
		SUB RSP, 32

	.MENULOOP:
		; START BLOCK
		; Call the main menu options
		CALL MAIN_MENU_OPTIONS_PROMPT
		CALL read_int_new
		MOV RDX, RAX
		MOV RDI, str_option_selected
		CALL print_string_new
		MOV RDI, RDX
		CALL print_int_new
		CALL print_nl_new
		
		; jump to the selected option
		.BRANCHING:
			; START BLOCK
			CMP RDX, 1
			JE .OPTION1
			CMP RDX, 2
			JE .OPTION2
			CMP RDX, 3
			JE .OPTION3
			CMP RDX, 4
			JE .OPTION4
			CMP RDX, 5
			JE .OPTION5
			CMP RDX, 6
			JE .OPTION6
			CMP RDX, 7
			JE .OPTION7
			CMP RDX, 8
			JE .OPTION8
			; if we reach this point, an invalid option was selected
			MOV RDI, str_invalid_option
			CALL print_string_new
			JMP .MENULOOP
			; END BLOCK
		
	.OPTION1: ;ADD STAFF MEMBER
		; START BLOCK
		; CHECK THAT THE STAFF MEMBER ARRAY ISN'T FULL
		MOV RDX, [current_number_staff]
		CMP RDX, max_number_staff
		JL .STAFF_NOT_FULL
		MOV RDI, str_prompt_staff_full
		CALL print_string_new
		JMP .MENULOOP
		.STAFF_NOT_FULL:
		; CALL ADD STAFF MEMBER METHOD
		CALL ADD_STAFF_MEMBER
		JMP .MENULOOP
		; END BLOCK
	
	.OPTION2: ;DELETE STAFF MEMBER
		; START BLOCK
		JMP .MENULOOP
		; END BLOCK
		
	.OPTION3: ;LIST STAFF MEMBERS
		; START BLOCK
		CALL PRINT_NUMBER_STAFF
		CALL print_nl_new
		CALL LIST_STAFF
		JMP .MENULOOP
		; END BLOCK
	
	.OPTION4: ;ADD BADGER
		; START BLOCK
		; CHECK THAT THE STAFF MEMBER ARRAY ISN'T FULL
		MOV RDX, [current_number_badg]
		CMP RDX, max_number_badg
		JL .BADG_NOT_FULL
		MOV RDI, str_prompt_badg_full
		CALL print_string_new
		JMP .MENULOOP
		.BADG_NOT_FULL:
		; CALL ADD STAFF MEMBER METHOD
		CALL ADD_BADGER
		JMP .MENULOOP
		; END BLOCK
	
	.OPTION5:
		; START BLOCK
		JMP .MENULOOP
		; END BLOCK
	
	.OPTION6:
		; START BLOCK
		JMP .MENULOOP
		; END BLOCK
	
	.OPTION7:
		; START BLOCK
		JMP .MENULOOP
		; END BLOCK
	
	.OPTION8:  ;EXIT
		; START BLOCK
		MOV RDI, str_program_exit
		CALL print_string_new
		; END BLOCK
	
	.FINISH_MAIN_FUNCTION:
		; START BLOCK
		; compatability boilerplate 2: electric boogaloo
		; undo the stack
		XOR RAX, RAX ; return zero
		ADD RSP, 32
		POP RBP
		RET ; End function main
		; END BLOCK
	; END BLOCK

	
