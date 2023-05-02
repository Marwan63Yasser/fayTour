//This file is for viewing the details of the hotel if you click its card on
//the area page (descScreen.dart)

import 'package:faytour/Widgets/BottomBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:faytour/Widgets/RatingStarsBar.dart';

 class HOTEL extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser!; 
  final _textFieldController = TextEditingController(); 

  String ro;
  HOTEL({Key? key, required this.ro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("hotels").where("name",isEqualTo: ro).snapshots(),
      builder: ((context, snapshot) {
        return Container(
      height: MediaQuery.of(context).size.height/1.49,
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  decoration:  BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
      child: ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder:(context, index) {
          Padding(
            padding: const EdgeInsets.only(),
            child: Column(
                                        children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(margin: const EdgeInsets.all(10),child: Text(ro,
                                style: GoogleFonts.rye(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary),),)),
          
                               Align(
                                 alignment: Alignment.center,
                                 child: Container(margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),child: Text(snapshot.data?.docs[index]["desc"],
                                 style: GoogleFonts.merriweather(fontSize: 18,color: Theme.of(context).colorScheme.onPrimary),),)),
          
          
                              Align(
                                alignment: Alignment.center,
                                child: Container(margin: const EdgeInsets.all(10),child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Rate: ",style: GoogleFonts.rye(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary),),
                                    RatingBar(rating: snapshot.data?.docs[index]["rate"], ratingCount: 25,size: 22,),
                                  ],
                                ),)), 
          
          
          
                              Container(
                              margin: const EdgeInsets.fromLTRB(0,25,0,10),
                              child: SizedBox(
                                height: 55, 
                                width: 260,
                                child: TextButton(
                                  onPressed: (){},
                                  style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 10
                                  ),
                                  child: Text("Reserve!",style: GoogleFonts.rye(color: Theme.of(context).colorScheme.onSecondary,fontSize: 18),),
                                  ),
                              ),
                            ),
          
                            Align(
                                alignment: Alignment.center,
                                child: Container(margin: const EdgeInsets.all(10),child: Text("OR",style: GoogleFonts.merriweather(fontSize: 17,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),),)
                                ),
                              
                            checkFav(ro: ro, name: snapshot.data?.docs[index]["name"], image: snapshot.data?.docs[index]["image"]),
          
          
                            ],
          
              ),
          );
          return null;
        },
      ),
    );
        
        }),
    );
  }
}



class checkFav extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  String ro,name,image;
  checkFav({Key? key, required this.ro,required this.name,required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Favourite').where("Fav",isEqualTo: ro).where("Email",isEqualTo: user.email).snapshots(),
      builder: (context, snapshot) {
        return Container(
                      margin: const EdgeInsets.fromLTRB(0,10,0,30),
                      child: SizedBox(
                        height: 55,
                        width: 260,
                        child: TextButton(
                          onPressed: (){
                            if(snapshot.data!.docs.isEmpty)
                            {
                              FirebaseFirestore.instance.collection("Favourite").add({
                                "Email": user.email,
                                "Fav": name,
                                "image": image,
                                "type": "hotel",});

                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) =>const DefaultTabController(length: 4, child: BottomBar(select: 1,)))), (route) => false);
                            }
                            else
                            {
                                    showDialog(context: context,
                                    barrierDismissible: false, 
                                    builder: (context) {
                                      return AlertDialog(
                                      title: Text("This hotel already exists in the Favourite list!",style: GoogleFonts.merriweather(),),
                                      actions: [
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),), child: Text("Okay",style: GoogleFonts.rye(color: Colors.black),)
                                          ),
                                        )
                                      ],
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    );
                                    }
                                    );
                            }

                      
                          },
                          style: TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 220, 109, 101),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 10
                          ), child: Text("Add to Favourites",style: GoogleFonts.rye(color: Theme.of(context).colorScheme.onSecondary,fontSize: 18),),
                          ),
                      ),
        );
      }
    );
  }
}