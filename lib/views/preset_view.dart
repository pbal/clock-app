import 'package:clock/views/clock_view.dart';
import 'package:clock/model/clock.dart';
import 'package:clock/widgets/custom_widget.dart';
import 'package:flutter/material.dart';

class PresetView extends StatefulWidget {
  final String? title ;
  PresetView({Key? key, this.title}) : super(key: key);

  @override
  _PresetViewState createState() => _PresetViewState();
}

class _PresetViewState extends State<PresetView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 60.0,
        height: 60.0,
        child: RawMaterialButton(
          fillColor: Theme.of(context).primaryColor,
          shape: CircleBorder(),
          elevation: 5.0,
          child: Icon(
            Icons.add,
          ),
          onPressed: _customDialog,
        ),
      ),
      body: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title ?? ""),
            actions: <Widget>[
            ],
          ),
          body: Container(
            decoration: BoxDecoration(color: Color(0xFFe8e8e8)),
            child: ListView.separated(
              itemCount: Clock.presets.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                thickness: 2,
                height: 10,
              ),
              itemBuilder: (context, index) {
                var item = Clock.presets[index];
                return ListTile(
                  title: Text(
                    item.type,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: _getSubtitle(item),
                  onTap: () => _onListItemClick(item),
                  trailing: Icon(Icons.keyboard_arrow_right),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSubtitle(Clock item) {
    String text = '';

    switch (item.seconds) {
      case 30:
        text = '\u00BD + 0';
        break;
      case 15:
        text = '\u00BC + 0';
        break;
      default:
        text = '${item.seconds ~/ 60} + ${item.increment}';
        break;
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  _onListItemClick(Clock item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClockView(
          time: item.seconds,
          increment: item.increment,
          clockMode: item.increment == 0 ? 'Sudden Death' : 'Increment',
        ),
      ),
    );
  }

  _customDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomClock();
      },
    );
  }
}
