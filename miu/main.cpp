#include <cstring>
#include <iostream>
#include <cstddef>
#include <cstdint>

#include <boost/foreach.hpp>

enum rules_t
{
    rule_1,
    rule_2,
    rule_3,
    rule_4,
};

int bit[]
{
    0x80,
    0x40,
    0x20,
    0x10,
    0x08,
    0x04,
    0x02,
    0x01
};

struct mu_t
{
    mu_t()
    {
        std::memset(mu, 0, sizeof mu);
        mu[0] = bit[0];
        length = 1;
    }

    bool solved()
    {
        for (std::size_t i = 0; i <= length / 8; i++)
        {
            if (mu[i])
            {
                return false;
            }
        }

        return true;
    }

    bool rule_1(bool do_it = false)
    {
        bool allowed = mu[length / 8] & bit[length % 8];

        if (!allowed) return false;

        if (do_it)
        {
        }

        return true;
    }

    bool rule_2(bool do_it = false)
    {
        bool allowed = length > 0;

        if (!allowed) return false;

        if (do_it)
        {
        }

        return true;
    }

    bool rule_3(bool do_it = false)
    {
        const int masks[] =
        {
            0xe0,
            0x70,
            0x0e,
            0x07
        };
        int mask_index = 0;
        if (length >= 3)
        {
            std::size_t maskings_remaining = length - 3;
            while (maskings_remaining--)
            {
                mask_index++;
                mask_index %= 4;
            }
        }
    }

    char mu[1024*128];
    std::size_t length;
};

std::ostream& operator<<(std::ostream& os, const mu_t& mu)
{
    std::cout << "m";

    std::size_t bits = mu.length;
    for (int i = 0; i <= mu.length / 8; i++)
    {
        char this_byte = mu.mu[i];
        for (int j = 0; j < 8 && bits > 0; j++, bits--)
        {
            if (this_byte & bit[0])
            {
                os << "i";
            }
            else
            {
                os << "u";
            }
        }
    }

    return os;
}

int main()
{
    mu_t mu;
    std::cout << mu << std::endl;
    while(!mu.solved())
    {
    }
    return 0;
}
