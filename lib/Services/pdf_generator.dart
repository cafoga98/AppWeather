import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unipilotoconmutacion/Services/persister.dart' as global;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFgen {

  Future<Uint8List> generateDocument(PdfPageFormat format, List<List<dynamic>> ListaTable) async {
    print("LISTA QUE SERA LA TABLA");

    ListaTable.insert(0, ['#','Fecha', 'Radiación', 'Temperatura','Humedad']);
    print(ListaTable.toString());
    final pw.Document doc = pw.Document();

    doc.addPage(pw.MultiPage(
        pageFormat:
        PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        maxPages: 1000000,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: pw.Text('Universidad Piloto de Colombia',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text('Informe Climatologico', textScaleFactor: 2),
                    pw.PdfLogo()
                  ])),
          pw.Paragraph(
              text:
              'A continuacion se mostrara el reporte climatologico desde la fecha ${global.DateFrom}, hasta la fecha: ${global.DateTo} proveniente de las instalaciones de la Universidad Piloto de Colombia en la sede del Alto Magdalena:'),
          pw.Table.fromTextArray(context: context, data: ListaTable),
          pw.Padding(padding: const pw.EdgeInsets.all(10)),
          pw.Paragraph(
              text:
              'Creado por: Carlos Fernando Villareal Ramirez y Román Fernando Jiménez Bulla.')
        ]));
    print("RETORNANDO PDF CREATOR");
    global.ProgressPDF = false;
    /*final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/reporte_climatico.pdf");
    global.DateFrom ='0000-00-00';
    await file.writeAsBytes(doc.save());
    await FlutterShareFile.shareImage(directory.path, "reporte_climatico.pdf");*/

    return doc.save();
  }

}

/*
const <List<String>>[
<String>['Date', 'PDF Version', 'Acrobat Version'],
<String>['1993', 'PDF 1.0', 'Acrobat 1'],
<String>['1994', 'PDF 1.1', 'Acrobat 2'],
<String>['1996', 'PDF 1.2', 'Acrobat 3'],
<String>['1999', 'PDF 1.3', 'Acrobat 4'],
<String>['2001', 'PDF 1.4', 'Acrobat 5'],
<String>['2003', 'PDF 1.5', 'Acrobat 6'],
<String>['2005', 'PDF 1.6', 'Acrobat 7'],
<String>['2006', 'PDF 1.7', 'Acrobat 8'],
<String>['2008', 'PDF 1.7', 'Acrobat 9'],
<String>['2009', 'PDF 1.7', 'Acrobat 9.1'],
<String>['2010', 'PDF 1.7', 'Acrobat X'],
<String>['2012', 'PDF 1.7', 'Acrobat XI'],
<String>['2017', 'PDF 2.0', 'Acrobat DC'],
]
*/
