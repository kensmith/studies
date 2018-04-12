#include <Magick++.h>

namespace im = Magick;

const int image_height = 1080;
const int image_width = 1920;

void draw_square(im::Image& image, int x, int y, int width)
{
  if (width == 0)
  {
    image.pixelColor(x, y, "black");
  }
  else
  {
    auto square = im::DrawableRectangle(x, y, x+width, y+width);
    image.draw(square);
  }
}

void draw_calibration_image(im::Image& image)
{
  int x = 10;
  int y = 10;
  int width = 0;
  while (y + width < image_height)
  {
    draw_square(image, x, y, width);
    x += width+1;
    y += width+1;
    ++width;
  }
}

int main()
{
  im::Image base(im::Geometry(image_width, image_height), "white");
  base.magick("GIF");
  base.strokeAntiAlias(false);
  base.strokeColor("black");
  base.fillColor("black");
  draw_calibration_image(base);
  base.write("calibration.gif");
  return 0;
}
