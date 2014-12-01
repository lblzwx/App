//
//  MJExtension.h
//  MJExtension
//
//  Created by lblzwx on 13-1-15.
//  Copyright (c) 2013年 lblzwx. All rights reserved.


#import "MJTypeEncoding.h"
#import "NSObject+MJCoding.h"
#import "NSObject+MJMember.h"
#import "NSObject+MJKeyValue.h"

#define MJLogAllIvrs \
- (NSString *)description \
{ \
    return [self keyValues].description; \
}
