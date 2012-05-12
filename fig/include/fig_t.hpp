/**
 * @file
 */

#include <iosfwd>

/**
 * represents GIF89a data
 */
struct fig_t
{
   fig_t(int width, int height);
   friend std::ostream & operator<<(std::ostream & os, const fig_t & fig);
private:
   int width_;
   int height_;
};
