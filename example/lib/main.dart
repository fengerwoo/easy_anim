import 'dart:math';

import 'package:easy_anim/easy_anim.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'easy_anim example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            this.one(),
            this.two(),
            this.three(),
            this.four(),
            this.five(),

            SizedBox(height: 500,)
          ],
        ),
      ),
    );
  }


  /// @Desc  : 单个动画单次执行
  /// @author: 枫儿
  Widget one(){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.album),
            title: Text('单个动画'),
            subtitle: Text("红色方块单个动画，执行一次 \n 紫色方块延迟3秒执行一次"),
          ),

          /// example
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

                Animation width = animationMap['width']!;

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
          ),

          SizedBox(height: 20,),


          /// example delay
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
              delay: Duration(seconds: 3),
              builder: (BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget? child){

                Animation width = animationMap['width']!;

                return AnimatedBuilder(animation: curvedAnimation, builder: (context, child){
                  return Container(
                    width: width.value,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent
                    ),
                  );
                },
                );
              }
          ),

          SizedBox(height: 20,)


        ],
      ),
    );
  }



  /// @Desc  : 单个动画循环执行
  /// @author: 枫儿
  Widget two(){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.album),
            title: Text('循环执行'),
            subtitle: Text("黄色方块单个动画，循环执行"),
          ),

          /// example
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
              loop: true, ///循环执行
              curve: Curves.bounceInOut,
              builder: (BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget? child){

                Animation width = animationMap['width']!;

                return AnimatedBuilder(animation: curvedAnimation, builder: (context, child){
                  return Container(
                    width: width.value,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.amber
                    ),
                  );
                },
                );
              }
          ),

          SizedBox(height: 20,)
        ],
      ),
    );
  }



  /// @Desc  : 串行执行多个动画
  /// @author: 枫儿
  Widget three(){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.album),
            title: Text('串行执行多个动画'),
            subtitle: Text("蓝色方块串行执行多个动画（宽度放大->颜色改变为红色）"),
          ),

          /// example
          EasyTweenAnimation(
              animSequence: [
                EasyTweenAnimationItem(
                  animatables: {
                    "width": Tween(begin: 0.0, end: 200.0),
                    "color": ColorTween(begin: Colors.blue, end: Colors.blue), /// 第一个 EasyTweenAnimationItem 应该包含animSequence存在的所有效果作为默认值
                  },
                  weight: 50, /// 占总时长的50%，也就是0%~50%时的动画效果
                ),

                EasyTweenAnimationItem(
                  animatables: {
                    "width": Tween(begin: 200.0, end: 200.0),
                    "color": ColorTween(begin: Colors.blue, end: Colors.red),
                  },
                  weight: 50, /// 占总时长的50%，也就是50%~100%时的动画效果
                ),
              ],
              duration: Duration(seconds: 2),
              loop: true, ///循环执行
              builder: (BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget? child){

                Animation width = animationMap['width']!;
                Animation color = animationMap['color']!;

                return AnimatedBuilder(animation: curvedAnimation, builder: (context, child){
                  return Container(
                    width: width.value,
                    height: 100,
                    decoration: BoxDecoration(
                        color: color.value,
                    ),
                  );
                },
                );
              }
          ),

          SizedBox(height: 20,)
        ],
      ),
    );
  }



  /// @Desc  : 并行执行多个动画（交织动画）
  /// @author: 枫儿
  Widget four(){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.album),
            title: Text('并行执行多个动画（交织动画）'),
            subtitle: Text("蓝色方块并行执行多个动画（宽度放大+颜色改变为红色）"),
          ),

          /// example
          EasyTweenAnimation(
              animSequence: [
                EasyTweenAnimationItem(
                  animatables: {
                    "width": Tween(begin: 0.0, end: 200.0),
                    "color": ColorTween(begin: Colors.blue, end: Colors.red),
                  },
                  weight: 100,
                ),

              ],
              duration: Duration(seconds: 2),
              loop: true, ///循环执行
              builder: (BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget? child){

                Animation width = animationMap['width']!;
                Animation color = animationMap['color']!;

                return AnimatedBuilder(animation: curvedAnimation, builder: (context, child){
                  return Container(
                    width: width.value,
                    height: 100,
                    decoration: BoxDecoration(
                        color: color.value,
                    ),
                  );
                },
                );
              }
          ),

          SizedBox(height: 20,)
        ],
      ),
    );
  }



  /// @Desc  : 串行+并行执行多个动画效果
  /// @author: 枫儿
  Widget five(){
    return Card(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.album),
            title: Text('串行+并行执行多个动画效果'),
            subtitle: Text("方块旋转缩放 然后 修改颜色缩放"),
          ),

          /// example
          EasyTweenAnimation(
              animSequence: [
                EasyTweenAnimationItem(
                  animatables: {
                    "angle": Tween<double>(begin: 0, end: 1 * pi),
                    "size": Tween(begin: 50.0, end: 200.0),
                    "color": ColorTween(begin: Colors.blue[50], end: Colors.blue[400]),
                    "radius": Tween<double>(begin: 20, end: 0),
                    "borderColor": ColorTween(begin: Colors.red, end: Colors.deepPurpleAccent),
                  },
                  weight: 50,
                ),

                EasyTweenAnimationItem(
                  animatables: {
                    "angle": Tween<double>(begin: 1 * pi, end: 1 * pi),
                    "size": Tween(begin: 200, end: 50.0),
                    "color": ColorTween(begin: Colors.blue[400], end: Colors.amber),
                    "radius": Tween<double>(begin: 0, end: 360),
                    "borderColor": ColorTween(begin: Colors.deepPurpleAccent, end: Colors.brown),
                  },
                  weight: 50,
                ),

              ],
              duration: Duration(seconds: 2),
              loop: true, ///循环执行
              builder: (BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget? child){

                Animation size = animationMap['size']!;
                Animation color = animationMap['color']!;
                Animation angle = animationMap['angle']!;
                Animation radius = animationMap['radius']!;
                Animation borderColor = animationMap['borderColor']!;


                return AnimatedBuilder(animation: curvedAnimation, builder: (context, child){
                  return Transform.rotate(
                      angle: angle.value,
                      child: Container(
                        width: size.value,
                        height: size.value,
                        decoration: BoxDecoration(
                          color: color.value,
                          borderRadius: BorderRadius.circular(radius.value),
                          border: Border.all(color: borderColor.value, width: 2),
                        ),
                      )
                  );

                },
                );
              }
          ),

          SizedBox(height: 20,)
        ],
      ),
    );
  }





}
