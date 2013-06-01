.386
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
BSIZE equ 9
BSIZE2 equ 1
.data
ifmt db "%d",0
stdout dd ?
cWritten dd ?
c1_2 dd ?
c2_2 dd ?
ost dd ?
n1 dd ?
n2 dd ?
i dd 0
i2 dd 0
j dd 2
.data?
buf db BSIZE dup(?)
.code
start:
invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdout,eax
; перше повне число = 1234567898765431
; друге повне число = 5886073286297002
mov c1_2,98765431d ; друга частина першого числа
mov c2_2,86297002d ; друга частина другого числа
mov ost,0
cycl:
inc i
inc i2
cmp i,9
je whatnext
; берем останню цифру від 1 (1) числа
mov eax,c1_2
mov edx,0
mov ebx,10
div ebx ; в edx знаходиться остача
mov n1,edx ; зберігаємо остачу
; берем останню цифру від 2 (2) числа
mov eax,c2_2
mov edx,0
mov ebx,10
div ebx ; в edx знаходиться остача
mov n2,edx ; зберігаємо остачу
; додаємо дві остачі
mov eax,0
add eax,n1
add eax,n2
; додаємо остачу
add eax,ost
; заносимо "в ум"
mov edx,0
mov ebx,10
div ebx
push edx ; заносимо число
mov ost,eax ; заносимо перенос
next:
; здвигаємо числа, за допомогою ділення
mov eax,c1_2
mov edx,0
mov ebx,10
div ebx
mov c1_2,eax ; c1_2
mov eax,c2_2
mov edx,0
mov ebx,10
div ebx
mov c2_2,eax ; c2_2
jmp cycl
whatnext:
dec j
cmp j,1
je change
cycl2:
; перевряємо чи останнє число не більше 9 (перевіряємо останню остачу.. якщо 1 то пишемо на початку 1)
cmp ost,1
je show
jmp next2
show:
invoke wsprintf,ADDR buf,ADDR ifmt,ost
invoke WriteConsoleA,stdout,ADDR buf,BSIZE2,ADDR cWritten,NULL 
mov ost,0 ; присвоюємо остачі 0
next2:
dec i2
cmp i2,1
je exit
pop edx
invoke wsprintf,ADDR buf,ADDR ifmt,edx
invoke WriteConsoleA,stdout,ADDR buf,BSIZE2,ADDR cWritten,NULL 
mov edx,0
jmp cycl2
change:
; заносиму перші частини чисел
; 12345678d - перша частина першого числа,  58860732d - перша частина другого числа
mov c1_2,12345678d
mov c2_2,58860732d
; обнюляємо лічильник
mov i,0
jmp cycl
exit:
invoke ExitProcess,0
end start