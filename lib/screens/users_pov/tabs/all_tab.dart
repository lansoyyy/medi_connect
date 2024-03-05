import 'package:flutter/material.dart';
import 'package:medi_connect/utlis/colors.dart';
import 'package:medi_connect/widgets/button_widget.dart';

import '../../../widgets/text_widget.dart';

class AllTab extends StatelessWidget {
  const AllTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: primary,
                ),
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/sample_logo.jpg',
                    height: 125,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'Polymedic General Hospital',
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Bold',
                  ),
                  TextWidget(
                    text: 'Zone-5, Casisang, Malaybalay Buk.',
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ButtonWidget(
                    width: 200,
                    color: primary,
                    radius: 100,
                    label: 'View',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
