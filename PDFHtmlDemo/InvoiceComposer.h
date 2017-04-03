//
//  InvoiceComposer.h
//  PDFHtmlDemo
//
//  Created by Shivaji Tanpure on 30/03/17.
//  Copyright © 2017 Tata Motors. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoiceComposer : NSObject

@property (nonatomic,strong) NSString *pathToInvoiceHTMLTemplate;
@property (nonatomic,strong) NSString *pathToSingleItemHTMLTemplate;
@property (nonatomic,strong) NSString *pathToLastItemHTMLTemplate;

@property (nonatomic,strong) NSString *senderInfo;
@property (nonatomic,strong) NSString *dueDate;
@property (nonatomic,strong) NSString *paymentMethod;
@property (nonatomic,strong) NSString *logoImageURL;
@property (nonatomic,strong) NSString *invoiceNumber;
@property (nonatomic,strong) NSString *pdfFilename;

-(NSString*)renderInvoice:(NSString*)invoiceNumber invoiceDate:(NSString*)invoiceDate recipientInfo:(NSString*)recipientInfo items:(NSArray*)items totalAmount:(NSString*)totalAmount;

-(void)exportHTMLContentToPDF:(NSString*)HTMLContent;

@end
