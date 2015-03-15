#include ".test.hpp"
#include <memory>

enum class minmax_choice_t {min, max};

template<typename iter_t>
auto extreme_val(iter_t b, iter_t e, minmax_choice_t choice)
{
   if (b == e)
   {
      throw std::domain_error("range must not be empty");
   }

   switch (choice)
   {
      case minmax_choice_t::min:
         return *std::min_element(b, e);
         break;

      case minmax_choice_t::max:
         return *std::max_element(b, e);
         break;
   }

   throw std::domain_error("invalid extremity");
}

TEST(extreme_val_test)
{
   auto values = {5,4,6,4,7,3,8,2,9,1};
   auto least = extreme_val(begin(values), end(values), minmax_choice_t::min);
   EQ(1, least);
   auto greatest = extreme_val(begin(values), end(values), minmax_choice_t::max);
   EQ(9, greatest);
}

struct big_t
{
   explicit big_t(int elems)
   :vec_(elems)
   {
   }
   std::vector<std::string> vec_;
};

bool operator<(const big_t& lhs, const big_t& rhs)
{
   return lhs.vec_.size() < rhs.vec_.size();
}

template<typename iter_t>
const auto& extreme_val_big(iter_t b, iter_t e, minmax_choice_t choice)
{
   if (b == e)
   {
      throw std::domain_error("range must not be empty, yo");
   }

   switch(choice)
   {
      case minmax_choice_t::min:
         return *std::min_element(b, e);
         break;
      case minmax_choice_t::max:
         return *std::max_element(b, e);
         break;
   }

   throw std::domain_error("invalid extremity");
}

TEST(extreme_val_big_test)
{
   auto values = std::vector<big_t>{big_t(1000), big_t(2000), big_t(100)};
   auto least = extreme_val_big(begin(values), end(values), minmax_choice_t::min);
   EQ(100, least.vec_.size());
}

template<typename iter_t>
decltype(auto) extreme_val_ref(iter_t b, iter_t e, minmax_choice_t choice)
{
   if (b == e)
   {
      throw std::domain_error("range must not be empty, yo");
   }

   switch(choice)
   {
      case minmax_choice_t::min:
         return *std::min_element(b, e);
         break;
      case minmax_choice_t::max:
         return *std::max_element(b, e);
         break;
   }

   throw std::domain_error("invalid extremity");
}

TEST(extreme_val_ref_test)
{
   auto values = std::vector<big_t>{big_t(1000), big_t(2000), big_t(100)};
   auto least = extreme_val_ref(begin(values), end(values), minmax_choice_t::min);
   EQ(100, least.vec_.size());
}

auto make_biggie()
{
   sentinel("");
   auto del_big_t = [](big_t* biggie)
   {
      ooo(iii) << "deleting big_t";
      delete biggie;
   };

   // can't use make_unique because make_unique doesn't
   // allow specifying the deleter
   ooo(iii)
      << "constructing biggie";
   std::unique_ptr<big_t, decltype(del_big_t)> biggie(nullptr, del_big_t);
   biggie.reset(new big_t(12345));

   return biggie;
}

TEST(test_make_biggie)
{
   auto biggie = make_biggie();
   (void) biggie;
}
