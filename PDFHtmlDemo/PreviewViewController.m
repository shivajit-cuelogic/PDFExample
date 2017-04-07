//
//  PreviewViewController.m
//  PDFHtmlDemo
//
//  Created by Shivaji Tanpure on 30/03/17.
//  Copyright © 2017 Tata Motors. All rights reserved.
//

#import "PreviewViewController.h"
#import "InvoiceComposer.h"
#import "CustomPrintPageRenderer.h"

@interface PreviewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webPreview;
@property (weak, nonatomic) NSString *HTMLContent;


@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    _webPreview.delegate = self;
    
    [self createInvoiceAsHTML];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createInvoiceAsHTML {
    
    InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
    
    NSString *invoiceHTML = [invoiceComposer renderInvoice:@"101" invoiceDate:@"12/12/2010" recipientInfo:@"Tata Technology" items:nil totalAmount:@"144810"];
    
    [_webPreview loadHTMLString:invoiceHTML baseURL:[NSURL URLWithString:invoiceComposer.pathToInvoiceHTMLTemplate]];
    
    _HTMLContent = invoiceHTML;
    
    
    //Generate pdf file
    //[invoiceComposer exportHTMLContentToPDF:_HTMLContent];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
    
    NSString *invoiceHTML = [invoiceComposer renderInvoice:@"101" invoiceDate:@"12/12/2010" recipientInfo:@"Tata Technology" items:nil totalAmount:@"144810"];
    
    // Get the height of our webView
    NSString *heightStr = [_webPreview stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    
    int height = [heightStr intValue];
    
    // Get the number of pages needed to print. 9 * 72 = 648
    int pages = ceil(height / 648.0);
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );
    
    for (int i = 0; i < pages; i++) {
        UIGraphicsBeginPDFPage();
       
        CustomPrintPageRenderer *printPageRenderer = [[CustomPrintPageRenderer alloc]init];
        
        UIMarkupTextPrintFormatter* printFormatter =[[UIMarkupTextPrintFormatter alloc] initWithMarkupText:invoiceHTML];
        
        [printPageRenderer addPrintFormatter:printFormatter startingAtPageAtIndex:0];
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        
        [printPageRenderer drawPageAtIndex:i inRect:bounds];
    }
    
    UIGraphicsEndPDFContext();
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString * pdfFile = [documentsDirectory stringByAppendingPathComponent:@"test.pdf"];
    [pdfData writeToFile:pdfFile atomically:YES];
    NSLog(@"pdfFile path:%@",pdfFile);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
