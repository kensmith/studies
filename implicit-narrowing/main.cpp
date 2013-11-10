#include <iostream>

int main()
{
    int x = 0xffffff;
    int y = 0xffff;
    int z = 0xff;
    char buf[4] = {x, y, z};
    for (int i = 0; i < 4; ++i)
    {
        std::cout << std::dec << "buf[" << i << "] = 0x" << std::hex << (unsigned) buf[i] << std::endl;
    }
    return 0;
}
