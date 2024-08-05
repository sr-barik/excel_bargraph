import 'package:flutter/material.dart';

class ManagementSystem extends StatefulWidget {
  const ManagementSystem({super.key});

  @override
  State<ManagementSystem> createState() => _ManagementSystemState();
}

class _ManagementSystemState extends State<ManagementSystem> {
  List<Map<String, dynamic>> customers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
        actions: [
          ElevatedButton(
            onPressed: () => _showCustomerDialog(),
            child: const Text('Create Customer'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Customer Code')),
                  DataColumn(label: Text('Customer Type')),
                  DataColumn(label: Text('Company/Customer Name')),
                  DataColumn(label: Text('Mobile Number')),
                  DataColumn(label: Text('Credit Limit')),
                  DataColumn(label: Text('Account Balance')),
                  DataColumn(label: Text('Action')),
                ],
                rows: customers.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> customer = entry.value;
                  return DataRow(
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
            ),
          ),
          // Pagination controls would go here
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
