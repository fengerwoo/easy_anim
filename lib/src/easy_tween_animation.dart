
import 'package:flutter/material.dart';

typedef EasyTweenAnimationWidgetBuilder = Widget Function(BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget child);
typedef EasyTweenAnimationOnStatus = Widget Function(AnimationStatus status, AnimationController controller);


/// @Desc  : 简单的方式使用Flutter Tween动画
/// 1，自维护controller，使用动画代码简洁
/// 2，支持延时执行动画
/// 3，支持循环执行动画
/// 4，支持交织动画（并行动画）
///
/// Created by 枫儿 on 2021/2/24.
/// @email：hsnndly@163.com
class EasyTweenAnimation extends StatefulWidget{


  final List<EasyTweenAnimationItem> animSequence;
  final Duration duration;
  final Curve curve;
  final EasyTweenAnimationWidgetBuilder builder;
  final EasyTweenAnimationOnStatus onStatus;
  final Widget child;
  final Duration delay;
  final bool loop;


  /// @Desc  : 创建一个动画组件，自维护controller，使用简单
  ///
  ///  ## 参数列表
  /// [animSequence] 动画分镜序列
  /// [duration] 动画执行总时长
  /// [curve] 动画执行曲线，默认线性
  /// [builder] 构建要使用动画的组件
  /// [onStatus] 监听动画执行状态回调
  /// [child] 子组件
  /// [delay] 延时时间，默认0秒立即执行
  /// [loop] 是否循环执行
  ///
  /// ## 使用示例
  ///
  /// ```dart
  /// EasyTweenAnimation(
  ///   animSequence: [
  ///     EasyTweenAnimationItem(
  ///       animatables: {
  ///         "angle": Tween<double>(begin: 0, end: 1 * pi),
  ///         "color": ColorTween(begin: Colors.blue, end: Colors.blue),
  ///         "width": Tween<double>(begin: 100, end: 100),
  ///       },
  ///       weight: 50.0, // 占总时长的50%，也就是2秒的0%~50%时的动画效果
  ///     ),
  ///
  ///
  ///     EasyTweenAnimationItem(
  ///       animatables: {
  ///         "color": ColorTween(begin: Colors.blue, end: Colors.red),
  ///         "width": Tween<double>(begin: 100, end: 200),
  ///       },
  ///       weight: 50.0, // 占总时长的50%，也就是2秒的50%~100%时的动画效果
  ///     ),
  ///   ],
  ///
  ///   duration: Duration(seconds: 2), // 执行动画总时长
  ///   delay: Duration(milliseconds: 200), // 延时多久执行，默认0秒立即执行
  ///   loop: true, // 是否循环执行动画
  ///   builder: (BuildContext context, CurvedAnimation curvedAnimation, Map<String, Animation> animationMap, AnimationController animationController, Widget child){
  ///
  ///     // 从animationMap里取出各个效果的Animation对象
  ///     Animation angle = animationMap["angle"];
  ///     Animation color = animationMap['color'];
  ///     Animation width = animationMap['width'];
  ///
  ///     // AnimatedBuilder 里使用 各个效果的Animation对象value即可
  ///     return AnimatedBuilder(animation: curvedAnimation, builder: (context, child){
  ///       return Transform.rotate(
  ///         angle: angle.value,
  ///         child: Container(
  ///           color: color.value,
  ///           width: width.value,
  ///           height: width.value,
  ///         ),
  ///       );
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// @author: 枫儿
  EasyTweenAnimation({
    Key key,
    @required this.animSequence,
    @required this.duration,
    this.curve = Curves.linear,
    @required this.builder,
    this.onStatus,
    this.child,
    this.delay = Duration.zero,
    this.loop = false,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _EasyTweenAnimationState();
}


class _EasyTweenAnimationState extends State<EasyTweenAnimation> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Map<String, List<TweenSequenceItem>> _tagTweenSequenceItems = {};
  CurvedAnimation _animation;
  Map<String, Animation> _animationMap = {};

  @override
  void initState() {
    super.initState();
    // 创建控制器
    _animationController = AnimationController(duration: this.widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _animationController, curve: this.widget.curve);

    // 添加监听
    _animation.addStatusListener((status) {
      // 回调状态
      if(this.widget.onStatus != null){
        this.widget.onStatus(status, _animationController);
      }
    });

    this.makeUpAnimSequence(this.widget.animSequence); // 补齐 各个分镜 未存在的效果
    _tagTweenSequenceItems = this.buildTagTweenSequenceItems(this.widget.animSequence); // 创建Tag 的 TweenSequenceItem 数组

    // 创建 各个Tag效果的 TweenSequence
    _tagTweenSequenceItems.forEach((String tag, List<TweenSequenceItem> items) {
      Animation animation = TweenSequence(items).animate(_animationController);
      _animationMap[tag] = animation;
    });



    // 延时执行动画（默认0秒）
    new Future.delayed(this.widget.delay, (){

      if(this.widget.loop){
        _animationController.repeat();
      }else{
        _animationController.forward();
      }

    });
  }


  /// @Desc  : 生成所有Tag的TweenSequenceItem
  /// @author: 枫儿
  Map<String, List<TweenSequenceItem>> buildTagTweenSequenceItems(List<EasyTweenAnimationItem> animSequence){

    Map<String, List<TweenSequenceItem>> tagTweenSequenceItems = {};

    // 循环处理分镜
    for(int i=0; i<animSequence.length; i++){
      EasyTweenAnimationItem clipItem = animSequence[i];

      // 循环处理分镜内单个效果
      clipItem.animatables.forEach((String tag, Animatable animatable){
          if(tagTweenSequenceItems[tag] == null){ //如果不存在这个tag对应数组，创建空数组
            tagTweenSequenceItems[tag] = [];
          }

          TweenSequenceItem tweenSequenceItem = TweenSequenceItem(tween: animatable, weight: clipItem.weight);
          tagTweenSequenceItems[tag].add(tweenSequenceItem);
      });
    }

    return tagTweenSequenceItems;
  }


  /// @Desc  : 补齐[animSequence]各个分镜里缺失的动画效果，默认保持上一个
  /// @author: 枫儿
  makeUpAnimSequence(List<EasyTweenAnimationItem> animSequence){
    List<String> tags = this.getTags(animSequence);

    // 循环所有分镜
    for(int i=0; i<animSequence.length; i++){
      EasyTweenAnimationItem clipItem = animSequence[i];

      // 检查该分镜所有Tag是否存在
      for(int j=0; j<tags.length; j++){
        String tag = tags[j];

        // 不存在的Tag，查找前面分镜的相同Tag补上
        if(clipItem.existTag(tag) == false){
          clipItem.animatables[tag] = this.findLastTag(animSequence, i, tag);
        }
      }

    }
  }


  /// @Desc  : 寻找动画序列里某个节点前面最近一个存在该tag的节点，要是到第一个都没找到，就断言中断并警告
  /// @author: 枫儿
  Animatable findLastTag(List<EasyTweenAnimationItem> animSequence, int index, String tag){
    Animatable animate;
    for(int i=index; i>=0; i--){
      EasyTweenAnimationItem item = animSequence[i];

      if(item.existTag(tag)){ //不为空则为找到了
        animate = item.animatables[tag];
        break;
      }
    }

    assert(
      animate != null,
      "EasyTweenAnimation 组件 animSequence 列表属性的第一个 EasyTweenAnimationItem 应该包含animSequence存在的所有效果作为默认值。 当前「${tag}」效果不存在，请在第一个EasyTweenAnimationItem内添加「${tag}」默认效果 \n\n"
      "The first EasyTweenAnimationItem in the animSequence list property of the EasyTweenAnimation component should contain all the effects that exist in the animSequence as default values. The current 「${tag}」 effect does not exist, please add the 「${tag}」 default effect in the first EasyTweenAnimationItem\n");

    return animate;
  }



  /// @Desc  : 获取所有的Tag
  /// @author: 枫儿
  List<String> getTags(List<EasyTweenAnimationItem> animSequence){
    List<String> tags = [];

    for(int i=0; i<animSequence.length; i++){
      EasyTweenAnimationItem clipItem = animSequence[i];

      clipItem.animatables.keys.toList().forEach((itemTag) {
        if(tags.contains(itemTag) == false){
          tags.add(itemTag);
        }
      });
    }
    return tags;
  }



  @override
  Widget build(BuildContext context) {
    return this.widget.builder(context, _animation, _animationMap, _animationController, this.widget.child);
  }



  @override
  void dispose() {
    // 组件销毁，释放 controller
    _animationController.dispose();

    super.dispose();
  }

}

/// 动画分镜
/// Created by 枫儿 on 2021/2/24.
/// @email：hsnndly@163.com
class EasyTweenAnimationItem{

  Map<String, Animatable> animatables;
  double weight;

  /// @Desc  : 动画分镜
  /// [animatables] 动画效果，该分镜时间段里的动画效果组
  /// [weight] 分镜占动画执行总时长权重百分比(0-100)
  EasyTweenAnimationItem({
    Key key,
    @required this.animatables,
    @required this.weight,
  });


  /// @Desc  : 判断分镜内是否存在某个Tag
  /// @author: 枫儿
  bool existTag(String tag){
    if(this.animatables[tag] != null){
      return true;
    }else{
      return false;
    }
  }


}
