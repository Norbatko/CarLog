import 'package:car_log/model/user.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/base/builders/stream_custom_builder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class UserDropdown extends StatelessWidget {
  final Stream<List<User>> userStream;
  final ValueChanged<User?> onUserSelected;
  final dropDownKey = GlobalKey<DropdownSearchState>();
  final _userService = get<UserService>();

  UserDropdown(
      {super.key, required this.userStream, required this.onUserSelected});

  @override
  Widget build(BuildContext context) {
    return StreamCustomBuilder<List<User>>(
      stream: userStream,
      builder: (context, users) {
        return DropdownSearch<User>(
          key: dropDownKey,
          items: (filter, infiniteScrollProps) => users.toList(),
          itemAsString: (item) => item.login,
          compareFn: (item, selectedItem) => item.id == selectedItem.id,
          selectedItem: _userService.currentUser,
          filterFn: (user, filter) {
            return user.login.toLowerCase().contains(filter.toLowerCase()) ||
                user.email.toLowerCase().contains(filter.toLowerCase());
          },
          onChanged: onUserSelected,
          dropdownBuilder: (context, selectedItem) {
            if (selectedItem == null) {
              return SizedBox.shrink();
            }

            return ListTile(
              leading: Icon(
                Icons.person, // Replace with your desired icon
                color:
                    Theme.of(context).primaryColor, // Optional: set icon color
                size: 36, // Adjust icon size as needed
              ),
              title: Text('Login: ${selectedItem.login}'),
              subtitle: Text('Email: ${selectedItem.email}'),
              visualDensity: VisualDensity.compact,
            );
          },
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: const TextFieldProps(
              decoration: InputDecoration(
                labelText: 'Search User by LOGIN or EMAIL',
                border: OutlineInputBorder(),
              ),
            ),
            showSelectedItems: true,
            itemBuilder: (context, user, isSelected, isDisabled) {
              return ListTile(
                leading: Icon(
                  Icons.person, // Replace with your desired icon
                  color: Theme.of(context)
                      .primaryColor, // Optional: set icon color
                  size: 36, // Adjust icon size as needed
                ),
                title: Text('Login: ${user.login}'),
                subtitle: Text('Email: ${user.email}'),
                enabled: !isDisabled,
              );
            },
          ),
        );
      },
    );
  }
}
