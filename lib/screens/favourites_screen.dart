import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petadoptionapp/screens/animal_detail_screen.dart';
import 'package:petadoptionapp/screens/navigation_drawer.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Favourites'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favourites')
            .where(
              'uid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List favourites = snapshot.data!.docs;
            return ListView.builder(
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 28.0,
                    right: 20.0,
                    left: 20.0,
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.circular(20.0),
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                width: deviceWidth * 0.4,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                          ),
                                          child: Text(
                                            favourites[index]['petname'],
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnimalDetailScreen(pet: {
                                                        'pet_id':
                                                            favourites[index]
                                                                ['pet_id'],
                                                        'petname':
                                                            favourites[index]
                                                                ['petname'],
                                                        'breed':
                                                            favourites[index]
                                                                ['breed'],
                                                        'desc':
                                                            favourites[index]
                                                                ['desc'],
                                                        'age': favourites[index]
                                                            ['age'],
                                                        'image':
                                                            favourites[index]
                                                                ['image'],
                                                        'gender':
                                                            favourites[index]
                                                                ['gender'],
                                                        'type':
                                                            favourites[index]
                                                                ['type'],
                                                        'owner_name':
                                                            favourites[index]
                                                                ['owner_name'],
                                                        'pet_added_date':
                                                            favourites[index][
                                                                'pet_added_date'],
                                                      })),
                                            );
                                          },
                                        ),
                                        Icon(
                                          favourites[index]['gender'] == 'Male'
                                              ? FontAwesomeIcons.mars
                                              : FontAwesomeIcons.venus,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      favourites[index]['breed'],
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "${favourites[index]['age']} years old",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 140,
                                          child: Text(
                                            favourites[index]['desc'],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            height: 200.0,
                            width: deviceWidth * 0.4,
                          ),
                          Image(
                            image: NetworkImage(favourites[index]['image']),
                            height: 220.0,
                            fit: BoxFit.fitHeight,
                            width: deviceWidth * 0.4,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }),
      ),
    );
  }
}
