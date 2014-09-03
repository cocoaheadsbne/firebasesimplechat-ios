//
//  RTSViewController.m
//  FirebaseSimpleChat
//
//  Created by Roger Stephen on 1/09/2014.
//  Copyright (c) 2014 Roger Stephen. All rights reserved.
//

#import "RTSViewController.h"
#import <Firebase/Firebase.h>

@interface RTSViewController ()<UITextFieldDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *myId;
@property (strong, nonatomic) Firebase *firebase;
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RTSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Change the URL to your Firebase instance
    self.firebase = [[Firebase alloc] initWithUrl:@"https://cocoaheadsbne.firebaseio.com/messages/"];
    self.myId = [NSString stringWithFormat:@"ID%d", arc4random() % 100];
    self.messages = [NSMutableArray new];
    self.titleLabel.text = self.myId;
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        [self.messages insertObject:snapshot.value atIndex:0];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *messageDict = self.messages[indexPath.row];
    cell.textLabel.text = messageDict[@"text"];
    cell.detailTextLabel.text = messageDict[@"name"];
    cell.textLabel.textColor = cell.detailTextLabel.textColor = [self.myId isEqualToString:messageDict[@"name"]] ? [UIColor blueColor] : [UIColor blackColor];
    
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [[self.firebase childByAutoId] setValue:@{@"name" : self.myId,
                                                  @"text": textField.text}];
        textField.text = @"";
    }
    return YES;
}

@end
