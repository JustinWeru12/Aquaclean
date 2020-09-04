import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardDesign extends StatefulWidget {
  final Widget child;
  final Color color;
  final Function onTap;
  final double height;
  final double width;

  const CardDesign(this.child, {Key key, @required this.color, this.onTap,  this.height, this.width,}) : assert(child != null, 'A Widget is Required'), super(key: key);
  @override
  _CardDesignState createState() => _CardDesignState();
}

class _CardDesignState extends State<CardDesign> {
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(20.0),
          child: InkWell(
            onTap: widget.onTap,
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topRight,
                //   end: Alignment.bottomLeft,
                //   colors: [
                //     Color(0xFF00bf72),
                //     Color(0xFF008793),
                //     Color(0xFF004d7a),
                //   ],
                // ),
                color: widget.color,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    offset: Offset(10.0, 10.0),
                    blurRadius: 5.0,
                  )
                ],
              ),
              child: widget.child,
            ),
          ),
        );
  }
}