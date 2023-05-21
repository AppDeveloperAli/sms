import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PDFViewerScreen extends StatefulWidget {
  String pdfPath;
  PDFViewerScreen({Key? key,required this.pdfPath}) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: ('https://docs.google.com/gview?embedded=true&url=${widget.pdfPath}'),
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
