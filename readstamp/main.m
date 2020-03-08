//
//  main.m
//  readstamp
//
//  Created by Dan Park on 3/7/20.
//  Copyright © 2020 Dan Park. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "SLTesseract.h"

//#include <unistd.h>
//#include <stdio.h>
//#include <limits.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        char cwd[PATH_MAX];
        if (getcwd(cwd, sizeof(cwd)) != NULL) {
//            printf("Current working dir: %s\n", cwd);
        }
        
        NSString *pictureDirectory = [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [pictureDirectory stringByAppendingFormat:@"/%s/%s",argv[1],argv[2]];
//        NSString *filename = [pictureDirectory stringByAppendingFormat:@"%s/%s", cwd,argv[1]];
//        NSLog(@"filename:%@", filename);

        NSImage *imageOriginal = [[NSImage alloc] initWithContentsOfFile:filename];
//        NSLog(@"image:%@", imageOriginal);
        if (! imageOriginal) {
            exit(-1);
        }
        
        NSSize size = imageOriginal.size;
        CGFloat stampHeight = 42;
        size.height = stampHeight;
        
        NSRect rect;
        rect.size = size;
        
        NSRect originalRect = { NSZeroPoint, imageOriginal.size };
        NSRect dest = { NSZeroPoint, size };

        NSImage *imageCropped = [[NSImage alloc] initWithSize:size];
        [imageCropped lockFocus];
        [imageOriginal drawInRect:dest fromRect:dest operation:NSCompositingOperationCopy fraction:1];
        [imageCropped unlockFocus];
//        NSLog(@"cropped:%@", imageCropped);

        //ocr.charWhitelist = @"1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
        //ocr.charWhitelist = @"1234567890";
        //ocr.charBlacklist = @"1234567890";
        SLTesseract *ocr = [[SLTesseract alloc] init];
        ocr.language = @"eng";
        NSString *text = [ocr recognize:imageOriginal];
        NSRange rangeJPG = [text rangeOfString:@".jpg"];
        NSRange rangeSnap = [text rangeOfString:@"snap"];
        if (rangeJPG.location == NSNotFound ||
            rangeSnap.location == NSNotFound ) {
            exit(-2);
        }

        NSRange trimRange = NSMakeRange(rangeSnap.location, rangeJPG.location + rangeJPG.length - rangeSnap.location);
        NSString *timestamp = [text substringWithRange:trimRange];
//        printf("Text detected: \n%s\n", [text UTF8String]);
        printf("%s\n", [timestamp UTF8String]);
        
        NSError *error = nil;
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *timestampName = [pictureDirectory stringByAppendingFormat:@"/%s/%@",argv[1],timestamp];
        [manager moveItemAtPath:filename toPath:timestampName error:&error];
        if (error) {
            NSLog(@"error: %@", error);
        }
    }
    return 0;
}
