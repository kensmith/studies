#include ".test.hpp"

#if 0 // gcc 4.9.1 apparently not ready
template<typename T>
constexpr T pi = T(3.1415926535897932385);

TEST(canoncial_pi)
{
   //auto x = pi<float> * 1.0f;
}
#endif
