#include <vector>
#include <iostream>
#include <set>

#include <boost/foreach.hpp>

struct mu_t
{
    mu_t()
    {
        string.push_back(1);
    }

    std::set<int> applicable_rules()
    {
        std::set<int> rules;
        std::vector<bool>::const_iterator i = string.end();
        --i;
        if (*i)
        {
            rules.push_back(1);
        }
        if (string.size() > 1)
        {
            rules.push_back(2);
        }
        if 
    }

    void apply(int rule);
    friend std::ostream& operator<<(std::ostream& os, const mu_t& mu);
private:
    std::vector<bool> string;
};

std::ostream& operator<<(std::ostream& os, const mu_t& mu)
{
    os << "m";

    BOOST_FOREACH(bool b, mu.string)
    {
        if (b)
        {
            os << "i";
        }
        else
        {
            os << "u";
        }
    }

    return os;
}

int main()
{
    mu_t mu;

    std::cout << "mu = " << mu << std::endl;

    return 0;
}
