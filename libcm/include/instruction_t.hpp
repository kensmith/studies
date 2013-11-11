#pragma once

struct instruction_t
{
   virtual ~instruction_t() {}

   // I might have used typeid(i).name() but that returns an
   // implementation defined silly string.
   virtual str_t name() const = 0;
};
