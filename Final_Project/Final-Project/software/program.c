/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/26/2022
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
#include <stdio.h>
#include <mega32.h>

#include <delay.h>

// Alphanumeric LCD functions
#include <alcd.h>

//#include <avr/io.h>		/* Include AVR std. library file */
// Declare your global variables here

// Voltage Reference: Int., cap. on AREF
#define ADC_VREF_TYPE ((1 << REFS1) | (1 << REFS0) | (0 << ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
      ADMUX = adc_input | ADC_VREF_TYPE;
      // Delay needed for the stabilization of the ADC input voltage
      delay_us(10);
      // Start the AD conversion
      ADCSRA |= (1 << ADSC);
      // Wait for the AD conversion to complete
      while ((ADCSRA & (1 << ADIF)) == 0)
            ;
      ADCSRA |= (1 << ADIF);
      return ADCW;
}

void _turn_on_heater(int delay)
{
      PORTD = 0x90;
      delay_ms(100);
      PORTD = 0x80;
      delay_ms(delay);
      PORTD = 0xC0;
      delay_ms(delay);
      PORTD = 0x40;
      delay_ms(delay);
      PORTD = 0x60;
      delay_ms(delay);
      PORTD = 0x20;
      delay_ms(delay);
      PORTD = 0x30;
      delay_ms(delay);
      PORTD = 0x10;
      delay_ms(delay);
}

void turn_on_cooler(int delay)
{
      PORTD = 0x09;
      delay_ms(delay);
      PORTD = 0x08;
      delay_ms(delay);
      PORTD = 0x0C;
      delay_ms(delay);
      PORTD = 0x04;
      delay_ms(delay);
      PORTD = 0x06;
      delay_ms(delay);
      PORTD = 0x02;
      delay_ms(delay);
      PORTD = 0x03;
      delay_ms(delay);
      PORTD = 0x01;
      delay_ms(delay);
}

void main(void)
{
      // Declare your local variables here
      unsigned int temperature;
      char output[8];
      int state = 1;
      int delay = 900;

      DDRD = 0xFF; //Make PortD output
      PORTD = 0;
      // ADC initialization
      // ADC Clock frequency: 1000.000 kHz
      // ADC Voltage Reference: Int., cap. on AREF
      // ADC Auto Trigger Source: ADC Stopped
      ADMUX = ADC_VREF_TYPE;
      ADCSRA = (1 << ADEN) | (0 << ADSC) | (0 << ADATE) | (0 << ADIF) | (0 << ADIE) | (0 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
      SFIOR = (0 << ADTS2) | (0 << ADTS1) | (0 << ADTS0);

      // Alphanumeric LCD initialization
      // Connections are specified in the
      // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
      // RS - PORTC Bit 0
      // RD - PORTC Bit 1
      // EN - PORTC Bit 2
      // D4 - PORTC Bit 4
      // D5 - PORTC Bit 5
      // D6 - PORTC Bit 6
      // D7 - PORTC Bit 7
      // Characters/line: 16
      lcd_init(16);
      lcd_clear();
      delay_ms(500);

      lcd_gotoxy(1, 0);
      lcd_puts("LM35 Sensor");

      while (1)
      {
            // Place your code here
            temperature = read_adc(0) / 4;
            snprintf(output, 8, "%d", temperature);
            lcd_gotoxy(1, 1);
            lcd_puts("Temp: ");
            lcd_puts(output);
            if (temperature < 100)
                  lcd_puts(" ");

            lcd_gotoxy(10, 1);
            lcd_putchar(0xDF);
            lcd_putchar('c');
            switch (state)
            {
            case 1:
                  if (temperature > 35)
                  {
                        state = 21;
                  }
                  if (temperature < 15)
                  {
                        state = 3;
                  }
                  break;
            case 21:
                  if (temperature < 25)
                  {
                        state = 1;
                  }
                  if (temperature > 40)
                  {
                        state = 22;
                  }
                  break;
            case 22:
                  if (temperature < 35)
                  {
                        state = 21;
                  }
                  if (temperature > 45)
                  {
                        state = 23;
                  }
                  break;
            case 23:
                  if (temperature < 40)
                  {
                        state = 22;
                  }
                  break;
            case 3:
                  if (temperature > 30)
                  {
                        state = 1;
                  }
                  break;
            }
            switch (state)
            {
            case 21:
                  turn_on_cooler(delay / 2);
                  break;
            case 22:
                  turn_on_cooler(delay / 6);
                  break;
            case 23:
                  turn_on_cooler(delay / 10);
                  break;
            case 3:
                  _turn_on_heater(100);
                  break;
            }
      }
      /* Set period in between two steps */
      while (1)
      {
      }
}