#include <Magick++.h>
#include <cmath>
#include <cstdlib>
#include <iostream>

/**
 * No warranty. Public domain. Don't judge the code. It is a
 * quick and dirty hack.
 */

namespace im = Magick;

const int image_height = 1080;
const int image_width = 1920;
double one_mil_subtends_px = 7.0;

int px_from_moa(double moa)
{
  int pixels =
    static_cast<int>(
        std::round(moa * one_mil_subtends_px * .290888));
  return pixels;
}

void draw_square(im::Image& image, int x, int y, int width, im::Color color)
{
  if (width == 0)
  {
    image.pixelColor(x, y, color);
  }
  else
  {
    auto square = im::DrawableRectangle(x, y, x+width, y+width);
    image.strokeColor(color);
    image.fillColor(color);
    image.draw(square);
    image.strokeColor("black");
    image.fillColor("black");
  }
}

void draw_target(im::Image& image, int x, int y, double moa)
{
  draw_square(image, x, y, px_from_moa(moa), "black");
}

void draw_calibration_image(im::Image& image)
{
  int x = 10;
  int y = 10;
  int width = 0;
  while (y + width < image_height)
  {
    im::Color color{"black"};
    if (fabs(static_cast<double>(width) - one_mil_subtends_px) < 0.25)
    {
      color = im::Color("red");
    }
    draw_square(image, x, y, width, color);
    x += width+1;
    y += width+1;
    ++width;
  }
}

void draw_targets(im::Image& image)
{
  int x = image_width / 2;
  int y = image_height * 3 / 4;
  double moa = 0.5;
  while (y - px_from_moa(moa) > 0)
  {
    draw_target(image, x, y, moa);
    y -= 100;
    moa += 0.5;
  }
}

int main(int argc, char* const * argv)
{
  if (argc != 2)
  {
    return 1;
  }
  one_mil_subtends_px = std::strtod(argv[1], nullptr);

  im::Image base(im::Geometry(image_width, image_height), "white");
  base.magick("GIF");
  base.strokeAntiAlias(false);
  base.strokeColor("black");
  base.fillColor("black");
  draw_calibration_image(base);
  draw_targets(base);
  base.write("calibration.gif");
  return 0;
}
