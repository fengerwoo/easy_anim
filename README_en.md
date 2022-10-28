# easy_anim

💨🚀 Declaratively describe animations using Flutter in a simple way


## Preface

> When talking about Flutter animation, what do we usually think of?
> 
> If you read the Flutter documentation manual, there must be a mess of Tween, AnimationController, forward() and so on in your mind. It is certainly possible to write, but it greatly affects development efficiency and increases the complexity of the code. If it is not maintained well, it will easily mess up the code.
> 
> Of course, the official also provides implicit animations such as TweenAnimationBuilder to achieve some simple single animations, and TweenSequence to achieve serial animations, but the simplest animation in my actual project is also a parallel animation that zooms and rotates at the same time (also called interlaced animation). So it’s not applicable. After searching for third-party libraries on pub.dev and Github for a few hours, I didn’t find a library that can write animation in a declarative way and simple way, so I decided to pick one by myself.
> 


## advantage
- Declarative description of animation using component method
- Self-maintaining controller, using animation code concisely
- Support delay execution animation
- Support loop execution animation
- Support parallel animation, serial animation and serial parallel animation




## Quick start

### Add dependencie
``` yaml
dependencies:
  easy_anim: ^3.1.1
```


### A minimal usage example
``` dart
import 'package:easy_anim/easy_anim.dart';

EasyTweenAnimation(
  animSequence: [
    EasyTweenAnimationItem(
        animatables: {
          "width": Tween(begin: 0.0, end: 200.0),
        },
        weight: 100,
    ),
  ],
  duration: Duration(seconds: 2),
  builder: (BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget? child){

    Animation width = animationMap['width'];

    return AnimatedBuilder(animation: curvedAnimation, builder: (context, child){
          return Container(
            width: width.value,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red
            ),
          );
        },
    );
  }
)
```

The first animation in the example picture, the animation of the width of a single block of Container from 0 to 200, the animation execution time is 2 seconds<br/>

The above code is similar to the one in CSS animation

``` css
@keyframes anim
{
    from { width: 0px; }
    to   { width: 200px; }
}
```


### Example project screenshot
View the corresponding source code of the screenshot effect：[example/lib/main.dart](example/lib/main.dart)

<img src="https://raw.githubusercontent.com/fengerwoo/easy_anim/main/doc/assets/demo1.gif" width="300" > <img src="https://raw.githubusercontent.com/fengerwoo/easy_anim/main/doc/assets/demo2.gif" width="300" >



### Usage example
``` dart
 import 'package:easy_anim/easy_anim.dart';
 
 EasyTweenAnimation(
   animSequence: [
     EasyTweenAnimationItem(
      animatables: {
        "angle": Tween<double>(begin: 0, end: 1 * pi),
        "color": ColorTween(begin: Colors.blue, end: Colors.blue),
        "width": Tween<double>(begin: 100, end: 100),
      },
      weight: 50.0, // It accounts for 50% of the total time, which is the animation effect at 0%~50% of 2 seconds
    ),


    EasyTweenAnimationItem(
      animatables: {
        "color": ColorTween(begin: Colors.blue, end: Colors.red),
        "width": Tween<double>(begin: 100, end: 200),
      },
      weight: 50.0, // 50% of the total time, which is the animation effect at 50%~100% of 2 seconds
    ),
  ],

  duration: Duration(seconds: 2), // Total execution time of animation
  delay: Duration(milliseconds: 200), // How long is the delay to execute, the default is 0 seconds to execute immediately
  loop: true, // Whether to loop the animation
  builder: (BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget? child){

    // Take out the Animation object of each effect from the AnimationMap
    Animation angle = animationMap["angle"];
    Animation color = animationMap['color'];
    Animation width = animationMap['width'];

    // Use the Animation object value of each effect in AnimatedBuilder
    return AnimatedBuilder(animation: curvedAnimation, builder: (context, child){
      return Transform.rotate(
        angle: angle.value,
        child: Container(
          color: color.value,
          width: width.value,
          height: width.value,
        ),
      );
    });
  },
)

```

##### A serial + parallel animation, a total of 2 seconds, the first second the square rotates the angle, the second second then changes the color and width at the same time
1. The outermost EasyTweenAnimation is a component for building animations. The animSequence parameter in it is the animation effect of each time stage, the builder parameter is used to return the component you want to build, and the other parameters are shown in the comments.
2. EasyTweenAnimationItem is the animation effect of a certain stage, the parameter animatables is the animation of each attribute, and the weight parameter is the time weight of the total duration for this stage

The above code is similar to the one in CSS animation


``` css
@keyframes anim
{
    0% 	  {angle: 0; color: blue; width:100;}
    50%   {angle: 3.14;}
    100%  {color: red; width:200;}
}
```


### Parameter Description

#### EasyTweenAnimation component parameter description
- [ animSequence: List\<EasyTweenAnimationItem> ] Animation storyboard sequence
- [ duration: Duration ] Total animation execution time
- [ curve: Curve ] Animation execution curve, default linear
- [ builder: Funtion ] Build the component to use animation
- [ onStatus: Funtion ] Monitor animation execution status callback
- [ child: Widget ] Subassembly
- [ delay: Duration ] Delay time, default 0 seconds to execute immediately
- [ loop: bool ] Whether to execute in a loop

#### EasyTweenAnimationItem component parameter description

- [ animatables: Map\<String, Animatable> ] Animation effect, the animation effect group in the segmentation period
	- Map description
		- [ key : String tag ] Effect name, such as width
		- [ value : Animatable animatable ] Animation effect, generally use Tween or ColorTween
- [ weight: double ] The percentage of the weight of the total animation execution time (0-100)



### Join group chat
Scan the code and add me WeChat to join the WeChat exchange group (please note: Flutter library easy_anim)

<img src="https://raw.githubusercontent.com/fengerwoo/easy_anim/main/doc/assets/wechat_qr.jpg" width="200" >

#### 🤗 🤗 🤗 If it helps you, please star