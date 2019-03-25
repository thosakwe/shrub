#include "scanner.hpp"

shrub::Scanner::Scanner() {
  shrub_flex_lex_init(&yyscanner);
}

shrub::Scanner::~Scanner() {
 shrub_flex_lex_destroy(yyscanner);
}
