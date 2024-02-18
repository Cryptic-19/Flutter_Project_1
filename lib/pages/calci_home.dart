import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Calci());
}*/

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
  double f = 0.0;
  int s = 0;
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future addCalc(String email, String calculation) async {
    await FirebaseFirestore.instance
        .collection('user:' + email)
        .add({'calculation': calculation});
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
          _final = (num1 + num2).toString();
          addCalc(user.email!,
              num1.toString() + " + " + num2.toString() + " = " + _final);
          _temp = num1.toString();
          _round();
          num1 = 0.0;
          num2 = 0.0;
          operand = '';
        } else if (operand == '-') {
          _final = (num1 - num2).toString();
          addCalc(user.email!,
              num1.toString() + " - " + num2.toString() + " = " + _final);
          _temp = num1.toString();
          _round();
          num1 = 0.0;
          num2 = 0.0;
          operand = '';
        } else if (operand == 'x') {
          _final = (num1 * num2).toString();
          addCalc(user.email!,
              num1.toString() + " x " + num2.toString() + " = " + _final);
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
            _final = (pow(num1, num2)).toString();
            addCalc(user.email!,
                num1.toString() + " ^ " + num2.toString() + " = " + _final);
            _temp = num1.toString();
            _round();
            num1 = 0.0;
            num2 = 0.0;
            operand = '';
          }
        } else if (operand == '÷') {
          if (num2 != 0) {
            _final = (num1 / num2).toString();
            addCalc(user.email!,
                num1.toString() + " ÷ " + num2.toString() + " = " + _final);
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
          addCalc(user.email!, "ln(" + f.toString() + ") = " + _final);
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
          addCalc(user.email!, "sqrt(" + f.toString() + ") = " + _final);
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

  @override
  Widget build(BuildContext context) {
    double displayW = MediaQuery.of(context).size.width;
    double displayH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: _eul,
                    child: const Text('e'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: _pi,
                    child: const Text('π'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: _clear,
                    child: const Text('AC'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: _backspace,
                    child: const Icon(Icons.backspace_outlined),
                  ),
                ],
              ),
              SizedBox(
                height: displayH * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: _ln,
                    child: const Text('ln'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: _sqrt,
                    child: const Text('√'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _opC('^');
                    },
                    child: const Text('xʸ'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _opC('÷');
                    },
                    child: const Text('÷'),
                  ),
                ],
              ),
              SizedBox(
                height: displayH * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('1');
                    },
                    child: const Text('1'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('2');
                    },
                    child: const Text('2'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('3');
                    },
                    child: const Text('3'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _opC('x');
                    },
                    child: const Text('x'),
                  ),
                ],
              ),
              SizedBox(
                height: displayH * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('4');
                    },
                    child: const Text('4'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('5');
                    },
                    child: const Text('5'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('6');
                    },
                    child: const Text('6'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _opC('+');
                    },
                    child: const Text('+'),
                  ),
                ],
              ),
              SizedBox(
                height: displayH * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('7');
                    },
                    child: const Text('7'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('8');
                    },
                    child: const Text('8'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('9');
                    },
                    child: const Text('9'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _opC('-');
                    },
                    child: const Text('-'),
                  ),
                ],
              ),
              SizedBox(
                height: displayH * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: _sigC,
                    child: const Text('±'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('0');
                    },
                    child: const Text('0'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(displayW * 0.20, displayH * 0.075),
                    ),
                    onPressed: () {
                      _numC('.');
                    },
                    child: const Text('.'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize:
                          Size(displayW * 0.20, displayH * 0.075), //////// HERE
                    ),
                    onPressed: _calculate,
                    child: const Text('='),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
