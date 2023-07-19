 import '../models/PlaceModel.dart';
import '../models/PostModel.dart';

abstract class AppStates{}
 class initialstate extends AppStates{}
 class changePageSuccess extends AppStates{}
 class isFavouriteSuccessState extends AppStates{}
 class registerLoadingState extends AppStates{}
 class registerSucessState extends AppStates{}
 class registerErrorState extends AppStates{}
 class loginLoadingState extends AppStates{}
 class loginSucessState extends AppStates{}
 class loginErrorState extends AppStates{}
 class visibilitysuccessstate extends AppStates{}
 class createUserLoadingState extends AppStates{}
 class createUserSucessState extends AppStates{}
 class DeleteSuccessState extends AppStates{}
 class createUserErrorState extends AppStates{}
 class getUserLoadingState extends AppStates{}
 class getUserSucessState extends AppStates{}
 class getUserErrorState extends AppStates{}
 class GetTourGuidesLoadingState extends AppStates{}
 class SendSuccessMesState extends AppStates {}
 class SearchFriendsLoadingState extends AppStates {}
 class SearchFriendsSuccessState extends AppStates {}
 class GetSuccessMesState extends AppStates {}
 class GetSuccessChatState extends AppStates {}
 class GetPlansLoadingState extends AppStates {}
 class GetPlansSuccessState extends AppStates {}
 class SendErrorMesState extends AppStates {
  final error;

  SendErrorMesState(this.error);
 }
 class GetTourGuidesSucessState extends AppStates{}
 class GetTourGuidesErrorState extends AppStates{}
 class getHistoricalPlaceLoadingState extends AppStates{}
 class getHistoricalPlaceSucessState extends AppStates{}
 class getHistoricalPlaceErrorState extends AppStates{}
 class getALLHistoricalPlacesSucessState extends AppStates{}
 class GetALLPlacesSuccessState extends AppStates{}
 class GetTopRatedSuccessState extends AppStates{}
 class GetALLPlacesErrorState extends AppStates{}
 class GetTopRatedErrorState extends AppStates{}
 class getALLHistoricalPlacesErrorState extends AppStates{}
 class getALLReligiousSitesSucessState extends AppStates{}
 class getALLReligiousSiteErrorState extends AppStates{}
 class getALLTouristLandmarkSucessState extends AppStates{}
 class getALLTouristLandmarkErrorState extends AppStates{}
 class getALLCulturalplacesSucessState extends AppStates{}
 class getALLCulturalplacesErrorState extends AppStates{}
 class changeStarSucessState extends AppStates{}
 class profileImagePickedSucessState extends AppStates{}
 class profileImagePickedErrorState extends AppStates{}
 class coverImagePickedSucessState extends AppStates{}
 class coverImagePickedErrorState extends AppStates{}
 class uploadprofileImageSucessState extends AppStates{}
 class uploadprofileImageErrorState extends AppStates{}
 class uploadcoverImageSucessState extends AppStates{}
 class uploadcoverImageErrorState extends AppStates{}
 class userUpdateErrorState extends AppStates{}
 class userUpdateLoadingState extends AppStates{}
 class userUpdateSuccessState extends AppStates{}
 class PlaceUpdateSuccessState extends AppStates{}
 class PlaceUpdateLoadingState extends AppStates{}
 class PlaceUpdateErrorState extends AppStates{}
 class signoutSucessState extends AppStates{}
 class signoutErrorState extends AppStates{}
 class bookLoadingState extends AppStates{}
 class bookSucessState extends AppStates{}
 class bookErrorState extends AppStates{}
 class UpdateLoadingState extends AppStates{}
 class UpdateSuccessState extends AppStates{}
 class DeletePlanSuccessState extends AppStates{}
 class UpdateErrorState extends AppStates{}
 class locationSuccessState extends AppStates{}
 class favouriteSuccessState extends AppStates{}
 class favouriteErrorState extends AppStates{}
 class resetPasswordSuccessState extends AppStates{}
 class resetPasswordErrorState extends AppStates{}
 class getSearchedPlacesSucessState extends AppStates {}
 class getSearchedPlacesLoadingState extends AppStates{}
 class getSearchedPlacesErrorState extends AppStates{}
 class getOrderedPlacesSucessState extends AppStates{}
 class getOrderedPlacesErrorState extends AppStates{}
 class createPostLoadingState extends AppStates{}
 class createPostSucessState extends AppStates{}
 class createPostErrorState extends AppStates{}
 class PostImagePickedSuccessState extends AppStates{}
 class PostImagePickedErrorState extends AppStates{}
 class RemovePostImageState extends AppStates{}
 class UserCreatePostLoadingState extends AppStates{}
 class UserCreatePostSuccessState extends AppStates{}
 class UserCreatePostErrorState extends AppStates{}
 class getPostLoadingState extends AppStates{}
 class changeFavouriteColorState extends AppStates{}
 class getPostStremSuccessState extends AppStates{}
 class getPostSuccessState extends AppStates
 {
  List<Postmodel>? posts ;

  getPostSuccessState(this.posts);
}
 class getPostErrorState extends AppStates{}
 class createCommentLoadingState extends AppStates{}
 class createCommentSucessState extends AppStates{}
 class createCommentErrorState extends AppStates{}
 class getCommentLoadingState extends AppStates{}
 class getCommentSuccessState extends AppStates{}
 class getCommentErrorState extends AppStates{}
 class removeFavouriteSuccessState extends AppStates{}
 class removeFavouriteErrorState extends AppStates{}
 class makeLikePostSuccessState extends AppStates{}
 class makeLikePostErrorState extends AppStates{}
 class getDataTourGuideLoadingState extends AppStates{}
 class getDataTourGuideSuccessState extends AppStates{}
 class getDataTourGuideErrorState extends AppStates{}
 class getFavouritePlacesLoadingState extends AppStates{}
 class getFavouritePlacesSucessState extends AppStates{}
 class getFavouritePlacesErrorState extends AppStates{}


class GetCountriesCurrenciesLoadingState extends AppStates{}
class GetCountriesCurrenciesSuccessState extends AppStates{}
class GetCountriesCurrenciesErrorState extends AppStates{}

class ConvertCurrenciesLoadingState extends AppStates{}
class ConvertCurrenciesSuccessState extends AppStates{}
class ConvertCurrenciesErrorState extends AppStates{}

 class SearchCurrenciesLoadingState extends AppStates{}
 class SearchCurrenciesSuccessState extends AppStates{}

 class PlanChangeIndexState extends AppStates{}





