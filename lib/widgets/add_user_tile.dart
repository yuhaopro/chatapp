import 'package:chatapp/models/group_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddUserTile extends StatefulWidget {
  const AddUserTile({Key? key, required this.searchResults}) : super(key: key);
  final Stream<QuerySnapshot>? searchResults;

  @override
  State<AddUserTile> createState() => _AddUserTileState();
}

class _AddUserTileState extends State<AddUserTile> {
  final double _iconSize = 24;
  final Color _iconColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    final groupData = context.watch<GroupData>();
    return Column(
      children: [
        groupData.getUsernames.isEmpty
            ? Container()
            : Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 3,
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // If list is null, print 1 item which is No Users Added
                  // If list is not null, print the usernames in the list as ListTiles
                  itemCount: groupData.getUsernames.length,
                  itemBuilder: (BuildContext context, int index) {
                    String currentUsername =
                        groupData.getUsernames[index];
                    return Container(
                      width: MediaQuery.of(context).size.height * 0.175,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          right: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentUsername,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Nunito'),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              String username = groupData.getUsernames[index];
                              groupData.removeMember(username);
                            },
                            child: Icon(
                              Icons.cancel,
                              size: _iconSize,
                              color: _iconColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        Expanded(
          child: StreamBuilder(
            stream: widget.searchResults,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // checks if the query is either not ready, or the collection has no documents.
              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty ||
                  widget.searchResults == null) {
                return const Center(
                  child: Text(
                    "No users found",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String username =
                        snapshot.data!.docs[index].get("username");
                    // Filter out usernames already in groupData
                    if (groupData.getUsernames.contains(username)) {
                      return const SizedBox.shrink(); // Return an empty widget
                    }
                    return ListTile(
                      title: Text(username),
                      onTap: () {
                          //add username to the top of the bar
                          setState(() {
                            if (!groupData.getUsernames.contains(username)) {
                              groupData.addMember(username);
                            }
                            // remove username from the search pile

                        });
                      },
                    );
                  });
            },
          ),
        ),
      ],
    );
  }
}
