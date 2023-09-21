#ifndef SRC_UTILS_ARGPARSE_HPP_
#define SRC_UTILS_ARGPARSE_HPP_

#include <map>
#include <string>
#include <vector>

#include "./_argparse.hpp"

using dict = std::map<std::string, std::string>;

namespace argparse {

class ArgumentParser {
   public:
    Argument &add_argument(std::string option, std::string long_option);
    dict parse_args(int argc, char **argv);

   private:
    std::vector<Argument> arguments;
    dict args;
    std::string help_message(char *argv0) const;
};

}  // namespace argparse

#endif  // SRC_UTILS_ARGPARSE_HPP_
