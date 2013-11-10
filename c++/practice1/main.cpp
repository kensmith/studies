#include <iostream>

struct Person
{
    //virtual ~Person() = 0;
    virtual void eat() = 0;
    virtual void digest() = 0;
};

struct Student : public Person
{
    Student();
    ~Student();
    void eat();
    void digest();
private:
    bool full_;
};

Student::Student()
    : full_(false)
{
}

Student::~Student()
{
}

void Student::eat()
{
    full_ = true;
}

void Student::digest()
{
    full_ = false;
}

template<unsigned int mask>
struct generate_masks_t
{
    static void run()
    {
        std::cout << std::hex << mask << std::endl;
        generate_masks_t<mask<<1>::run();
    }
};

template<>
struct generate_masks_t<0x80000000>
{
    static void run()
    {
        std::cout << std::hex << 0x80000000 << std::endl;
    }
};


template<int n>
struct binary_t
{
    enum {value = n % 2 + binary_t<n / 10>::value * 2};
};

template<>
struct binary_t<0>
{
    enum {value = 0};
};

template<int... list>
struct sum_t;

template<>
struct sum_t<>
{
    enum {value = 0};
};

template<int car, int... cdr>
struct sum_t<car, cdr...>
{
    enum {value = car + sum_t<cdr...>::value};
};

int main()
{
    std::cout
        << "sum_t<1,2,3,4,5,6,7,8,9>::value = "
        << sum_t<1,2,3,4,5,6,7,8,9>::value
        << std::endl;

    std::cout
        << "binary_t<10000001>::value = "
        << binary_t<10000001>::value
        << std::endl;

    generate_masks_t<1>::run();

    return 0;
}
