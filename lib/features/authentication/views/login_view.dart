import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/authentication/bloc/login/login_bloc.dart';
import 'package:pujcovadlo_client/features/authentication/exceptions/invalid_credentials.dart';
import 'package:pujcovadlo_client/features/authentication/views/register_view.dart';
import 'package:pujcovadlo_client/features/authentication/widgets/gradient_background.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final _formKey;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => LoginBloc(),
          child: BlocListener<LoginBloc, LoginState>(
            // listen only to status changes
            listenWhen: (previous, current) =>
                previous.status != current.status,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GradientBackground(
                      color: Theme.of(context).colorScheme.primary,
                      children: [
                        Text(
                          context.loc.sign_to_your_account,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: Colors.white),
                        ),
                        SizedBox(height: 6),
                        Text(context.loc.sign_to_your_account_message,
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
                          _UsernameField(controller: emailController),
                          const SizedBox(height: 20),
                          _PasswordField(controller: passwordController),
                          const SizedBox(height: 10),
                          const _SubmitError(),
                          const SizedBox(height: 10),
                          const _LoginSubmit(),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {}, // TODO
                                  child: Text(
                                      context.loc.forgotten_password_button),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: Divider(color: Colors.grey.shade200)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  context.loc.login_using_other,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                              ),
                              Expanded(
                                  child: Divider(color: Colors.grey.shade200)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.g_mobiledata, size: 14),
                                  label: const Text(
                                    "Google",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.facebook, size: 14),
                                  label: const Text(
                                    "Facebook",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.loc.dont_have_an_account,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterView(),
                          ),
                        ),
                        child: Text(context.loc.register_button),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const _UsernameField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (String value) => BlocProvider.of<LoginBloc>(context)
              .add(LoginUsernameChanged(value)),
          decoration: InputDecoration(
            labelText: context.loc.login_email_or_username_title,
            hintText: context.loc.login_email_or_username_hint,
            errorText: "",
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
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          onChanged: (String value) => BlocProvider.of<LoginBloc>(context)
              .add(LoginPasswordChanged(value)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: context.loc.login_password_title,
            errorText: null,
            border: const OutlineInputBorder(),
            //border: InputBorder.none
          ),
        );
      },
    );
  }
}

class _LoginSubmit extends StatelessWidget {
  const _LoginSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<LoginBloc>().add(const LoginSubmitted()),
                child: Text(context.loc.login_button),
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
        BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          // Return nothing if the status is not failure
          if (state.status != FormzSubmissionStatus.failure) {
            return const SizedBox.shrink();
          }

          // Default error message
          var error = context.loc.request_failed;

          // Invalid credentials message
          if (state.error is InvalidCredentialsException) {
            error = context.loc.invalid_credentials;
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
