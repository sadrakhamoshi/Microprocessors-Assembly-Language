#include <mega32.h>
#include <alcd.h>
#include <delay.h>      
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#define KEYPAD_R1 PORTD.0
#define KEYPAD_R2 PORTD.1
#define KEYPAD_R3 PORTD.2
#define KEYPAD_R4 PORTD.3
#define KEYPAD_C1 PIND.4
#define KEYPAD_C2 PIND.5
#define KEYPAD_C3 PIND.6
#define KEYPAD_C4 PIND.7

#define KEYPAD_MULTIPLY '*'
#define KEYPAD_DIVISION '/'
#define KEYPAD_ADD '+'
#define KEYPAD_MINUS '-'
#define KEYPAD_EQUAL '='
#define KEYPAD_CLEAR 'C'

#define KEYPAD_NUM0 '0'
#define KEYPAD_NUM1 '1'
#define KEYPAD_NUM2 '2'
#define KEYPAD_NUM3 '3'
#define KEYPAD_NUM4 '4'
#define KEYPAD_NUM5 '5'
#define KEYPAD_NUM6 '6'
#define KEYPAD_NUM7 '7'
#define KEYPAD_NUM8 '8'
#define KEYPAD_NUM9 '9'

unsigned char keypad_scan();

float COMPUTE(float num1, float num2, unsigned char operation) {
    switch (operation)
        {
            case KEYPAD_MULTIPLY: 
                return num1 * num2;                 
            case KEYPAD_DIVISION: 
                return num1 / num2;                
            case KEYPAD_ADD: 
                return num1 + num2;                           
            case KEYPAD_MINUS: 
                return num1 - num2;
            default: break;
        }
    return -1;
}


float num0 = 0;
float num1 = 1;
float num2 = 0;

char operation0 = KEYPAD_ADD;
char operation1 = KEYPAD_MULTIPLY;
int operation_enter = 0; 
int equal_enter = 1;
char buffer[32];

void main(void) {
    unsigned char key_res;
    DDRC = 0xFF;
    DDRD = 0x0F;
    PORTC = 0x00;

    lcd_init(16);
    lcd_clear();

    while (1) {
        key_res = keypad_scan();
        
        if (key_res != 255) {
            while (keypad_scan() != 255);
            delay_ms(20);
            
            if (key_res == KEYPAD_CLEAR) {
                lcd_clear();

                num0 = 0;
                num1 = 1;
                num2 = 0;
                operation0 = KEYPAD_ADD;
                operation1 = KEYPAD_MULTIPLY;
                operation_enter = 0;
                equal_enter = 1;
                   
            } else if (key_res == KEYPAD_EQUAL) {
                if (operation_enter != 1 && equal_enter != 1) {
                    num1 = COMPUTE(num1, num2, operation1);
                    num2 = 0;
                    num0 = COMPUTE(num0, num1, operation0);
                    num1 = 0;
                    
                    sprintf(buffer, "%.2f", num0);
                    lcd_gotoxy(0, 1);
                    lcd_puts(buffer);

                    num0 = 0;
                    num1 = 1;
                    num2 = 0;
                    operation0 = KEYPAD_ADD;
                    operation1 = KEYPAD_MULTIPLY;
                    operation_enter = 0;
                    equal_enter = 1;
                }
                
            } else if (key_res == KEYPAD_DIVISION || key_res == KEYPAD_MULTIPLY || key_res == KEYPAD_MINUS || key_res == KEYPAD_ADD) {
                if (operation_enter != 1 && equal_enter != 1) {
                    if (key_res == KEYPAD_DIVISION || key_res == KEYPAD_MULTIPLY) {
                        num1 = COMPUTE(num1, num2, operation1);
                        num2 = 0;
                        operation1 = key_res;    
                    } else {
                        num1 = COMPUTE(num1, num2, operation1);
                        num2 = 0;
                        num0 = COMPUTE(num0, num1, operation0);
                        num1 = 1;
                        operation0 = key_res;
                        operation1 = KEYPAD_MULTIPLY;
                    }
                    lcd_putchar(key_res);                    
                    operation_enter = 1;
                }
            } else {
                if (equal_enter == 1) {
                    lcd_clear();
                }
                equal_enter = 0;    
                operation_enter = 0;
                lcd_putchar(key_res);
            
                num2 *= 10;
                num2 += key_res - 48;
            }
                   
        }
    }
}

unsigned char keypad_scan() {
    unsigned char result = 255;

    ////////////////////////  ROW1 ////////////////////////
    KEYPAD_R1 = 1;
    KEYPAD_R2 = 0; 
    KEYPAD_R3 = 0; 
    KEYPAD_R4 = 0;
    
    delay_ms(5);
    if (KEYPAD_C1)
        result = KEYPAD_NUM7;
    else if (KEYPAD_C2)
        result = KEYPAD_NUM8;
    else if (KEYPAD_C3)
        result = KEYPAD_NUM9;
    else if (KEYPAD_C4)
        result = KEYPAD_DIVISION;
        

    ////////////////////////  ROW2 ////////////////////////
    KEYPAD_R1 = 0;
    KEYPAD_R2 = 1; 
    KEYPAD_R3 = 0;
    KEYPAD_R4 = 0;
    
    delay_ms(5);
    if (KEYPAD_C1)
        result = KEYPAD_NUM4;
    else if (KEYPAD_C2)
        result = KEYPAD_NUM5;
    else if (KEYPAD_C3)
        result = KEYPAD_NUM6;
    else if (KEYPAD_C4)
        result = KEYPAD_MULTIPLY;
    ////////////////////////  ROW3 ////////////////////////
    KEYPAD_R1 = 0;
    KEYPAD_R2 = 0;
    KEYPAD_R3 = 1;
    KEYPAD_R4 = 0;
    
    delay_ms(5);
    if (KEYPAD_C1)
        result = KEYPAD_NUM1;
    else if (KEYPAD_C2)
        result = KEYPAD_NUM2;
    else if (KEYPAD_C3)
        result = KEYPAD_NUM3;
    else if (KEYPAD_C4)
        result = KEYPAD_MINUS;
    ////////////////////////  ROW4 ////////////////////////
    KEYPAD_R1 = 0;
    KEYPAD_R2 = 0;
    KEYPAD_R3 = 0;
    KEYPAD_R4 = 1;
    
    delay_ms(5);
    if (KEYPAD_C1)
        result = KEYPAD_CLEAR;
    else if (KEYPAD_C2)
        result = KEYPAD_NUM0;
    else if (KEYPAD_C3)
        result = KEYPAD_EQUAL;
    else if (KEYPAD_C4)
        result = KEYPAD_ADD;

    return result;
}
