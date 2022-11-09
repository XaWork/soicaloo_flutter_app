import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socialoo/layouts/widgets/view_pdf.dart';

class PdfWidget extends StatefulWidget {
  final String? pdf;
  final String? pdfName;
  final String? pdfSize;

  const PdfWidget({
    Key? key,
    this.pdf,
    this.pdfName,
    this.pdfSize,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  PdfWidgetState createState() =>
      PdfWidgetState(pdf: pdf, pdfName: pdfName, pdfSize: pdfSize);
}

class PdfWidgetState extends State<PdfWidget> {
  TextEditingController commentController = TextEditingController();
  final String? pdf;
  final String? pdfName;
  final String? pdfSize;
  String remotePDFpath = "";

  PdfWidgetState({
    this.pdf,
    this.pdfName,
    this.pdfSize,
  });

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final url = pdf!;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (remotePDFpath.isNotEmpty) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(
                path: remotePDFpath,
                pdfName: pdfName,
              ),
            ),
          );
        }
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey)),
          child: ListTile(
            leading: SvgPicture.asset(
              'assets/images/pdf_file.svg',
              height: 45,
              color: Colors.grey,
            ),
            title: Text(
              pdfName!,
              style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
            ),
            subtitle: Text(
              pdfSize!,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
