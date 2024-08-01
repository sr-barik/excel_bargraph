import 'package:flutter/material.dart';

class BarGraph extends StatelessWidget {
  const BarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CREDIT SALES'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Transform.rotate(
                    angle: 255 * 3.31 / 180,
                    child: const Text(
                      'Quantity',
                      style: TextStyle(),
                    ),
                  ),
                ]),
                // Y-axis
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: List.generate(
                //       5, (index) => Text('${(4 - index) * 25}')),
                // ),
                // const SizedBox(width: 5),
                // // Y-axis line
                Container(
                  width: 1,
                  color: Colors.black,
                ),
                // const SizedBox(width: 10),
                // Bars
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBar('MS', 0.8, '70'),
                          _buildBar('HSD', 0.9, '90'),
                          _buildBar('POWER', 0.4, '40'),
                          _buildBar('JET', 0.6, '60'),
                          _buildBar('MS - E20', 0.55, '55'),
                          _buildBar('CNG', 0.5, '50'),
                        ],
                      ),
                      // const SizedBox(height: 10),
                      Container(height: 1, color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Text('Products')
        ],
      ),
    );
  }

  Widget _buildBar(String label, double height, String value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 200 * height,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
              Transform.rotate(
                angle: 255 * 3.31 / 180,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          // Text(
          //   label,
          //   style: const TextStyle(fontSize: 12),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
