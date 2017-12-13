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
