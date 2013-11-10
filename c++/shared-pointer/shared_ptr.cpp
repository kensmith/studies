#include "shared_ptr.hpp"

template<typename T>
shared_ptr_t::shared_ptr_t(T* t)
    : p_(t), ref_count_(new int(1))
{
}

template<typename T>
shared_ptr_t::~shared_ptr_t()
{
    if (--(*ref_count_) == 0)
    {
        delete p_;
    }
}

template <typename T>
std::ostream& operator<<(std::ostream os, const shared_ptr_t<T>& sp);
{
    os << std::hex << sp<T>.p_ << "," << sp<T>.ref_count_;
    return os;
}
