// To parse this JSON data, do
//
//     final chatGptResponse = chatGptResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChatGptResponse chatGptResponseFromJson(String str) => ChatGptResponse.fromJson(json.decode(str));

String chatGptResponseToJson(ChatGptResponse data) => json.encode(data.toJson());

class ChatGptResponse {
    final String msg;
    final Body body;

    ChatGptResponse({
        required this.msg,
        required this.body,
    });

    factory ChatGptResponse.fromJson(Map<String, dynamic> json) => ChatGptResponse(
        msg: json["msg"],
        body: Body.fromJson(json["body"]),
    );

    Map<String, dynamic> toJson() => {
        "msg": msg,
        "body": body.toJson(),
    };
}

class Body {
    final String id;
    final String object;
    final int created;
    final String model;
    final Usage usage;
    final List<Choice> choices;

    Body({
        required this.id,
        required this.object,
        required this.created,
        required this.model,
        required this.usage,
        required this.choices,
    });

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        id: json["id"],
        object: json["object"],
        created: json["created"],
        model: json["model"],
        usage: Usage.fromJson(json["usage"]),
        choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created": created,
        "model": model,
        "usage": usage.toJson(),
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
    };
}

class Choice {
    final Message message;
    final String finishReason;
    final int index;

    Choice({
        required this.message,
        required this.finishReason,
        required this.index,
    });

    factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        message: Message.fromJson(json["message"]),
        finishReason: json["finish_reason"],
        index: json["index"],
    );

    Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "finish_reason": finishReason,
        "index": index,
    };
}

class Message {
    final String role;
    final String content;

    Message({
        required this.role,
        required this.content,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        role: json["role"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
    };
}

class Usage {
    final int promptTokens;
    final int completionTokens;
    final int totalTokens;

    Usage({
        required this.promptTokens,
        required this.completionTokens,
        required this.totalTokens,
    });

    factory Usage.fromJson(Map<String, dynamic> json) => Usage(
        promptTokens: json["prompt_tokens"],
        completionTokens: json["completion_tokens"],
        totalTokens: json["total_tokens"],
    );

    Map<String, dynamic> toJson() => {
        "prompt_tokens": promptTokens,
        "completion_tokens": completionTokens,
        "total_tokens": totalTokens,
    };
}
