class ListModel {
  final String listingId;
  final String userId;
  final List<String> amentities;
  final List<String> buildingAmenities;
  final String arriveAfter;
  final String arriveBefore;
  final String leaveBefore;
  final int basePrice;
  final int bathsCount;
  final int bedroomsCount;
  final int bedsCount;
  final String bookingAvailability;
  final String country;
  final String currency;
  final String discountPercentage;
  final int guestsCount;
  final List<String> imagePath;
  final String listingTitle;
  final String listingDescription;
  final int maxStay;
  final int minStay;
  final String noticeBeforeGuestArrival;
  final String typeOfBed;
  final String typeOfProperty;
  final String whatGuestsBook;
  final String forGuestsOnly;
  final ListingAddress listingAddress;
  final String ratingStar;
  final int reviewCount;
  final HouseRules houseRules;
  ListModel({
    this.listingId,
    this.userId,
    this.amentities,
    this.buildingAmenities,
    this.arriveAfter,
    this.arriveBefore,
    this.leaveBefore,
    this.basePrice,
    this.bathsCount,
    this.bedroomsCount,
    this.bedsCount,
    this.bookingAvailability,
    this.country,
    this.currency,
    this.discountPercentage,
    this.guestsCount,
    this.imagePath,
    this.listingTitle,
    this.listingDescription,
    this.maxStay,
    this.minStay,
    this.noticeBeforeGuestArrival,
    this.typeOfBed,
    this.typeOfProperty,
    this.whatGuestsBook,
    this.forGuestsOnly,
    this.listingAddress,
    this.ratingStar,
    this.reviewCount,
    this.houseRules,
  });

  Map<String, dynamic> toMap() {
    return {
      'listingId': listingId,
      'user_id': userId,
      'amentities': amentities,
      'building_amenities': buildingAmenities,
      'arriveAfter': arriveAfter,
      'arriveBefore': arriveBefore,
      'leaveBefore': leaveBefore,
      'basePrice': basePrice,
      'bathsCount': bathsCount,
      'bedroomsCount': bedroomsCount,
      'bedsCount': bedsCount,
      'bookingAvailability': bookingAvailability,
      'country': country,
      'currency': currency,
      'discountPercentage': discountPercentage,
      'guestsCount': guestsCount,
      'imagePath': imagePath,
      'listingTitle': listingTitle,
      'listingDescription': listingDescription,
      'maxStay': maxStay,
      'minStay': minStay,
      'noticeBeforeGuestArrival': noticeBeforeGuestArrival,
      'typeOfBed': typeOfBed,
      'typeOfProperty': typeOfProperty,
      'whatGuestsBook': whatGuestsBook,
      'forGuestsOnly': forGuestsOnly,
      'listingAddress': listingAddress?.toMap(),
      'ratingStar': ratingStar,
      'reviewCount': reviewCount,
      'houseRules': houseRules?.toMap(),
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ListModel(
      listingId: map['listingId'],
      userId: map['user_id'],
      amentities: List<String>.from(map['amentities']),
      buildingAmenities: List<String>.from(map['building_amenities']),
      arriveAfter: map['arriveAfter'],
      arriveBefore: map['arriveBefore'],
      leaveBefore: map['leaveBefore'],
      basePrice: map['basePrice'],
      bathsCount: map['bathsCount'],
      bedroomsCount: map['bedroomsCount'],
      bedsCount: map['bedsCount'],
      bookingAvailability: map['bookingAvailability'],
      country: map['country'],
      currency: map['currency'],
      discountPercentage: map['discountPercentage'],
      guestsCount: map['guestsCount'],
      imagePath: List<String>.from(map['imagePath']),
      listingTitle: map['listingTitle'],
      listingDescription: map['listingDescription'],
      maxStay: map['maxStay'],
      minStay: map['minStay'],
      noticeBeforeGuestArrival: map['noticeBeforeGuestArrival'],
      typeOfBed: map['typeOfBed'],
      typeOfProperty: map['typeOfProperty'],
      whatGuestsBook: map['whatGuestsBook'],
      forGuestsOnly: map['forGuestsOnly'],
      listingAddress: ListingAddress.fromMap(map['listingAddress']),
      ratingStar: map['ratingStar'],
      reviewCount: map['reviewCount'],
      houseRules: HouseRules.fromMap(map['houseRules']),
    );
  }
}

class HouseRules {
  final bool kidsAllowed;
  final bool petsAllowed;
  final bool smokingAllowed;
  final bool eventsPartiesAllowed;
  final AdditionalRules additionalRules;
  HouseRules({
    this.kidsAllowed,
    this.petsAllowed,
    this.smokingAllowed,
    this.eventsPartiesAllowed,
    this.additionalRules,
  });

  Map<String, dynamic> toMap() {
    return {
      'kidsAllowed': kidsAllowed,
      'petsAllowed': petsAllowed,
      'smokingAllowed': smokingAllowed,
      'eventsPartiesAllowed': eventsPartiesAllowed,
      'additionalRules': additionalRules?.toMap(),
    };
  }

  factory HouseRules.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return HouseRules(
      kidsAllowed: map['kidsAllowed'],
      petsAllowed: map['petsAllowed'],
      smokingAllowed: map['smokingAllowed'],
      eventsPartiesAllowed: map['eventsPartiesAllowed'],
      additionalRules: AdditionalRules.fromMap(map['additionalRules']),
    );
  }
}

class AdditionalRules {
  final String ruleOne;
  final String ruleTwo;
  AdditionalRules({
    this.ruleOne,
    this.ruleTwo,
  });

  Map<String, dynamic> toMap() {
    return {
      'rule_1': ruleOne,
      'rule_2': ruleTwo,
    };
  }

  factory AdditionalRules.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AdditionalRules(
      ruleOne: map['rule_1'],
      ruleTwo: map['rule_2'],
    );
  }
}

class ListingAddress {
  final String address;
  final String city;
  final String aptNo;
  final String state;
  final String zip;
  final String country;
  ListingAddress({
    this.address,
    this.city,
    this.aptNo,
    this.state,
    this.zip,
    this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'aptNo': aptNo,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }

  factory ListingAddress.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ListingAddress(
      address: map['address'],
      city: map['city'],
      aptNo: map['aptNo'],
      state: map['state'],
      zip: map['zip'],
      country: map['country'],
    );
  }
}
