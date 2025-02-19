import 'package:expense_app/controllers/db_helper.dart';
import 'package:expense_app/pages/add_transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper = DbHelper();
  DateTime today = DateTime.now();
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataset = [];

  List<FlSpot> getPlotPoints(Map entireData) {
    dataset = [];
    entireData.forEach((key, value) {
      if (value['type'] == "Expense" &&
          (value['date'] as DateTime).month == today.month) {
        dataset.add(
          FlSpot(
            (value['date'] as DateTime).day.toDouble(),
            (value['amount'] as int).toDouble(),
          ),
        );
      }
    });
    return dataset;
  }

  getTotalBalance(Map entireData) {
    totalExpense = 0;
    totalIncome = 0;
    totalBalance = 0;

    entireData.forEach((key, value) {
      print(value);
      if (value['type'] == "Income") {
        totalBalance += (value['amount'] as int);
        totalIncome += (value['amount'] as int);
      } else {
        totalBalance -= (value['amount'] as int);
        totalExpense += (value['amount'] as int);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddTransaction(),
            ),
          )
              .whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: Color.fromARGB(255, 143, 47, 40),
        child: Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
      //
      body: FutureBuilder<Map>(
          future: dbHelper.fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Unexpected Error !"),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text("No Values Found !"),
                );
              }
              //
              getTotalBalance(snapshot.data!);
              getPlotPoints(snapshot.data!);
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: Colors.white70,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red.shade200,
                                  maxRadius: 40,
                                  child: Image.asset(
                                    "assets/ilk.png",
                                    width: 70,
                                  ),
                                )),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "Welcome, Ilkin ",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(228, 56, 48, 115),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white70,
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.settings,
                            size: 32,
                            color: Color(0xff3E454C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  //
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.all(
                      12,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.blueAccent],
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                      child: Column(
                        children: [
                          Text(
                            "Total Balance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            " AZN $totalBalance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardIncome(
                                  totalIncome.toString(),
                                ),
                                cardExpense(
                                  totalExpense.toString(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //
                  //
                  //
                  //
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Expenses",
                      style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  //
                  //
                  //
                  //
                  dataset.length < 2
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 5,
                                    blurRadius: 6,
                                    offset: Offset(0, 4))
                              ]),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 40.0),
                          margin: EdgeInsets.all(12),
                          child: Text(
                            "Not enough Values to render Chart",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ))
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 5,
                                    blurRadius: 6,
                                    offset: Offset(0, 4))
                              ]),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 40.0),
                          margin: EdgeInsets.all(12),
                          height: 400,
                          child: LineChart(
                            LineChartData(
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: getPlotPoints(snapshot.data!),
                                    isCurved: false,
                                    barWidth: 2.5,
                                    color: Colors.red,
                                  ),
                                ]),
                          ),
                        ),
                  //
                  //
                  //
                  //
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Recent Expenses",
                      style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  //
                  //
                  //
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map dataAtIndex = snapshot.data![index];
                      if (dataAtIndex['type'] == "Income") {
                        return incomeTile(
                          dataAtIndex['amount'],
                          dataAtIndex['note'],
                        );
                      } else {
                        return expenseTile(
                          dataAtIndex['amount'],
                          dataAtIndex['note'],
                        );
                      }
                    },
                  )
                ],
              );
            } else {
              return Center(
                child: Text("Unexpected Error !"),
              );
            }
          }),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(6),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(6),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget expenseTile(int value, String note) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(
          0xffced4eb,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_up_outlined,
                size: 28,
                color: Colors.red[700],
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                "Expense",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Text(
            "- $value",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  Widget incomeTile(int value, String note) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(
          0xffced4eb,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_down_outlined,
                size: 28,
                color: Colors.green[700],
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                "Income",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Text(
            "+ $value",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
