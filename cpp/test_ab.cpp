#include "hachi64/hachi64.hpp"
#include <iostream>
#include <vector>

int main() {
    std::string text = "ab";
    std::vector<uint8_t> data(text.begin(), text.end());
    std::string encoded = hachi64::encode(data);
    std::cout << "Encoded 'ab': " << encoded << std::endl;
    return 0;
}
