#import <Foundation/Foundation.h>
#import "../include/main.h"

void demo_print_hello()
{
    NSLog(@"Hello from Objective-C Demo!");
}

int main() 
{
    @autoreleasepool 
    {
        demo_print_hello();
    }
    return 0;
}