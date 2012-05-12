#include <functional>
#include <iostream>
#include <vector>
#include <tuple>

//static_assert(sizeof(void*) == 8, u"ack\u2620");

void polymorph(int x) = delete;
void polymorph(short x) {
    std::cout << "polymorph short x = " << x << std::endl;
}

int abc;

template <int... list>
struct sum_t;

template <>
struct sum_t<>
{
    enum {value = 0};
};

template <int car, int... cdr>
struct sum_t<car, cdr...>
{
    enum {value = car + sum_t<cdr...>::value};
};

void print()
{
    std::cout << "\n";
}

template<typename T, typename... TRest>
void print(const T& car, const TRest&... cdr)
{
    std::cout << car << "\t";
    print(cdr...);
}

decltype(abc) def = 0;

namespace s = std;

template<typename T>
void f(T&& param)
{
}

class C
{
public:
    C() = default;
    void foo() = delete;
};

#if 0
/* not yet */
class Widget {
private:
    int x = 5;
};
#endif

int foo(int x)
{
    std::cout << "foo " << x << std::endl;
}

int main()
{
    std::function<void(int)> f(foo);

    auto x = 10;
    f(x);

    s::tuple<int,int> t;
    std::cout << "std::get<0>(t) = " << std::get<0>(t) << std::endl;
    ++std::get<0>(t);
    std::cout << "std::get<0>(t) = " << std::get<0>(t) << std::endl;

    const int sum = sum_t<1,2,3,4,5>::value;

    print(12, std::string{"abcd"}, 1.5, sum);

#if 0
    // not yet
    auto lamb = []{std::cout << "lambda!" << std::endl;};
    lamb();
#endif
    std::vector<int> v{1,2,3,4,5};

    polymorph(static_cast<short>(10));

    return 0;
}
