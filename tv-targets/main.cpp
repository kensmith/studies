#include <Magick++.h>
#include <cmath>
#include <cstdlib>
#include <iostream>
#include <sstream>
#include <iomanip>

/**
 * No warranty. Public domain. Don't judge the code. It is a
 * quick and dirty hack.
 */

namespace im = Magick;

const int image_height = 1080;
const int image_width = 1920;
double one_mil_subtends_px = 7.0;
static const std::string background_color = "black";
static const std::string foreground_color = "white";
static const std::string highlight_color = "green";
static const std::string alternate_color = "green";

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
    image.strokeColor(foreground_color);
    image.fillColor(foreground_color);
  }
}

void draw_target(im::Image& image, int x, int y, double moa, const std::string& color)
{
  draw_square(image, x, y, px_from_moa(moa), color);
}

void draw_calibration_image(im::Image& image)
{
  int x = 10;
  int y = 10;
  int width = 0;
  bool is_primary_color = true;
  while (y + width < image_height)
{
    if (is_primary_color)
    {
      draw_square(image, x, y, width, foreground_color);
    }
    else
    {
      draw_square(image, x, y, width, highlight_color);
    }
    is_primary_color = !is_primary_color;
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
  bool is_primary_color = true;
  while (y - px_from_moa(moa) > 0)
  {
    if (is_primary_color)
    {
      draw_target(image, x, y, moa, foreground_color);
    }
    else
    {
      draw_target(image, x, y, moa, alternate_color);
    }
    y -= 100;
    moa += 0.5;
    is_primary_color = !is_primary_color;
  }
}

int main(int argc, char* const * argv)
{
  if (argc != 2)
  {
    return 1;
  }
  one_mil_subtends_px = std::strtod(argv[1], nullptr);

  im::Image base(im::Geometry(image_width, image_height), background_color);
  base.magick("GIF");
  base.strokeAntiAlias(false);
  base.strokeColor(foreground_color);
  base.fillColor(foreground_color);
  if (one_mil_subtends_px == 0)
  {
    draw_calibration_image(base);
    base.write("calibration.gif");
  }
  else
  {
    draw_targets(base);
    std::stringstream ss;
    ss << std::setfill('0') << std::setw(2) << one_mil_subtends_px << ".gif";
    base.write(ss.str());
  }
  return 0;
}
