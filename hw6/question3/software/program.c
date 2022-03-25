/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/27/2022
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <delay.h>
// Declare your global variables here

int ispause = 0;
int counter = 0;

interrupt[EXT_INT2] void ext_int2_isr(void)
{
      ispause = 1 - ispause;
}

// Timer1 output compare A interrupt service routine
interrupt[TIM1_COMPA] void timer1_compa_isr(void)
{
      if (!ispause)
      {
            counter++;
            if (counter > 9)
            {
                  counter -= 10;
            }
      }
}
void main(void)
{
      DDRC = 0xFF; //output

      GICR |= 0xE0;
      MCUCR = 0x0A;
      MCUCSR = 0x00;
      GIFR = 0xE0;

      // Timer 1 config
      TCCR1A = 0x00;
      TCCR1B = 0x0C;
      TCNT1H = 0x00;
      TCNT1L = 0x00;
      ICR1H = 0x00;
      ICR1L = 0x00;
      OCR1AH = 0x7A;
      OCR1AL = 0x12;
      OCR1BH = 0x00;
      OCR1BL = 0x00;

      TIMSK = 0x12;

// Global enable interrupts
#asm("sei")

      while (1)
      {
            PORTC = counter;
      }
}
