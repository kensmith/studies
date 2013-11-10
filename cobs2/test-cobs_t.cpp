#include ".test.hpp"
#include "cobs_t.hpp"

TEST(basic)
{
   std::vector<uint8_t> sample = {'\x00'};
   cobs_t::encode(sample);
   std::vector<uint8_t> expected{'\x01'};
   EQC(expected, sample);
}

TEST(only_zeros)
{
   std::vector<uint8_t> sample = {'\x00','\x00','\x00',};
   cobs_t::encode(sample);
   std::vector<uint8_t> expected{'\x01','\x01','\x01',};
   EQC(expected, sample);
}

TEST(basic_examples_from_the_paper_1)
{
   std::vector<uint8_t> sample = {'x','\x00',};
   cobs_t::encode(sample);
   std::vector<uint8_t> expected{'\x02', 'x'};
   EQC(expected, sample);
}

TEST(basic_examples_from_the_paper_2)
{
   std::vector<uint8_t> sample = {'x','y','\x00',};
   cobs_t::encode(sample);
   std::vector<uint8_t> expected{'\x03', 'x', 'y'};
   EQC(expected, sample);
}

TEST(basic_examples_from_the_paper_3)
{
   std::vector<uint8_t> sample =
      {'H','e','l','l','o',' ',
       'W','o','r','l','d','\x00',};
   cobs_t::encode(sample);
   std::vector<uint8_t> expected =
      {'\xc','H','e','l','l','o',' ',
       'W','o','r','l','d'};
   EQC(expected, sample);
}

TEST(extended_examples_from_the_paper_4)
{
   std::vector<uint8_t> sample =
   {'\x45','\x0','\x0','\x2c','\x4c','\x79','\x0','\x0',
    '\x40','\x6','\x4f','\x37'};
   cobs_t::encode(sample);
   std::vector<uint8_t> expected =
   {
      '\x2','\x45','\x1','\x4','\x2c','\x4c','\x79',
      '\x1','\x5','\x40','\x6','\x4f','\x37'
   };
   EQC(expected, sample);
}

TEST(extended_examples_from_the_paper_4_augmented)
{
   std::vector<uint8_t> sample =
   {'\x45','\x0','\x0','\x2c','\x4c','\x79','\x0','\x0',
    '\x40','\x6','\x4f','\x37','\x0'};
   cobs_t::encode(sample);
   std::vector<uint8_t> expected =
   {
      '\x2','\x45','\x1','\x4','\x2c','\x4c','\x79',
      '\x1','\x5','\x40','\x6','\x4f','\x37',
   };
   EQC(expected, sample);
}

TEST(ff_encoding)
{
   std::vector<uint8_t> sample;
   for (uint8_t i = 1; i < 255; i++)
   {
      sample.push_back(i);
   }
   cobs_t::encode(sample);
   std::vector<uint8_t> expected;
   expected.push_back(0xff);
   for (uint8_t i = 1; i < 255; i++)
   {
      expected.push_back(i);
   }
   EQC(expected, sample);
}

TEST(one_kilobyte_message)
{
   std::vector<uint8_t> sample;
   for (int i = 0; i < 1024; i++)
   {
      sample.push_back(1);
   }
   cobs_t::encode(sample);
   std::vector<uint8_t> expected;
   for (int i = 0; i < 4; i++)
   {
      expected.push_back(0xff);
      for (uint8_t j = 1; j < 254; j++)
      {
         expected.push_back(1);
      }
   }
   expected.push_back(9);
   for (int i = 0; i < 8; i++)
   {
      expected.push_back(1);
   }
   EQC(expected, sample);
}
