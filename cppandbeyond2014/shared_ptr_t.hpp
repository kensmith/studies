#pragma once

#include <atomic>

template <typename t>
struct shared_ptr_t
{
   shared_ptr_t()
   :p_(nullptr)
   ,c_(nullptr)
   {}

   shared_ptr_t(t* p)
   :p_(p)
   ,c_(nullptr)
   {}

   shared_ptr_t(const shared_ptr_t& rhs)
   :p_(rhs.p_)
   ,c_(rhs.c_)
   {
      if (!p_) return;
      if (!c_)
      {
         c_ = rhs.c_ = new std::atomic_int(2);
      }
      else
      {
         c_->fetch_add(1, std::memory_order_relaxed);
      }
   }
   shared_ptr_t(shared_ptr_t&& rhs)
   :p_(rhs.p_)
   ,c_(rhs.c_)
   {
      rhs.p_ = nullptr;
   }

   ~shared_ptr_t()
   {
      ooo(iii)
         << "deleting shared ptr";
      if (!c_)
      {
so_sue_me:
         ooo(iii)
            << "returning memory";
         delete p_;
      }
      else if (*c_ == 1)
      {
         delete c_;
         goto so_sue_me;
      }
      else
      {
         c_->fetch_sub(1, std::memory_order_relaxed);
         ooo(iii)
            << "new ref count is "
            << *c_;
      }
   }
private:
   t* p_;
   mutable std::atomic_int* c_;

   template <typename u>
   friend std::ostream& operator<<(std::ostream& lhs, const shared_ptr_t<u>& rhs);
};

template <typename t>
std::ostream& operator<<(std::ostream& lhs, const shared_ptr_t<t>& rhs)
{
   int ref_count = 1;
   if (rhs.c_)
   {
      ref_count = *rhs.c_;
   }

   lhs
      << "shared_ptr_t("
      << std::hex
      << std::ptrdiff_t(rhs.p_)
      << std::dec
      << ","
      << ref_count
      << ")";

   return lhs;
}
