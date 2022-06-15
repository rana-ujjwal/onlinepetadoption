// ignore_for_file: sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AnimalDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pet;
  const AnimalDetailScreen({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    DateTime petAddedDate = DateTime.fromMillisecondsSinceEpoch(
        pet['pet_added_date'].millisecondsSinceEpoch);
    String formattedDate = DateFormat('yyyy-MM-dd').format(petAddedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favourites')
            .where('pet_id', isEqualTo: pet['pet_id'])
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            bool inFavourites = snapshot.data!.docs.isNotEmpty;
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: screenHeight * 0.35,
                          child: Image(
                            image: NetworkImage(pet['image']),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22.0,
                            vertical: 30.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  const CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage:
                                        AssetImage('assets/images/me.jpeg'),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '${pet['owner_name']}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              formattedDate,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6.0,
                                        ),
                                        const Text(
                                          'Owner',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                '${pet['desc']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Material(
                              borderRadius: BorderRadius.circular(20.0),
                              elevation: 4.0,
                              color: inFavourites
                                  ? Theme.of(context).errorColor
                                  : Theme.of(context).primaryColor,
                              child: IconButton(
                                onPressed: () {
                                  if (inFavourites) {
                                    for (var doc in snapshot.data!.docs) {
                                      doc.reference.delete();
                                    }
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection('favourites')
                                        .add({
                                      'uid': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'pet_id': pet['pet_id'],
                                      'petname': pet['petname'],
                                      'age': pet['age'],
                                      'gender': pet['gender'],
                                      'type': pet['type'],
                                      'breed': pet['breed'],
                                      'owner_id': pet['owner_id'],
                                      'desc': pet['desc'],
                                      'image': pet['image'],
                                      'owner_name': pet['owner_name'],
                                      'pet_added_date': pet['pet_added_date'],
                                    });
                                  }
                                },
                                icon: Icon(
                                  inFavourites
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 24.0,
                            ),
                            Expanded(
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                elevation: 4.0,
                                color: Theme.of(context).primaryColor,
                                child: MaterialButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('requests')
                                        .add({
                                      'adopter_id': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'adopter_name': FirebaseAuth
                                          .instance.currentUser!.displayName,
                                      'adopter_email': FirebaseAuth
                                          .instance.currentUser!.email,
                                      'owner_id': pet['owner_id'],
                                      'pet_id': pet['pet_id'],
                                      'petname': pet['petname'],
                                      'image': pet['image'],
                                      'owner_name': pet['owner_name'],
                                      'pet_added_date': pet['pet_added_date'],
                                    });

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: Text(
                                                'Adoption request notification has been sent to the owner.'),
                                          );
                                        });
                                  },
                                  child: const Text(
                                    'Adopt',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.06),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 70.0),
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Material(
                    elevation: 6.0,
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pet['petname'],
                                style: TextStyle(
                                  fontSize: 26.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                pet['gender'] == 'Male'
                                    ? FontAwesomeIcons.mars
                                    : FontAwesomeIcons.venus,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${pet['age']} years old',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            pet['breed'],
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      height: 120.0,
                    ),
                  ),
                )
              ],
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
