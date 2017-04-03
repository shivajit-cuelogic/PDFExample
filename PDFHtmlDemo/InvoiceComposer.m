//
//  InvoiceComposer.m
//  PDFHtmlDemo
//
//  Created by Shivaji Tanpure on 30/03/17.
//  Copyright © 2017 Tata Motors. All rights reserved.
//

#import "InvoiceComposer.h"
#import "CustomPrintPageRenderer.h"

@implementation InvoiceComposer


- (id)init
{
    self = [super init];
    if (self) {
        
        _pathToInvoiceHTMLTemplate = [[NSBundle mainBundle] pathForResource:@"invoice" ofType:@"html"];
        _pathToSingleItemHTMLTemplate = [[NSBundle mainBundle] pathForResource:@"single_item" ofType:@"html"];
        _pathToLastItemHTMLTemplate = [[NSBundle mainBundle] pathForResource:@"last_item" ofType:@"html"];
        
        _senderInfo = @"Gabriel Theodoropoulos<br>123 Somewhere Str.<br>10000 - MyCity<br>MyCountry";
        _dueDate = @"10/10/2017";
        _logoImageURL = @"http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png";
        _invoiceNumber = @"101";
        _pdfFilename = @"test";
        _paymentMethod = @"Cash";

    }
    return self;
}

 -(NSString*)renderInvoice:(NSString*)invoiceNumber invoiceDate:(NSString*)invoiceDate recipientInfo:(NSString*)recipientInfo items:(NSArray*)items totalAmount:(NSString*)totalAmount{
     
     // Store the invoice number for future use.
     self.invoiceNumber = invoiceNumber;
     
     NSError *error;

     NSString *HTMLContent = [NSString stringWithContentsOfFile:_pathToInvoiceHTMLTemplate encoding:NSUTF8StringEncoding error:&error];
     
     if (error)
         NSLog(@"Error reading file: %@", error.localizedDescription);
     
     NSLog(@"HTMLContent: %@", HTMLContent);
     
     // Replace all the placeholders with real values except for the items.
     // The logo image.
     HTMLContent = [[HTMLContent stringByReplacingOccurrencesOfString:@"#LOGO_IMAGE#" withString:_logoImageURL] mutableCopy];
     
     // Invoice number.
      HTMLContent = [[HTMLContent stringByReplacingOccurrencesOfString:@"#INVOICE_NUMBER#" withString:_invoiceNumber] mutableCopy];
     
     // Invoice date.
     HTMLContent = [[HTMLContent stringByReplacingOccurrencesOfString:@"#INVOICE_DATE#" withString:invoiceDate] mutableCopy];
     
     // Due date (we leave it blank by default).
     HTMLContent = [[HTMLContent stringByReplacingOccurrencesOfString:@"#DUE_DATE#" withString:_dueDate] mutableCopy];
     
     // Sender info.
      HTMLContent = [[HTMLContent stringByReplacingOccurrencesOfString:@"#SENDER_INFO#" withString:_senderInfo] mutableCopy];
     
     // Recipient info.
     HTMLContent = [HTMLContent stringByReplacingOccurrencesOfString:@"#RECIPIENT_INFO#" withString:[recipientInfo stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]];
     
     // Payment method.
     HTMLContent = [[HTMLContent stringByReplacingOccurrencesOfString:@"#PAYMENT_METHOD#" withString:_paymentMethod] mutableCopy];
     
     // Total amount.
     HTMLContent = [[HTMLContent stringByReplacingOccurrencesOfString:@"#TOTAL_AMOUNT#" withString:totalAmount] mutableCopy];

     
     // The invoice items will be added by using a loop.
     NSString *allItems = @"";
     
     // For all the items except for the last one we'll use the "single_item.html" template.
     // For the last one we'll use the "last_item.html" template.
     for (int i=0 ; i < 2;i++) {
         NSString *itemHTMLContent = @"";
         
         // Determine the proper template file.
         if (i != items.count - 1) {
             
            itemHTMLContent = [NSString stringWithContentsOfFile:_pathToSingleItemHTMLTemplate encoding:NSUTF8StringEncoding error:&error];
         }
         else {
             itemHTMLContent = [NSString stringWithContentsOfFile:_pathToLastItemHTMLTemplate encoding:NSUTF8StringEncoding error:&error];
         }
         
         // Replace the description and price placeholders with the actual values.
         
         itemHTMLContent = [[itemHTMLContent stringByReplacingOccurrencesOfString:@"#ITEM_DESC#" withString:@"Item Name"] mutableCopy];
         
         // Format each item's price as a currency value.
         itemHTMLContent = [[itemHTMLContent stringByReplacingOccurrencesOfString:@"#PRICE#" withString:@"$100"] mutableCopy];
         
         // Add the item's HTML code to the general items string.
         
         allItems = [NSString stringWithFormat:@"%@ %@",allItems, itemHTMLContent];

         //[allItems stringByAppendingString:itemHTMLContent];

     }
     
     // Set the items.
     HTMLContent = [[HTMLContent stringByReplacingOccurrencesOfString:@"#ITEMS#" withString:allItems] mutableCopy];
    
     return HTMLContent;
     
 }


-(void)exportHTMLContentToPDF:(NSString*)HTMLContent {
    
    CustomPrintPageRenderer *printPageRenderer = [[CustomPrintPageRenderer alloc]init];
    
    UIMarkupTextPrintFormatter* printFormatter =[[UIMarkupTextPrintFormatter alloc] initWithMarkupText:HTMLContent];

    [printPageRenderer addPrintFormatter:printFormatter startingAtPageAtIndex:0];
    
    NSMutableData * pdfData = [NSMutableData data];
    

    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );
    
    for (NSInteger i=0; i < [printPageRenderer numberOfPages]; i++)
        
    {
        
        UIGraphicsBeginPDFPage();
        
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        
        [printPageRenderer drawPageAtIndex:i inRect:bounds];
        
    }
    
    UIGraphicsEndPDFContext();
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString * pdfFile = [documentsDirectory stringByAppendingPathComponent:@"test.pdf"];
    NSLog(@"pdfFile path:%@",pdfFile);
    [pdfData writeToFile:pdfFile atomically:YES];
}


//func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
//    let data = NSMutableData()
//    
//    UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
//    
//    UIGraphicsBeginPDFPage()
//    
//    printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
//    
//    UIGraphicsEndPDFContext()
//    
//    return data
//}



@end
