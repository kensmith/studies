#include <Magick++.h>

namespace im = Magick;

const int height = 1080;
const int width = 1920;

void draw_vert(im::Image& image, int x, im::Color color)
{
  for (int i = 0; i < height; ++i)
  {
    image.pixelColor(x, i, color);
  }
}

int main()
{
  im::Image base(im::Geometry(width, height), "white");
  base.magick("GIF");
  auto black = im::Color("black");
  auto red = im::Color("red");
  for (int x = 0; x < width/5; ++x)
  {
    auto color = black;
    if (x % 5 == 0)
    {
      color = red;
    }
    draw_vert(base, x*5, color);
  }
  base.write("calibration.gif");
  return 0;
}
