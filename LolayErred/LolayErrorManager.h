//
//  Copyright 2012 Lolay, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#import "LolayErrorDelegate.h"

#define LolayErrorLocalizedTitleKey @"LolayErrorLocalizedTitleKey_"

@interface LolayErrorManager : NSObject

@property (nonatomic, unsafe_unretained) id<LolayErrorDelegate> delegate;
@property (nonatomic, strong, readwrite) NSString* domain;

/*!
	For convenience, but recommend to use constructor injection
	http://googletesting.blogspot.com/2008/08/where-have-all-singletons-gone.html
*/
+ (LolayErrorManager*) shared;

/*!
	This is in case you don't want to use the shared, singleton creation and prefer to use your
	own mechanism to create a single instance (i.e. a factory with constructor injection).
*/
- (id) initWithDomain:(NSString*) inDomain;

- (NSError*) createError:(NSInteger) code;
- (NSError*) createError:(NSInteger) code suffix:(NSString*) suffix;
- (NSError*) createError:(NSInteger) code error:(NSError*) error;
- (NSError*) createError:(NSInteger) code suffix:(NSString*) suffix error:(NSError*) error;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion error:(NSError*) error;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title error:(NSError*) error;

@end
