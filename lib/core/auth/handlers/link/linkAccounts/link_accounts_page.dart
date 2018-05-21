import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../app_model.dart';

import '../../../../common/dialog.dart';
import 'link_accounts_view_model.dart';
import '../../email/link/link_account.dart' as email;
import '../../email/icon.dart' as email;
import '../../google/icon.dart' as google;
import 'link_card.dart';

import '../../../../dialogs/show_ok_cancel_dialog.dart';
import '../../signin_accounts/signin_picker_dialog.dart';

class LinkAccounts extends StatefulWidget {
  @override
  createState() => new LinkAccountsState();
}

class LinkAccountsState extends State<LinkAccounts> {
  @override
  void initState() {
    super.initState();

    _viewModel = new ViewModel();
  }

  ViewModel _viewModel;

  final Map<String, IconData> _icons = {
    'google': google.providerIcon,
    'password': email.providerIcon
  };

  bool isEmpty(String str) {
    return str == null || str.length == 0;
  }

  Widget _buildActiveCard({ViewModelItem viewModel, IconData icon}) {
    var theme = Theme.of(context);
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(icon),
          title: Text(viewModel.title),
          subtitle: (isEmpty(viewModel.subTitle)
              ? null
              : Text(
                  viewModel.subTitle,
                  style: theme.textTheme.body1,
                )),
          trailing: Text('Connected', style: theme.textTheme.body2),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildLinkableCard(
      {ViewModel parentViewModel, ViewModelItem viewModel, IconData icon}) {
    switch (viewModel.providerName) {
      case 'password':
        return LinkCard(
          icon: email.providerIcon,
          title: viewModel.title,
          subTitle: viewModel.subTitle,
          linkAction: (context) async => await openDialog(
                context: context,
                builder: (_) => email.LinkEmailAccount(
                      viewModel.linkableProvider,
                      onAuthRequired: () =>
                          handleAuthenticationRequired(parentViewModel),
                    ),
              ),
        );
      case 'google':
        return LinkCard(
          icon: google.providerIcon,
          title: viewModel.title,
          subTitle: viewModel.subTitle,
          linkAction: (context) async {
            try {
              await viewModel.linkableProvider.linkAccount({});
            } on AuthRequiredException {
              handleAuthenticationRequired(parentViewModel);
            }
          },
        );
    }
    return Container();
  }

  void handleAuthenticationRequired(ViewModel viewModel) {
    showOkCancelDialog(() {
      Navigator.pop(context);

      showSigninPickerDialog(context, viewModel.signInProviders);
    }, () {
      Navigator.pop(context);
    },
        context: context,
        caption: "Authentication Required",
        message:
            "You need to re-authenticate to be able to connect this account");
  }

  Widget _handleCompleted(ViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Material(
          color: isMaterial ? null : Theme.of(context).cardColor,
          elevation: isMaterial ? 4.0 : 0.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Access the same data with multiple accounts.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(0.0),
            itemCount: viewModel.items.length,
            itemBuilder: (BuildContext context, int index) {
              var vm = viewModel.items.elementAt(index);
              if (vm.isActive) {
                return _buildActiveCard(
                    viewModel: vm, icon: _icons[vm.providerName]);
              } else {
                return _buildLinkableCard(
                    parentViewModel: viewModel,
                    viewModel: vm,
                    icon: _icons[vm.providerName]);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _handleError(error) {
    return Center(child: Text('An error occrued'));
  }

  Widget _handleSnapshot(
      BuildContext context, AsyncSnapshot<ViewModel> snapshot) {
    if (snapshot.hasData) {
      return _handleCompleted(snapshot.data);
    } else if (snapshot.hasError) {
      return _handleError(snapshot.error);
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: PlatformCircularProgressIndicator(),
      );
    }
  }

  Widget _buildPage(AuthService authService) {
    FutureBuilder _loader;
    _loader = FutureBuilder<ViewModel>(
      future: _viewModel.loadItems(authService),
      builder: (BuildContext context, AsyncSnapshot<ViewModel> snapshot) {
        return _handleSnapshot(context, snapshot);
      },
    );
    return _loader;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Accounts'),
      ),
      body: ScopedModelDescendant<AppModel>(
        //rebuildOnChange: false,
        builder: (_, child, model) => Material(
              color: isMaterial ? null : Theme.of(context).cardColor,
              child: _buildPage(model.authService),
            ),
      ),
    );
  }
}
