import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/authentication/bloc/register/register_bloc.dart';
import 'package:pujcovadlo_client/features/authentication/exceptions/email_exists.dart';
import 'package:pujcovadlo_client/features/authentication/exceptions/username_exists.dart';
import 'package:pujcovadlo_client/features/authentication/models/register/models.dart';
import 'package:pujcovadlo_client/features/authentication/view_helpers/registration_helper.dart';
import 'package:pujcovadlo_client/features/authentication/widgets/gradient_background.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final _formKey;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmationController;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle:
              Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                    color: Colors.white,
                  ),
          title: Text(context.loc.create_you_account_page_title),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: BlocProvider(
          create: (context) => RegisterBloc(),
          child: BlocListener<RegisterBloc, RegisterState>(
            // Listen only to status changes
            //listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              // Display overlay when the state is in progress
              if (state.status == FormzSubmissionStatus.inProgress) {
                context.loaderOverlay.show();
              }
              // Hide overlay when the state is not in progress
              else {
                context.loaderOverlay.hide();
              }
            },
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GradientBackground(
                        color: Theme.of(context).colorScheme.primary,
                        children: [
                          Text(
                            context.loc.create_your_account_title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                    color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          Text(context.loc.create_you_account_message,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white)),
                        ]),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                    flex: 5,
                                    child: _FirstNameField(
                                      controller: _firstNameController,
                                    )),
                                const SizedBox(
                                  height: 15,
                                  width: 15,
                                ),
                                Flexible(
                                    flex: 5,
                                    child: _LastNameField(
                                      controller: _lastNameController,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 15),
                            _UsernameField(controller: _usernameController),
                            const SizedBox(height: 15),
                            _EmailField(controller: _emailController),
                            const SizedBox(height: 15),
                            _PhoneField(controller: _phoneController),
                            const SizedBox(height: 15),
                            _PasswordField(controller: _passwordController),
                            const SizedBox(height: 15),
                            _PasswordConfirmationField(
                                controller: _passwordConfirmationController),
                            const SizedBox(height: 15),
                            const _SubmitError(),
                            const SizedBox(height: 10),
                            const _RegisterSubmit(),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.loc.already_have_account_question,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(context.loc.login_button),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstNameField extends StatelessWidget {
  final TextEditingController controller;

  const _FirstNameField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          onChanged: (String value) => BlocProvider.of<RegisterBloc>(context)
              .add(RegisterFirstNameChanged(value)),
          maxLength: FirstName.maxLength,
          decoration: InputDecoration(
            counterText: '',
            // Hide the counter
            labelText: context.loc.register_first_name,
            hintText: context.loc.register_first_name,
            errorText: RegistrationLocalizationHelper.firstNameError(
                context.loc, state.firstName),
            border: const OutlineInputBorder(),
            //border: InputBorder.none
          ),
        );
      },
    );
  }
}

class _LastNameField extends StatelessWidget {
  final TextEditingController controller;

  const _LastNameField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          onChanged: (String value) => BlocProvider.of<RegisterBloc>(context)
              .add(RegisterLastNameChanged(value)),
          maxLength: LastName.maxLength,
          decoration: InputDecoration(
            counterText: '',
            // Hide the counter
            labelText: context.loc.register_last_name,
            hintText: context.loc.register_last_name,
            errorText: RegistrationLocalizationHelper.lastNameError(
                context.loc, state.lastName),
            border: const OutlineInputBorder(),
            //border: InputBorder.none
          ),
        );
      },
    );
  }
}

class _UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const _UsernameField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onChanged: (String value) => BlocProvider.of<RegisterBloc>(context)
              .add(RegisterUsernameChanged(value)),
          maxLength: RegisterUsername.maxLength,
          decoration: InputDecoration(
            counterText: '',
            // Hide the counter
            labelText: context.loc.register_username_title,
            hintText: context.loc.register_username_title,
            errorText: RegistrationLocalizationHelper.usernameError(
                context.loc, state.username),
            border: const OutlineInputBorder(),
            //border: InputBorder.none
          ),
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (String value) => BlocProvider.of<RegisterBloc>(context)
              .add(RegisterEmailChanged(value)),
          maxLength: RegisterEmail.maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: InputDecoration(
            counterText: '',
            // Hide the counter
            labelText: context.loc.register_email,
            hintText: context.loc.register_email,
            errorText: RegistrationLocalizationHelper.emailError(
                context.loc, state.email),
            border: const OutlineInputBorder(),
            //border: InputBorder.none
          ),
        );
      },
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const _PhoneField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onChanged: (String value) => BlocProvider.of<RegisterBloc>(context)
              .add(RegisterPhoneChanged(value)),
          maxLength: RegisterPhone.maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: InputDecoration(
            counterText: '',
            // Hide the counter
            labelText: context.loc.register_phone,
            hintText: context.loc.register_phone,
            errorText: RegistrationLocalizationHelper.phoneError(
                context.loc, state.phone),
            border: const OutlineInputBorder(),
            //border: InputBorder.none
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          onChanged: (String value) => BlocProvider.of<RegisterBloc>(context)
              .add(RegisterPasswordChanged(value)),
          obscureText: true,
          maxLength: RegisterPassword.maxLength,
          decoration: InputDecoration(
            counterText: '',
            // Hide the counter
            labelText: context.loc.register_password,
            hintText: context.loc.register_password,
            errorText: RegistrationLocalizationHelper.passwordError(
                context.loc, state.password),
            errorMaxLines: 3,
            border: const OutlineInputBorder(),
            //border: InputBorder.none
          ),
        );
      },
    );
  }
}

class _PasswordConfirmationField extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordConfirmationField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.passwordConfirmation != current.passwordConfirmation,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          onChanged: (String value) => BlocProvider.of<RegisterBloc>(context)
              .add(RegisterPasswordConfirmationChanged(value)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: context.loc.register_password_confirmation,
            hintText: context.loc.register_password_confirmation,
            errorText: RegistrationLocalizationHelper.passwordConfirmationError(
                context.loc, state.passwordConfirmation),
            border: const OutlineInputBorder(),
            //border: InputBorder.none
          ),
        );
      },
    );
  }
}

class _RegisterSubmit extends StatelessWidget {
  const _RegisterSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<RegisterBloc>().add(const RegisterSubmitted()),
                child: Text(context.loc.register_button),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SubmitError extends StatelessWidget {
  const _SubmitError({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
          // Return nothing if the status is not failure
          if (state.status != FormzSubmissionStatus.failure) {
            return const SizedBox.shrink();
          }

          // Default error message
          var error = context.loc.request_failed;

          if (state.error is UsernameAlreadyExists) {
            error = context.loc.register_username_already_exists;
          }

          if (state.error is EmailAlreadyExists) {
            error = context.loc.register_email_already_exists;
          }

          // return formated error text
          return Expanded(
            child: Text(
              error,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).colorScheme.error),
            ),
          );
        }),
      ],
    );
  }
}
