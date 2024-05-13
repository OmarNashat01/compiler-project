int main ()
{
    int x = 2;
    int y = 0;
    const int width = 800;
    for (int i = 0; i < width; i++) {
        x = 0;
        y++;
    }
    return x >= y;
}
