#include <iostream>
#include <iomanip>
#include <cmath>
#include <boost/lexical_cast.hpp>

long fact(long x)
{
    if (x == 0) return 1;
    return x * fact(x - 1);
}

int main(int argc, char ** argv)
{
    if (argc != 2)
    {
        std::cout
            << "usage:\n"
            << "\t" << argv[0] << " <number of iterations>"
            << std::endl;

        return 1;
    }
    const double coef = 2 * std::sqrt(2) / 9801;
    const int iters = boost::lexical_cast<long>(argv[1]);
    if (iters < 1)
    {
        std::cout
            << "error: iters must be positive, is "
            << iters
            << std::endl;
    }
    double sum = 0.0;
    for (long i = 0; i < iters; i++)
    {
        double t1 = fact(4*i);
        std::cout << "t1 = " << t1 << std::endl;
        long t2 = 1103 + 26390*i;
        double t3 = std::pow(fact(i), 4.0);
        double t4 = std::pow(396.0, 4.0*i);
        sum += (t1*t2)/(t3*t4);
    }
    double pi_inv = coef * sum;
    double pi = 1.0 / pi_inv;

    std::cout
        << "pi = "
        << std::setprecision(100)
        << std::fixed
        << pi
        << std::endl;
}
