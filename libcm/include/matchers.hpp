#pragma once

#include "matcher_t.hpp"

extern vec_t<sp_t<matcher_t>> matchers;

void sort_matchers(sp_t<matcher_t>* & m);
