#include ".test.hpp"

auto create_init_list()
{
#if 0
    return {1, 2, 3};
#else
    return std::initializer_list<int>{1, 2, 3};
#endif
}

TEST(basic)
{
    auto l = create_init_list();
    (void)l;
}
