import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Unit Conversion App',
    home: UnitSelectorPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class UnitSelectorPage extends StatelessWidget {
  const UnitSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarTextStyle: const TextStyle(overflow: TextOverflow.ellipsis),
        title: const Text('Unit Conversion App : Unit Selection'),
      ),
      body: Center(
        child: Column(children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: UnitDropdownWidget(),
          ),
        ]),
      ),
    );
  }
}

class UnitDropdownWidget extends StatefulWidget {
  const UnitDropdownWidget({super.key});

  @override
  State<UnitDropdownWidget> createState() => _UnitDropdownWidgetState();
}

class _UnitDropdownWidgetState extends State<UnitDropdownWidget> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final List<String> dropdownItems = <String>[
    "Length",
    "Weight",
    "Temperature"
  ];
  String selectedVal = "Length";

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formState,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            Container(
              decoration: const BoxDecoration(),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.black12,
                    labelText: "Unit to convert",
                    labelStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
                value: selectedVal,
                items:
                    dropdownItems.map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                iconSize: 25,
                onChanged: (String? value) {
                  setState(() {
                    selectedVal = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (selectedVal == "Length") {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: const ConversionPage(
                            measurement: "Length",
                          ),
                          type: PageTransitionType.fade,
                          inheritTheme: true,
                          ctx: context),
                    );
                  } else if (selectedVal == "Weight") {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: const ConversionPage(
                            measurement: "Weight",
                          ),
                          type: PageTransitionType.fade,
                          inheritTheme: true,
                          ctx: context),
                    );
                  } else if (selectedVal == "Temperature") {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: const ConversionPage(
                            measurement: "Temperature",
                          ),
                          type: PageTransitionType.fade,
                          inheritTheme: true,
                          ctx: context),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}

// =============================================================================
// Pages to be routed from the home page (UnitSelectorRoute)

class ConversionPage extends StatelessWidget {
  final String measurement;

  const ConversionPage({super.key, required this.measurement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Conversion App : $measurement Conversion'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: UnitExchangeWidget(
              measurement: measurement,
            ),
          ),
        ]),
      ),
    );
  }
}

class UnitExchangeWidget extends StatefulWidget {
  final String measurement;

  const UnitExchangeWidget({super.key, required this.measurement});

  @override
  State<UnitExchangeWidget> createState() => _UnitExchangeWidgetState();
}

class _UnitExchangeWidgetState extends State<UnitExchangeWidget> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final _inputText1Controller = TextEditingController();
  final _inputText2Controller = TextEditingController();
  final _outputText1Controller = TextEditingController();
  final _outputText2Controller = TextEditingController();

  @override
  void dispose() {
    _inputText1Controller.dispose();
    _inputText2Controller.dispose();
    _outputText1Controller.dispose();
    _outputText2Controller.dispose();
    super.dispose();
  }

  String _unitConversionFromLabel1 = "Feet";
  String _unitConversionFromLabel2 = "Inches";
  String _unitConversionToLabel1 = "Meter";
  String _unitConversionToLabel2 = "Centimeters";
  num _unitConversionDirection = -1; // imperial to metric
  num _unitConversionFactor = 2.54;
  num _reductionFactorFrom =
      12; // reduces the 1st input field value to the 2nd input field if applicable
  num _reductionFactorTo =
      100; // provides the 2nd output field value in terms of the 1st output field unit if applicable
  bool _visibleFrom = false;
  bool _visibleTo = false;

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
      msg: widget.measurement,
    );
    String unitToMeasure = widget.measurement;
    setState(() {
      if (unitToMeasure == "Length") {
        _unitConversionFromLabel1 = "Feet";
        _unitConversionFromLabel2 = "Inches";
        _unitConversionToLabel1 = "Meter";
        _unitConversionToLabel2 = "Centimeters";
        _unitConversionDirection = -1;
        _unitConversionFactor = 2.54;
        _reductionFactorFrom = 12;
        _reductionFactorTo = 100;
        _visibleFrom = true;
        _visibleTo = true;
      } else if (unitToMeasure == "Weight") {
        _unitConversionFromLabel1 = "Kilograms";
        _unitConversionFromLabel2 = "Grams";
        _unitConversionToLabel1 = "Pounds";
        _unitConversionToLabel2 = "";
        _unitConversionDirection = 1;
        _unitConversionFactor = 0.00220462;
        _reductionFactorFrom = 1000;
        _reductionFactorTo = 1;
        _visibleFrom = true;
        _visibleTo = false;
      } else if (unitToMeasure == "Temperature") {
        _unitConversionFromLabel1 = "Celsius";
        _unitConversionFromLabel2 = "";
        _unitConversionToLabel1 = "Fahrenheit";
        _unitConversionToLabel2 = "";
        _unitConversionDirection = 1;
        _unitConversionFactor = 1.8;
        _visibleFrom = false;
        _visibleTo = false;
      }
    });
  }

  void _clearOutput() {
    _inputText1Controller.value = const TextEditingValue(text: "0");
    _inputText2Controller.value = const TextEditingValue(text: "0");
    _outputText1Controller.value = const TextEditingValue(text: "0");
    _outputText2Controller.value = const TextEditingValue(text: "0");
  }

  void _swapUnits() {
    Fluttertoast.showToast(
      msg: "Swapping Units!",
    );
    _clearOutput();
    String unitToMeasure = widget.measurement;
    setState(() {
      if (unitToMeasure == "Length") {
        num temp = _reductionFactorFrom;
        _reductionFactorFrom = _reductionFactorTo;
        _reductionFactorTo = temp;
      } else if (unitToMeasure == "Weight") {
        _visibleFrom = !_visibleFrom;
        _visibleTo = !_visibleTo;
        num temp = _reductionFactorFrom;
        _reductionFactorFrom = _reductionFactorTo;
        _reductionFactorTo = temp;
      }
      String temp1 = _unitConversionFromLabel1;
      String temp2 = _unitConversionFromLabel2;
      _unitConversionFromLabel1 = _unitConversionToLabel1;
      _unitConversionFromLabel2 = _unitConversionToLabel2;
      _unitConversionToLabel1 = temp1;
      _unitConversionToLabel2 = temp2;
      _unitConversionDirection = -1 * _unitConversionDirection;
      _unitConversionFactor = 1 / _unitConversionFactor;
    });
    _inputText1Controller.selection = TextSelection(
        baseOffset: 0, extentOffset: _inputText1Controller.value.text.length);
  } // method to swap units to convert

  void _convertUnits() {
    Fluttertoast.showToast(
      msg: "Converting!",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    if (widget.measurement == "Length") {
      // ================================================================ Length
      String tbx1 = _inputText1Controller.value.text;
      if (tbx1.isEmpty) {
        tbx1 = '0';
        setState(() {
          _inputText1Controller.value = const TextEditingValue(text: ('0'));
        });
      }
      String tbx2 = _inputText2Controller.value.text;
      if (tbx2.isEmpty) {
        tbx2 = '0';
        setState(() {
          _inputText2Controller.value = const TextEditingValue(text: ('0'));
        });
      }
      num convertedLength =
          ((_reductionFactorFrom * double.parse(tbx1)) + double.parse(tbx2)) *
              _unitConversionFactor;
      String output1Val = (convertedLength ~/ _reductionFactorTo).toString();
      String output2Val = (convertedLength % _reductionFactorTo) == 0
          ? '0'
          : (convertedLength % _reductionFactorTo).toStringAsFixed(2);
      setState(() {
        _outputText1Controller.value = TextEditingValue(text: output1Val);
        _outputText2Controller.value = TextEditingValue(text: output2Val);
      });
    } else if (widget.measurement == "Weight") {
      // ================================================================ Weight
      String tbx1 = _inputText1Controller.value.text;
      if (tbx1.isEmpty) {
        tbx1 = '0';
        setState(() {
          _inputText1Controller.value = const TextEditingValue(text: ('0'));
        });
      }
      String tbx2 = _inputText2Controller.value.text;
      if (tbx2.isEmpty) {
        tbx2 = '0';
        setState(() {
          _inputText2Controller.value = const TextEditingValue(text: ('0'));
        });
      }
      num convertedWeight =
          ((_reductionFactorFrom * double.parse(tbx1)) + double.parse(tbx2)) *
              _unitConversionFactor;

      String output1Val = (convertedWeight ~/ _reductionFactorTo).toString();
      String output2Val = (convertedWeight % _reductionFactorTo) == 0
          ? '0'
          : (convertedWeight % _reductionFactorTo).toStringAsFixed(2);

      setState(() {
        if (_unitConversionDirection == 1) {
          _outputText1Controller.value =
              TextEditingValue(text: convertedWeight.toStringAsFixed(3));
        } else {
          _outputText1Controller.value = TextEditingValue(text: output1Val);
          _outputText2Controller.value = TextEditingValue(text: output2Val);
        }
      });
    } else if (widget.measurement == "Temperature") {
      // ================================================================ Temperature
      String tbx1 = _inputText1Controller.value.text;
      if (tbx1.isEmpty) {
        tbx1 = '0';
        setState(() {
          _inputText1Controller.text = tbx1;
        });
      }
      num temp = 0;
      if (_unitConversionDirection == 1) {
        temp = 32 +
            (_unitConversionFactor *
                double.parse(_inputText1Controller.value.text));
      } else {
        temp = _unitConversionFactor *
            (double.parse(_inputText1Controller.value.text) - 32);
      }
      _outputText1Controller.value =
          TextEditingValue(text: (temp).toStringAsFixed(2));
    }
    _inputText1Controller.selection = TextSelection(
        baseOffset: 0, extentOffset: _inputText1Controller.value.text.length);
  } // method to convert units according to type

  // String? get _errorText {
  //   final inputText = _inputTextController.value.text;
  //   // RegExp regExpLetter = RegExp(r'');
  //   // Iterable<RegExpMatch> matchesLetter = regExpLetter.allMatches(inputText);
  //   // if() {
  //   //
  //   // }
  //   RegExp regExp = RegExp(r'^(\d*\.?\d*)((\s+)(\d*\.?\d*))?$');
  //   Iterable<RegExpMatch> matches = regExp.allMatches(inputText);
  //   // try
  //   if (matches.elementAt(0) != null || matches.elementAt(0) != "") {
  //     print(matches.elementAt(0));
  //     print(matches.elementAt(0).group(1));
  //     print(matches.elementAt(0).group(4));
  //     print("==============");
  //     return null;
  //   } else {
  //     return "Error";
  //   }
  //   // if (inputText.length < 5) {
  //   //   return "Error";
  //   // }
  //   return null;
  // } // validator for input

  final List<Color> gradientList = const [
    Colors.indigo,
    Colors.pink,
    Colors.lightGreen
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formState,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            Row(
              children: [
                Flexible(
                  flex: 10,
                  child: Focus(
                    canRequestFocus: false,
                    onFocusChange: (value) {
                      _inputText1Controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset:
                              _inputText1Controller.value.text.length);
                    },
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      controller: _inputText1Controller,
                      // validator: (value) {
                      //   return _errorText;
                      // },
                      // onChanged: (value) {
                      //   _formState.currentState!.validate();
                      // },
                      onFieldSubmitted: (value) {
                        _convertUnits();
                      },
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                          // contentPadding: const EdgeInsets.fromLTRB(12, 30, 12, 30),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 3),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 3),
                          ),
                          filled: true,
                          fillColor: Colors.black12,
                          labelText: _unitConversionFromLabel1,
                          labelStyle: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 22)),
                    ),
                  ),
                ),
                Visibility(
                  visible: _visibleFrom,
                  child: const Spacer(flex: 1),
                ),
                Visibility(
                  visible: _visibleFrom,
                  child: Flexible(
                    flex: 10,
                    child: Focus(
                      canRequestFocus: false,
                      onFocusChange: (value) {
                        _inputText2Controller.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset:
                                _inputText2Controller.value.text.length);
                      },
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _inputText2Controller,
                        onFieldSubmitted: (value) {
                          _convertUnits();
                        },
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.redAccent, width: 3),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.redAccent, width: 3),
                            ),
                            filled: true,
                            fillColor: Colors.black12,
                            labelText: _unitConversionFromLabel2,
                            labelStyle: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 22)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _convertUnits,
                    child: const Text('Convert'),
                  ),
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Colors.purple,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.swap_vert_rounded),
                      iconSize: 40,
                      onPressed: _swapUnits,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 10,
                  child: TextField(
                    focusNode: FocusNode(skipTraversal: true),
                    controller: _outputText1Controller,
                    readOnly: true,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        isDense: true,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 3),
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                        labelText: _unitConversionToLabel1,
                        labelStyle: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 22)),
                  ),
                ),
                Visibility(
                  visible: _visibleTo,
                  child: const Spacer(flex: 1),
                ),
                Visibility(
                  visible: _visibleTo,
                  child: Flexible(
                    flex: 10,
                    child: TextField(
                      focusNode: FocusNode(skipTraversal: true),
                      controller: _outputText2Controller,
                      readOnly: true,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 3),
                          ),
                          filled: true,
                          fillColor: Colors.black12,
                          labelText: _unitConversionToLabel2,
                          labelStyle: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 22)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
            ),
          ],
        ));
  }
}
