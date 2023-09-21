#include "./_argparse.hpp"

argparse::Argument& argparse::Argument::default_value(std::string value) {
    this->value = value;
    return *this;
}
argparse::Argument& argparse::Argument::required() {
    this->is_required = true;
    return *this;
}
argparse::Argument& argparse::Argument::metavar(std::string metavar) {
    this->metavar_name = metavar;
    return *this;
}
argparse::Argument& argparse::Argument::nargs(char nargs) {
    this->nargs_type = nargs;
    return *this;
}
argparse::Argument& argparse::Argument::choices(
    std::vector<std::string> choices) {
    this->choices_vector = choices;
    return *this;
}
argparse::Argument& argparse::Argument::action(std::string action) {
    this->action_type = action;
    return *this;
}
argparse::Argument& argparse::Argument::help(std::string help) {
    this->help_message = help;
    return *this;
}
