import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  final List<String> options;
  final int initialIndex;
  final ValueChanged<int> onChanged;
  final Color selectedColor;
  final Color unselectedColor;
  final Color textColor;
  final Color selectedTextColor;
  final double height;
  final double fontSize;
  final BorderRadius borderRadius;

  const CustomToggleButton({
    super.key,
    required this.options,
    this.initialIndex = 0,
    required this.onChanged,
    this.selectedColor = const Color(0xFF1E88E5),
    this.unselectedColor = const Color(0xFF00796B),
    this.textColor = Colors.black,
    this.selectedTextColor = Colors.white,
    this.height = 50.0,
    this.fontSize = 20.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(30.0)),
  }) : assert(
         initialIndex >= 0 && initialIndex < options.length,
         'initialIndex must be a valid index in options',
       );

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,

      width: widget.height * 4.6, //largura total do botão
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: widget.borderRadius,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left:
                _currentIndex == 0
                    ? 0
                    : _currentIndex == 1
                    ? widget.height * 1.5
                    : widget.height * 3,
            right:
                _currentIndex == 0
                    ? widget.height * 3
                    : _currentIndex == 1
                    ? widget.height * 1.5
                    : 0,
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                color:
                    _currentIndex == 2
                        ? widget
                            .unselectedColor // Verde para ON
                        : widget.selectedColor, // Azul para AUTO e OFF
                borderRadius: widget.borderRadius,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children:
                widget.options.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final String text = entry.value;

                  final bool isSelected = _currentIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                      widget.onChanged(index);
                    },
                    child: Container(
                      width: widget.height * 1.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            isSelected
                                ? widget.borderRadius
                                : BorderRadius.zero,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? widget.selectedTextColor
                                      : widget.textColor,
                              fontSize: widget.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isSelected)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
