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

#import "LolayErrorManager.h"

@interface LolayErrorManager () <UIAlertViewDelegate>

@property (nonatomic, assign) BOOL showingError;

@end

@implementation LolayErrorManager

@synthesize delegate = delegate_;
@synthesize showingError = showingError_;
@synthesize domain = domain_;

+ (LolayErrorManager*) shared {
	static LolayErrorManager* instance = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		instance = [[LolayErrorManager alloc] initWithDomain:nil];
	});
	return instance;
}

- (id) initWithDomain:(NSString*) inDomain {
	self = [super init];
	
	if (self) {
		self.delegate = nil;
		self.domain = inDomain;
		self.showingError = NO;
	}
	
	return self;
}

- (NSString*) localizedString:(NSString*) key {
	if ([self.delegate respondsToSelector:@selector(errorManager:localizedString:)]) {
		return [self.delegate errorManager:self localizedString:key];
	}
	
	return NSLocalizedString(key, nil);
}

- (NSError*) createError:(NSInteger) code {
	return [self createError:code error:nil];
}

- (NSError*) createError:(NSInteger) code suffix:(NSString*) suffix {
	return [self createError:code suffix:suffix error:nil];
}

- (NSError*) createError:(NSInteger) code error:(NSError*) error {
	return [self createError:code suffix:nil error:error];
}

- (NSError*) createError:(NSInteger) code suffix:(NSString*) suffix error:(NSError*) error {
	NSString* titleKey = [NSString stringWithFormat:@"error-%li-localizedTitle", (long) code];
	NSString* descriptionKey = [NSString stringWithFormat:@"error-%li-localizedDescription", (long) code];
	NSString* recoveryKey = [NSString stringWithFormat:@"error-%li-recoverySuggestion", (long) code];
	if (suffix) {
		titleKey = [titleKey stringByAppendingFormat:@"-%@", suffix];
		descriptionKey = [descriptionKey stringByAppendingFormat:@"-%@", suffix];
		recoveryKey = [recoveryKey stringByAppendingFormat:@"-%@", suffix];
	}
	
	NSString* title = [self localizedString:titleKey];
	NSString* description = [self localizedString:descriptionKey];
	NSString* recoverySuggestion = [self localizedString:recoveryKey];
	
	if ([title length] == 0 || [title isEqualToString:titleKey]) {
		title = [self localizedString:@"error-localizedTitle"];
		
		if ([title length] == 0 || [title isEqualToString:@"error-localizedTitle"]) {
			title = nil;
		}
	}
	
	if ([description length] == 0 || [description isEqualToString:descriptionKey]) {
		description = [self localizedString:@"error-localizedDescription"];
		
		if ([description length] == 0 || [description isEqualToString:@"error-localizedDescription"]) {
			description = nil;
		}
	}
	
	if ([recoverySuggestion length] == 0 || [recoverySuggestion isEqualToString:recoveryKey]) {
		recoverySuggestion = [self localizedString:@"error-recoverySuggestion"];
		
		if ([recoverySuggestion length] == 0 || [recoverySuggestion isEqualToString:@"error-recoverySuggestion"]) {
			recoverySuggestion = nil;
		}
	}
	
	return [self createError:code description:description recoverySuggestion:recoverySuggestion title:title error:error];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion {
	return [self createError:code description:description recoverySuggestion:recoverySuggestion title:nil error:nil];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion error:(NSError*) error {
	return [self createError:code description:description recoverySuggestion:recoverySuggestion title:nil error:error];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title {
	return [self createError:code description:description recoverySuggestion:recoverySuggestion title:title error:nil];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title error:(NSError*) error {
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:4];
	if (description) {
		[userInfo setObject:description forKey:NSLocalizedDescriptionKey];
	}
	if (recoverySuggestion) {
		[userInfo setObject:recoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
	}
	if (title) {
		[userInfo setObject:title forKey:LolayErrorLocalizedTitleKey];
	}
	if (error) {
		[userInfo setObject:error forKey:NSUnderlyingErrorKey];
	}
	if(!self.domain){
		NSException* domainNilException = [[NSException alloc] initWithName:@"NSErrorIsNil"
															   reason:@"NSError domain is Nil"
															 userInfo:userInfo];
		@throw domainNilException;
	}
	return [NSError errorWithDomain:self.domain code:code userInfo:userInfo];
}

@end
