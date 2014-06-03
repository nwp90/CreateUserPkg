//
//  CUPImageSelector.m
//  CreateUserPkg
//
//  Created by Per Olofsson on 2012-06-29.
//  Copyright (c) 2012 University of Gothenburg. All rights reserved.
//

#import "CUPImageSelector.h"

@implementation CUPImageSelector

@synthesize imageData = _imageData;
@synthesize imagePath = _imagePath;


- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:@[NSTIFFPboardType, NSURLPboardType]];
        self.imageData = nil;
        self.imagePath = nil;
    }
    
    return self;
}


- (BOOL)saveJpegData:(NSData *)data
{
    NSBitmapImageRep *imgrep = [NSBitmapImageRep imageRepWithData:data];
    if (imgrep == nil) {
        return NO;
    }
    self.imageData = [imgrep representationUsingType:NSJPEGFileType properties:nil];
    if (self.imageData == nil) {
        return NO;
    }
    return YES;
}

- (void)saveUserPicturesPath:(NSURL *)url
{
    if (url != nil) {
        if ([url isFileURL] == YES) {
            NSString *path = [url path];
            if ([path hasPrefix:@"/Library/User Pictures/"]) {
                self.imagePath = path;
            }
        }
    }
}

- (void)displayImageData
{
    if (self.imageData) {
        NSImage *image = [[NSImage alloc] initWithData:self.imageData];
        [self setImage:image];
    }
    [self setNeedsDisplay:YES];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
        return NSDragOperationGeneric;
    } else {
        return NSDragOperationNone;
    }
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSString *droppedType = [pboard availableTypeFromArray:@[NSTIFFPboardType, NSURLPboardType]];
    
    if ([droppedType isEqualToString:NSTIFFPboardType]) {
        NSData *droppedData = [pboard dataForType:droppedType];
        if ([self saveJpegData:droppedData] == NO) {
            return NO;
        }
        [self displayImageData];
        self.imagePath = nil;
    } else if ([droppedType isEqualToString:NSURLPboardType]) {
        NSURL *droppedURL = [NSURL URLFromPasteboard:pboard];
        if ([self saveJpegData:[NSData dataWithContentsOfURL:droppedURL]] == NO) {
            return NO;
        }
        [self saveUserPicturesPath:droppedURL];
    } else {
        return NO;
    }
    
    [self setNeedsDisplay:YES];
    return YES;
}

@end
