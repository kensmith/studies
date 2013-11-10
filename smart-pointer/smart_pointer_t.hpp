#pragma once

template <typename t>
struct smart_pointer_t
{
   smart_pointer_t(t* instance)
      :instance_(instance)
      ,reference_count_(new int(1))
   {
   }

   void cleanup()
   {
      delete instance_;
      instance_ = nullptr;
      *reference_count_ = 0;
      delete reference_count_;
      reference_count_ = 0;
   }

   ~smart_pointer_t()
   {
      --*reference_count_;
      if (*reference_count_ <= 0)
      {
         cleanup();
      }
   }

   smart_pointer_t(smart_pointer_t& rhs)
   {
      reference_count_ = rhs.reference_count_;
      ++*reference_count_;
      instance_ = rhs.instance_;
   }

   smart_pointer_t& operator=(smart_pointer_t& rhs)
   {
      if (*reference_count_ > 0)
      {
         --*reference_count_;
         if (*reference_count_ <= 0)
         {
            cleanup();
         }
      }
      reference_count_ = rhs.reference_count_;
      ++*reference_count_;
      instance_ = rhs.instance_;
      return *this;
   }

   int reference_count() const
   {
      return *reference_count_;
   }

   t* operator->()
   {
      return instance_;
   }
private:
   t* instance_;
   int* reference_count_;
};
