import 'package:flutter/material.dart';
import 'package:projeto_704apps/screens/widgets/sliding_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedOptionIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'config');
            },
            icon: Icon(Icons.settings, size: 50, color: Colors.black),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/WhatsApp_Image_2025-06-20_at_17.56.48-removebg-preview.png',
            ),
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,

            colorFilter: ColorFilter.mode(
              // ignore: deprecated_member_use
              Colors.white.withOpacity(0.1),
              BlendMode.dstATop,
            ),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/WhatsApp_Image_2025-06-20_at_17.56.48-removebg-preview.png',
              width: 190,
              height: 190,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MOBILITY WATCH',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            CustomToggleButton(
              options: const ['AUTO', 'OFF', 'ON'],
              initialIndex: _selectedOptionIndex,
              onChanged: (index) {
                setState(() {
                  _selectedOptionIndex = index;
                });

                // lógica do botão aqui

                print(
                  'Opção selecionada na Home: ${['AUTO', 'OFF', 'ON'][index]}',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
