#include ".test.hpp"

template<typename t, std::size_t n>
constexpr std::size_t numelems(t (&)[n]) noexcept
{
    return n;
}

TEST(basic)
{
    int arr[] = {1,2,3};
    EQ(3, numelems(arr));
    int brr[23];
    EQ(23, numelems(brr));
    int crr[numelems(brr)];
    EQ(23, numelems(crr));
}
