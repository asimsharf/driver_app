class Coordinate {
  PlusCode? plusCode;
  List<Results>? results;
  String? status;

  Coordinate({this.plusCode, this.results, this.status});

  Coordinate.fromJson(Map<String, dynamic> json) {
    plusCode = json['plus_code'] != null
        ? PlusCode?.fromJson(json['plus_code'])
        : null;

    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results?.add(Results.fromJson(v));
      });
    }

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (plusCode != null) {
      data['plus_code'] = plusCode?.toJson();
    }
    if (results != null) {
      data['results'] = results?.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['compound_code'] = compoundCode;
    data['global_code'] = globalCode;
    return data;
  }
}

class Results {
  List<AddressComponents>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  List<dynamic>? types;
  PlusCode? plusCode;
  List<dynamic>? postcodeLocalities;

  Results(
      {this.addressComponents,
      this.formattedAddress,
      this.geometry,
      this.placeId,
      this.types,
      this.plusCode,
      this.postcodeLocalities});

  Results.fromJson(Map<String, dynamic> json) {
    if (json['address_components'] != null) {
      addressComponents = <AddressComponents>[];
      json['address_components'].forEach((v) {
        addressComponents?.add(AddressComponents.fromJson(v));
      });
    }
    formattedAddress = json['formatted_address'];
    geometry =
        json['geometry'] != null ? Geometry?.fromJson(json['geometry']) : null;
    placeId = json['place_id'];
    types = json['types'];
    plusCode = json['plus_code'] != null
        ? PlusCode?.fromJson(json['plus_code'])
        : null;
    postcodeLocalities = json['postcode_localities'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (addressComponents != null) {
      data['address_components'] =
          addressComponents?.map((v) => v.toJson()).toList();
    }
    data['formatted_address'] = formattedAddress;
    if (geometry != null) {
      data['geometry'] = geometry?.toJson();
    }
    data['place_id'] = placeId;
    data['types'] = types;
    if (plusCode != null) {
      data['plus_code'] = plusCode?.toJson();
    }
    data['postcode_localities'] = postcodeLocalities;
    return data;
  }
}

class AddressComponents {
  String? longName;
  String? shortName;
  List<dynamic>? types;

  AddressComponents({this.longName, this.shortName, this.types});

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longName = json['long_name'];
    shortName = json['short_name'];
    types = json['types'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['long_name'] = longName;
    data['short_name'] = shortName;
    data['types'] = types;
    return data;
  }
}

class Geometry {
  Bounds? bounds;
  Northeast? location;
  String? locationType;
  Bounds? viewport;

  Geometry({this.bounds, this.location, this.locationType, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    bounds = json['bounds'] != null ? Bounds?.fromJson(json['bounds']) : null;
    location =
        json['location'] != null ? Northeast?.fromJson(json['location']) : null;
    locationType = json['location_type'];
    viewport =
        json['viewport'] != null ? Bounds?.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (bounds != null) {
      data['bounds'] = bounds?.toJson();
    }
    if (location != null) {
      data['location'] = location?.toJson();
    }
    data['location_type'] = locationType;
    if (viewport != null) {
      data['viewport'] = viewport?.toJson();
    }
    return data;
  }
}

class Bounds {
  Northeast? northeast;
  Northeast? southwest;

  Bounds({this.northeast, this.southwest});

  Bounds.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ? Northeast?.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? Northeast?.fromJson(json['southwest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (northeast != null) {
      data['northeast'] = northeast?.toJson();
    }
    if (southwest != null) {
      data['southwest'] = southwest?.toJson();
    }
    return data;
  }
}

class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  Northeast.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
