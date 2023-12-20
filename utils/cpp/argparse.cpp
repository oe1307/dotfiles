#include "./argparse.hpp"

#include <algorithm>
#include <filesystem>
#include <iostream>
#include <sstream>

argparse::Argument &argparse::ArgumentParser::add_argument(
    std::string option, std::string long_option) {
    Argument argument;
    std::string metavar = long_option.substr(2);
    std::transform(metavar.begin(), metavar.end(), metavar.begin(), toupper);

    argument.option = option;
    argument.long_option = long_option;
    argument.key = long_option.substr(2);
    argument.metavar_name = metavar;
    this->arguments.push_back(argument);
    return this->arguments.back();
}

dict argparse::ArgumentParser::parse_args(int argc, char **argv) {
    args["basedir"] = std::filesystem::path(argv[0]).parent_path();
    args["basedir"] = std::filesystem::relative(args["basedir"] + "/..");

    // check help
    for (int i = 1; i < argc; i++) {
        std::string arg = argv[i];
        if (arg == "-h" || arg == "--help") {
            std::cout << this->help_message(argv[0]);
            exit(0);
        }
    }

    // set default values
    for (auto argument : this->arguments) {
        this->args[argument.key] = argument.value;
    }

    // parse args
    for (int i = 1; i < argc; i++) {
        std::string arg = argv[i];
        for (auto &argument : this->arguments) {
            if (arg == argument.option || arg == argument.long_option) {
                if (argument.action_type == "store_true") {
                    this->args[argument.key] = "true";
                } else if (argument.action_type == "store_false") {
                    this->args[argument.key] = "false";
                } else if (argument.action_type == "store") {
                    if (argument.nargs_type == '1') {
                        this->args[argument.key] = argv[++i];
                    } else if (argument.nargs_type == '*') {
                        std::string value = "";
                        while (i + 1 < argc) {
                            std::string next_arg = argv[i + 1];
                            if (next_arg[0] == '-') {
                                break;
                            }
                            value += next_arg + " ";
                            i++;
                        }
                        this->args[argument.key] = value;
                    }
                }
                argument.is_set = true;
                break;
            }
        }
    }

    // check required
    for (auto argument : this->arguments) {
        if (argument.is_required && !argument.is_set) {
            throw std::invalid_argument(
                "the following arguments are required: " + argument.option +
                "/" + argument.long_option + "\n\n" +
                this->help_message(argv[0]));
        }
    }
    return this->args;
}

std::string argparse::ArgumentParser::help_message(char *argv0) const {
    std::stringstream stream;
    stream << "Usage: " << argv0 << " [-h]";
    for (auto argument : this->arguments) {
        if (argument.is_required) {
            stream << " " << argument.option << " " << argument.metavar_name;
        } else {
            stream << " [" << argument.option << " " << argument.metavar_name
                   << "]";
        }
    }
    stream << std::endl << std::endl;
    stream << "Options:" << std::endl;
    for (auto argument : this->arguments) {
        stream << "  " << argument.option << " " << argument.metavar_name
               << ", " << argument.long_option << " " << argument.metavar_name
               << "      " << argument.help_message << std::endl;
    }
    return stream.str();
}
