#include <tuple>
#include <iostream>

template <typename...>
struct shifted_t;

template <typename car_t, typename... cdr_t>
struct shifted_t<std::tuple<car_t, cdr_t...>>
{
   using first_type = car_t;
   using rest_type = std::tuple<cdr_t...>;
};

int main()
{
   using orig_t = std::tuple<int, bool, double>;
   using new_t = shifted_t<orig_t>::rest_type;
   new_t x = std::make_tuple(true, 2.1);
   std::cout << std::get<0>(x) << "," << std::get<1>(x) << std::endl;
   return 0;
}
