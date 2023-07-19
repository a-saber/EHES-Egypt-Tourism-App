import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:projectt/authontication/login.dart';
import 'package:projectt/component/default_time_picker.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/Booking.dart';
import 'package:projectt/models/PostModel.dart';
import 'package:projectt/models/Tourguide.dart';
import 'package:projectt/models/Users.dart';
import 'package:projectt/models/comments.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:projectt/models/currency_country_model.dart';
import 'package:projectt/screens/chats.dart';
import 'package:projectt/screens/country_currency_screen.dart';
import 'package:projectt/screens/favourite.dart';
import 'package:projectt/screens/homepage.dart';
import 'package:projectt/screens/profile/profile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projectt/screens/search.dart';
import 'package:projectt/authontication/welcomepage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../models/category_model.dart';
import '../models/message_model.dart';
import '../models/plan_model.dart';
import '../network/sharedpreference.dart';
import '../screens/Booking.dart';
import '../screens/places_lists/places_view.dart';
import '../screens/posts/Inquiry.dart';
import '../screens/MyPlan.dart';
import '../screens/endpoint.dart';

class AppCubit extends Cubit<AppStates> {
  Duration? differenceNow;
  String? timeNow;
  AppCubit() : super(initialstate());
  static AppCubit get(context) => BlocProvider.of(context);


  int currentindex = 0;
  void changepage(int index) {
    currentindex = index;
    emit(changePageSuccess());
  }
  bool isshow = true;
  void show() {
    isshow = !isshow;
    emit(visibilitysuccessstate());
  }
  List screens = [HomePage(), Favourite(), Myplan(), Inquiry(), Profile(), Chats(), CountryCurrencyScreen()];


  //     Auth ************
  Users? userModel;
  void makeregister(String name, String email, String password, String phone, context, bool isTourGuide)
  {
    print("hallo");
    emit(registerLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createuser(name, email, phone, value.user!.uid, isTourGuide);
      emit(registerSucessState());
      Navigator.pushNamed(context, 'login');
    }).catchError((e) {
      emit(registerErrorState());
      print(e.toString());
    });
  }
  void makelogin(String email, String password)async
  {
    emit(loginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await CacheHelper.saveData(key: 'token', value: value.user!.uid);
      token = value.user!.uid;

      currentindex = 0;
      await getUserData().then((value) async
      {
        await FirebaseMessaging.instance.getToken().then((fCMToken) async
        {
          print("token cubit $fCMToken");
          await CacheHelper.saveData(key: 'fCMToken',value:  fCMToken);
          userModel!.token = fCMToken;
          await updateUser();

        });
      });
      token = value.user!.uid;
      asGuest = null;
      await CacheHelper.removeData(key: 'asGuest');
      await getTourGuides();
      emit(loginSucessState());
      print(value.user?.uid);
    }).catchError((error) {
      emit(loginErrorState());
      print(error.toString());
    });
  }
  void createuser(String name, String email, String phone, String uid, bool isTourGuide)async
  {
    Users users = Users(
      name: name,
      email: email,
      phone: phone,
      image:
          "https://t4.ftcdn.net/jpg/01/19/32/93/240_F_119329387_sUTbUdeyhk0nuhNw5WaFvOyQFmxeppjX.jpg",
      uid: uid,
      isTourGuide: isTourGuide
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(users.toJson())
        .then((value)async {
      uid = FirebaseAuth.instance.currentUser!.uid;
      emit(createUserSucessState());
      print("sucess");
    }).catchError((error) {
      emit(createUserErrorState());
      print("bbbbbbbbbbbbbbbbbbbbbb");
    });
  }
  Future logout(context) async
  {
    await FirebaseAuth.instance.signOut().then((value) async {
      print(FirebaseAuth.instance.currentUser);

      await CacheHelper.removeData(key: "fCMToken");
      await CacheHelper.removeData(key: "token").then((value) {
        currentindex = 0;
        userModel = null;
        token = null;
        emit(signoutSucessState());
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WelcomePage()));
        print("signoutttttttttttttttttt");
      });
    }).catchError((error) {
      emit(signoutErrorState());
    });
  }

  // UserData **************
  Future getUserData() async
  {
    token = await CacheHelper.getData(key: 'token');
    emit(getUserLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(token)
        .get()
        .then((value) async {
          print("88888888888888");
          print(value.data().toString());
      userModel = Users.fromJson(value.data());
      await getFavouritePlaces();
      log(userModel!.toJson().toString());
      emit(getUserSucessState());
    }).catchError((error) {
      print("This is get user data error : " + error.toString());
      emit(getUserErrorState());
    });
  }
  XFile? profileImage;
  var picker = ImagePicker();
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = pickedFile;
      emit(profileImagePickedSucessState());
    } else {
      print('No image selected');
      emit(profileImagePickedErrorState());
    }
  }
  String? profileImageUrl;
  Future uploadProfile() async {
    print('Before Uploud Image');
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(File(profileImage!.path))
        .then((value) async {
      print('Here Upload Image Successfully');
      await value.ref.getDownloadURL().then((value) {
        //emit(uploadprofileImageSucessState());
        print(value);
        profileImageUrl = value;
        print("mmmmmmmmmmmmmm${profileImageUrl}");
      }).catchError((error) {
        emit(uploadprofileImageErrorState());
      });
    }).catchError((error) {
      emit(uploadprofileImageErrorState());
    });
  }
  Future updateUser({String? name, String? email, String? phone, bool? isTourGuide}) async {
    emit(userUpdateLoadingState());
    Users user = Users(
        name: name??userModel!.name,
        email: email??userModel!.email,
        phone: phone??userModel!.phone,
        uid: userModel!.uid,
        token: userModel!.token,
        image: userModel!.image,
      isTourGuide: isTourGuide??userModel!.isTourGuide
    );
    if (profileImage != null) {
      await uploadProfile().then((value) async {
        user.image = profileImageUrl;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userModel?.uid)
            .update(user.toJson())
            .then((value) async {
          await getUserData();
          await getTourGuides();
        }).catchError((error) {
          emit(userUpdateErrorState());
        });
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel?.uid)
          .update(user.toJson())
          .then((value) async {
        await getUserData();
        await getTourGuides();

      }).catchError((error) {
        emit(userUpdateErrorState());
      });
    }
  }
  List<Users> tourGuides =[];
  Future getTourGuides() async
  {
    tourGuides =[];
    emit(GetTourGuidesLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .where("isTourGuide", isEqualTo: true)
        .get()
        .then((value) async {
          for (var element in value.docs)
          {
            tourGuides.add(Users.fromJson(element.data()));
          }
      emit(GetTourGuidesSucessState());
    }).catchError((error) {
      print("This is get Tour Guides Data error : " + error.toString());
      emit(GetTourGuidesErrorState());
    });
  }

  //      Get Places***************
  List<String> groupsNames = [
    "religious",
    "historical",
    "touristLandmark",
    "cultural"
  ];
  List<PlaceModel> religiousPlaces = [];
  List<PlaceModel> touristLandmarks = [];
  List<PlaceModel> culturalPlaces = [];
  List<PlaceModel> historicalPlaces = [];
  Future getAllPlaces() async {
    religiousPlaces = [];
    touristLandmarks = [];
    culturalPlaces = [];
    historicalPlaces = [];
    for (var category in groupsNames) {
      await FirebaseFirestore.instance
          .collection('places')
          .where("category", isEqualTo: category)
          .orderBy('rate', descending: true)
          .get()
          .then((value) {
        for (var element in value.docs) {
          if (category == groupsNames[0]) {
            religiousPlaces.add(PlaceModel.fromJson(element.data()));
          } else if (category == groupsNames[1]) {
            historicalPlaces.add(PlaceModel.fromJson(element.data()));
          } else if (category == groupsNames[2]) {
            touristLandmarks.add(PlaceModel.fromJson(element.data()));
          } else {
            culturalPlaces.add(PlaceModel.fromJson(element.data()));
          }
        }
        emit(GetALLPlacesSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(GetALLPlacesErrorState());
      });
    }
  }
  List<PlaceModel> topRated = [];
  Future getTopRatedPlaces() async {
      await FirebaseFirestore.instance
          .collection('places')
          .orderBy('rate', descending: true)
          .limit(10)
          .get()
          .then((value) {
        topRated = [];
        for (var element in value.docs) {
            topRated.add(PlaceModel.fromJson(element.data()));
        }
        emit(GetTopRatedSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(GetTopRatedErrorState());
      });

  }

  // Favourite  ***********
  List<PlaceModel> favouritePlaces = [];
  List<String> favouritePlacesId = [];
  void addToFavourite(context, String placeId) async
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(token)
        .collection('Favourite')
        .doc(placeId)
        .set({"favourite": true}).then((value) async {
      await getFavouritePlaces();
      emit(favouriteSuccessState());
      Fluttertoast.showToast(
          msg: "Added to wishlist",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          backgroundColor: Colors.purple,
          fontSize: 16);
    }).catchError((error) {
      emit(favouriteErrorState());
    });
  }
  Future getFavouritePlaces() async
  {
    favouritePlaces = [];
    favouritePlacesId = [];
    emit(getFavouritePlacesLoadingState());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(token)
        .collection("Favourite")
        .get()
        .then((value) async {
      for (var element in value.docs) {
        await FirebaseFirestore.instance
            .collection('places')
            .doc(element.id)
            .get()
            .then((value) {
          favouritePlacesId.add(value.data()!["id"]);
          favouritePlaces.add(PlaceModel.fromJson(value.data()!));
        }).catchError((error) {
          print(error.toString());
          emit(GetALLPlacesErrorState());
        });
      }
      emit(getFavouritePlacesSucessState());
    }).catchError((error) {
      emit(getFavouritePlacesErrorState());
      print(error.toString());
    });
  }
  void deleteFromFavourite({required context, required String placeId, int? index}) async
  {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(token)
        .collection("Favourite")
        .doc(placeId)
        .delete()
        .then((value) async {
          if (index == null) {
            await getFavouritePlaces();
          }
          else {
            favouritePlaces.removeAt(index);
            favouritePlacesId.removeAt(index);
          }
      emit(DeleteSuccessState());
      Fluttertoast.showToast(
          msg: "Remove from wishlist",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.purple);
    }).catchError((error) {});
  }


  //      search ***************
  List<PlaceModel> placesSearch = [];
  Future secondSearch(String name) async {
    await FirebaseFirestore.instance
        .collection('places')
        .orderBy("rate", descending: true)
        .get()
        .then((value) {
      placesSearch = [];
      for (var element in value.docs) {
        if (element
                .data()["name"]
                .toString()
                .toLowerCase()
                .trim()
                .contains(name) ||
            name.contains(
                element.data()["name"].toString().toLowerCase().trim())) {
          placesSearch.add(PlaceModel.fromJson(element.data()));
        }
      }
      print("******************");
      print(placesSearch.length);
      for (var element in placesSearch) {
        print(element.id);
      }
    }).catchError((error) {
      print(error.toString());
    });
  }
  Future firstSearch(String name) async {
    placesSearch = [];
    await FirebaseFirestore.instance
        .collection('places')
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: "$name\uf8ff")
        .get()
        .then((value) {
      for (var element in value.docs) {
        placesSearch.add(PlaceModel.fromJson(element.data()));
      }
    }).catchError((error) {
      print(error.toString());
    });
  }
  void search(String text) async {
    emit(getSearchedPlacesLoadingState());
    if (text.toLowerCase().trim().isNotEmpty) {
      print("#########");
      print(text);
      secondSearch(text.toLowerCase().trim()).then((value) {
        print(placesSearch.length);
        if (placesSearch.isNotEmpty) {
          emit(getSearchedPlacesSucessState());
        } else {
          placesSearch = [];
          emit(getSearchedPlacesErrorState());
        }
      });
    } else {
      placesSearch = [];
      emit(getSearchedPlacesErrorState());
    }
  }

  //    Rating **********
  double? newRateValue;
  void updatePlaceRate(PlaceModel placeModel) {
    emit(PlaceUpdateLoadingState());
    FirebaseFirestore.instance
        .collection('places')
        .doc(placeModel.id)
        .update(placeModel.toJson())
        .then((value) async{
          await getTopRatedPlaces();
      emit(PlaceUpdateSuccessState());
      getAllPlaces();
    }).catchError((error) {
      print(error.toString());
      emit(PlaceUpdateErrorState());
    });
  }

  //  Posts ******************
  File? postImage;
  Future<void> getPostImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(PostImagePickedErrorState());
    }
  }
  void removePostImage()
  {
    postImage = null;
    emit(RemovePostImageState());
  }
  void uploadPostImage({required String dateTime, required String text })
  {
    emit(createPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          text: text,
          datetime: dateTime,
          postimage: value,
        );
      }).catchError((error) {
        emit(UserCreatePostSuccessState());
      });
    }).catchError((error) {
      emit(UserCreatePostErrorState());
    });
  }
  void createPost({required String text, String? postimage, required String datetime})
  {
    emit(createPostLoadingState());
    log(userModel!.toJson().toString());
    Postmodel postmodel = Postmodel(
        uid: userModel?.uid,
        datetime: datetime,
        text: text,
        postimage: postimage);
    FirebaseFirestore.instance
        .collection('posts')
        .add(postmodel.tojson())
        .then((value) async {
      emit(createPostSucessState());
    }).catchError((error) {
      emit(createPostErrorState());
      print(error.toString());
    });
  }
  List<Postmodel> homePosts = [];
  void createComment(String text, String datetime, String postId, int postIndex) async
  {
    emit(createCommentLoadingState());
    Commentmodel commentss = Commentmodel(text: text, datetime: datetime, uId: userModel!.uid);
    final collectionRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection("comments");
    final newDocRef = collectionRef.doc();
    commentss.commentId = newDocRef.id;
    await newDocRef.set(commentss.tomap()).then((value) async {
      // emit(createCommentSucessState());
    }).catchError((error) {
      emit(createCommentErrorState());
      print(error.toString());
    });
  }
  void likepost(int postIndex)
  {
    if (homePosts[postIndex].likes.contains(userModel!.uid)) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(homePosts[postIndex].postId)
          .collection('likes')
          .doc(userModel!.uid)
          .delete()
          .then((value) {
        emit(makeLikePostSuccessState());
      }).catchError((error) {
        emit(makeLikePostErrorState());
        print(error.toString());
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(homePosts[postIndex].postId)
          .collection('likes')
          .doc(userModel!.uid)
          .set({'like': true}).then((value) {
        emit(makeLikePostSuccessState());
      }).catchError((error) {
        emit(makeLikePostErrorState());
        print(error.toString());
      });
    }
  }

  //  messages **************
  void sendMessage({
    required String receiverId,
    String? text,
    String? image,
    required String dateTime,
  })async {
    MessageModel model = MessageModel(
      text: text ?? "",
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel!.uid,
    );
    final collectionRef =  FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("message");
    model.messageId = collectionRef.doc().id;
    collectionRef.
        doc(model.messageId)
        .set(model.toMap())
        .then((value) async{
     await FirebaseFirestore.instance
          .collection("users")
          .doc(userModel!.uid)
          .collection("chats")
          .doc(receiverId)
          .set(model.toMap());
    }).catchError((error) {
      print("send message error:- ${error.toString()}");
      emit(SendErrorMesState(error));
    });

   await  FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(userModel!.uid)
        .collection("message")
        .doc(model.messageId)
        .set(model.toMap())
        .then((value) async{
     await FirebaseFirestore.instance
         .collection("users")
         .doc(receiverId)
         .collection("chats")
         .doc(userModel!.uid)
         .set(model.toMap());
    }).catchError((error) {
      print("send message error:- ${error.toString()}");
      emit(SendErrorMesState(error));
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("message")
        .orderBy("dateTime")
        .snapshots()
        .listen((event) {
      messages = [];
     // print(event.docs[0].data());
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(GetSuccessMesState());
    });
  }

  List<Users> chats = [];
  List<Users> chats2 = [];
  List<Users> searchFriendsList = [];
  void searchFriends(String search)
  {
    searchFriendsList =[];
    emit(SearchFriendsLoadingState());
    for (var element in chats2)
    {
      if(element.name!.toLowerCase().trim().contains(search.toLowerCase().trim())||search.toLowerCase().trim().contains(element.name!.toLowerCase().trim()))
      {
        searchFriendsList.add(element);
      }
    }
    emit(SearchFriendsSuccessState());
  }
  Future getChats() async
  {
    FirebaseFirestore.instance
        .collection("users")
        .doc(token)
        .collection("chats")
        .get()
        .then((event) async{
      chats2 = [];
          for (var user in event.docs)
          {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.id).get().then((userData)
                {
                  Users chatFriend = Users.fromJson(userData.data());
                  chatFriend.lastMessage = MessageModel.fromJson(user.data());
                  chats2.add(chatFriend);
                });
          }
          emit(GetSuccessChatState());

        });
  }



//  Plans ****************
  List<PlanModel> newPlans=[];
  List<PlanModel> donePlans=[];
  List<PlanModel> archivedPlans=[];
  int currentPlanIndex=0;
  void planOnTap(int index)
  {
    currentPlanIndex = index;
    emit(PlanChangeIndexState());
  }
  Future getPlans() async
  {
    emit(GetPlansLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(token)
        .collection("plans")
        .orderBy("date")
    .orderBy("time")
        .get()
        .then((value) async {
          newPlans=[];
          donePlans=[];
          archivedPlans=[];
          for (var element in value.docs)
          {
            PlanModel plan = PlanModel.fromJson(element.data());
            if(plan.status == "new")
            {
              newPlans.add(plan);
            }
            else if (plan.status == "done")
            {
              donePlans.add(plan);
            }
            else
            {
              archivedPlans.add(plan);
            }
          }
          emit(GetPlansSuccessState());
        });
  }
  void addToPlan(PlanModel plan, PlaceModel place,context) async {
    emit(bookLoadingState());
    final collectionRef = FirebaseFirestore.instance
        .collection("users")
        .doc(token)
        .collection("plans");
    plan.id = collectionRef.doc().id;
    await collectionRef
        .doc(plan.id)
        .set(plan.toJson())
        .then((value)async {
      await getPlans();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Added To Plan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 10,
      ));


      DateTime userChosen = DateTime(dateTime!.year, dateTime!.month,dateTime!.day,timeOfDay!.hour,timeOfDay!.minute );
      Duration diff = userChosen.difference(DateTime.now());
      print("diff is    ${diff.toString()}");
      var date = DateTime.now().add(diff);
      print("date is    ${date.toString()}");

      await api.showScheduledNotification(
          scheduledDate:  date,
         // id: date.minute+date.hour+date.second+date.microsecond,
          //id:0,
          title: place.name ,
          body: "",
          image:place.image
      );
      print("suceeeeessssssssssssssssssss");
      emit(bookSucessState());
    }).catchError((error) {
      emit(bookErrorState());
    });
  }
  void updatePlan(PlanModel plan,context) async {
    emit(UpdateLoadingState());
   FirebaseFirestore.instance
        .collection("users")
        .doc(token)
        .collection("plans")
        .doc(plan.id)
        .update(plan.toJson())
        .then((value)async {
      await getPlans();
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text(
          "Moved To ${plan.status} Plans",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 10,
      ));
      print("suceeeeessssssssssssssssssss");
      emit(UpdateSuccessState());
    }).catchError((error) {
      emit(UpdateErrorState());
    });
  }
  Future deletePlan(PlanModel plan,context) async {
    emit(UpdateLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(token)
        .collection("plans")
        .doc(plan.id)
        .delete()
        .then((value)async {
      await getPlans();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Deleted Success",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 10,
      ));
      print("suceeeeessssssssssssssssssss");
      emit(DeletePlanSuccessState());
    }).catchError((error) {
      emit(UpdateErrorState());
    });
  }


  //  Currency  **********

  Future<double> getExchangeRate(String countryCurrencyCode) async {
    String url = 'https://openexchangerates.org/api/latest.json?app_id=a3b924f60d564340ba6f6f95bfcf8f53';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      double exchangeRate = data['rates']['EGP'] / data['rates'][countryCurrencyCode];
      return exchangeRate;
    } else {
      throw Exception('Failed to retrieve exchange rate');
    }
  }
  // a3b924f60d564340ba6f6f95bfcf8f53
  var moneyController = TextEditingController();
  double? convertedAmount;
  List<CountryCurrencyModel> countriesCurrencies=[];
  Future getCountries() async {
    emit(GetCountriesCurrenciesLoadingState());
    String url = 'https://openexchangerates.org/api/currencies.json';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      countriesCurrencies =[];
      for(int i=0; i<data.keys.length;i++)
      {
        countriesCurrencies.add(
            CountryCurrencyModel(
            countryCode: data.keys.elementAt(i) ,
            countryName: data.values.elementAt(i)
            )
        );
      }
      print(countriesCurrencies.length);
      emit(GetCountriesCurrenciesSuccessState());

    }
    else {
      emit(GetCountriesCurrenciesErrorState());
      throw Exception('Failed to retrieve exchange rate');
    }
  }
  Future convertCurrency(String amountDouble, String countryCurrencyCode) async {
    double amount = double.parse(amountDouble);
    emit(ConvertCurrenciesLoadingState());
    double exchangeRate = await getExchangeRate(countryCurrencyCode);
     convertedAmount = amount * exchangeRate;
     if(convertedAmount != null) {
       emit(ConvertCurrenciesSuccessState());
     } else {
       emit(ConvertCurrenciesErrorState());
     }

  }

  List<CountryCurrencyModel> countriesCurrenciesSearch = [];
  void searchCurrencies(String search)
  {
    countriesCurrenciesSearch =[];
    emit(SearchCurrenciesLoadingState());
    for (var element in countriesCurrencies)
    {
      if(element.countryName!.toLowerCase().trim().contains(search.toLowerCase().trim())||search.toLowerCase().trim().contains(element.countryName!.toLowerCase().trim()))
      {
        countriesCurrenciesSearch.add(element);
      }
    }
    emit(SearchCurrenciesSuccessState());
  }

  void sendMessageWhatsApp(PlaceModel model) async{
    String phoneNumber = '+201003465232';
    for(int i=0;i<2;i++)
    {
      String message = "Hi I'm ${userModel!
          .name}\nthis is my ID: $token\ni wanna book a ticket for ${model
          .name}\nhere is place details:\nplace ID : ${model.id}";
      String url = 'whatsapp://send?phone=$phoneNumber&text=$message';
      if (await canLaunchUrl(Uri.parse(url))
      ) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
      phoneNumber = '+201119032987';
    }
  }


  TextEditingController emailcontroller = TextEditingController();

  void resetpassword(context) {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailcontroller.text.trim())
        .then((value) {
      emit(resetPasswordSuccessState());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password Reset Email Sent")));
      Navigator.pushNamed(context, "login");
    }).catchError((e) {
      emit(resetPasswordErrorState());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.toString()}")));
      Navigator.pop(context);
    });
  }


}

