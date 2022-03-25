#include <mega32.h>
#include <alcd.h>
#include <stdio.h>
#include <delay.h>

void response(void)
{
    DDRD .0 = 0;
    while (PIND .0 == 1)
        ;
    while (PIND .0 == 0)
        ;
    while (PIND .0 == 1)
        ;
}

void request(void)
{
    DDRD .0 = 1;
    PORTD .0 = 0;
    delay_ms(30);
    PORTD .0 = 1;
}

unsigned char reed_dht11(void)
{
    char counter_bit = 0, data = 0;
    while (counter_bit < 8)
    {
        counter_bit++;
        while (PIND .0 == 0)
            ;
        delay_us(40);
        if (PIND .0 == 1)
        {
            data = (data << 1) | (0x01);
        }
        else
        {
            data = data << 1;
        }
        while (PIND .0 == 1)
            ;
    }

    return data;
}

void main(void)
{
    char buffer[16], sum = 0, temp_int = 0, hum_int = 0, temp_dec = 0, hum_dec = 0;

    DDRB .1 = 1;
    PORTB .1 = 0;

    lcd_init(16);
    delay_ms(500);

    while (1)
    {
        request();
        response();
        hum_int = reed_dht11();
        hum_dec = reed_dht11();
        temp_int = reed_dht11();
        temp_dec = reed_dht11();
        sum = reed_dht11();

        if (hum_int + hum_dec + temp_int + temp_dec != sum)
            continue;

        sprintf(buffer, "H:%d %% ", hum_int);
        lcd_gotoxy(0, 0);
        lcd_puts(buffer);
        if (hum_int < 40 || hum_int > 60)
            PORTB .1 = 1;
        else
            PORTB .1 = 0;
    }
}
