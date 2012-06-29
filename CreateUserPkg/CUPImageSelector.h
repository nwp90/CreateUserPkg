//
//  CUPImageSelector.h
//  CreateUserPkg
//
//  Created by Per Olofsson on 2012-06-29.
//  Copyright (c) 2012 University of Gothenburg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CUPImageSelector : NSImageView

@property (retain) NSData *imageData;
@property (retain) NSString *imagePath;

- (void)saveJpegData:(NSData *)data;

@end