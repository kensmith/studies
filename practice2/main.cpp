#include <iostream>

template<int n>
struct binary_t
{
    enum {
        value =
            n % 2
            +
            binary_t<n / 10>::value * 2
    };
};

template<>
struct binary_t<0>
{
    enum {
        value = 0
    };
};

template<int... list>
struct sum_t;

template<int car, int... cdr>
struct sum_t<car, cdr...>
{
    enum {
        value =
            car
            +
            sum_t<cdr...>::value
    };
};

template<>
struct sum_t<>
{
    enum {
        value = 0
    };
};

template<typename T>
struct shared_ptr_t
{
    void show()
    {
        std::cout
            << "shared_ptr_t("
            << raw_ptr
            << ","
            << *ref_count
            << ")"
            << std::endl;
    }

    shared_ptr_t(T* const unmanaged_ptr)
        : raw_ptr(unmanaged_ptr), ref_count(new int(1))
    {
        show();
    }

    ~shared_ptr_t()
    {
        if (--(*ref_count) <= 0)
        {
            std::cout
                << "shared_ptr_t no longer in use"
                << std::endl;
            do_delete();
        }
        else
        {
            std::cout
                << "destructor decremented"
                << std::endl;
            show();
        }
    }

    shared_ptr_t(const shared_ptr_t& rhs)
    {
        std::cout
            << "shared_ptr_t copied"
            << std::endl;
        raw_ptr = rhs.raw_ptr;
        ref_count = rhs.ref_count;
        ++(*ref_count);
    }

    shared_ptr_t& operator=(const shared_ptr_t& rhs)
    {
        std::cout
            << "shared_ptr_t assignment"
            << std::endl;
        if (--(*ref_count) <= 0)
        {
        }
    }
private:
    void do_delete()
    {
            delete ref_count;
            delete raw_ptr;
    }
    T* raw_ptr;
    int* ref_count;
};

int main()
{
    std::cout
        << "binary_t<11110000>::value = "
        << binary_t<11110000>::value
        << std::endl;

    std::cout
        << "sum_t<1,2,3,4,5,6,7,8,9>::value = "
        << sum_t<1,2,3,4,5,6,7,8,9>::value
        << std::endl;

    shared_ptr_t<int> sp(new int(10));
    {
        shared_ptr_t<int> sp2 = sp;
    }
}
