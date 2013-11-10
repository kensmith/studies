struct foo
{
    int a;
    int b;
    int c;
    char d[25];
    double e;
    float f;
};

foo * test1()
{
    foo * f = new foo;
    return f;
}

foo * test2()
{
    foo * f = new foo();
    return f;
}

int main()
{
    foo * f1 = test1();
    foo * f2 = test2();

    delete f2;
    delete f1;
}
