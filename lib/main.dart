import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
/*
WebViewController controller;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.key,
      home: Scaffold(body: WebViewClass()),
    );
  }
}

class WebViewClass extends StatefulWidget {
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebViewClass> {
  num position = 1;

  //final key = UniqueKey();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    //firebaseCloudMessagingListeners();
  }

  doneLoading(String A) {
    setState(() {
      position = 0;
      //controller.evaluateJavascript('javascriptString');
      //Get.dialog()
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(index: position, children: <Widget>[
      SafeArea(
        child: WebView(
          initialUrl: 'https://au.qhomestory.com/user/mobile/ssoMain.do',
          javascriptMode: JavascriptMode.unrestricted,
          //key: key,
          onPageFinished: doneLoading,
          onPageStarted: startLoading,
          onWebViewCreated: (WebViewController webViewController) {
            controller = webViewController;
          },
        ),
      ),
      Container(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      ),
    ]));
  }
}
*/

InAppWebViewController controller;
final box = GetStorage();
final CookieManager cookieManager = CookieManager();

//void main() => runApp(MyApp());
void main() async {
  // it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // rest of your app code
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      home: CupertinoPageScaffold(
        child: WebViewClass(),
      ),
    );
  }
}

class WebViewClass extends StatefulWidget {
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebViewClass> {
  num position = 1;

  @override
  void initState() {
    super.initState();

    if (box.read('username') != null) {
      cookieManager.setCookie(
        url: 'https://au.qhomestory.com',
        name: 'username',
        value: box.read('username'),
        domain: 'au.qhomestory.com',
      );
    }
    if (box.read('password') != null) {
      cookieManager.setCookie(
        url: 'https://au.qhomestory.com',
        name: 'password',
        value: box.read('password'),
        domain: 'au.qhomestory.com',
      );
    }
  }

  doneLoading(String A) {
    setState(() {
      position = 0;
      //controller.evaluateJavascript('javascriptString');
      //Get.dialog()
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        // Stack과 같은 특성을 가지지만 설정된 index에 해당하는 자식만 보여줌.
        // IndexedStack의 크기는 자식들의 크기 중 가장 큰 크기에 맞춰짐
        child: IndexedStack(index: position, children: <Widget>[
      SafeArea(
        child: InAppWebView(
          initialUrl: 'https://au.qhomestory.com/user/mobile/ssoMain.do',
          onLoadStop: (InAppWebViewController controller, String url) async {
            String userName;
            String password;

            if (url == 'https://au.qhomestory.com/mobile/mainPage.do') {
              box.erase();
            } else {
              final gotCookies = await cookieManager.getCookies(
                  url: 'https://au.qhomestory.com');
              for (var item in gotCookies) {
                if (item.name == 'username') {
                  userName = item.value;
                  await cookieManager.setCookie(
                    url: 'https://au.qhomestory.com',
                    name: 'username',
                    value: userName,
                    domain: 'au.qhomestory.com',
                  );
                  box.write('username', userName);
                }
                if (item.name == 'password') {
                  password = item.value;
                  await cookieManager.setCookie(
                    url: 'https://au.qhomestory.com',
                    name: 'password',
                    value: password,
                    domain: 'au.qhomestory.com',
                  );
                  box.write('password', password);
                }
              }
            }

            setState(() {
              position = 0;
            });
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            setState(() {
              position = 1;
            });
          },
          onWebViewCreated: (InAppWebViewController webViewController) {
            controller = webViewController;
          },
        ),
      ),
      Container(
        color: Colors.white,
        child: Column(
          // 원래 child 크기에 따라 가로 크기가 변하지만 꽉차게 강제로 바꾼다.
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          // 가로축 균등하게 나눔
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // 가로축 가운데 모음
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
            ),
            SizedBox(
              width: 250,
              height: 100,
              child: Image.asset('images/qcells.png'),
            ),
            SizedBox(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Q",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                          fontSize: 25,
                        )),
                    Text(
                      ".HOME STORY",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              width: 200,
              height: 200,
            ),
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
              ),
            ),
          ],
        ),
      ),
    ]));
  }
}
