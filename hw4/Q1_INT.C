#include <stdio.h>
#include <dos.h>

#define GET_SYSTEM_DATE 0x2A

int main()
{
    unsigned int year;
    unsigned int month;
    unsigned int day;
    union REGS inreg, outreg;
    inreg.h.ah = GET_SYSTEM_DATE;

    intdos(&inreg, &outreg);

    day = outreg.h.dl;
    month = outreg.h.dh;
    year = outreg.x.cx;

    if (month < 3 || (month == 3 && day < 21))
    {
        year -= 622;
    }
    else
    {
        year -= 621;
    }
    switch (month)
    {
    case 1:
        if (day < 21)
        {
            month = 10;
            day += 10;
        }
        else
        {
            month = 11;
            day -= 20;
        }
        break;

    case 2:
        if (day < 20)
        {
            month = 11;
            day += 11;
        }
        else
        {
            month = 12;
            day -= 19;
        }
        break;

    case 3:
        if (day < 21)
        {
            month = 12;
            day += 9;
        }
        else
        {
            month = 1;
            day -= 20;
        }
        break;

    case 4:
        if (day < 21)
        {
            month = 1;
            day += 11;
        }
        else
        {
            month = 2;
            day -= 20;
        }
        break;

    case 5:
    case 6:
        if (day < 22)
        {
            month -= 3;
            day += 10;
        }
        else
        {
            month -= 2;
            day -= 21;
        }
        break;

    case 7:
    case 8:
    case 9:
        if (day < 23)
        {
            month -= 3;
            day += 9;
        }
        else
        {
            month -= 2;
            day -= 22;
        }
        break;

    case 10:
        if (day < 23)
        {
            month = 7;
            day += 8;
        }
        else
        {
            month = 8;
            day -= 22;
        }
        break;
    case 11:
    case 12:
        if (day < 22)
        {
            month -= 3;
            day += 9;
        }
        else
        {
            month -= 2;
            day -= 21;
        }
        break;
    default:
        break;
    }

    printf("%d-%d-%d", month, day, year);
    getch();
    return 0;
}