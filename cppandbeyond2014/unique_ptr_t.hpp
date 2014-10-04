#pragma once

template<typename t>
struct unique_ptr_t
{
   unique_ptr_t()
   :p_(nullptr)
   {
      sentinel("default construction");
   }

   unique_ptr_t(t* p)
   :p_(p)
   {
      sentinel("initializing construction");
   }

   unique_ptr_t(const unique_ptr_t& rhs) = delete;
   unique_ptr_t& operator=(const unique_ptr_t& rhs) = delete;

   unique_ptr_t(unique_ptr_t&& rhs)
   :p_(rhs.p_)
   {
      sentinel("move assignment");
      rhs.p_ = nullptr;
   }

   ~unique_ptr_t()
   {
      sentinel("destructor");
      delete p_;
      p_ = nullptr;
   }
private:
   mutable t* p_;
   template<typename u>
   friend std::ostream& operator<<(std::ostream& lhs, const unique_ptr_t<u>& rhs);
};

template<typename t>
std::ostream& operator<<(std::ostream& lhs, const unique_ptr_t<t>& rhs)
{
   lhs
      << "unique_ptr_t("
      << std::hex
      << rhs.p_
      << ")";

   return lhs;
}
