#pragma once

#include <atomic>

template<typename t>
struct shared_ptr2_t
{
   shared_ptr2_t()
   :p_(nullptr)
   ,c_(nullptr)
   {
      sentinel("default construction");
   }

   shared_ptr2_t(t* p)
   :p_(p)
   ,c_(nullptr)
   {
      sentinel("init construction");
   }

   shared_ptr2_t(const shared_ptr2_t& rhs)
   :p_(rhs.p_)
   ,c_(rhs.c_)
   {
      sentinel("copy construction");
      if (!p_) return;
      if (c_ == nullptr)
      {
         ooo(iii) << "allocating c_";
         rhs.c_ = c_ = new std::atomic_int(1);
      }
      else
      {
         c_->fetch_add(1, std::memory_order_relaxed);
         show(*c_);
      }
   }

   shared_ptr2_t(shared_ptr2_t&& rhs)
   :p_(rhs.p_)
   ,c_(rhs.c_)
   {
      sentinel("move construction");
      rhs.p_ = nullptr;
   }

   ~shared_ptr2_t()
   {
      sentinel("destruction");
      if (!p_) return;
      if (!c_)
      {
         ooo(iii) << "c is null";
so_sue_me:
         delete p_;
      }
      else if (*c_ == 0)
      {
         ooo(iii) << "c reached zero";
         delete c_;
         goto so_sue_me;
      }
      else
      {
         ooo(iii) << "decrementing c";
         c_->fetch_sub(1, std::memory_order_relaxed);
         show(*c_);
      }
   }

private:
   t* p_;
   mutable std::atomic_int* c_;
   template<typename u> friend
   std::ostream& operator<<(std::ostream& lhs, const shared_ptr2_t<u>& rhs);
};

template<typename t>
std::ostream& operator<<(std::ostream& lhs, const shared_ptr2_t<t>& rhs)
{
   int ref_count = 0;
   if (rhs.c_ != nullptr)
   {
      ref_count = *rhs.c_;
   }
   lhs
      << "shared_ptr2_t("
      << std::hex
      << rhs.p_
      << ","
      << ref_count
      << ")";

   return lhs;
}
