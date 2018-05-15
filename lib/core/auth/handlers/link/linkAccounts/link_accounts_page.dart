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
    return Card(
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        ListTile(
            leading: Icon(icon),
            title: Text(viewModel.title),
            subtitle:
                (isEmpty(viewModel.subTitle) ? null : Text(viewModel.subTitle)),
            trailing: Text('Active', style: theme.textTheme.body2))
      ]),
    );
  }

  Widget _buildLinkableCard({ViewModelItem viewModel, IconData icon}) {
    switch (viewModel.providerName) {
      case 'password':
        return LinkCard(
            icon: email.providerIcon,
            title: viewModel.title,
            subTitle: viewModel.subTitle,
            linkAction: (context) async => await openDialog(
                context: context,
                builder: (_) =>
                    email.LinkEmailAccount(viewModel.linkableProvider)));
      case 'google':
        return LinkCard(
          icon: google.providerIcon,
          title: viewModel.title,
          subTitle: viewModel.subTitle,
          linkAction: (_) => viewModel.linkableProvider.linkAccount({}),
        );
    }
    return Container();
  }

  Widget _handleCompleted(ViewModel viewModel) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Access the same data with multiple accounts.'),
        ),
        Expanded(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          //itemExtent: 20.0,
          itemCount: viewModel.items.length,
          itemBuilder: (BuildContext context, int index) {
            var vm = viewModel.items.elementAt(index);
            if (vm.isActive) {
              return _buildActiveCard(
                  viewModel: vm, icon: _icons[vm.providerName]);
            } else {
              return _buildLinkableCard(
                  viewModel: vm, icon: _icons[vm.providerName]);
            }
          },
        )),
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
        child: CircularProgressIndicator(),
      );
    }
  }

  //FutureBuilder _loader;
  Widget _buildPage(AuthService authService) {
    print('BUILD Link accounts');

    FutureBuilder _loader;
    _loader = FutureBuilder<ViewModel>(
        future: _viewModel.loadItems(authService),
        builder: (BuildContext context, AsyncSnapshot<ViewModel> snapshot) {
          return _handleSnapshot(context, snapshot);
        });
    return _loader;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Accounts'),
      ),
      body: ScopedModelDescendant<AppModel>(
        rebuildOnChange: false,
        builder: (_, child, model) => SafeArea(
              child: Material(
                color: isMaterial ? null : Theme.of(context).cardColor,
                child: _buildPage(model.authService),
              ),
            ),
      ),
    );
  }
}
