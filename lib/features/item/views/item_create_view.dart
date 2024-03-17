import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';

class ItemCreateView extends StatelessWidget {
  const ItemCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.title_create_new_item),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          // Todo: ask confirmation if there are unsaved changes
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Theme.of(context).primaryColor),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        context.loc.item_name_and_description_title,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.loc.item_name_and_description_description,
                        style: Theme.of(context).textTheme.labelSmall!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 30,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: InputDecoration(
                          labelText: context.loc.item_name_title,
                          hintText: context.loc.item_name_hint_text,
                          helperText: context.loc.item_name_helper_text,
                          border: OutlineInputBorder(),
                          //border: InputBorder.none
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLength: 500,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        // Set this
                        maxLines: 7,
                        //
                        decoration: InputDecoration(
                          labelText: context.loc.item_description_title,
                          hintText: context.loc.item_description_hint_text,
                          helperText: context.loc.item_description_helper_text,
                          helperMaxLines: 2,
                          border: OutlineInputBorder(),
                          //border: InputBorder.none
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.next_plan_rounded),
                      label: Text(context.loc.next),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
