//
//  NSObject+RACDeallocating.m
//  ReactiveCocoa
//
//  Created by Kazuo Koga on 2013/03/15.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACTestObject.h"

#import "NSObject+RACDeallocating.h"
#import "RACDisposable.h"
#import "RACSignal+Operations.h"

SpecBegin(NSObjectRACDeallocatingSpec)

describe(@"-rac_addDeallocDisposable:", ^{
	it(@"should dispose of the disposable when it is dealloc'd", ^{
		__block BOOL wasDisposed = NO;
		@autoreleasepool {
			NSObject *object __attribute__((objc_precise_lifetime)) = [[NSObject alloc] init];
			[object rac_addDeallocDisposable:[RACDisposable disposableWithBlock:^{
				wasDisposed = YES;
			}]];

			expect(wasDisposed).to.beFalsy();
		}

		expect(wasDisposed).to.beTruthy();
	});
});

describe(@"-rac_didDeallocSignal", ^{
	it(@"should complete on dealloc", ^{
		__block BOOL completed = NO;
		@autoreleasepool {
			[[[[RACTestObject alloc] init] rac_didDeallocSignal] subscribeCompleted:^{
				completed = YES;
			}];
		}

		expect(completed).to.beTruthy();
	});

	it(@"should not send anything", ^{
		__block BOOL valueReceived = NO;
		__block BOOL completed = NO;
		@autoreleasepool {
			[[[[RACTestObject alloc] init] rac_didDeallocSignal] subscribeNext:^(id x) {
				valueReceived = YES;
			} completed:^{
				completed = YES;
			}];
		}

		expect(valueReceived).to.beFalsy();
		expect(completed).to.beTruthy();
	});
});

SpecEnd
