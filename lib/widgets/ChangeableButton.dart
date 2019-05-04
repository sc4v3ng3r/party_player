import 'package:flutter/material.dart';


enum ButtonStatus {PRIMARY, SECONDARY }

typedef Callback = void Function(final ButtonStatus);

class ChangeableIconButton extends StatefulWidget {   
  final Icon primaryIcon, secondaryIcon;
  final ButtonStatus initialStatus;
  final Callback onTap;
  final double size;
  final String tooltip;

  ChangeableIconButton({@required this.primaryIcon, @required this.secondaryIcon,
    this.onTap, this.size = 25.0, this.initialStatus = ButtonStatus.PRIMARY, this.tooltip});

  @override
  _ChangeableIconButtonState createState() => _ChangeableIconButtonState();
}

class _ChangeableIconButtonState extends State<ChangeableIconButton> {

  ButtonStatus _status;
  
  @override
  void initState() {
    _status = widget.initialStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: widget.tooltip,
      icon: (_status == ButtonStatus.PRIMARY) ? widget.primaryIcon :
        widget.secondaryIcon,
      iconSize: widget.size,
        onPressed: (){
          _changeIcon();
          
          if (widget.onTap != null)
            widget.onTap(_status);
        }
    );
  }

  void _changeIcon(){
    setState(() {
    _status = (_status == ButtonStatus.PRIMARY) ? ButtonStatus.SECONDARY :
        ButtonStatus.PRIMARY;
    });

  }
}
