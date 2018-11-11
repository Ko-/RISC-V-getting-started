#include <stdio.h>

extern int power(int x, int e);

int main(void)
{
    int a = power(3, 5); // should be 3 ** 5 = 243

    printf("3 ** 5 = %d.\n", a);

    return 0;
}

