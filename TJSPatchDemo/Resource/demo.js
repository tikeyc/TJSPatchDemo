//如果是模块化开发(需要include导入js文件的时候)使用[JPEngine evaluateScriptWithPath:sourcePath];方法执行本js文件
include('CommonDefine.js')
include('ViewController/LoginViewController.js')
include('ViewController/TableViewController.js')

//会自动把OC类型转成js类型，如果调用autoConvertOCType(1)的话，很多类如NSString、NSDictionary等的调用会出问题
//autoConvertOCType(1)

require('UIButton, UIColor');
defineClass('FirstViewController', {
            viewDidLoad: function() {
                self.ORIGviewDidLoad();//在方法名前加 ORIG 即可调用未覆盖前的 OC 原方法viewDidLoad
                self.addSubView();
            },
            addSubView: function() {
                var button = UIButton.alloc().initWithFrame({x:(global.SCREEN_WIDTH - 200)/2, y:100, width:200, height:44});
                button.setBackgroundColor(UIColor.redColor());
                var UIControlStateNormal = 0;
                button.setTitle_forState("JSPatch", UIControlStateNormal);
                var UIControlEventTouchUpInside = 1 <<  6;
                button.addTarget_action_forControlEvents(self, "buttonClick:", UIControlEventTouchUpInside);
                self.view().addSubview(button);
            },
            buttonClick: function(button) {
                var tableVC = JPTableViewController.alloc().init();
                self.navigationController().pushViewController_animated(tableVC, YES);
            
            }
            }, {})


//defineClass('JPTableViewController : UITableViewController <UIAlertViewDelegate>', ['data'], {
//            dataSource: function() {
//                var data = self.data();
//                if (data) return data;
//                var data = [];
//                for (var i = 0; i < 20; i ++) {
//                    data.push("cell from js " + i);
//                }
//                self.setData(data)
//                return data;
//            },
//            numberOfSectionsInTableView: function(tableView) {
//                return 1;
//            },
//            tableView_numberOfRowsInSection: function(tableView, section) {
//                return self.dataSource().length;
//            },
//            tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
//                var cell = tableView.dequeueReusableCellWithIdentifier("cell")
//                if (!cell) {
//                    cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
//                }
//                cell.textLabel().setText(self.dataSource()[indexPath.row()])
//                return cell
//            },
//            tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
//                return 60
//            },
//            tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
//                var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert",self.dataSource()[indexPath.row()], self, "OK",  null);
//                alertView.show()
//                },
//                alertView_willDismissWithButtonIndex: function(alertView, idx) {
//                console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
//            }
//            })




