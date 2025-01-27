import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kandostum2/app/modules/home/pages/home_page.dart';
import 'package:kandostum2/app/modules/login/controllers/account_controller.dart';
import 'package:kandostum2/app/modules/login/pages/forget_page.dart';
import 'package:kandostum2/app/modules/login/pages/sign_up_page.dart';
import 'package:kandostum2/app/shared/widgets/forms/custom_input_field.dart';
import 'package:kandostum2/app/modules/login/widgets/logotipo.dart';
import 'package:kandostum2/app/modules/login/widgets/password_input_field.dart';
import 'package:kandostum2/app/modules/login/widgets/text_button.dart';
import 'package:kandostum2/app/shared/helpers/snackbar_helper.dart';
import 'package:kandostum2/app/shared/helpers/validator.dart';
import 'package:kandostum2/app/shared/widgets/forms/submit_button.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/signin';
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = new GlobalKey<FormState>();

  AccountController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= Provider.of<AccountController>(context);
  }

  signInWithEmailAndPassword() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      _controller.signInWithCredentials(onSuccess: onSuccess, onError: onError);
    }
  }

  onSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  onError(error) {
    SnackBarHelper.showFailureMessage(context, title: 'Error', message: error);
  }

  navigatorToRegisterPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  navigatorToForgetPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgetPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Container(
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 2, child: SizedBox()),
                Logotipo(
                  color: Theme.of(context).accentColor,
                ),
                Expanded(child: SizedBox()),
                Observer(
                  builder: (_) {
                    return CustomInputField(
                      label: 'Email',
                      busy: _controller.busy,
                      validator: Validator.isValidEmail,
                      textInputType: TextInputType.emailAddress,
                      onSaved: _controller.setEmail,
                    );
                  },
                ),
                SizedBox(height: 10),
                Observer(
                  builder: (_) {
                    return PasswordInputField(
                      forgetPassword: true,
                      busy: _controller.busy,
                      textInputType: TextInputType.text,
                      validator: Validator.isValidatePassword,
                      onTap: navigatorToForgetPasswordPage,
                      onSaved: _controller.setPassword,
                    );
                  },
                ),
                SizedBox(height: 20),
                Observer(
                  builder: (_) {
                    return SubmitButton(
                      busy: _controller.busy,
                      firstColor: Theme.of(context).accentColor,
                      secondColor: Theme.of(context).primaryColor,
                      onTap: signInWithEmailAndPassword,
                    );
                  },
                ),
                Expanded(child: SizedBox()),
                MetinButton(
                  question: 'Do not you have an account?',
                  label: 'Register',
                  onTap: navigatorToRegisterPage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
