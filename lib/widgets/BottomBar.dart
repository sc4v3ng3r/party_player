import 'package:flutter/material.dart';

class BottomBarItem {
  /// Icon data for this item
  final IconData iconData;
  /// Text that appears below the icon
  final String text;
  /// Icon color
  final Color color;
  /// Icon size
  final double size;

  BottomBarItem({@required this.iconData, this.text = '',
    this.color = Colors.white, this.size = 25.0});
}

class BottomBar extends StatefulWidget {

  /// Action list of BottomBarItem
  final List<BottomBarItem> actions;

  /// BottomBar height
  final double height;

  /// Callback when an item is selected
  final ValueChanged<int> onTabSelected;

  /// Initial selected item
  final int selectedIndex;

  /// Item selected color
  final Color selectedColor;

  /// BottomBar backgorund color
  final Color backgroundColor;

  /// notched shape
  final NotchedShape notchedShape;

  BottomBar({@required this.actions, this.onTabSelected, 
    this.selectedIndex = 0, this.selectedColor, this.height = 60.0,
    this.backgroundColor = Colors.grey, this.notchedShape = const CircularNotchedRectangle()});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _selectedIndex;
  
  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    List<Widget> actionsWidgets = List.generate( widget.actions.length, (index){
      return _buildItem(
        item: widget.actions[index],
        index: index,
        onPressed: _updateIndex
      );
    });

    actionsWidgets.insert( actionsWidgets.length >> 1 , _buildMiddleTabItem() );

    return BottomAppBar(
      shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: Container(
        height: widget.height,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actionsWidgets,
        ),
      ),
    );
  }

  Widget _buildItem({ final BottomBarItem item, final int index,
    final ValueChanged<int> onPressed} ) {

    Color color = _selectedIndex == index ? widget.selectedColor : item.color;
    
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: item.size,),
                Text(item.text, style: TextStyle(color: color),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() => _selectedIndex = index );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(),
          ],
        ),
      ),
    );
  }
}
