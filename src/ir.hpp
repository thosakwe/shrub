#ifndef SHRUB_IR_H
#define SHRUB_IR_H
#include <string>
#include <variant>
#include <vector>

namespace shrub {
namespace ir {
struct ReturnVoid {};
struct ReturnInt {
  bool isSigned;
  int sizeInBytes;
  long value;
};

typedef std::variant<ReturnVoid, ReturnInt> Instruction;
} // namespace ir
} // namespace shrub

#endif