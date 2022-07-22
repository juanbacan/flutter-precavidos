// To parse this JSON data, do
//
//     final tokenResponse = tokenResponseFromJson(jsonString);

import 'dart:convert';

TokenResponse tokenResponseFromJson(String str) => TokenResponse.fromJson(json.decode(str));

String tokenResponseToJson(TokenResponse data) => json.encode(data.toJson());

class TokenResponse {
    TokenResponse({
        required this.ok,
        required this.msg,
        this.admin,
        this.premium,
    });

    bool ok;
    String msg;
    bool? admin;
    bool? premium;

    factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        ok: json["ok"],
        msg: json["msg"],
        admin: json["admin"],
        premium: json["premium"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "admin": admin,
        "premium": premium,
    };
}
