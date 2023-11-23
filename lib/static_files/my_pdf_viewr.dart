import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'my_color.dart';

class PdfViewer extends StatefulWidget {
  final String url;

  const PdfViewer({Key? key, required this.url}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  Future<bool> _pdfLoaded = Future<bool>.delayed(
    Duration(seconds: 1),
        () => true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.yellow,
      ),
      body: FutureBuilder(
        future: _pdfLoaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error loading PDF');
          } else {
            return SfPdfViewer.network(
              widget.url,
              enableDoubleTapZooming: true,
            );
          }
        },
      ),
    );
  }
}
