#ifndef SHRUB_SCANNER_H
#define SHRUB_SCANNER_H
#include <lexer.hpp>

namespace shrub {
  class Scanner {
    public:
      Scanner();
      ~Scanner();
    private:
      int flex_scan();
      void *yyscanner;
  };    
}

#endif
