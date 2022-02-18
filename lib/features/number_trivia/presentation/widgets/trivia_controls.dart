import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({ Key key }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            label: const Text('Input a number'),
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (newValue) {
            controller.text = newValue;
            controller.selection = TextSelection.collapsed(offset: newValue.length);
          },
          onSubmitted: (_) => dispatchConcrete(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text('Search'),
                onPressed: dispatchConcrete,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: const Text('Get Random Trivia'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[600]),
                ),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    FocusScope.of(context).unfocus();

    BlocProvider.of<NumberTriviaBloc>(context)
      .add(GetTriviaForConcreteNumber(controller.text));

    controller.clear();
  }

  void dispatchRandom() {
    FocusScope.of(context).unfocus();
    controller.clear();
    
    BlocProvider.of<NumberTriviaBloc>(context)
      .add(GetTriviaForRandomNumber());

  }

  @override 
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}