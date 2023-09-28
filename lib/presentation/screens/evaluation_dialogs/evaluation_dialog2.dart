import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/root/root_cubit.dart';
import 'package:trips/presentation/screens/evaluation_dialogs/thanks_dialog.dart';
import 'package:trips/presentation/style/app_colors.dart';
import '../../../cubit/evaluation/evaluation_cubit.dart';
import '../../../cubit/evaluation/evaluation_states.dart';
import '../../common_widgets/dialog/action_alert_dialog.dart';
import '../../common_widgets/dialog/error_dialog.dart';

evalAnimatedDialog({required BuildContext context}) {
  return ActionAlertDialog.show(
      context,
      dialogTitle: 'eval_title'.translate(),
      message: 'to_know'.translate(),
      onCancel: () => Navigator.pop(context),
      secondaryWidget:
     const Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         EmojiWidget(emoji: AnimatedEmojis.scrunchedMouth,index: 0,),
         EmojiWidget(emoji: AnimatedEmojis.unamused,index: 1,),
         EmojiWidget(emoji: AnimatedEmojis.neutralFace,index: 2,),
         EmojiWidget(emoji: AnimatedEmojis.slightlyHappy,index: 3,),
         EmojiWidget(emoji: AnimatedEmojis.heartEyes,index: 4,),
       ],
     )
  );
}

class EmojiWidget extends StatelessWidget {
  final int index;
  final AnimatedEmojiData emoji;
  const EmojiWidget({Key? key, required this.index, required this.emoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EvaluationCubit,EvaluationStates>(
      listener: (context, state) {
      },
      builder: (context, state) =>InkWell(
        onTap: () {
          context.read<EvaluationCubit>().changeIndex(index);
          context.read<RootPageCubit>().rateTrip(rate:index ,);
          },
        child: Animate(
            effects: const [FadeEffect(), ScaleEffect()],
        child: Container(
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: context.read<EvaluationCubit>().index == index ?
        const LinearGradient(
        end: Alignment.centerRight,
        begin: Alignment.centerLeft,
        colors: [
        AppColors.lightXGreen,
        AppColors.lightXXGreen,
        ]) : null,
        color: context.read<EvaluationCubit>().index == index ? null : AppColors.darkXXGrey.withOpacity(0.2),
        ),
        child: Padding(
        padding: const EdgeInsets.all(6.0),
        child:  AnimatedEmoji(emoji,size: 42),
        ))),
      ),
    );
  }
}
