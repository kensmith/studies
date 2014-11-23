#include ".test.hpp"

struct thing_t
{
    void go() &
    {
        ooo(iii)
            << "go called with lvalue reference";
    }
#if 1
    void go() &&
    {
        ooo(iii)
            << "go called with rvalue reference";
    }
#endif
};

TEST(basic)
{
#if 1
    thing_t thing;
    thing.go();
    thing_t().go();
#endif
}
