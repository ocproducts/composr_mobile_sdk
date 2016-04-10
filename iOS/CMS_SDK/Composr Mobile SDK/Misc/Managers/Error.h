//
//  Error.h
//  FishinMobile
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Error : NSObject

@property (strong, nonatomic) NSString *errorCode;
@property (strong, nonatomic) NSString *message;

- (id)initWithDictionary:(NSDictionary*)dictResult;
- (id)initWithError:(NSError*)error;
- (id)initWithMessage:(NSString*)message errorCode:(NSString*)code;

@end
