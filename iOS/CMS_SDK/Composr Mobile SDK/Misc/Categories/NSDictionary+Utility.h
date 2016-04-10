//
//  NSDictionary+Utility.h
//  Beplused
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utility)

- (id)objectForKeyNotNull:(id)key;
- (id)objectForKeyWithEmptyString:(id)key;

@end
