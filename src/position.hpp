#ifndef SHRUB_POSITION_H
#define SHRUB_POSITION_H
#include <string>

namespace shrub {
struct Position {
  std::string &sourceText;
  std::string filename;
  unsigned long line, column;
};
} // namespace shrub

#endif