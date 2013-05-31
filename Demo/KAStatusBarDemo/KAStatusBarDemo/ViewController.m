//
//  ViewController.m
//  KAStatusBarDemo
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *statusTextField;
@property (strong, nonatomic) IBOutlet UITextField *colorTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;
@end

@implementation ViewController


-(IBAction)loading:(id)sender{
    
    [KAStatusBar showWithStatus:@"Loading..." ];
}

-(IBAction)info:(id)sender{
    
    [KAStatusBar showWithStatus:@"Info message" andRemoveAfterDelay:@2];
}
-(IBAction)success:(id)sender{
    
    [KAStatusBar showWithStatus:@"Success" barColor:[UIColor colorWithRed:0.1 green:0.6 blue:0.1 alpha:1] andRemoveAfterDelay:@2];
}
-(IBAction)error:(id)sender{
    
    [KAStatusBar showWithStatus:@"Error" barColor:[UIColor colorWithRed:0.6 green:0.1 blue:0.1 alpha:1] andRemoveAfterDelay:@2];
}

- (IBAction)dismiss:(id)sender{
    [KAStatusBar dismiss];
}

@end
