import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(
      home: WebViewScreen(),
    ));

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController webViewController;
  bool hasData;
  String webFilePath;
  List<String> lapList;

  @override
  void initState() {
    hasData = false;
    lapList = [];

    super.initState();
  }

  @override
  void dispose() {
    webViewController = null;
    hasData = false;
    lapList = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                //JavaScript WebView
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: webView(),
                ),
                //Control Buttons
                Container(
                  child: buttonViewRow(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //Lap List
                Container(
                  child: uiLapListView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget webView() {
    return WebView(
      initialUrl:
          "file:///D:/Internship/Flutter/webviewproject/assets/index.html",
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController controller) {
        webViewController = controller;
      },
      javascriptChannels: Set.from(
        [
          JavascriptChannel(
            name: "LapMessage",
            onMessageReceived: (JavascriptMessage message) {
              setState(() {
                if (message.message == 'Start') {
                  hasData = true;
                } else if (message.message == 'Stop') {
                  hasData = false;
                } else {
                  lapList.add(message.message);
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buttonViewRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //Start Timer
        uiButton(
          index: 1,
          buttonLabel: 'Start',
        ),
        //Stop Timer
        if (hasData)
          uiButton(
            index: 2,
            buttonLabel: 'Stop',
          ),
        //Add Lap
        if (hasData)
          uiButton(
            index: 3,
            buttonLabel: 'Lap',
          )
      ],
    );
  }

  Widget uiLapListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: lapList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Color(0xFF1F375F),
          child: ListTile(
            leading: uiText(labelText: '${index + 1}'),
            title: uiText(labelText: lapList[index]),
          ),
        );
      },
    );
  }

  Widget uiText({
    String labelText,
  }) {
    return Text(
      labelText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Colors.white,
      ),
    );
  }

  Widget uiButton({
    int index,
    String buttonLabel,
  }) {
    return ElevatedButton(
      onPressed: () {
        if (index == 1) {
          webViewController.evaluateJavascript("startTimer()");
        } else if (index == 2) {
          webViewController.evaluateJavascript('stopTimer()');
          lapList.clear();
        } else {
          webViewController.evaluateJavascript('createLap()');
        }
      },
      child: Text(buttonLabel),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Color(0xFF1F375F),
          ),
          textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white))),
    );
  }
}
