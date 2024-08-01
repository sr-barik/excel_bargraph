import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<String>> tableData = [];

  @override
  void initState() {
    super.initState();
    _initializeTableData();
  }

  void _initializeTableData() {
    tableData = [
      [
        'Date',
        'Opening Stock',
        'Receipt',
        'Total Stock',
        'Sales By Meter',
        'Pump Test',
        'Net Sales By Meter',
        'Cumulative Sales',
        'Sales By Dip',
        'Variation',
        '',
        'Remarks'
      ],
      ['', '', '', '', '', '', '', '', '', 'Daily', 'Cumm.', ''],
      // Add empty rows for data
      ...List.generate(10, (_) => List.filled(12, '')),
    ];
  }

  Future<void> _createExcelFile() async {
    var excelFile = excel.Excel.createExcel();
    excel.Sheet sheetObject = excelFile['Sheet1'];

    for (int i = 0; i < tableData.length; i++) {
      for (int j = 0; j < tableData[i].length; j++) {
        var cell = sheetObject.cell(
            excel.CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i));
        cell.value = excel.TextCellValue(tableData[i][j]);
      }
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/FuelSalesReport.xlsx';
    final file = File(path);
    file.writeAsBytesSync(excelFile.encode()!);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Excel file created at $path')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Sales Report'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(color: Colors.black),
            defaultColumnWidth: const FixedColumnWidth(100.0),
            children: [
              TableRow(
                children: List.generate(
                  tableData[0].length,
                  (index) => TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(4.0),
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          tableData[0][index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TableRow(
                children: List.generate(
                  tableData[1].length,
                  (index) => TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(4.0),
                      color: Colors.grey[100],
                      child: Center(
                        child: Text(
                          tableData[1][index],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              for (int i = 2; i < tableData.length; i++)
                TableRow(
                  children: List.generate(
                    tableData[i].length,
                    (index) => TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 4),
                          ),
                          onChanged: (value) {
                            setState(() {
                              tableData[i][index] = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createExcelFile,
        child: const Icon(Icons.save),
      ),
    );
  }
}
