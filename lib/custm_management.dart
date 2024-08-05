import 'package:flutter/material.dart';

class ManagementSystem extends StatefulWidget {
  const ManagementSystem({super.key});

  @override
  State<ManagementSystem> createState() => _ManagementSystemState();
}

class _ManagementSystemState extends State<ManagementSystem> {
  List<Map<String, dynamic>> customers = [
    // Add your initial customer data here
  ];

  int currentPage = 0;
  int rowsPerPage = 9; // Change this to the number of rows you want per page

  @override
  Widget build(BuildContext context) {
    int start = currentPage * rowsPerPage;
    int end = start + rowsPerPage;
    List<Map<String, dynamic>> paginatedCustomers = customers.sublist(
      start,
      end > customers.length ? customers.length : end,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.blue),
            ),
            onPressed: () => _showCustomerDialog(),
            child: const Text(
              'Create Customer',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 8, right: MediaQuery.of(context).size.width / 1.3),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here....',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    headingRowColor:
                        MaterialStateProperty.all<Color>(Colors.blue[50]!),
                    border: const TableBorder.symmetric(),
                    columns: const [
                      DataColumn(label: Text('Customer Code')),
                      DataColumn(label: Text('Customer Type')),
                      DataColumn(label: Text('Company/Customer Name')),
                      DataColumn(label: Text('Mobile Number')),
                      DataColumn(label: Text('Credit Limit')),
                      DataColumn(label: Text('Account Balance')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: paginatedCustomers.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> customer = entry.value;
                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return index.isEven
                                ? Colors.white
                                : Colors.blue[50];
                          },
                        ),
                        cells: [
                          DataCell(Text(customer['code'])),
                          DataCell(Text(customer['type'])),
                          DataCell(Text(customer['name'])),
                          DataCell(Text(customer['mobile'])),
                          DataCell(Text(customer['creditLimit'].toString())),
                          DataCell(Text(customer['accountBalance'].toString())),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _showCustomerDialog(editIndex: index),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () {}),
                              IconButton(
                                  icon: const Icon(Icons.car_rental),
                                  onPressed: () {}),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 4,
                right: MediaQuery.of(context).size.width / 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Showing ${start + 1} to ${end > customers.length ? customers.length : end} of ${customers.length} entries',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left),
                          onPressed: currentPage > 0
                              ? () {
                                  setState(() {
                                    currentPage--;
                                  });
                                }
                              : null,
                        ),
                        for (int i = 1;
                            i <= (customers.length / rowsPerPage).ceil();
                            i++)
                          ElevatedButton(
                            child: Text('$i'),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              foregroundColor: currentPage == i - 1
                                  ? Colors.white
                                  : Colors.black,
                              backgroundColor: currentPage == i - 1
                                  ? Colors.blue
                                  : Colors.grey[200],
                            ),
                            onPressed: () {
                              setState(() {
                                currentPage = i - 1;
                              });
                            },
                          ),
                        IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed:
                              (currentPage + 1) * rowsPerPage < customers.length
                                  ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                  : null,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showCustomerDialog({int? editIndex}) {
    String code = '';
    String type = 'INDIVIDUAL';
    String name = '';
    String mobile = '';
    double creditLimit = 0;
    double accountBalance = 0;

    if (editIndex != null) {
      final customer = customers[editIndex];
      code = customer['code'];
      type = customer['type'];
      name = customer['name'];
      mobile = customer['mobile'];
      creditLimit = customer['creditLimit'];
      accountBalance = customer['accountBalance'];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(editIndex == null ? 'Create Customer' : 'Edit Customer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Customer Code'),
                  onChanged: (value) => code = value,
                  controller: TextEditingController(text: code),
                ),
                DropdownButtonFormField<String>(
                  value: type,
                  items: ['INDIVIDUAL', 'COMPANY'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => type = value!,
                  decoration: const InputDecoration(labelText: 'Customer Type'),
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Company/Customer Name'),
                  onChanged: (value) => name = value,
                  controller: TextEditingController(text: name),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  onChanged: (value) => mobile = value,
                  controller: TextEditingController(text: mobile),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Credit Limit'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      creditLimit = double.tryParse(value) ?? 0,
                  controller:
                      TextEditingController(text: creditLimit.toString()),
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Account Balance'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      accountBalance = double.tryParse(value) ?? 0,
                  controller:
                      TextEditingController(text: accountBalance.toString()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(editIndex == null ? 'Create' : 'Update'),
              onPressed: () {
                setState(() {
                  final customerData = {
                    'code': code,
                    'type': type,
                    'name': name,
                    'mobile': mobile,
                    'creditLimit': creditLimit,
                    'accountBalance': accountBalance,
                  };
                  if (editIndex == null) {
                    customers.add(customerData);
                  } else {
                    customers[editIndex] = customerData;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
