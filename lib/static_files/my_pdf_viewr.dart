import 'package:flutter/material.dart';
//import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'my_color.dart';

class PdfViewer extends StatefulWidget {
  final String url;

  const PdfViewer({Key? key, required this.url}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(
      widget.url,
      enableDoubleTapZooming: true,
    );
    // return  const PDF(
    //   enableSwipe: true,
    //   swipeHorizontal: false,
    //   autoSpacing: false,
    //   pageFling: false,
    //   // onError: (error) {
    //   //   print(error.toString());
    //   // },
    //   // onPageChanged: (int? page, int? total) {
    //   //   print('page change: $page/$total');
    //   // },
    //   // onPageError: (page, error) {
    //   //   print('$page: ${error.toString()}');
    //   // },
    // ).cachedFromUrl(
    //   widget.url,
    //   placeholder: (progress) => Center(child: Text('$progress %')),
    //   errorWidget: (error) => Center(child: Text(error.toString())),
    // );
  }
}

class PdfViewerAssets extends StatefulWidget {
  final String filePDF;
  final Color color;
  const PdfViewerAssets({super.key, required this.filePDF, required this.color});

  @override
  State<PdfViewerAssets> createState() => _PdfViewerAssetsState();
}

class _PdfViewerAssetsState extends State<PdfViewerAssets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
      ),
      body: SfPdfViewer.asset(
        widget.filePDF,
        enableDoubleTapZooming: true,
      ),
    );
  }
}
