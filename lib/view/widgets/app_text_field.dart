import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shapes.dart';

class AppTextField extends StatefulWidget {
  final String hint;
  final TextInputType inputType;
  final bool obscureText;
  final Function onChanged;
  final EdgeInsets margin;
  final IconData? icon;
  final void Function()? onIconPressed;
  final void Function()? onTap;
  final String? errorText;
  final int maxLines;
  final String? Function(String?)? validator;
  final int minLines;
  final int? maxLength;
  final TextInputAction textInputAction;
  final bool readOnly;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatter;
  final TextCapitalization textCapitalization;
  final TextAlign? textAlign;

  const AppTextField(
      {super.key,
      required this.hint,
      required this.onChanged,
      this.inputType = TextInputType.text,
      this.obscureText = false,
      this.margin = const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      this.icon,
      this.onIconPressed,
      this.errorText,
      this.maxLines = 1,
      this.minLines = 1,
      this.maxLength,
      this.validator,
      this.textInputAction = TextInputAction.next,
      this.readOnly = false,
      this.controller,
      this.inputFormatter,
      this.textCapitalization = TextCapitalization.sentences,
      this.onTap,
      this.textAlign});

  @override
  State<StatefulWidget> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: widget.margin,
            child: TextFormField(
              key: _formKey,
              onTap: widget.onTap,
              controller: widget.controller,
              textCapitalization: widget.textCapitalization,
              inputFormatters: widget.inputFormatter,
              readOnly: widget.readOnly,
              style: TextStyle(color: Colors.black),
              textAlign: widget.textAlign ?? TextAlign.start,
              textInputAction: widget.textInputAction,
              obscureText: widget.obscureText,
              onChanged: (text) {
                widget.onChanged(text);
              },
              keyboardType: widget.inputType,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: widget.validator,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                filled: true,
                counterText: "",
                fillColor: Theme.of(context).cardColor,
                labelStyle: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.9), fontWeight: FontWeight.w400, fontSize: 14.0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).cardColor, width: 0), borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0), borderRadius: BorderRadius.zero),
                errorText: widget.errorText,
                errorStyle: TextStyle(
                  color: Theme.of(context).errorColor,
                  height: 0.9,
                ),
                errorMaxLines: 100,
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0), borderRadius: BorderRadius.zero),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                labelText: widget.hint,
                suffixIcon: widget.icon != null
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Icon(
                            widget.icon,
                            color: Theme.of(context).hintColor,
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                              child: InkWell(
                                onTap: widget.onIconPressed,
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ))
      ],
    );
  }
}
