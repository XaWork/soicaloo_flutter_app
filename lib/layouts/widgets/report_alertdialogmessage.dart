import 'package:flutter/material.dart';

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
