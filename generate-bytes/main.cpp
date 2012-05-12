#include <iostream>
#include <boost/lexical_cast.hpp>

int main(int argc, char** argv)
{
    if (argc != 2)
    {
        std::cerr << argv[0] << " <iters>"
            << std::endl;
        return 1;
    }
    int iters = boost::lexical_cast<int>(argv[1]);
    for (int i = 0; i < iters; i++)
    {
        for (int j = 0; j < 256; j++)
        {
            char c = static_cast<char>(j);
            std::cout << c;
        }
    }
    std::cout.flush();
    return 0;
}
