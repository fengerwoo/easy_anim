import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_anim/easy_anim.dart';


void main() {
  testWidgets('Simple animation test', (WidgetTester tester) async {

    EasyTweenAnimation anim = EasyTweenAnimation(
      animSequence: [
        EasyTweenAnimationItem(
            animatables: {
              "width": Tween<double>(begin: 100, end: 200),
            },
            weight: 100
        ),
      ],
      duration: Duration(seconds: 1),
      builder: (BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget child){

        Animation width = animationMap['width'];

        return AnimatedBuilder(animation: curvedAnimation, builder: (context, child){
          return Transform.rotate(
            angle: 0.5,
            child: Container(
              color: Colors.red,
              width: width.value,
              height: 300,
            ),
          );
        });
      },
    );

    expect(anim, isNotNull);

  });
}
