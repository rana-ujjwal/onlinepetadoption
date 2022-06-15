import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petadoptionapp/screens/navigation_drawer.dart';
import '../screens/animal_detail_screen.dart';

class AdoptionScreen extends StatefulWidget {
  const AdoptionScreen({Key? key}) : super(key: key);

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  int selectedAnimalIconIndex = 0;

  List<String> animalTypes = [
    'All',
    'Cat',
    'Dog',
    'Bird',
    'Fish',
  ];

  List<IconData> animalIcons = [
    FontAwesomeIcons.alignLeft,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.dove,
    FontAwesomeIcons.fish,
  ];

  String? searchTerm;

  Widget buildAnimalIcon(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                selectedAnimalIconIndex = index;
              });
            },
            child: Material(
              color: selectedAnimalIconIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              elevation: 8.0,
              borderRadius: BorderRadius.circular(20.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  animalIcons[index],
                  size: 30.0,
                  color: selectedAnimalIconIndex == index
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            animalTypes[index],
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Location',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
              ),
            ),
            Row(
              children: <Widget>[
                const Icon(
                  FontAwesomeIcons.locationDot,
                  color: Colors.red,
                ),
                Text(
                  'Kathmandu, ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'Nepal',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/me.jpeg'),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).primaryColor.withOpacity(0.06),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 22.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: 'Search pets to adopt',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchTerm = value;
                                });
                              },
                            ),
                          ),
                          Icon(FontAwesomeIcons.magnifyingGlass),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 8.0,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: animalTypes.length,
                      itemBuilder: (context, index) {
                        return buildAnimalIcon(index);
                      },
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('pets')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            var pets = snapshot.data!.docs;
                            return ListView.builder(
                              padding: const EdgeInsets.only(top: 10.0),
                              itemCount: pets.length,
                              itemBuilder: ((context, index) {
                                if (searchTerm == null ||
                                    pets[index]['petname']
                                        .toLowerCase()
                                        .contains(searchTerm!.toLowerCase())) {
                                  if (animalTypes[selectedAnimalIconIndex] ==
                                          'All' ||
                                      pets[index]['type'] ==
                                          animalTypes[
                                              selectedAnimalIconIndex]) {
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
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            elevation: 4.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 20.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: deviceWidth * 0.4,
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .white,
                                                              ),
                                                              child: Text(
                                                                pets[index]
                                                                    ['petname'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      22.0,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          AnimalDetailScreen(
                                                                              pet: {
                                                                                'pet_id': pets[index].id,
                                                                                'petname': pets[index]['petname'],
                                                                                'breed': pets[index]['breed'],
                                                                                'desc': pets[index]['desc'],
                                                                                'age': pets[index]['age'],
                                                                                'image': pets[index]['image'],
                                                                                'owner_id': pets[index]['owner_id'],
                                                                                'gender': pets[index]['gender'],
                                                                                'type': pets[index]['type'],
                                                                                'owner_name': pets[index]['owner_name'],
                                                                                'pet_added_date': pets[index]['pet_added_date'],
                                                                              })),
                                                                );
                                                              },
                                                            ),
                                                            Icon(
                                                              pets[index]['gender'] ==
                                                                      'Male'
                                                                  ? FontAwesomeIcons
                                                                      .mars
                                                                  : FontAwesomeIcons
                                                                      .venus,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Text(
                                                          pets[index]['breed'],
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Text(
                                                          "${pets[index]['age']} years old",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                                pets[index]
                                                                    ['desc'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                height: 200.0,
                                                width: deviceWidth * 0.4,
                                              ),
                                              Image(
                                                image: NetworkImage(
                                                    pets[index]['image']),
                                                height: 220.0,
                                                fit: BoxFit.fitHeight,
                                                width: deviceWidth * 0.4,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                                return Container();
                              }),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
