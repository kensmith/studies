#ifndef __SHARED_PTR_HPP__
#define __SHARED_PTR_HPP__

#include <iostream>

template<typename T>
struct shared_ptr_t
{
    shared_ptr_t(T* t)
    : p_(t), ref_count_(new int(1))
    {}
    ~shared_ptr_t()
    {
        if (--(*ref_count_) == 0)
        {
            std::cout
                << "shared pointer deleted"
                << std::endl;
            delete p_;
            delete ref_count_;
        }
        else
        std::cout
            << "ref_count_ is "
            << *ref_count_
            << std::endl;
    }

    void show()
    {
        std::cout
            << "shared_ptr_t("
            << p_
            << ","
            << *ref_count_
            << ")"
            << std::endl;
    }

    shared_ptr_t(const shared_ptr_t& rhs)
    {
        p_ = rhs.p_;
        ref_count_ = rhs.ref_count_;
        ++(*ref_count_);
        std::cout
            << "copied, ref_count_ is " 
            << *ref_count_
            << std::endl;
    }

    shared_ptr_t& operator=(const shared_ptr_t& rhs)
    {
        if (--(*ref_count_) == 0)
        {
            std::cout
                << "assignment caused deletion"
                << std::endl;
            delete ref_count_;
            delete p_;
        }

        p_ = rhs.p_;
        ref_count_ = rhs.ref_count_;
        ++(*ref_count_);
        std::cout
            << "assignment, ref_count_ is " 
            << *ref_count_
            << std::endl;
    }

private:
    T* p_;
    int* ref_count_;
};

#endif // __SHARED_PTR_HPP__
