import 'package:flutter/material.dart';

class InlineEditableText extends StatefulWidget {
  final String initialText;
  final Function(String) onDoneEditing;
  final TextStyle? textStyle;
  final String? hintText;
  final bool enabled;

  const InlineEditableText({
    Key? key,
    required this.initialText,
    required this.onDoneEditing,
    this.textStyle,
    this.hintText,
    this.enabled = true,
  }) : super(key: key);

  @override
  _InlineEditableTextState createState() => _InlineEditableTextState();
}

class _InlineEditableTextState extends State<InlineEditableText> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isEditing = false;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    _previousText = widget.initialText;

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isEditing) {
        _finishEditing();
      }
    });
  }

  void _finishEditing() {
    setState(() {
      _isEditing = false;
    });

    if (_previousText != _controller.text) {
      widget.onDoneEditing(_controller.text);
      _previousText = _controller.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled
          ? () {
        setState(() {
          _isEditing = true;
        });
        _focusNode.requestFocus();
      }
          : null,
      child: IntrinsicWidth(
        child: _isEditing
            ? TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: widget.textStyle,
          minLines: 1,
          maxLines: 1,
          maxLength: 32,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          onSubmitted: (_) => _finishEditing(),
        )
            : Text(
          _controller.text,
          style: widget.textStyle,textAlign: TextAlign.center,
        ),
      ),
    );
  }
}