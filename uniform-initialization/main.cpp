#include <list>
#include <iostream>
#include <unordered_map>

int main()
{
    auto f = [](){};
    std::list<const char*> l{"1", "2", "3"};
    std::unordered_map<int, const char*> m{{1, "yo"}, {2, "bye"}};

    for (auto s: l)
    {
        std::cout
            << "s = "
            << s
            << std::endl;
    }

    for (auto p: m)
    {
        std::cout
            << "p: "
            << p.first
            << " = "
            << p.second
            << std::endl;
    }

    return 0;
}
