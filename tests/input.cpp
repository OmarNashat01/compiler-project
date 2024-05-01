int x;
int y = 0;
// const int width = 800;
int test() {
    while (x == 0) {
        y = 0; 
        while (y < 20) {
            y = y + 1;
        } x = x + 1;
    } 
    return x >= y;
}
char func(int a, int b, bool x, float y) {
    int z = 0;
    if (x > 0) {
        z = a + b; 
    }
    else
    { 
        z = a - b;
    }
    do {
        z = z + 1;
    } while (z < 10);
    return z;
}
bool test2() {
    switch (x) {
        case 1: {
            x = 1;
            break;
        }
        case 2:{
            x = 2;
            break;
        }
        default:{
            x = 0;
        }
    }
    return true;
}

int main() {
    {
        int a = 0;
        int b = 1;
        bool x = true;
        float y = 1.0;
        char z = func(a, b, x, y);
    }
    return 0;
}
