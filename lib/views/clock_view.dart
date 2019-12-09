import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'dart:async';

class ClockView extends StatefulWidget {
  ClockView({
    Key key,
    this.time = 90,
    this.increment = 0,
    this.clockMode = 'Sudden Death',
  }) : super(key: key);

  final String clockMode;
  final int time;
  final int increment;

  @override
  _ClockViewState createState() => _ClockViewState();
}

enum ClockState { Playing, Paused, Completed, Init }

class _ClockViewState extends State<ClockView> with TickerProviderStateMixin {
  AnimationController _controllerUp;
  AnimationController _controllerDown;
  AnimationController _controllerDelay;
  AnimationStatusListener _listenerDelay;

  ClockState _state;

  int time;
  int increment;
  String clockMode;

  bool _activeTop = false;
  bool _activeDown = false;

  Color _activeColor;
  Color _inactiveColor;

  @override
  void initState() {
    super.initState();

    time = widget.time;
    increment = widget.increment;
    clockMode = widget.clockMode;

    _activeColor = Color(0xFF3c6f9c);
    _inactiveColor = Colors.grey.shade500;

    _state = ClockState.Init;

    _controllerUp = _createController();
    _controllerDown = _createController();

    _controllerDelay = AnimationController(
      vsync: this,
      duration: Duration(seconds: increment),
      value: 1,
    );
  }

  _createController() {
    AnimationController controller;
    controller = new AnimationController(
      vsync: this,
      duration: Duration(seconds: time.toInt()),
      value: 1,
    )..addStatusListener((status) {
        if (controller.status == AnimationStatus.dismissed) {
          _completeClock();
        }
      });
    return controller;
  }

  String timerString(AnimationController _controller) {
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}.${(duration.inMilliseconds % 1000).toString().substring(0, 1)}';
  }

  _resetDelay() {
    _controllerDelay.removeStatusListener(_listenerDelay);
    _controllerDelay.value = 1;
    _controllerDelay.stop(canceled: true);
  }

  _pauseClock() {
    print('paused');
    _controllerUp.stop(canceled: true);
    _controllerDown.stop(canceled: true);

    _resetDelay();

    if (_state != ClockState.Paused) {
      setState(() {
        _state = ClockState.Paused;
        _activeDown = false;
        _activeTop = false;
      });
    }
  }

  _completeClock() {
    print('completed');
    _controllerUp.stop(canceled: true);
    _controllerDown.stop(canceled: true);

    _resetDelay();

    if (_state != ClockState.Completed) {
      setState(() {
        _state = ClockState.Completed;
        _activeDown = false;
        _activeTop = false;
      });
    }
  }

  _timerReset() {
    print('reset');

    _controllerUp.stop(canceled: true);
    _controllerDown.stop(canceled: true);
    _controllerDelay.stop(canceled: true);
    _controllerUp.value = 1;
    _controllerDown.value = 1;

    _controllerUp.duration = Duration(seconds: time.toInt());
    _controllerDown.duration = Duration(seconds: time.toInt());

    _controllerDelay.value = 1;

    if (_state != ClockState.Init) {
      setState(() {
        _state = ClockState.Init;
        _activeDown = false;
        _activeTop = false;
      });
    }
  }

  void _timePressed(bool isUp) {
    if (_controllerDown.value == 0 || _controllerUp.value == 0) {
      _completeClock();
      return;
    }

    if (_state != ClockState.Playing) {
      setState(() {
        _state = ClockState.Playing;
      });
    }

    if (_isTopActive(isUp)) {
      _toggleClock(_controllerUp, _controllerDown);
    } else if (_isBottomActive(isUp)) {
      _toggleClock(_controllerDown, _controllerUp);
    } else if (_activeTop != true && _activeDown != true) {
      if (isUp) {
        _toggleClock(_controllerUp, _controllerDown);
      } else {
        _toggleClock(_controllerDown, _controllerUp);
      }
    }

    _toggleActiveButton(isUp);
  }

  bool _isTopActive(bool isUp) {
    return _activeTop == true && isUp;
  }

  bool _isBottomActive(bool isUp) {
    return _activeDown == true && !isUp;
  }

  _toggleClock(AnimationController active, AnimationController passive) {
    if (increment != 0 && clockMode == 'Increment') {
      _toggleIncrementClock(active, passive);
    } else if (increment != 0 && clockMode == 'Simple Delay') {
      _toggleSimpleDelayClock(active, passive);
    } else if (increment != 0 && clockMode == 'Bronstein Delay') {
      _toggleBronsteinDelayClock(active, passive);
    } else {
      active.stop(canceled: true);

      passive.reverse(from: passive.value);
    }
  }

  _toggleSimpleDelayClock(
      AnimationController active, AnimationController passive) {
    print('simple delay started ' + _controllerDelay.value.toString());

    active.stop(canceled: true);
    passive.stop(canceled: true);
    _controllerDelay.value = 1;

    _controllerDelay.removeStatusListener(_listenerDelay);

    _listenerDelay = (state) {
      if (state == AnimationStatus.dismissed) {
        print("dismissed");
        passive.reverse(from: passive.value);
        _controllerDelay.removeStatusListener(_listenerDelay);
      } else if (state == AnimationStatus.completed) {
        print('completed delay prematurely');
      }
    };

    _controllerDelay..addStatusListener(_listenerDelay);
    _controllerDelay.reverse(from: _controllerDelay.value);
  }

  _toggleBronsteinDelayClock(
      AnimationController active, AnimationController passive) {
    print('Bronstein delay started ' + _controllerDelay.value.toString());
    if (_activeTop == true || _activeDown == true) {
      active.duration = Duration(
        milliseconds: (active.duration.inMilliseconds * active.value +
                (increment * 1000 -
                    _controllerDelay.duration.inMilliseconds *
                        (_controllerDelay.value)))
            .toInt(),
      );
    }

    active.stop(canceled: true);
    active.value = 1;
    passive.reverse(from: passive.value);

    _controllerDelay.value = 1;
    _controllerDelay.reverse(from: _controllerDelay.value);
  }

  _toggleIncrementClock(
      AnimationController active, AnimationController passive) {
    if (_activeTop == true || _activeDown == true) {
      active.duration = Duration(
        milliseconds:
            (active.duration.inMilliseconds * active.value + increment * 1000)
                .toInt(),
      );
    }

    active.stop(canceled: true);
    active.value = 1;
    passive.reverse(from: passive.value);
  }

  _toggleActiveButton(bool isUp) {
    setState(() {
      _activeTop = !isUp;
      _activeDown = isUp;
    });
  }

  BorderRadius get tapRadius {
    double radius = 10.0;

    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: _button(
                _controllerUp,
                true,
                () => _timePressed(true),
              ),
            ),
            _timeBar(_controllerUp, true),
            Container(
              height: 1,
            ),
            _timeBar(_controllerDown, false),
            Expanded(
              child: _button(
                _controllerDown,
                false,
                () => _timePressed(false),
              ),
            ),
            AnimatedBuilder(
              animation: _controllerDelay,
              builder: (BuildContext context, Widget child) {
                return SizedBox();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(top: 30.0, left: 37.0),
        child: Align(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 5,
            children: <Widget>[
              (_state == ClockState.Paused || _state == ClockState.Completed)
                  ? Container(
                      width: 50.0,
                      height: 50.0,
                      child: RawMaterialButton(
                        elevation: 10,
                        child: Icon(
                          Icons.refresh,
                          size: 40.0,
                          color: Colors.white70,
                        ),
                        shape: new CircleBorder(),
                        onPressed: _timerReset,
                        fillColor: Colors.green,
                      ),
                    )
                  : SizedBox(),
              _state == ClockState.Playing
                  ? Container(
                      width: 50.0,
                      height: 50.0,
                      child: RawMaterialButton(
                        elevation: 10,
                        child: Icon(
                          Icons.pause,
                          size: 40.0,
                          color: Colors.white70,
                        ),
                        shape: new CircleBorder(),
                        onPressed: _pauseClock,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    )
                  : SizedBox(),
              _state == ClockState.Init
                  ? Container(
                      width: 50.0,
                      height: 50.0,
                      child: RawMaterialButton(
                        elevation: 10,
                        child: Icon(
                          Icons.play_arrow,
                          size: 40.0,
                          color: Colors.white70,
                        ),
                        onPressed: () => _timePressed(false),
                        fillColor: _activeColor,
                        shape: new CircleBorder(),
                      ),
                    )
                  : SizedBox(),
              (_state == ClockState.Paused ||
                      _state == ClockState.Completed ||
                      _state == ClockState.Init)
                  ? Container(
                      width: 50.0,
                      height: 50.0,
                      child: RawMaterialButton(
                        elevation: 10,
                        child: Icon(
                          Icons.close,
                          size: 40.0,
                          color: Colors.white70,
                        ),
                        shape: new CircleBorder(),
                        fillColor: Color(0xFF757575),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _button(
      AnimationController _controller, bool isUp, Function callback) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: callback,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return Container(
              decoration: BoxDecoration(
                color: _controller.value == 0
                    ? Color(0xFFc9554d)
                    : (_activeTop == true && isUp) ||
                            (_activeDown == true && !isUp)
                        ? _activeColor
                        : _inactiveColor,
                borderRadius: tapRadius,
              ),
              child: Container(
                alignment: Alignment.center,
                child: RotatedBox(
                  quarterTurns: isUp ? 2 : 0,
                  child: _controller.value == 0
                      ? Icon(
                          Icons.outlined_flag,
                          size: 140,
                          color: Color(0xFFededed),
                        )
                      : Text(
                          timerString(_controller),
                          style: TextStyle(
                              fontSize: 80.0,
                              fontWeight: FontWeight.normal,
                              color: (_activeTop == true && isUp) ||
                                      (_activeDown == true && !isUp)
                                  ? Colors.white70
                                  : Colors.black),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container _timeBar(AnimationController _controller, bool top) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration:
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return ClockState.Completed != _state
                  ? Container(
                      width: _controller.value *
                          (MediaQuery.of(context).size.width - 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFdbdbdb),
                        borderRadius: top
                            ? BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              )
                            : BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                      ),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllerUp.dispose();
    _controllerDown.dispose();
    _controllerDelay.dispose();
    super.dispose();
  }
}
