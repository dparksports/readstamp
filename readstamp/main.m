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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *pictureDirectory = [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [pictureDirectory stringByAppendingFormat:@"/f90182848.jpg", index];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:filename];
        
        //ocr.charWhitelist = @"1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
        //ocr.charWhitelist = @"1234567890";
        //ocr.charBlacklist = @"1234567890";
        SLTesseract *ocr = [[SLTesseract alloc] init];
        ocr.language = @"eng";
        NSString *text = [ocr recognize:image];
        printf("Text detected: \n%s\n", [text UTF8String]);

        NSLog(@"Hello, World!");
    }
    return 0;
}
