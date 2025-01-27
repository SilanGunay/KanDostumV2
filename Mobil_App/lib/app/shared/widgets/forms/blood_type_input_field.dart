import 'package:flutter/material.dart';

class BloodTypeInputField extends StatefulWidget {
  final String label;
  final bool busy;
  final Function(String) onSaved;
  final TextEditingController controller;

  const BloodTypeInputField({
    Key key,
    this.label,
    this.onSaved,
    this.busy = false,
    this.controller,
  }) : super(key: key);

  @override
  _BloodTypeInputFieldState createState() => _BloodTypeInputFieldState();
}

class _BloodTypeInputFieldState extends State<BloodTypeInputField> {
  String _itemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: !widget.busy,
        controller: widget.controller,
        onSaved: widget.onSaved,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: widget.label,
          filled: true,
        ),
        readOnly: true,
        onTap: () {
          _showDialog(context);
        },
      ),
    );
  }

  _showDialog(BuildContext context) {
    _itemSelected = widget.controller.text;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _bloodDialog();
      },
    );
  }

  _bloodDialog() {
    return AlertDialog(
      title: new Text(widget.label),
      content: Container(
        child: FormField<String>(
          initialValue: _itemSelected,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    _button('A+', state: state),
                    SizedBox(width: 10),
                    _button('B+', state: state),
                    SizedBox(width: 10),
                    _button('AB+', state: state),
                    SizedBox(width: 10),
                    _button('O+', state: state),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    _button('A-', state: state),
                    SizedBox(width: 10),
                    _button('B-', state: state),
                    SizedBox(width: 10),
                    _button('AB-', state: state),
                    SizedBox(width: 10),
                    _button('O-', state: state),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    _button('I do not know', state: state),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            _itemSelected = widget.controller.text;
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Confirm'),
          onPressed: () {
            if (_itemSelected.isNotEmpty) {
              widget.controller.text = _itemSelected;
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _button(
    String label, {
    FormFieldState<String> state,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          state.didChange(label);
          _itemSelected = label;
        },
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: state.value == label ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
            ),
            color: state.value == label ? Theme.of(context).accentColor : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: state.value == label ? Colors.white : Theme.of(context).disabledColor,
            ),
          ),
        ),
      ),
    );
  }
}
