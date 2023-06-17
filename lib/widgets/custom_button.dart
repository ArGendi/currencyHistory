import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onClick;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onClick,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      borderRadius: BorderRadius.circular(5),
      child: AnimatedContainer(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(5)),
        duration: const Duration(milliseconds: 400),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: !widget.isLoading
              ? Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
