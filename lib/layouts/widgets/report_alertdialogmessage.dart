import 'package:flutter/material.dart';
import 'package:socialoo/global/global.dart';

class ReportDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffE5E6EB),
      content: Text(
        "This user is successfully reported!",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.0,
          color: Colors.black,
        ),
      ),
      actions: [
        Center(
            child: MaterialButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }))
      ],
    );
  }
}

class ReportDialog2 extends StatelessWidget {
  const ReportDialog2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffE5E6EB),
      content: Text(
        "Are you sure you want to report this person?",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.0,
          color: Colors.black,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ReportDialog();
                      });
                }),
            MaterialButton(
                child: Text(
                  "No",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        )
      ],
    );
  }
}

class ReportDialog3 extends StatelessWidget {
  final ontap;
  ReportDialog3({Key? key, this.ontap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffE5E6EB),
      content: Text(
        "Are you sure you want to Block this person?",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.0,
          color: Colors.black,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: ontap),
            MaterialButton(
                child: Text(
                  "No",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        )
      ],
    );
  }
}
