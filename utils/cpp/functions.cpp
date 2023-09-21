#include "./functions.hpp"

#include <filesystem>
#include <fstream>
#include <iostream>

dict yaml::load(std::string path) {
    dict params;
    std::string line;
    std::size_t pos;
    std::string key;
    std::string val;

    std::ifstream stream(path);
    if (stream.fail()) {
        throw std::runtime_error("Failed to open file: " + path);
    }
    while (!stream.eof()) {
        std::getline(stream, line);
        if (line[0] == '#' || line[0] == '\0') {
            continue;
        }
        pos = line.find(':');
        key = line.substr(0, pos);
        pos = line.find_first_not_of(' ', pos + 1);
        val = line.substr(pos, line.size() - pos);
        params[key] = val;
    }
    return params;
}

std::string utils::rename_dir(std::string dir_path) {
    std::string dir_name = dir_path;
    int count = 1;

    if (dir_path.back() == '/') {
        dir_name = dir_path.substr(0, dir_path.size() - 1);
    }
    dir_path = dir_name + std::to_string(count) + "/";
    while (std::filesystem::exists(dir_path)) {
        count++;
        dir_path = dir_name + std::to_string(count) + "/";
    }
    std::filesystem::create_directories(dir_path);
    std::cout << std::endl
              << Color::cyan << " [ SAVEDIR ] " << dir_path << Color::reset
              << std::endl;
    return dir_path;
}

const char Color::white[] = "\033[37m";
const char Color::cyan[] = "\033[36m";
const char Color::green[] = "\033[32m";
const char Color::yellow[] = "\033[33m";
const char Color::red[] = "\033[31m";
const char Color::reset[] = "\033[0m";
