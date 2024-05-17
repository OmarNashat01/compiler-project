int x;
int y = 0;
const int width = 800;

int h = x + y;
bool t = x > y;

int test()
{
    int x = 2;
    int y;
    while (x == 0)
    {
        y = 0;
        while (y < 20)
        {
            y = y + 1;
        }
        x = x + 1;
    }
    for (int i = 0; i < 10; i++)
    {
        x = x + 1;
    }
    return x + y;
}
char func(char a, int b, bool x, float y)
{
    int z = 0;
    // int z;
    int a = 1;
    int b = 2;
    if (x > 0)
    {
        z = a + b;
    }
    else
    {
        z = a - b;
    }
    do
    {
        z = z + 1;
    } while (z < 10);
    return 't';
}
bool test2()
{
    int x = 1;
    switch (x)
    {
    case 1:
    {
        x = 1;
    }
    case 2:
    {
        x = 2;
    }
    }
    return true;
}

int main()
{
    {
        int a = 0;
        int b = 1;
        bool x = true;
        float y = 1.0;
    }
    return 0;
}
char s;
int f;
bool m;
float n;
char z = func(s, f, m, n);
