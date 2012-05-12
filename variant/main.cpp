#include <string>
#include <boost/variant.hpp>

typedef boost::variant<
    int,
    std::string
> var_t;

int main()
{
    var_t v = 0;
    v = "hi";
}
