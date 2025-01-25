import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BottomNavBarElasticLine(),
    );
  }
}

class BottomNavBarElasticLine extends StatefulWidget {
  const BottomNavBarElasticLine({super.key});

  @override
  _BottomNavBarElasticLineState createState() =>
      _BottomNavBarElasticLineState();
}

class _BottomNavBarElasticLineState extends State<BottomNavBarElasticLine>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _lineWidthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _lineWidthAnimation = Tween<double>(begin: 0, end: 60).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = 4;
    final itemWidth = MediaQuery.of(context).size.width / itemCount;

    return Scaffold(
      body: Center(
        child: Text('Selected Index: $_selectedIndex'),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Navigation items
          Container(
            height: 70,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(itemCount, (index) {
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Item $index',
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Animated line
          AnimatedBuilder(
            animation: _lineWidthAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 0,
                left: itemWidth * _selectedIndex +
                    (itemWidth / 2) -
                    (_lineWidthAnimation.value / 2),
                child: Container(
                  height: 4,
                  width: _lineWidthAnimation.value,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
