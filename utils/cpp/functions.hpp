#ifndef SRC_UTILS_FUNCTIONS_HPP_
#define SRC_UTILS_FUNCTIONS_HPP_

#include <map>
#include <string>

using dict = std::map<std::string, std::string>;

namespace yaml {

dict load(std::string path);

}  // namespace yaml

namespace utils {

std::string rename_dir(std::string dir_path);

}

class Color {
   public:
    static const char white[];
    static const char cyan[];
    static const char green[];
    static const char yellow[];
    static const char red[];
    static const char reset[];
};

#endif  // SRC_UTILS_FUNCTIONS_HPP_
