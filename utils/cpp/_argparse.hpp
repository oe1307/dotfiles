#ifndef SRC_UTILS__ARGPARSE_HPP_
#define SRC_UTILS__ARGPARSE_HPP_

#include <string>
#include <vector>

namespace argparse {

class Argument {
   public:
    std::string option;
    std::string long_option;
    std::string key;

    Argument& metavar(std::string metavar);
    std::string metavar_name;

    Argument& default_value(std::string value);
    std::string value = "";

    Argument& action(std::string action);
    std::string action_type = "store";

    Argument& required();
    bool is_required = false;

    Argument& nargs(char nargs);
    char nargs_type = '1';

    Argument& choices(std::vector<std::string> choices);
    bool choices_set = false;
    std::vector<std::string> choices_vector;

    Argument& help(std::string help);
    std::string help_message;

    bool is_set = false;
};

}  // namespace argparse

#endif  // SRC_UTILS__ARGPARSE_HPP_
