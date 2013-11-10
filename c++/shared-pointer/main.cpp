#include "shared_ptr.hpp"
#include <iostream>

int main()
{
    shared_ptr_t<double> sp(new double(10.0));
    {
        shared_ptr_t<double> another = sp;
    }
    shared_ptr_t<double> yet_another(sp);
    shared_ptr_t<double> and_yet_another(NULL);
    and_yet_another = sp;
    sp.show();
    return 0;
}
