#include ".test.hpp"
#include <vector>

template<typename container_t, typename index_t>
decltype(auto) elem_at(container_t& c, index_t i)
{
    return c[i];
}

template<typename container_t, typename index_t>
auto byvalue_elem_at(container_t& c, index_t i)
{
    return c[i];
}

template<typename container_t, typename index_t>
decltype(auto) elem_at_refined(container_t&& c, index_t i)
{
    return c[i];
}

template<typename container_t, typename index_t>
decltype(auto) elem_at_final(container_t&& c, index_t i)
{
    return std::forward<container_t>(c)[i];
}

TEST(basic)
{
    std::vector<int> vs{1,2,3};
    for (decltype(auto) e : vs)
    {
#if 0
        showt(e);
        //decltype(e) x = 1.0;
        // error: non-const lvalue reference to type 'int'
        // cannot bind to a temporary of type 'double'
        // hooray for decltype(auto)
        // (until we get c++1z for(e:vs)
#else
        decltype(e) x = e;
        ooo(iii) << x;
#endif
    }

#if 0
    byvalue_elem_at(vs, 1) = 5; // doesn't compile because
    // referenceness of c[i] is lost in auto type deduction
#else
    elem_at(vs, 1) = 5; // yay!
    EQ(5, vs[1]);
#endif

#if 0
    elem_at(std::vector<int>{4,5,6}, 2);
#else
    ooo(iii) << elem_at_refined(std::vector<int>{4,5,6}, 2);
    elem_at_refined(vs, 0) = 10;
    EQ(10, vs[0]);
#endif

#if 0
    elem_at(std::vector<int>{4,5,6}, 2);
#else
    ooo(iii) << elem_at_final(std::vector<int>{4,5,6}, 0);
    elem_at_final(vs, 2) = 20;
    EQ(20, vs[2]);
#endif
}
