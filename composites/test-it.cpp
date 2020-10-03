#include ".test.hpp"
#include <cstdint>
#include <cmath>

static const int64_t highly_composite[] = {
  // 83160
  // 16.34 bits
  2LL*3*4*5*7*9*11,

  // 18378360
  // 24.13 bits
  2LL*3*4*5*7*9*11*13*17,

  // 349188840
  // 28.38 bits
  2LL*3*4*5*7*9*11*13*17*19,

  // sweet spot
  // 8031343320
  // 32.90 bits
  2LL*3*4*5*7*9*11*13*17*19*23,

  // 232908956280
  // 37.76 bits
  2LL*3*4*5*7*9*11*13*17*19*23*29,

  // 7220177644680
  // 42.72 bits
  2LL*3*4*5*7*9*11*13*17*19*23*29*31,

  // 267146572853160
  // 47.92 bits
  2LL*3*4*5*7*9*11*13*17*19*23*29*31*37,

  // 10953009486979560
  // 53.28 bits
  2LL*3*4*5*7*9*11*13*17*19*23*29*31*37*41,

  // 470979407940121080
  // 58.71 bits
  2LL*3*4*5*7*9*11*13*17*19*23*29*31*37*41*43,
};

static constexpr double epsilon = 0.00000001;

static constexpr bool is_zeroish(double val)
{
  return std::abs(val) < epsilon;
}

TEST(basic)
{
  for (auto shards: highly_composite)
  {
    int64_t prev = 0;
    int64_t max_jump = 0;
    const int64_t max_iter = 100000;
    int64_t iters = std::min(max_iter, shards);
    ooo(iii) << "composite: " << shards;
    for (int step = 1; step <= iters; step++)
    {
      double div = static_cast<double>(shards) / step;
      double rounded = std::round(div);
      double distance = std::abs(div - rounded);

      if (is_zeroish(distance))
      {
        int64_t jump = step - prev;
        double pct_increase = 100.0 * jump / step;
        ooo(iii)
          << "shards<" << shards << "> "
          << "step<" << step << "> "
          << "jump<" << jump << "> "
          << std::fixed << "increase<" << pct_increase << "%> "
          << 3000 * step;
        prev = step;
        max_jump = std::max(jump, max_jump);
      }
    }
    double bits_required = std::log(shards * 1.0) / std::log(2.0);
    bits_required = std::ceil(bits_required);
    ooo(iii)
      << "shards<" << shards << "> "
      << "bits<" << bits_required << "> "
      << "max_jump<" << max_jump << "> ";
  }
}
