import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calculator/components/my_button.dart';

class Calci extends StatelessWidget {
  const Calci({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepOrange.shade100),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _final = '';
  String _temp = '';
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = '';
  String history = '';
  // ignore: non_constant_identifier_names
  String sp_history = '';
  double f = 0.0;
  int s = 0;
  bool showHistory = false;

  void hisPage() {
    setState(() {
      showHistory = !showHistory;
    });
  }

  bool present() {
    if (history.contains('+') ||
        history.contains('-') ||
        history.contains('^')) {
      return true;
    } else {
      return false;
    }
  }

  void cond(String op) {
    if (sp_history.isEmpty) {
      if (present()) {
        history = "(" + history + ")" + op + _final;
      } else {
        history = history + op + _final;
      }
    } else {
      if (present()) {
        history = "(" + history + ")" + op + sp_history;
      } else {
        history = history + op + sp_history;
      }
      sp_history = '';
    }
  }

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void showErrorMsg(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _round() {
    if ((double.parse(_final) - ((double.parse(_final)).round()).toDouble()) ==
        0.0) {
      _final = ((double.parse(_final)).round()).toString();
    }
    if (_temp.isNotEmpty) {
      if ((double.parse(_temp) - ((double.parse(_temp)).round()).toDouble()) ==
          0.0) {
        _temp = ((double.parse(_temp)).round()).toString();
      }
    }
  }

  void _calculate() {
    setState(() {
      s = 1;
      if (_final == 'Error') {
        _clear();
      } else if (_final.isNotEmpty) {
        num2 = double.parse(_final);
        if (operand == '+') {
          if (sp_history.isEmpty) {
            history = history + " + " + _final;
          } else {
            history = history + " + " + sp_history;
            sp_history = '';
          }
          _final = (num1 + num2).toString();

          _temp = num1.toString();
          _round();
          num1 = 0.0;
          num2 = 0.0;
          operand = '';
        } else if (operand == '-') {
          if (sp_history.isEmpty) {
            history = history + " - " + _final;
          } else {
            history = history + " - " + sp_history;
            sp_history = '';
          }
          _final = (num1 - num2).toString();

          _temp = num1.toString();
          _round();
          num1 = 0.0;
          num2 = 0.0;
          operand = '';
        } else if (operand == 'x') {
          cond(' x ');
          _final = (num1 * num2).toString();

          _temp = num1.toString();
          _round();
          num1 = 0.0;
          num2 = 0.0;
          operand = '';
        } else if (operand == '^') {
          if (num1 == 0 && num2 == 0) {
            _final = 'Error';
          } else if ((pow(num1, num2)).isInfinite) {
            _final = 'Infinity';
          } else {
            if (sp_history.isEmpty) {
              history = "(" + history + ")" + " ^ " + _final;
            } else {
              history = "(" + history + ")" + " ^ " + sp_history;
              sp_history = '';
            }
            _final = (pow(num1, num2)).toString();

            _temp = num1.toString();
            _round();
            num1 = 0.0;
            num2 = 0.0;
            operand = '';
          }
        } else if (operand == '÷') {
          if (num2 != 0) {
            cond(' ÷ ');
            _final = (num1 / num2).toString();

            _temp = num1.toString();
            _round();
            num1 = 0.0;
            num2 = 0.0;
            operand = '';
          } else {
            _final = 'Error';
          }
        }
      } else if (_final.isEmpty) {
        s = 0;
      }
    });
  }

  void _clear() {
    setState(() {
      _final = '';
      _temp = '';
      num1 = 0.0;
      num2 = 0.0;
      operand = '';
      s = 0;
      history = '';
      sp_history = '';
    });
  }

  void _opC(String op) {
    setState(() {
      s = 0;
      if (_final == 'Error') {
        _clear();
      } else if (_final.isNotEmpty) {
        _temp = _final;
        if (operand != '') {
          _calculate();
          s = 0;
          num1 = double.parse(_final);
          _temp = _final;
          _final = '';
          operand = op;
        } else {
          num1 = double.parse(_final);
          if (sp_history.isEmpty) {
            history = _final;
          } else {
            history = sp_history;
            sp_history = '';
          }
          _final = '';
          operand = op;
        }
      } else if (_final.isEmpty) {
        if (num1 == 0.0) {
          _temp = '0';
        }
        operand = op;
      }
    });
  }

  void _numC(a) {
    setState(() {
      if (_final != 'Error') {
        if (s == 1) {
          _clear();
        }
        if (_final.length <= 16) {
          if (a == '.') {
            if (!_final.contains('.')) {
              _final = _final + a;
            }
          } else {
            _final = _final + a;
          }
        } else {
          showErrorMsg('More digits can\'t be entered!');
        }
      } else if (_final == 'Error') {
        _clear();
      }
    });
  }

  void _eul() {
    setState(() {
      if (s == 1) {
        _clear();
      }
      if (_final != 'Error') {
        _final = '2.71828';
      } else if (_final == 'Error') {
        _clear();
      }
    });
  }

  void _pi() {
    setState(() {
      if (s == 1) {
        _clear();
      }
      if (_final != 'Error') {
        _final = '3.14159';
      } else if (_final == 'Error') {
        _clear();
      }
    });
  }

  void _ln() {
    setState(() {
      if (_final != 'Error') {
        f = double.parse(_final);
        if (f >= 0) {
          double lnf = log(f);
          s = 1;
          _final = lnf.toString();
          if (sp_history.isEmpty) {
            sp_history = "ln(" + f.toString() + ")";
          } else {
            sp_history = "ln(" + sp_history + ")";
          }
        } else {
          _final = 'Error';
        }
      } else if (_final == 'Error') {
        _clear();
      }
    });
  }

  void _sqrt() {
    setState(() {
      if (_final != 'Error') {
        f = double.parse(_final);
        if (f >= 0) {
          double sqrtf = sqrt(f);
          s = 1;
          _final = sqrtf.toString();
          //addCalc(user.email!, "sqrt(" + f.toString() + ") = " + _final);
          if (sp_history.isEmpty) {
            sp_history = "sqrt(" + f.toString() + ")";
          } else {
            sp_history = "sqrt(" + sp_history + ")";
          }
        } else {
          _final = 'Error';
        }
      } else if (_final == 'Error') {
        _clear();
      }
    });
  }

  void _sigC() {
    s = 0;
    setState(() {
      if (_final != 'Error') {
        f = double.parse(_final) * (-1);
        _final = f.toString();
        _round();
      } else if (_final == 'Error') {
        _clear();
      }
    });
  }

  void _backspace() {
    setState(() {
      if (s == 1) {
        _clear();
      }
      if (_final != 'Error') {
        _final = _final.substring(0, _final.length - 1);
      } else if (_final == 'Error') {
        _clear();
      }
    });
  }

  Future addCalc(String email, String calculation) async {
    await FirebaseFirestore.instance
        .collection('user:' + email)
        .add({'calculation': calculation, 'time': Timestamp.now()});
  }

  Future deleteCalc(String email, String docID) {
    return FirebaseFirestore.instance
        .collection('user:' + email)
        .doc(docID)
        .delete();
  }

  Stream<QuerySnapshot> getHistory(String email) {
    final historyStream = FirebaseFirestore.instance
        .collection('user:' + email)
        .orderBy('time', descending: true)
        .snapshots();
    return historyStream;
  }

  @override
  Widget build(BuildContext context) {
    //double displayW = MediaQuery.of(context).size.width;
    double displayH = MediaQuery.of(context).size.height;
    if (showHistory) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("History"),
          foregroundColor: Colors.black,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              onPressed: hisPage,
              icon: const Icon(Icons.arrow_back_ios_outlined),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: getHistory(user.email!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List calcList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: calcList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = calcList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String entry = data['calculation'];

                  return ListTile(
                      title: Text(entry),
                      trailing: IconButton(
                          onPressed: () => deleteCalc(user.email!, docID),
                          icon: const Icon(Icons.delete)));
                },
              );
            } else {
              return const Text('loading...');
            }
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: hisPage,
              icon: const Icon(Icons.history),
            ),
            IconButton(
              onPressed: signUserOut,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Text(_temp,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            Text(_final,
                style: const TextStyle(
                  fontSize: 28,
                  overflow: TextOverflow.fade,
                )),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MyButton(fnc: _eul, num: const Text('e')),
                    MyButton(fnc: _pi, num: const Text('π')),
                    MyButton(
                        fnc: _clear,
                        num: const Text('AC'),
                        fgcolor: Colors.red),
                    MyButton(
                        fnc: _backspace,
                        num: const Icon(Icons.backspace_outlined)),
                  ],
                ),
                SizedBox(
                  height: displayH * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MyButton(fnc: _ln, num: const Text('ln')),
                    MyButton(fnc: _sqrt, num: const Text('√')),
                    MyButton(
                        fnc: () {
                          _opC('^');
                        },
                        num: const Text('xʸ')),
                    MyButton(
                        fnc: () {
                          _opC('÷');
                        },
                        num: const Text('÷')),
                  ],
                ),
                SizedBox(
                  height: displayH * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MyButton(
                        fnc: () {
                          _numC('7');
                        },
                        num: const Text('7')),
                    MyButton(
                        fnc: () {
                          _numC('8');
                        },
                        num: const Text('8')),
                    MyButton(
                        fnc: () {
                          _numC('9');
                        },
                        num: const Text('9')),
                    MyButton(
                        fnc: () {
                          _opC('x');
                        },
                        num: const Text('x')),
                  ],
                ),
                SizedBox(
                  height: displayH * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MyButton(
                        fnc: () {
                          _numC('4');
                        },
                        num: const Text('4')),
                    MyButton(
                        fnc: () {
                          _numC('5');
                        },
                        num: const Text('5')),
                    MyButton(
                        fnc: () {
                          _numC('6');
                        },
                        num: const Text('6')),
                    MyButton(
                        fnc: () {
                          _opC('-');
                        },
                        num: const Text('-')),
                  ],
                ),
                SizedBox(
                  height: displayH * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MyButton(
                        fnc: () {
                          _numC('1');
                        },
                        num: const Text('1')),
                    MyButton(
                        fnc: () {
                          _numC('2');
                        },
                        num: const Text('2')),
                    MyButton(
                        fnc: () {
                          _numC('3');
                        },
                        num: const Text('3')),
                    MyButton(
                        fnc: () {
                          _opC('+');
                        },
                        num: const Text('+')),
                  ],
                ),
                SizedBox(
                  height: displayH * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MyButton(fnc: _sigC, num: const Text('±')),
                    MyButton(
                        fnc: () {
                          _numC('0');
                        },
                        num: const Text('0')),
                    MyButton(
                        fnc: () {
                          _numC('.');
                        },
                        num: const Text('.')),
                    MyButton(
                        fnc: () {
                          _calculate();
                          if (sp_history.isEmpty && history.isNotEmpty) {
                            addCalc(user.email!, history + " = " + _final);
                            history = '';
                          } else if (sp_history.isNotEmpty) {
                            addCalc(user.email!, sp_history + " = " + _final);
                            sp_history = '';
                          }
                        },
                        num: const Text('='),
                        bgcolor: Colors.lightGreen,
                        fgcolor: Colors.white,
                        shcolor: Colors.greenAccent),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
