import 'package:expense_app/controllers/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/static.dart' as Static;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  //

  int? amount;
  String note = "Some Expense";
  String type = "Income";
  DateTime selectedDate = DateTime.now();

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2022, 12),
      lastDate: DateTime(2100, 01),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      //
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          //
          SizedBox(
            height: 20,
          ),
          //
          Text(
            "Add Transaction",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          //
          SizedBox(
            height: 20,
          ),
          //
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Static.PrimaryColor,
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              //
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "0",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  onChanged: (val) {
                    try {
                      amount = int.parse(val);
                    } catch (e) {}
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          //

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Static.PrimaryColor,
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              //
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Note on Transaction",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  onChanged: (val) {
                    note = val;
                  },
                ),
              ),
            ],
          ),
          //
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Static.PrimaryColor,
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.moving_sharp,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              //
              ChoiceChip(
                checkmarkColor: type == "Income" ? Colors.white : Colors.black,
                label: Text(
                  "Income",
                  style: TextStyle(
                    fontSize: 16,
                    color: type == "Income" ? Colors.white : Colors.black,
                  ),
                ),
                selectedColor: Static.PrimaryColor,
                selected: type == "Income" ? true : false,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      type = "Income";
                    });
                  }
                },
              ),
              SizedBox(
                width: 12,
              ),
              //
              ChoiceChip(
                checkmarkColor: type == "Expense" ? Colors.white : Colors.black,
                label: Text(
                  "Expense",
                  style: TextStyle(
                    fontSize: 16,
                    color: type == "Expense" ? Colors.white : Colors.black,
                  ),
                ),
                selectedColor: Static.PrimaryColor,
                selected: type == "Expense" ? true : false,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      type = "Expense";
                    });
                  }
                },
              ),
            ],
          ),
          //
          SizedBox(
            height: 20,
          ),
          //
          SizedBox(
            height: 50,
            child: TextButton(
              onPressed: () {
                _selectedDate(context);
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Static.PrimaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.date_range,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text("${selectedDate.day} ${months[selectedDate.month - 1]}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          //
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                //
                if (amount != null && note.isNotEmpty) {
                  //
                  DbHelper dbHelper = DbHelper();
                  await dbHelper.addData(amount!, selectedDate, note, type);
                  Navigator.of(context).pop();
                } else {
                  print("Not All Values Provided !");
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Static.PrimaryColor),
              child: Text(
                "Add",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
