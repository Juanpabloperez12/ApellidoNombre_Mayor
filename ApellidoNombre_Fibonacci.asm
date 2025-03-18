.data
mensaje_cantidad: .asciiz "Ingrese la cantidad de numeros de la serie Fibonacci a generar (min 3, max 5): "
mensaje_ingreso: .asciiz "Ingrese un numero: "
mensaje_fibo: .asciiz "Serie Fibonacci: "
mensaje_suma: .asciiz "\nSuma de la serie: "
espacio: .asciiz " "
newline: .asciiz "\n"
numeros: .align 2  # Asegurar que la memoria esté alineada en palabras de 4 bytes
buffer: .space 20  # Espacio para almacenar hasta 5 números (5 * 4 bytes)

.text
.globl main

main:
    # Pedir al usuario la cantidad de números de la serie
    li $v0, 4
    la $a0, mensaje_cantidad
    syscall

    li $v0, 5
    syscall
    move $t0, $v0   # Guardamos la cantidad en $t0

    # Validar que el número ingresado esté entre 3 y 5
    li $t1, 3
    li $t2, 5
    blt $t0, $t1, main  # Si es menor que 3, volver a pedir
    bgt $t0, $t2, main  # Si es mayor que 5, volver a pedir

    # Pedir los números al usuario
    move $t3, $t0   # Copia de la cantidad a ingresar
    la $t4, buffer  # Apuntador al array correctamente alineado

pedir_numeros:
    beqz $t3, procesar_fibonacci  # Si ya ingresamos todos los números, continuar

    # Mostrar mensaje de ingreso
    li $v0, 4
    la $a0, mensaje_ingreso
    syscall

    # Leer número ingresado
    li $v0, 5
    syscall
    sw $v0, 0($t4)   # Guardar número en memoria correctamente alineada

    addi $t4, $t4, 4  # Mover al siguiente espacio en el array (alineado)
    subi $t3, $t3, 1  # Reducir el contador
    j pedir_numeros

procesar_fibonacci:
    # Mostrar mensaje de la serie
    li $v0, 4
    la $a0, mensaje_fibo
    syscall

    # Inicializar valores
    move $t3, $t0   # Reiniciar contador
    la $t4, buffer  # Apuntar al inicio del array correctamente alineado
    li $t5, 0       # Suma total

imprimir_fibonacci:
    beqz $t3, imprimir_suma  # Si ya imprimimos todos los números, pasar a la suma

    lw $t6, 0($t4)  # Cargar el número desde la memoria correctamente alineada

    # Imprimir número
    li $v0, 1
    move $a0, $t6
    syscall

    # Agregar espacio
    li $v0, 4
    la $a0, espacio
    syscall

    # Acumular en la suma total
    add $t5, $t5, $t6

    # Avanzar en la memoria correctamente alineada
    addi $t4, $t4, 4
    subi $t3, $t3, 1
    j imprimir_fibonacci

imprimir_suma:
    # Mostrar mensaje de suma
    li $v0, 4
    la $a0, mensaje_suma
    syscall

    # Imprimir la suma total
    li $v0, 1
    move $a0, $t5
    syscall

    # Salto de línea final
    li $v0, 4
    la $a0, newline
    syscall

    # Salir del programa
    li $v0, 10
    syscall
