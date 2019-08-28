#ifndef SHRUB_AST_H
#define SHRUB_AST_H
#include "position.hpp"
#include <optional>
#include <variant>
#include <vector>

namespace shrub {
struct TypeRefCtx {
  Position position;
  std::string name;
};

typedef std::variant<TypeRefCtx> TypeCtx;

struct ParamCtx {
  Position position;
  std::string name;
  TypeCtx type;
};

struct VarGetCtx {
  Position position;
  ParamCtx param;
};

struct IntLiteralCtx {
  Position position;
  long value;
};

typedef std::variant<VarGetCtx, IntLiteralCtx> ExprCtx;

struct BlockCtx;

struct ReturnCtx {
  Position position;
  std::optional<ExprCtx> value;
};

typedef std::variant<BlockCtx, ReturnCtx> StmtCtx;

struct BlockCtx {
  Position position;
  std::vector<StmtCtx> body;
};

struct TopLevelFnDeclCtx {
  Position position;
  TypeCtx returns;
  std::string name;
  BlockCtx body;
};

typedef std::variant<TopLevelFnDeclCtx> TopLevelCtx;

struct ProgCtx {
  Position position;
  std::vector<TopLevelCtx> top_level;
};
} // namespace shrub

#endif