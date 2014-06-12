/*
 * Copyright 2010-2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#if AWS_TEST_ELASTIC_LOAD_BALANCING

#import <XCTest/XCTest.h>
#import "ElasticLoadBalancing.h"

@interface AWSElasticLoadBalancingTests : XCTestCase

@end

@implementation AWSElasticLoadBalancingTests

+ (void)setUp {
    [super setUp];

    if (![AWSServiceManager defaultServiceManager].defaultServiceConfiguration) {
        AWSStaticCredentialsProvider *credentialsProvider = [AWSStaticCredentialsProvider credentialsWithCredentialsFilename:@"credentials"];
        AWSServiceConfiguration *configuration = [AWSServiceConfiguration  configurationWithRegion:AWSRegionUSEast1
                                                                               credentialsProvider:credentialsProvider];
        [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    }
}

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testDescribeLoadBalancers {
    AWSElasticLoadBalancing *elb = [AWSElasticLoadBalancing defaultElasticLoadBalancing];

    AWSElasticLoadBalancingDescribeAccessPointsInput *describeAccessPointsInput = [AWSElasticLoadBalancingDescribeAccessPointsInput new];
    [[[elb describeLoadBalancers:describeAccessPointsInput] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            XCTFail(@"Error: [%@]", task.error);
        }

        if (task.result) {
            XCTAssertTrue([task.result isKindOfClass:[AWSElasticLoadBalancingDescribeAccessPointsOutput class]]);
            AWSElasticLoadBalancingDescribeAccessPointsOutput *describeAccessPointsOutput = task.result;
            XCTAssertNotNil(describeAccessPointsOutput.loadBalancerDescriptions, @"loadBalancerDescriptions Array should not be nil");
        }

        return nil;
    }] waitUntilFinished];
}

- (void)testConfigureHealthCheckFailed {
    AWSElasticLoadBalancing *elb = [AWSElasticLoadBalancing defaultElasticLoadBalancing];
    
    AWSElasticLoadBalancingConfigureHealthCheckInput *healthCheckInput = [AWSElasticLoadBalancingConfigureHealthCheckInput new];
    healthCheckInput.loadBalancerName = @""; //loadBalancerName is empty
    
    [[[elb configureHealthCheck:healthCheckInput] continueWithBlock:^id(BFTask *task) {
        
        XCTAssertNotNil(task.error, @"expected Validation Error, but got nil");
        return nil;
    }] waitUntilFinished];
}

@end

#endif
