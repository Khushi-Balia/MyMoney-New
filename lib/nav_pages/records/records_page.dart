import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import '../../pages/home_pages/expense_pages/addexpense.dart';
import '../budgets/budget_backend/buckets.firestore.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final TextEditingController _textDate = TextEditingController();

  String? getEmail(){
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser!.email;
    return uid;
  }

  Map<String, String> map1 = {
    'Shopping': 'assets/expense_icons/online-shopping.png',
    'Grocery': 'assets/expense_icons/grocery-cart.png',
    'Dining': 'assets/expense_icons/dining.png',
    'Bills': 'assets/expense_icons/bill.png',
    'Fuel': 'assets/expense_icons/biofuel.png',
    'Gadgets': 'assets/expense_icons/headphone.png',
    'Investment': 'assets/expense_icons/profits.png',
    'Household': 'assets/expense_icons/appliances.png',
    'Kids': 'assets/expense_icons/children.png',
    'Office': 'assets/expense_icons/bag.png',
    'House Rent': 'assets/expense_icons/home.png',
    'Travel': 'assets/expense_icons/destination.png',
    'Leisure': 'assets/expense_icons/golf-player.png',
    'Grooming': 'assets/expense_icons/sparkle.png',
    'Health': 'assets/expense_icons/heartbeat.png',
    'Transport': 'assets/expense_icons/metro.png',
  };

  String? imageRoute(String categoryName) {
    return map1[categoryName];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text('Records'),
        backgroundColor: Colors.amber,
      ),
      body: Container(
          decoration: const BoxDecoration(
            color: Colors.white54,
          ),
          padding: EdgeInsets.only(right: 20.0, left: 20.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.c,
            children: [
              SizedBox(
                height: 20,
              ),
              TextField(
                //onChanged: (value) =>
                controller: _textDate,
                decoration: InputDecoration(
                  hintText: 'Select Date',
                  hintStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2100),
                  );
                  setState(() {
                    if (date != null) {
                      _textDate.text = "${date.day}-${date.month}-${date.year}";
                    }
                  });
                },
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
               ),



              Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
              borderRadius: BorderRadius.circular(17.0),
            ),
            width: double.infinity,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(FirestoreBuckets.users)
                  .doc(getEmail())
                  .collection(FirestoreBuckets.dates)
                  .doc(_textDate.toString())
                  .collection(FirestoreBuckets.expenses)
                  .snapshots(),
              builder: (___,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  snapshot) {
                if (snapshot.hasData && snapshot.data != null && _textDate.text != null) {
                  print("Total Documents: ${snapshot.data!.docs.length}");
                  if (snapshot.data!.docs.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, int index) {
                          Map<String, dynamic> docData =
                          snapshot.data!.docs[index].data();

                          if (docData.isEmpty) {
                            return const Text(
                              "Document is Empty",
                              textAlign: TextAlign.center,
                            );
                          }
                          String category =
                          docData[FirestoreBuckets.categoryName];
                          int expense = docData[FirestoreBuckets.expense];
                          // expenseDay = expenseDay + expense;
                          return TextButton(
                            child: Container(
                              height: 65.0,
                              margin: const EdgeInsets.only(
                                  top: 8.0, left: 6.0, right: 6.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 13.0, right: 13.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40.0,
                                      width: 40.0,
                                      child:
                                      Image.asset(imageRoute(category)!),
                                    ),
                                    // const SizedBox(width: 20.0),
                                    Text(
                                      category,
                                      style: const TextStyle(fontSize: 22.0,
                                          color: Colors.black),
                                    ),
                                    //const SizedBox(width: 18.0),
                                    Text(
                                      "₹$expense",
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => IncrementExpense(category: category, expenditureOld: expense))
                              );
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Start adding expenses by clicking +",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 19.0),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: Text("Getting Error"),
                  );
                }
              },
            ),
          ),
        ),




            ],
          ),
        ),
      );


  }
}
