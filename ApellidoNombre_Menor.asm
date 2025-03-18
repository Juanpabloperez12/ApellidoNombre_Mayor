.data
mensaje_cantidad: .asciiz "Ingrese la cantidad de numeros a comparar (min 3, max 5): "
mensaje_ingreso: .asciiz "Ingrese un numero: "
mensaje_menor: .asciiz "El numero menor es: "
numeros: .space 20  # Espacio para almacenar hasta 5 enteros (5 * 4 bytes)

.text
.globl main

main:
    # Pedir la cantidad de números
    li $v0, 4
    la $a0, mensaje_cantidad
    syscall

    li $v0, 5
    syscall
    move $t0, $v0   # Guardamos la cantidad de números en $t0

    # Verificar que esté en el rango 3-5
    li $t1, 3
    li $t2, 5
    blt $t0, $t1, main
    bgt $t0, $t2, main

    # Pedir los números al usuario
    la $t3, numeros  # Dirección base del arreglo
    move $t4, $t0    # Guardamos la cantidad de números en $t4 para el bucle

pedir_numeros:
    beqz $t4, buscar_menor  # Si ya se ingresaron todos los números, buscar el menor

    li $v0, 4
    la $a0, mensaje_ingreso
    syscall

    li $v0, 5
    syscall
    sw $v0, 0($t3)  # Guardar el número en la memoria

    addi $t3, $t3, 4  # Mover al siguiente espacio en la memoria
    subi $t4, $t4, 1  # Reducir la cantidad de números restantes
    j pedir_numeros

buscar_menor:
    la $t3, numeros  # Reiniciar la dirección base
    lw $t5, 0($t3)   # Inicializar el menor con el primer número
    move $t4, $t0    # Restaurar la cantidad de números

continuar_busqueda:
    beqz $t4, imprimir_menor  # Si ya se compararon todos, imprimir el menor

    lw $t6, 0($t3)  # Cargar el número actual
    blt $t6, $t5, actualizar_menor  # Si es menor, actualizar

seguir:
    addi $t3, $t3, 4  # Pasar al siguiente número
    subi $t4, $t4, 1  # Reducir la cantidad de números restantes
    j continuar_busqueda

actualizar_menor:
    move $t5, $t6  # Actualizar el menor
    j seguir

imprimir_menor:
    li $v0, 4
    la $a0, mensaje_menor
    syscall

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 10  # Salir del programa
    syscall
