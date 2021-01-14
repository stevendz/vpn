import 'package:flutter/material.dart';

class Toggle extends StatefulWidget {
  const Toggle({
    Key key,
    this.onToggle,
  }) : super(key: key);

  @override
  ToggleState createState() {
    return ToggleState();
  }

  final Function onToggle;
}

class ToggleState extends State<Toggle> {
  ValueNotifier<double> valueListener = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final isActive = valueListener.value > 0.5;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(100),
      ),
      width: MediaQuery.of(context).size.width / 3.5,
      height: 280,
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (isActive) ...[
                  const Align(
                    heightFactor: 0.75,
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white38,
                      size: 40,
                    ),
                  ),
                  const Align(
                    heightFactor: 0,
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white70,
                      size: 50,
                    ),
                  ),
                ],
                const Spacer(),
                if (!isActive) ...[
                  const Align(
                    heightFactor: 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                      size: 50,
                    ),
                  ),
                  const Align(
                    heightFactor: 0.75,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white38,
                      size: 40,
                    ),
                  ),
                ],
              ],
            ),
          ),
          AnimatedBuilder(
            animation: valueListener,
            builder: (context, child) {
              return Align(
                alignment: Alignment(.5, valueListener.value * 2.0 - 1),
                child: child,
              );
            },
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                valueListener.value =
                    (valueListener.value + details.delta.dy / context.size.height).clamp(0, 1).toDouble();
              },
              onVerticalDragEnd: (details) {
                valueListener.value = valueListener.value < 0.5 ? 0 : 1;
                widget.onToggle(valueListener.value > 0.5);
              },
              child: Container(
                height: 160,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF5d857c) : const Color(0xFF41414a),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: isActive ? const Color(0xFF507068) : const Color(0xFF333543), width: 4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 20,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: isActive ? Colors.black38 : const Color(0xFF0bfd2d),
                        boxShadow: [
                          BoxShadow(
                            color: isActive ? Colors.transparent : const Color(0xFF0bfd2d),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        isActive ? 'STOP' : 'START',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isActive
                              ? [
                                  const Color(0xFF416058),
                                  const Color(0xFF6fa195),
                                ]
                              : [
                                  const Color(0xFF27282e),
                                  const Color(0xFF575a61),
                                ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const FittedBox(
                        child: Icon(
                          Icons.power_settings_new,
                          color: Colors.white70,
                          size: 50,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
