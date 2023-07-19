import 'package:flutter/material.dart';

String? date;
DateTime? dateTime;
class DefaultDatePicker extends StatefulWidget {
  const DefaultDatePicker({Key? key, required this.label}) : super(key: key);

      final String label;
      final int lastDate = 2030;

  @override
  State<DefaultDatePicker> createState() => _DefaultDatePickerState();
}

class _DefaultDatePickerState extends State<DefaultDatePicker> {
  @override
  void initState() {
    date =null;
    dateTime =null;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(widget.lastDate),
        ).then((value) {
          dateTime = value;
          print("6999999958");
          date = value.toString().substring(0, 10);
          setState((){});
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border : Border.all(
                color: Colors.purple
            )
        ),
        child: Row(
          children:
          [
            const Icon(Icons.date_range,color: Colors.grey),
            const SizedBox(width: 10,),
            Expanded(child: Text(date?? "choose date", style: TextStyle(color: Colors.grey),))
          ],
        ),
      ),
    );
  }
}


String? time;
TimeOfDay? timeOfDay;
class DefaultTimerPicker extends StatefulWidget {
  const DefaultTimerPicker({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  State<DefaultTimerPicker> createState() => _DefaultTimerPickerState();
}

class _DefaultTimerPickerState extends State<DefaultTimerPicker> {
  @override
  void initState() {
    time= null;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((value) {
          timeOfDay = value;
          time = value?.format(context);
          setState((){});
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border : Border.all(
                color: Colors.purple
            )
        ),
        child: Row(
          children:
          [
            const Icon(Icons.watch_later_outlined,color: Colors.grey),
            const SizedBox(width: 10,),
            Expanded(child: Text(time?? "choose time",style: TextStyle(color: Colors.grey),))
          ],
        ),
      ),
    );
  }
}


