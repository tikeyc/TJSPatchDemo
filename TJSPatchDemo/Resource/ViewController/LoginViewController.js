require("NSString, NSMutableDictionary, NSBundle, UIStoryboard, PPNetworkHelper");

defineClass("LoginViewController", {
            loginRequest: function() {
                var url = NSString.stringWithFormat("http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1");
            
                var parameters = NSMutableDictionary.alloc().init();
                parameters.setObject_forKey('tikeyc', 'userName');
                console.log('LoginViewController.js --- ' + parameters.objectForKey('userName').toJS());
            
                url = url.stringByRemovingPercentEncoding();
            
                PPNetworkHelper.GET_parameters_success_failure(url,
                                                               parameters,
                                                               block("void, id",
                                                                     function(responseObject) {
                                                                     self.view().window().setRootViewController(UIStoryboard.storyboardWithName_bundle("Main", NSBundle.mainBundle()).instantiateInitialViewController());
                                                                     }),
                                                               block("void, NSError*",
                                                                     function(error) {
                                                                        console.log('LoginViewController.js --- ' + error.description().toJS());
                                                                    self.view().window().setRootViewController(UIStoryboard.storyboardWithName_bundle("Main", NSBundle.mainBundle()).instantiateInitialViewController());
                                                                     }));
            }
            }, {});
