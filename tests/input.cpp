float x = 2.0;
int y = 1 + x++;

int main()
{
    int x = 2;
    int y = 0;
    for (int i = 0; i < 10; i++)
    {
        if (x > y)
        {
            x++;
        }
        else
        {
            y++;
        }
    }
    return x >= y;
}
