; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?
    include \masm32\include\masm32rt.inc
; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

comment * -----------------------------------------------------
                     Build this console app with
                  "MAKEIT.BAT" on the PROJECT menu.
        ----------------------------------------------------- *

Student struct
    _name db 256 dup(0)
    id db 4 dup(0)
    courses dword 5
    grade0 db 4 dup(0)
    grade1 db 4 dup(0)
    grade2 db 4 dup(0)
    grade3 db 4 dup(0)
    grade4 db 4 dup(0)
    gradex db 36 dup(0)
Student ends

    id_index = 256
    course_index = 260
    grade0 = 264
    grade1 = 268
    grade2 = 272
    grade3 = 276
    grade4 = 280
    StudentLen = 256 + 64

    .data

      students = this dword
      s1 Student <"s1", "01", 5, "11", "20", "30", "40", "50">
      s2 Student <"s2", "02", 5, "12", "20", "30", "40", "50">
      s3 Student <"s3", "03", 5, "13", "20", "30", "40", "50">
      s4 Student <"s4", "04", 5, "14", "20", "30", "40", "50">
      s5 Student <"s5", "05", 5, "15", "20", "30", "40", "50">
      s6 Student <"s6", "06", 5, "16", "20", "30", "40", "50">
      s7 Student <"s7", "07", 5, "17", "20", "30", "40", "50">
      s8 Student <"s8", "08", 5, "18", "20", "30", "40", "50">
      s9 Student <"s9", "09", 5, "19", "20", "30", "40", "50">
      s10 Student <"s10", "10", 5, "10", "21", "30", "40", "50">
      s11 Student <"s11", "11", 5, "10", "22", "30", "40", "50">
      s12 Student <"s12", "12", 5, "10", "23", "30", "40", "50">
      s13 Student <"s13", "13", 5, "10", "24", "30", "40", "50">
      s14 Student <"s14", "14", 5, "10", "25", "30", "40", "50">
      s15 Student <"s15", "15", 5, "10", "26", "30", "40", "50">
      s16 Student <"s16", "16", 5, "10", "27", "30", "40", "50">
      s17 Student <"s17", "17", 5, "10", "28", "30", "40", "50">
      s18 Student <"s18", "18", 5, "10", "29", "30", "40", "50">
      s19 Student <"s19", "19", 5, "10", "20", "31", "40", "50">
      s20 Student <"s20", "20", 5, "10", "20", "32", "40", "50">
      s21 Student <"s21", "21", 5, "10", "20", "33", "40", "50">
      s22 Student <"s22", "22", 5, "10", "20", "34", "40", "50">
      s23 Student <"s23", "23", 5, "10", "20", "35", "40", "50">
      s24 Student <"s24", "24", 5, "10", "20", "36", "40", "50">
      s25 Student <"s25", "25", 5, "10", "20", "37", "40", "50">
      s26 Student <"s26", "26", 5, "10", "20", "38", "40", "50">

      cmd dd 0

      total dd 26 dup(0)
      index dd 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
               15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25

    .code

start:
   
; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

    call main
    inkey
    exit

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

SkipSpace macro R
    local ingore_space
    dec R
ingore_space:
    inc R
    cmp byte ptr [R], ' '
    je ingore_space
endm

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

Num2String proc near c uses ebx ecx edx esi, num: dword, pstr: dword
    local buff[4]: byte
    mov eax, num
    xor ecx, ecx
    lea esi, buff

    cmp eax, 0
    je zero_convert
    
to_string_loop:
    xor edx, edx
    cmp eax, 0
    je to_string_loop_exit
    mov ebx, 10
    div ebx
    add dl, '0'
    mov byte ptr [esi + ecx], dl

    inc ecx
    cmp ecx, 3
    jl to_string_loop
to_string_loop_exit:

    mov ebx, 0
    lea esi, buff
    mov edi, pstr
reverse_loop:
    mov al, byte ptr [esi + ebx]
    mov byte ptr [edi + ecx - 1], al
    inc ebx
    loop reverse_loop

    ret    
zero_convert:
    mov edi, pstr
    mov byte ptr [edi], '0'
    mov byte ptr [edi+1], 0
    ret
Num2String endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

ParseNumber proc near c uses ebx ecx edx esi, pstr: dword
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    mov esi, pstr
    
read_loop:
    mov bl, byte ptr [esi]
    cmp bl, '0'
    jl end_parse
    cmp bl, '9'
    jg end_parse
    cmp ecx, 3
    je end_parse

    sub bl, '0'
    imul eax, 10
    add eax, ebx

    inc ecx
    inc esi
    jmp read_loop

end_parse:
    cmp eax, 99
    jle parse_ret
    mov eax, 99
parse_ret:
    ; global 
    mov cmd, esi
    ret
ParseNumber endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

GetStudent proc near c uses esi, curr_cmd: dword
    mov esi, curr_cmd
    SkipSpace esi
    invoke ParseNumber, esi
    dec eax

    cmp eax, 0
    jl wrong_id
    cmp eax, 25
    jg wrong_id
    
    imul eax, StudentLen
    add eax, offset students

    ret
wrong_id:
    printf("Wrong ID\n")
    xor eax, eax
    ret
GetStudent endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

PrintStudent proc near c uses ecx ebx esi, student: dword, rank: dword
    local course_num: dword
    mov esi, student
    printf("Name\tID  ")
    mov eax, [esi+course_index]
    mov course_num, eax
    mov ecx, 1
    
print_course_label:
    push ecx
    printf("C%d  ", ecx)
    pop ecx
    inc ecx
    cmp ecx, course_num
    jle print_course_label
    printf("Total\t")

    cmp rank, -1
    je skip_rank_label
    printf("Rank\t")
skip_rank_label:
    printf("\n")

    printf("%s\t", esi)
    add esi, id_index
    printf("%s  ", esi)
    add esi, 4

    mov ecx, 1
    xor ebx, ebx
print_grade:
    add esi, 4
    push ecx
    printf("%s  ", esi)
    pop ecx
    invoke ParseNumber, esi
    add ebx, eax
    inc ecx 
    cmp ecx, course_num
    jle print_grade

    printf("%d\t", ebx)
    
    cmp rank, -1
    je skip_rank
    printf("%d\t", rank)
skip_rank:
    printf("\n")
    ret
PrintStudent endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

Calc proc near c uses ebx ecx esi, curr_cmd: dword
    local course_num: dword

    invoke GetStudent, curr_cmd
    cmp eax, 0
    je calc_ret
    invoke PrintStudent, eax, -1
    
calc_ret: 
    ret
Calc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

NewGrade proc near c uses ecx edx esi, curr_cmd: dword
    local student: dword
    local course_num: dword
    local new_grade: dword

    invoke GetStudent, curr_cmd
    cmp eax, 0
    je new_grade_ret
    mov student, eax

    mov esi, cmd
    SkipSpace esi
    invoke ParseNumber, esi
    mov new_grade, eax

    mov esi, student
    add esi, course_index
    mov eax, [esi]
    mov course_num, eax

    ; move to new courses
    mov eax, course_num
    imul eax, 4
    add esi, eax
    add esi, 4
    invoke Num2String, new_grade, esi
    
    mov esi, student
    mov ecx, course_num
    inc ecx
    mov course_index[esi], ecx
    printf("add new grade %d of %s\n", new_grade, student)
    
new_grade_ret:
    ret
NewGrade endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

SumGrades proc near c uses ebx ecx edx esi, student: dword
    xor ebx, ebx
    xor ecx, ecx
    
    mov esi, student
    mov edx, course_index[esi]
    add esi, grade0
    
sum_grades_loop:
    invoke ParseNumber, esi
    add ebx, eax
    inc ecx
    add esi, 4
    cmp ecx, edx
    jl sum_grades_loop

    mov eax, ebx
    ret
SumGrades endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

CalcTotalGrade proc near c uses ecx esi
    xor ecx, ecx
    lea esi, students    
    
calc_total_loop:
    invoke SumGrades, esi
    mov total[ecx*4], eax
    add esi, StudentLen
    inc ecx
    cmp ecx, 26
    jl calc_total_loop  
    ret
CalcTotalGrade endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

Sort proc near c uses ecx edx esi edi
    local i: dword
    local j: dword
    local temp: dword
    
    invoke CalcTotalGrade

    mov i, 1
sort_outter_loop:
    mov eax, i
    mov esi, index[eax*4]   ; curr_index
    mov ecx, total[esi*4]   ; curr_total

    mov j, eax
sort_inner_loop:
    mov eax, j
    
    dec eax     ; j-1
    mov edi, index[eax*4]   ; temp_index
    mov edx, total[edi*4]   ; temp_total

    cmp ecx, edx
    jl inner_exit
    mov eax, j
    mov index[eax*4], edi

    ; dec j and judge inner loop
    dec j
    jg sort_inner_loop
inner_exit:

    mov eax, j
    mov index[eax*4], esi

    ; inc i and judge outter loop
    inc i
    cmp i, 26
    jl sort_outter_loop

    ret
Sort endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

DisplaySorted proc near c uses ecx esi
    invoke Sort

    xor ecx, ecx
    lea esi, students
display_loop:
    mov eax, index[ecx*4]

    imul eax, StudentLen
    add eax, esi

    mov ebx, ecx
    inc ebx
    invoke PrintStudent, eax, ebx
    
    inc ecx
    cmp ecx, 26
    jl display_loop

    ret
DisplaySorted endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

main proc
    cls
    
show_help:
    printf("Usage:\n")
    printf("c ID       : calc the total grade of student at ID\n")
    printf("i ID GRADE : input the grade of new coure\n")
    printf("s          : sort by grades\n")
    printf("h          : show help\n")

main_loop:
    mov cmd, input("~ ")
    mov esi, cmd
    SkipSpace esi
    
    cmp byte ptr [esi], 'c'
    jne skip_calc
    inc esi
    invoke Calc, esi
    jmp main_loop
skip_calc:

    cmp byte ptr [esi], 'i'
    jne skip_new_grade
    inc esi
    invoke NewGrade, esi
    jmp main_loop
skip_new_grade:

    cmp byte ptr [esi], 's'
    jne skip_sort
    invoke DisplaySorted
    jmp main_loop
skip_sort:

    cmp byte ptr [esi], 'h'
    jne skip_show_help
    jmp show_help
skip_show_help:

    printf("unrecognized command!\n")
    jmp main_loop
   
    ret

main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい?

end start
