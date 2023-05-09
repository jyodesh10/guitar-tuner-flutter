// To parse this JSON data, do
//
//     final tuningsModel = tuningsModelFromJson(jsonString);

import 'dart:convert';

TuningsModel tuningsModelFromJson(String str) => TuningsModel.fromJson(json.decode(str));

String tuningsModelToJson(TuningsModel data) => json.encode(data.toJson());

class TuningsModel {
    List<Datum> data;

    TuningsModel({
        required this.data,
    });

    factory TuningsModel.fromJson(Map<String, dynamic> json) => TuningsModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String instrument;
    List<Tuning> tunings;

    Datum({
        required this.instrument,
        required this.tunings,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        instrument: json["instrument"],
        tunings: List<Tuning>.from(json["tunings"].map((x) => Tuning.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "instrument": instrument,
        "tunings": List<dynamic>.from(tunings.map((x) => x.toJson())),
    };
}

class Tuning {
    String name;
    String notes;

    Tuning({
        required this.name,
        required this.notes,
    });

    factory Tuning.fromJson(Map<String, dynamic> json) => Tuning(
        name: json["name"],
        notes: json["notes"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "notes": notes,
    };
}
