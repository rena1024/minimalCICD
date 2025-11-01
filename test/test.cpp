#include <cassert>
#include <iostream>

int add(int a, int b) { return a + b; }

int main()
{
    assert(add(2, 3) == 5);
    std::cout << "basic_test passed\n";
    return 0;
}
