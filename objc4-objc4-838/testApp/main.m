//
//  main.m
//  testApp
//
//  Created by Murph on 2022/4/8.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}

@interface Person : NSObject

@end

@implementation Person
+ (void)load{
    NSLog(@"%s", __func__);
}

@end
