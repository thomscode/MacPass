//
//  KPKTestAutotypeNormalization.m
//  MacPass
//
//  Created by Michael Starke on 18.02.14.
//  Copyright (c) 2014 HicknHack Software GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Commands.h"
#import "MPAutotypeCommand.h"
#import "MPAutotypeContext.h"
#import "MPAutotypePaste.h"
#import "MPAutotypeKeyPress.h"

#import "KPKEntry.h"

@interface KPKTestAutotypeNormalization : XCTestCase

@end

@implementation KPKTestAutotypeNormalization

- (void)testSimpleNormalization {
  NSString *normalized = [@"Whoo %{%}{^}{SHIFT}+ {SPACE}{ENTER}^V%V~T" normalizedAutotypeSequence];
  XCTAssertTrue([normalized isEqualToString:@"Whoo{SPACE}{ALT}{%}{^}{SHIFT}{SHIFT}{SPACE}{SPACE}{ENTER}{CONTROL}V{ALT}V{ENTER}T"]);
}

- (void)testCommandRepetition {
  NSString *normalized = [@"Whoo %{% 2}{^}{SHIFT 5}+ {SPACE}{ENTER}^V%V~T" normalizedAutotypeSequence];
  XCTAssertTrue([normalized isEqualToString:@"Whoo{SPACE}{ALT}{%}{%}{^}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SPACE}{SPACE}{ENTER}{CONTROL}V{ALT}V{ENTER}T"]);
  normalized = [@"{TAB 5}TAB{TAB}{SHIFT}{SHIFT 10}ENTER{ENTER}{%%}" normalizedAutotypeSequence];
  XCTAssertTrue([normalized isEqualToString:@"{TAB}{TAB}{TAB}{TAB}{TAB}TAB{TAB}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SHIFT}{SHIFT}ENTER{ENTER}{%%}"]);
}

- (void)testeBracketValidation {
  XCTAssertFalse([@"{BOOO}NO-COMMAND{TAB}{WHOO}{WHOO}{SPACE}!!!thisIsFun{{MISMATCH!!!}" validateCommmand]);
  XCTAssertFalse([@"{{}}}}" validateCommmand]);
  XCTAssertFalse([@"{}{}{{{}{{{{{{}}" validateCommmand]); 
  XCTAssertTrue([@"{}{}{}{}{}{      }ThisIsValid{}{STOP}" validateCommmand]);
}

- (void)testCommandCreation {
  KPKEntry *entry = [[KPKEntry alloc] init];
  entry.title = @"Title";
  entry.url = @"www.myurl.com";
  entry.username = @"{{User{name}}}";
  entry.password = @"Pass{word}";
  
  MPAutotypeContext *context = [[MPAutotypeContext alloc] initWithEntry:entry andSequence:@"{USERNAME}{TAB}{PASSWORD}{ENTER}"];
  NSArray *commands = [MPAutotypeCommand commandsForContext:context];
  
  XCTAssert([commands count] == 4);
  XCTAssert([commands[0] isKindOfClass:[MPAutotypePaste class]]);
  XCTAssert([commands[1] isKindOfClass:[MPAutotypeKeyPress class]]);
  XCTAssert([commands[2] isKindOfClass:[MPAutotypePaste class]]);
  XCTAssert([commands[3] isKindOfClass:[MPAutotypeKeyPress class]]);
  
  context = [[MPAutotypeContext alloc] initWithEntry:entry andSequence:@"{DELAY=5}{VKEY-NX 1}{VKEY-EX 200}{DELAY 5}{VKEY 300}"];
  commands = [MPAutotypeCommand commandsForContext:context];
  
  context = [[MPAutotypeContext alloc] initWithEntry:entry andSequence:@"^T{USERNAME}%+^{TAB}Whoo{PASSWORD}{ENTER}"];
  commands = [MPAutotypeCommand commandsForContext:context];
  
  
  //XCTAssert([commands count] == 5);
}
@end
