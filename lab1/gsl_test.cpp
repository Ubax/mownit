#include <stdio.h>
#include <gsl/gsl_ieee_utils.h>

int main()
{
    float base = 1.0;
    int exponent2 = 0;
    for (; exponent2 < 100; exponent2 += 20)
    {
        const float a = 1.0 / base;
        printf("1/10^%i = ", exponent2);
        gsl_ieee_printf_float(&a);
        printf("\n");
        base *= 32 * 32 * 32 * 32;
    }
    for (; exponent2 < 115; exponent2 += 4)
    {
        const float a = 1.0 / base;
        printf("1/2^%i = ", exponent2);
        gsl_ieee_printf_float(&a);
        printf("\n");
        base *= 16;
    }
    for (; exponent2 < 130; exponent2 += 1)
    {
        const float a = 1.0 / base;
        printf("1/2^%i = ", exponent2);
        gsl_ieee_printf_float(&a);
        printf("\n");
        base *= 2;
    }
    return 0;
}