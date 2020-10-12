//
//  STPPaymentMethodAfterpayClearpayTest.m
//  StripeiOS Tests
//
//  Created by Yuki Tokuhiro on 10/12/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "STPAPIClient+Private.h"
#import "STPPaymentIntent+Private.h"
#import "STPTestingAPIClient.h"
@import Stripe;

@interface STPPaymentMethodAfterpayClearpayTest : XCTestCase
@property (strong, nonatomic) NSDictionary *afterpayJSON;
@end

@implementation STPPaymentMethodAfterpayClearpayTest

- (void)_retrieveAfterpayJSON:(void (^)(NSDictionary *))completion {
    if (self.afterpayJSON) {
        completion(self.afterpayJSON);
    } else {
        STPAPIClient *client = [[STPAPIClient alloc] initWithPublishableKey:STPTestingDefaultPublishableKey];
        [client retrievePaymentIntentWithClientSecret:@"pi_1HbSAfFY0qyl6XeWRnlezJ7K_secret_t6Ju9Z0hxOvslawK34uC1Wm2b"
                                               expand:@[@"payment_method"] completion:^(STPPaymentIntent * _Nullable paymentIntent, __unused NSError * _Nullable error) {
            self.afterpayJSON = paymentIntent.paymentMethod.afterpayClearpay.allResponseFields;
            completion(self.afterpayJSON);
        }];
    }
}

- (void)testCorrectParsing {
    XCTestExpectation *jsonExpectation = [[XCTestExpectation alloc] initWithDescription:@"Fetch Afterpay Clearpay JSON"];
    [self _retrieveAfterpayJSON:^(NSDictionary *json) {
        STPPaymentMethodAfterpayClearpay *afterpay = [STPPaymentMethodAfterpayClearpay decodedObjectFromAPIResponse:json];
        XCTAssertNotNil(afterpay, @"Failed to decode JSON");
        [jsonExpectation fulfill];
    }];
    [self waitForExpectations:@[jsonExpectation] timeout:STPTestingNetworkRequestTimeout];
}

@end
