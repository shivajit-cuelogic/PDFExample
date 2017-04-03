//
//  CustomPrintPageRenderer.m
//  PDFHtmlDemo
//
//  Created by Shivaji Tanpure on 30/03/17.
//  Copyright © 2017 Tata Motors. All rights reserved.
//

#import "CustomPrintPageRenderer.h"

static const CGFloat A4PageWidth = 595.2;
static const CGFloat A4PageHeight = 841.8;

@implementation CustomPrintPageRenderer


- (id)init
{
    self = [super init];
    if (self) {
    
        // Specify the frame of the A4 page.
        CGRect pageFrame = CGRectMake(0.0, 0.0,A4PageWidth,A4PageHeight);
        
        // Set the page frame.
        [self setValue:[NSValue valueWithCGRect:pageFrame] forKey:@"paperRect"];
        
        CGRect printable=CGRectInset(pageFrame, 0.0, 0.0 );
        
        // Set the horizontal and vertical insets (that's optional).
        [self setValue:[NSValue valueWithCGRect:printable] forKey:@"printableRect"];
        
        
        self.headerHeight = 50.0;
        self.footerHeight = 50.0;
        
    }
    return self;
}



//func getTextSize(text: String, font: UIFont!, textAttributes: [String: AnyObject]! = nil) -> CGSize {
//    let testLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.paperRect.size.width, height: footerHeight))
//    if let attributes = textAttributes {
//        testLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
//    }
//    else {
//        testLabel.text = text
//        testLabel.font = font!
//    }
//    
//    testLabel.sizeToFit()
//    
//    return testLabel.frame.size
//}


@end
