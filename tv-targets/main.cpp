#include <Magick++.h>
#include <cmath>
#include <cstdlib>

namespace im = Magick;

const int image_height = 1080;
const int image_width = 1920;
const double one_mil_subtends_px = 7.0;

double minute_from_mil(double mils)
{
  double moa = mils * 3.43775;
  return moa;
}

double mil_from_minute(double moa)
{
  double mils = moa * 0.290888;
  return mils;
}

int px_from_moa(double moa)
{
  int pixels =
    static_cast<int>(
        std::round(moa * one_mil_subtends_px * .290888));
  return pixels;
}

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

void draw_target(im::Image& image, int x, int y, double moa)
{
  draw_square(image, x, y, px_from_moa(moa));
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

void draw_targets(im::Image& image)
{
  int x = image_width / 2;
  int y = image_height - 100;
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
  double one_mil_subtends_px = std::strtod(argv[1], nullptr);
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
