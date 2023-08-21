import 'package:flutter/material.dart';
import 'package:nbsms/api/api_service.dart';

class PersonalContactsDropdown extends StatefulWidget {
  final List<Contactt> personalContacts;
  final List<Contactt> selectedContacts;
  final ValueChanged<List<Contactt>> onChanged;

  const PersonalContactsDropdown({
    super.key,
    required this.personalContacts,
    required this.selectedContacts,
    required this.onChanged,
  });

  @override
  _PersonalContactsDropdownState createState() =>
      _PersonalContactsDropdownState();
}

class _PersonalContactsDropdownState extends State<PersonalContactsDropdown> {
  bool showContacts = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Contacts"),
        if (showContacts)
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.personalContacts.length,
            itemBuilder: (context, index) {
              final contact = widget.personalContacts[index];
              final isSelected = widget.selectedContacts.contains(contact);

              return CheckboxListTile(
                title: Text(contact.name),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (isSelected) {
                      widget.selectedContacts.remove(contact);
                    } else {
                      widget.selectedContacts.add(contact);
                    }
                  });
                },
              );
            },
          ),
        TextButton(
          onPressed: () {
            widget.onChanged(widget.selectedContacts);
            setState(() {
              showContacts =
                  !showContacts; // Toggle visibility of contacts list
            });
          },
          child: Text(showContacts ? "OK" : "Show Selected Contacts"),
        ),
      ],
    );
  }
}
