//
//  NSDictionary+Utility.m
//  FishinMobile
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key {
	id object = self[key];
	if (object == [NSNull null])
		return nil;

	return object;
}

// if objectForKey returns nil, it will
// return an empty string.
- (id)objectForKeyWithEmptyString:(id)key {
	id object = [self objectForKeyNotNull:key];
	if (object == nil) {
		return @"";
	}
	return object;
}

@end
