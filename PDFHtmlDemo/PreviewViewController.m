//
//  PreviewViewController.m
//  PDFHtmlDemo
//
//  Created by Shivaji Tanpure on 30/03/17.
//  Copyright © 2017 Tata Motors. All rights reserved.
//

#import "PreviewViewController.h"
#import "InvoiceComposer.h"

@interface PreviewViewController ()
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
    [invoiceComposer exportHTMLContentToPDF:_HTMLContent];
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
