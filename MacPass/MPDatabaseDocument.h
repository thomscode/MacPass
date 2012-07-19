//
//  MPDocument.h
//  MacPass
//
//  Created by Michael Starke on 21.07.12.
//  Copyright (c) 2012 HicknHack Software GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPDatabaseDocument : NSObject

- (id)initWithFile:(NSURL *)file andPassword:(NSString *)password;
- (id)initWithFile:(NSURL *)file andKeyfile:(NSURL *)keyfile;

@end
