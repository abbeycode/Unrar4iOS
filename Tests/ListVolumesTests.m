//
//  ListVolumesTests.m
//  UnrarKit
//
//  Created by Dov Frankel on 12/9/16.
//
//

#import "URKArchiveTestCase.h"

@interface ListVolumesTests : URKArchiveTestCase

@end

@implementation ListVolumesTests

- (void)testSingleVolume {
    NSURL *testArchiveURL = self.testFileURLs[@"Test Archive.rar"];
    URKArchive *archive = [[URKArchive alloc] initWithURL:testArchiveURL error:nil];
    
    NSError *listVolumesError = nil;
    NSArray<NSString*> *volumePaths = [archive listVolumePaths:&listVolumesError];
    
    XCTAssertNil(listVolumesError, @"Error listing volume paths");
    XCTAssertNotNil(volumePaths, @"No paths returned");
    XCTAssertEqual(volumePaths.count, 1, @"Wrong number of volume paths listed");
    
    XCTAssertEqualObjects(volumePaths[0].lastPathComponent, testArchiveURL.path.lastPathComponent,
                          @"Wrong path returned");


    listVolumesError = nil;
    NSArray<NSURL*> *volumeURLs = [archive listVolumeURLs:&listVolumesError];
    
    XCTAssertNil(listVolumesError, @"Error listing volume URLs");
    XCTAssertNotNil(volumeURLs, @"No URLs returned");
    XCTAssertEqual(volumeURLs.count, 1, @"Wrong number of volume URLs listed");
    
    XCTAssertEqualObjects(volumeURLs[0].lastPathComponent, testArchiveURL.path.lastPathComponent,
                          @"Wrong URL returned");
}

- (void)testMultipleVolume_UseFirstVolume {
    NSArray<NSURL*> *generatedVolumeURLs = [self multiPartArchiveWithName:@"ListVolumesTests-testMultipleVolume_UseFirstVolume.rar"];
    URKArchive *archive = [[URKArchive alloc] initWithURL:generatedVolumeURLs.firstObject error:nil];
    
    NSMutableArray<NSString *> *expectedVolumePaths = [NSMutableArray array];
    NSMutableArray<NSURL *> *expectedVolumeURLs = [NSMutableArray array];
    
    // NSTemporaryDirectory() returns '/var', which maps to '/private/var'
    for (NSURL *volumeURL in generatedVolumeURLs) {
        NSString *originalPath = volumeURL.path;
        NSString *privatePath = [@"/private" stringByAppendingString:originalPath];
        [expectedVolumePaths addObject:privatePath];
        [expectedVolumeURLs addObject:[NSURL fileURLWithPath:privatePath]];
    }
    
    NSError *listVolumesError = nil;
    NSArray<NSString*> *volumePaths = [archive listVolumePaths:&listVolumesError];
    
    XCTAssertNil(listVolumesError, @"Error listing volume paths");
    XCTAssertNotNil(volumePaths, @"No paths returned");
    XCTAssertEqual(volumePaths.count, 5, @"Wrong number of volume paths listed");
    XCTAssertTrue([[NSSet setWithArray:expectedVolumePaths] isEqual:[NSSet setWithArray:volumePaths]],
                  @"Expected these paths:\n%@\n\nGot these:\n%@", expectedVolumePaths, volumePaths);

    
    listVolumesError = nil;
    NSArray<NSURL*> *volumeURLs = [archive listVolumeURLs:&listVolumesError];
    
    XCTAssertNil(listVolumesError, @"Error listing volume URLs");
    XCTAssertNotNil(volumeURLs, @"No URLs returned");
    XCTAssertEqual(volumeURLs.count, 5, @"Wrong number of volume URLs listed");
    XCTAssertTrue([[NSSet setWithArray:expectedVolumeURLs] isEqual:[NSSet setWithArray:volumeURLs]],
                  @"Expected these URL:\n%@\n\nGot these:\n%@", expectedVolumeURLs, volumeURLs);
}

- (void)testMultipleVolume_UseMiddleVolume {
    NSArray<NSURL*> *generatedVolumeURLs = [self multiPartArchiveWithName:@"ListVolumesTests-testMultipleVolume_UseMiddleVolume.rar"];
    URKArchive *archive = [[URKArchive alloc] initWithURL:generatedVolumeURLs[2] error:nil];
    
    NSMutableArray<NSString *> *expectedVolumePaths = [NSMutableArray array];
    NSMutableArray<NSURL *> *expectedVolumeURLs = [NSMutableArray array];
    
    // NSTemporaryDirectory() returns '/var', which maps to '/private/var'
    for (NSURL *volumeURL in generatedVolumeURLs) {
        NSString *originalPath = volumeURL.path;
        NSString *privatePath = [@"/private" stringByAppendingString:originalPath];
        [expectedVolumePaths addObject:privatePath];
        [expectedVolumeURLs addObject:[NSURL fileURLWithPath:privatePath]];
    }
    
    NSError *listVolumesError = nil;
    NSArray<NSString*> *volumePaths = [archive listVolumePaths:&listVolumesError];
    
    XCTAssertNil(listVolumesError, @"Error listing volume paths");
    XCTAssertNotNil(volumePaths, @"No paths returned");
    XCTAssertEqual(volumePaths.count, 5, @"Wrong number of volume paths listed");
    XCTAssertTrue([[NSSet setWithArray:expectedVolumePaths] isEqual:[NSSet setWithArray:volumePaths]],
                  @"Expected these paths:\n%@\n\nGot these:\n%@", expectedVolumePaths, volumePaths);
    
    
    listVolumesError = nil;
    NSArray<NSURL*> *volumeURLs = [archive listVolumeURLs:&listVolumesError];
    
    XCTAssertNil(listVolumesError, @"Error listing volume URLs");
    XCTAssertNotNil(volumeURLs, @"No URLs returned");
    XCTAssertEqual(volumeURLs.count, 5, @"Wrong number of volume URLs listed");
    XCTAssertTrue([[NSSet setWithArray:expectedVolumeURLs] isEqual:[NSSet setWithArray:volumeURLs]],
                  @"Expected these URL:\n%@\n\nGot these:\n%@", expectedVolumeURLs, volumeURLs);
}

@end