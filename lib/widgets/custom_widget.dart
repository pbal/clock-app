import 'package:clock/views/clock_view.dart';
import 'package:flutter/material.dart';
import 'package:clock/model/mode.dart';

class CustomClock extends StatefulWidget {
  CustomClock({Key key}) : super(key: key);

  @override
  _CustomClockState createState() => _CustomClockState();
}

class _CustomClockState extends State<CustomClock> {
  final _formKey = GlobalKey<FormState>();
  String clockMode = 'Sudden Death';
  int time = 60;
  int increment = 0;
  int delay = 0;
  int bronsDelay = 0;

  _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClockView(
            time: time,
            increment: increment,
            clockMode: clockMode,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InputDecorator(
                decoration: InputDecoration(
                  icon: Icon(Icons.hourglass_empty),
                  labelText: "Clock",
                ),
                child: DropdownButton<String>(
                  value: clockMode,
                  onChanged: (String value) {
                    setState(() => clockMode = value);
                  },
                  items: ClockMode.modes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              InputDecorator(
                decoration: InputDecoration(
                  icon: Icon(Icons.timer),
                  labelText: "Time (minutes)",
                ),
                child: DropdownButton<int>(
                  value: time,
                  onChanged: (int value) {
                    setState(() => time = value);
                  },
                  items: ClockMode.timeSeconds
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem(
                      value: value,
                      child: value == 30
                          ? Text('\u00BD')
                          : value == 45
                              ? Text('\u00BE')
                              : Text((value ~/ 60).toString()),
                    );
                  }).toList(),
                ),
              ),
              clockMode != 'Sudden Death'
                  ? InputDecorator(
                      decoration: InputDecoration(
                        icon: Icon(Icons.add_alarm),
                        labelText: "Increment (seconds)",
                      ),
                      child: DropdownButton<int>(
                        value: increment,
                        onChanged: (int value) {
                          setState(() => increment = value);
                        },
                        items: ClockMode.increment
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 10),
              RaisedButton(
                child: Text("Set Clock"),
                onPressed: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
