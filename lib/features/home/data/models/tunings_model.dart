// To parse this JSON data, do
//
//     final tuningsModel = tuningsModelFromJson(jsonString);

import 'dart:convert';

TuningsModel tuningsModelFromJson(String str) => TuningsModel.fromJson(json.decode(str));

String tuningsModelToJson(TuningsModel data) => json.encode(data.toJson());

class TuningsModel {
    Bass bass;
    Banjo banjo;
    Cello cello;
    Guitar guitar;
    Cello mandolin;
    Cello viola;
    Violin violin;
    Ukulele ukulele;

    TuningsModel({
        required this.bass,
        required this.banjo,
        required this.cello,
        required this.guitar,
        required this.mandolin,
        required this.viola,
        required this.violin,
        required this.ukulele,
    });

    factory TuningsModel.fromJson(Map<String, dynamic> json) => TuningsModel(
        bass: Bass.fromJson(json["bass"]),
        banjo: Banjo.fromJson(json["banjo"]),
        cello: Cello.fromJson(json["cello"]),
        guitar: Guitar.fromJson(json["guitar"]),
        mandolin: Cello.fromJson(json["mandolin"]),
        viola: Cello.fromJson(json["viola"]),
        violin: Violin.fromJson(json["violin"]),
        ukulele: Ukulele.fromJson(json["ukulele"]),
    );

    Map<String, dynamic> toJson() => {
        "bass": bass.toJson(),
        "banjo": banjo.toJson(),
        "cello": cello.toJson(),
        "guitar": guitar.toJson(),
        "mandolin": mandolin.toJson(),
        "viola": viola.toJson(),
        "violin": violin.toJson(),
        "ukulele": ukulele.toJson(),
    };
}

class Banjo {
    String standard;
    String c;
    String g;
    String doubleC;
    String sawmill;
    BanjoOpen open;

    Banjo({
        required this.standard,
        required this.c,
        required this.g,
        required this.doubleC,
        required this.sawmill,
        required this.open,
    });

    factory Banjo.fromJson(Map<String, dynamic> json) => Banjo(
        standard: json["standard"],
        c: json["C"],
        g: json["G"],
        doubleC: json["doubleC"],
        sawmill: json["sawmill"],
        open: BanjoOpen.fromJson(json["open"]),
    );

    Map<String, dynamic> toJson() => {
        "standard": standard,
        "C": c,
        "G": g,
        "doubleC": doubleC,
        "sawmill": sawmill,
        "open": open.toJson(),
    };
}

class BanjoOpen {
    String c;
    String d;

    BanjoOpen({
        required this.c,
        required this.d,
    });

    factory BanjoOpen.fromJson(Map<String, dynamic> json) => BanjoOpen(
        c: json["C"],
        d: json["D"],
    );

    Map<String, dynamic> toJson() => {
        "C": c,
        "D": d,
    };
}

class Bass {
    String standard;
    String fiveString;
    String sixString;

    Bass({
        required this.standard,
        required this.fiveString,
        required this.sixString,
    });

    factory Bass.fromJson(Map<String, dynamic> json) => Bass(
        standard: json["standard"],
        fiveString: json["fiveString"],
        sixString: json["sixString"],
    );

    Map<String, dynamic> toJson() => {
        "standard": standard,
        "fiveString": fiveString,
        "sixString": sixString,
    };
}

class Cello {
    String standard;

    Cello({
        required this.standard,
    });

    factory Cello.fromJson(Map<String, dynamic> json) => Cello(
        standard: json["standard"],
    );

    Map<String, dynamic> toJson() => {
        "standard": standard,
    };
}

class Guitar {
    String standard;
    GuitarOpen open;
    Drop drop;
    String lute;
    String irish;

    Guitar({
        required this.standard,
        required this.open,
        required this.drop,
        required this.lute,
        required this.irish,
    });

    factory Guitar.fromJson(Map<String, dynamic> json) => Guitar(
        standard: json["standard"],
        open: GuitarOpen.fromJson(json["open"]),
        drop: Drop.fromJson(json["drop"]),
        lute: json["lute"],
        irish: json["irish"],
    );

    Map<String, dynamic> toJson() => {
        "standard": standard,
        "open": open.toJson(),
        "drop": drop.toJson(),
        "lute": lute,
        "irish": irish,
    };
}

class Drop {
    String ab;
    String a;
    String dropA;
    String bb;
    String b;
    String c;
    String dropC;
    String db;
    String d;
    String dropD;
    String eb;
    String e;
    String f;
    String dropF;
    String gb;
    String g;
    String dropG;

    Drop({
        required this.ab,
        required this.a,
        required this.dropA,
        required this.bb,
        required this.b,
        required this.c,
        required this.dropC,
        required this.db,
        required this.d,
        required this.dropD,
        required this.eb,
        required this.e,
        required this.f,
        required this.dropF,
        required this.gb,
        required this.g,
        required this.dropG,
    });

    factory Drop.fromJson(Map<String, dynamic> json) => Drop(
        ab: json["Ab"],
        a: json["A"],
        dropA: json["A#"],
        bb: json["Bb"],
        b: json["B"],
        c: json["C"],
        dropC: json["C#"],
        db: json["Db"],
        d: json["D"],
        dropD: json["D#"],
        eb: json["Eb"],
        e: json["E"],
        f: json["F"],
        dropF: json["F#"],
        gb: json["Gb"],
        g: json["G"],
        dropG: json["G#"],
    );

    Map<String, dynamic> toJson() => {
        "Ab": ab,
        "A": a,
        "A#": dropA,
        "Bb": bb,
        "B": b,
        "C": c,
        "C#": dropC,
        "Db": db,
        "D": d,
        "D#": dropD,
        "Eb": eb,
        "E": e,
        "F": f,
        "F#": dropF,
        "Gb": gb,
        "G": g,
        "G#": dropG,
    };
}

class GuitarOpen {
    String a;
    String b;
    String c;
    String d;
    String f;
    String g;

    GuitarOpen({
        required this.a,
        required this.b,
        required this.c,
        required this.d,
        required this.f,
        required this.g,
    });

    factory GuitarOpen.fromJson(Map<String, dynamic> json) => GuitarOpen(
        a: json["A"],
        b: json["B"],
        c: json["C"],
        d: json["D"],
        f: json["F"],
        g: json["G"],
    );

    Map<String, dynamic> toJson() => {
        "A": a,
        "B": b,
        "C": c,
        "D": d,
        "F": f,
        "G": g,
    };
}

class Ukulele {
    String standard;
    String bass;
    String baritone;
    String tenor;
    String soprano;

    Ukulele({
        required this.standard,
        required this.bass,
        required this.baritone,
        required this.tenor,
        required this.soprano,
    });

    factory Ukulele.fromJson(Map<String, dynamic> json) => Ukulele(
        standard: json["standard"],
        bass: json["bass"],
        baritone: json["baritone"],
        tenor: json["tenor"],
        soprano: json["soprano"],
    );

    Map<String, dynamic> toJson() => {
        "standard": standard,
        "bass": bass,
        "baritone": baritone,
        "tenor": tenor,
        "soprano": soprano,
    };
}

class Violin {
    String standard;
    String cajun;
    String sawmill;
    ViolinOpen open;

    Violin({
        required this.standard,
        required this.cajun,
        required this.sawmill,
        required this.open,
    });

    factory Violin.fromJson(Map<String, dynamic> json) => Violin(
        standard: json["standard"],
        cajun: json["cajun"],
        sawmill: json["sawmill"],
        open: ViolinOpen.fromJson(json["open"]),
    );

    Map<String, dynamic> toJson() => {
        "standard": standard,
        "cajun": cajun,
        "sawmill": sawmill,
        "open": open.toJson(),
    };
}

class ViolinOpen {
    String d;
    String g;

    ViolinOpen({
        required this.d,
        required this.g,
    });

    factory ViolinOpen.fromJson(Map<String, dynamic> json) => ViolinOpen(
        d: json["D"],
        g: json["G"],
    );

    Map<String, dynamic> toJson() => {
        "D": d,
        "G": g,
    };
}
