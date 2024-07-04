part of '../shared.dart';

class CustomInputTextField<T extends Cubit<S>, S> extends StatelessWidget {
  const CustomInputTextField({
    required this.textFieldKey,
    required this.labelText,
    required this.helperText,
    required this.onChanged,
    required this.stateCondition,
    required this.errorTextExtractor,
    this.keyboardType = TextInputType.text,
    this.isObsecureField = false,
    super.key,
  });

  final Key textFieldKey;
  final TextInputType? keyboardType;
  final String labelText;
  final String helperText;
  final void Function(BuildContext context, String value) onChanged;
  final S Function(S state) stateCondition;
  final String? Function(S state) errorTextExtractor;
  final bool? isObsecureField;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, S>(
      buildWhen: (previous, current) =>
          stateCondition(previous) != stateCondition(current),
      builder: (context, state) {
        return TextField(
          key: textFieldKey,
          onChanged: (value) => onChanged(context, value),
          keyboardType: keyboardType,
          obscureText: isObsecureField ?? false,
          decoration: InputDecoration(
            labelText: labelText,
            helperText: helperText,
            errorText: errorTextExtractor(state),
          ),
        );
      },
    );
  }
}
