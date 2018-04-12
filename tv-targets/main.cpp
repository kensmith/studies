#include <Magick++.h>

namespace im = Magick;

const int height = 1080;
const int width = 1920;

void draw_vert(im::Image& image, int x, im::Color color)
{
#if 0
  for (int i = 0; i < height; ++i)
  {
    image.pixelColor(x, i, color);
  }
#else
  auto line = im::DrawableLine(x, 0, x, height);
  image.draw(line);
#endif
}

void draw_calibration_image(im::Image& image)
{
  auto black = im::Color("black");
  auto red = im::Color("red");
  auto yellow = im::Color("yellow");
  const int skip = 2;
  for (int x = 0; x < width/skip; ++x)
  {
    auto color = black;
    if (x % skip == 0)
    {
      color = yellow;
    }
    draw_vert(image, x*skip, color);
  }
}

int main()
{
  im::Image base(im::Geometry(width, height), "white");
  base.magick("GIF");
  base.strokeAntiAlias(false);
  draw_calibration_image(base);
  base.write("calibration.gif");
  return 0;
}
