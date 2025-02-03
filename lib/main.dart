import 'package:chess/features/1vsBot/bot/logic/bot_dialogues_cubit.dart';
import 'package:chess/features/board/logic/cubit/sfx_cubit.dart';
import 'package:chess/features/homepage/presentation/view/homepage.dart';
import 'package:chess/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SfxHapticsCubit>(
          create: (context) => SfxHapticsCubit(),
          lazy: false,
        ),
        BlocProvider<BotDialoguesCubit>(
          create: (context) => BotDialoguesCubit(),
          lazy: false,
        ),
      ],
      child: const MaterialApp(
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: HomePage(),
      ),
    );
  }
}
