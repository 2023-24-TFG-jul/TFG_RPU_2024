import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class CsvService {
  Future<List<Map<String, String>>> loadCsvData(String path) async {
    try {
      final rawData = await rootBundle.loadString(path);
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);

      List<Map<String, String>> data = [];
      for (var row in csvTable.skip(1)) { // Saltar la fila de encabezado
        if (row.length >= 2) {
          data.add({
            'brand': row[0].toString(),
            'model': row[1].toString(),
          });
        }
      }
      return data;
    } catch (e) {
      return [];
    }
  }
}
