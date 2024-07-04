part of '../shared.dart';

class CustomFormButton<C extends Cubit<S>, S> extends StatelessWidget {
  const CustomFormButton({
    required this.buttonText,
    required this.buttonColor,
    required this.borderRadius,
    required this.isButtonEnabled,
    required this.onButtonPressed,
    required this.buttonKey,
    super.key,
  });

  final String buttonText;
  final Color buttonColor;
  final BorderRadiusGeometry borderRadius;
  final bool Function(S state) isButtonEnabled;
  final void Function(BuildContext context) onButtonPressed;
  final Key buttonKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, S>(
      builder: (context, state) {
        return (state is SignUpState)
            ? state.status.isInProgress
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    key: buttonKey,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius,
                      ),
                      backgroundColor: buttonColor,
                    ),
                    onPressed: isButtonEnabled(state)
                        ? () => onButtonPressed(context)
                        : null,
                    child: Text(buttonText),
                  )
            : Container();
      },
    );
  }
}
