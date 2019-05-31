#ifndef SHRUB_AST_HPP
#define SHRUB_AST_HPP
#include <memory>
#include <string>

namespace shrub {
  struct SourceLocation {
    std::string sourceUrl;
    unsigned long line, column;
  };

  class AstNode {};

  class TypeNode : public AstNode {};

  class ExprNode : public AstNode {
    
  };

  struct IdNode : public ExprNode {
    
  };

  class TopLevelNode : public AstNode {};

  class TypedefNode : public TopLevelNode {};

  struct ProgNode : public AstNode {
    d::vector<std::unique_ptr<TopLevelNode>> topLevel;
  };
}

#endif
