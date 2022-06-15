import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petadoptionapp/screens/navigation_drawer.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  RequestPageState createState() => RequestPageState();
}

class RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: const Text('My Requests'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .where(
                'owner_id',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List requests = snapshot.data!.docs;
              return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: requests.length,
                  itemBuilder: ((context, index) {
                    return RequestsTile(
                      petID: requests[index]['pet_id'],
                      petName: requests[index]['petname'],
                      image: requests[index]['image'],
                      adopterName: requests[index]['adopter_name'],
                      adopterEmail: requests[index]['adopter_email'],
                    );
                  }),
                  separatorBuilder: (context, index) {
                    return const Divider();
                  });
            }
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }),
    );
  }
}

class RequestsTile extends StatelessWidget {
  final String adopterName, adopterEmail, petID, petName, image;
  const RequestsTile({
    Key? key,
    required this.adopterName,
    required this.adopterEmail,
    required this.petID,
    required this.petName,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: Colors.orange,
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.contain,
          ),
        ),
      ),
      enabled: true,
      title: Text(
        "$petName ($petID)",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
          "$adopterName ($adopterEmail) has requested to adopt your beautiful pet $petName"),
    );
  }
}
