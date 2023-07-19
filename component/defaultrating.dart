import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PlaceModel.dart';
class DefaultRating extends StatelessWidget {
  const DefaultRating({Key? key, required this.rate, this.readOnly = true, this.placeModel}) : super(key: key);
  final double rate;
  final bool readOnly;
  final PlaceModel? placeModel;

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        return RatingBar(
          ignoreGestures: readOnly,
          tapOnlyMode: readOnly,
            direction: Axis.horizontal,
            allowHalfRating: true,
            glowColor: Colors.white,
            updateOnDrag: !readOnly,
            initialRating: rate,
            itemSize: readOnly ? 20:30,
            itemCount:5,
            ratingWidget: RatingWidget(
                full: const Icon(Icons.star,
                    color: Colors.amber),
                half: const Icon(
                  Icons.star_half,
                  color: Colors.amber,
                ),
                empty: const Icon(
                  Icons.star_outline,
                  color: Colors.grey,
                )),
            onRatingUpdate: (value)
            {
              if (!readOnly)
              {
                AppCubit.get(context).newRateValue = value;
              }
            });
      },

    );
  }
}
