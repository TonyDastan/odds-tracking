import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'model/OddEntry.dart';

class OddsTrackerPage extends StatefulWidget {
  @override
  _OddsTrackerPageState createState() => _OddsTrackerPageState();
}

class _OddsTrackerPageState extends State<OddsTrackerPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<OddEntry> _oddEntries = [];

  @override
  void initState() {
    super.initState();
    _loadOdds();
  }

  void _loadOdds() async {
    final odds = await _dbHelper.getOdds();
    setState(() {
      _oddEntries = odds;
    });
  }

  void _addOddEntry(String input) async {
    double? newOdd = double.tryParse(input); // Use null-aware operator
    if (newOdd == null) {
      print('Invalid input, not a number');
      return; // Exit the function if input is not a valid double
    }

    DateTime now = DateTime.now();
    OddEntry newEntry = OddEntry(newOdd, now);

    int result = await _dbHelper.insertOdd(newEntry);
    if (result > 0) {
      print('Odd added successfully');
      _loadOdds(); // Reload odds after insertion
    } else {
      print('Failed to add odd');
    }
  }

  void _showInputDialog() {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Odd'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'Enter a number',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addOddEntry(_controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Odds Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await _dbHelper.deleteAllOdds();
              _loadOdds();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _oddEntries.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Odd Details'),
                    content: Text('Entered at: ${_oddEntries[index].time}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Card(
                color: Colors.black,
                child: Center(
                  child: Text(
                    _oddEntries[index].odd.toStringAsFixed(2),
                    style: TextStyle(
                      color: _getOddColor(_oddEntries[index].odd),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInputDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Color _getOddColor(double odd) {
    if (odd >= 1.00 && odd < 2.00) {
      return Colors.blue;
    } else if (odd >= 2.00 && odd < 10.00) {
      return Colors.purple;
    } else {
      return Colors.pink;
    }
  }
}
