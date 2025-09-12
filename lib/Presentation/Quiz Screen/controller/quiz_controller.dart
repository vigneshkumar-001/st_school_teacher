import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/Utility/snack_bar.dart';

import 'package:st_teacher_app/Core/consents.dart'; // AppLogger? (adjust if needed)
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../api/repository/failure.dart';
import '../Model/details_preview.dart'; // QuizDetailsPreview, QuizDetailsData, Question
import '../Model/history_specific_student_response.dart' hide Question;
import '../Model/quiz_attend_response.dart';
import '../Model/quizlist_response.dart';
import '../quiz_history.dart'; // QuizListResponse, QuizData, QuizItem

class QuizController extends GetxController {
  final isLoading = false.obs;
  final loadStudent = false.obs;
  final quizDetailsPreview = false.obs;
  final apiDataSource = ApiDataSource();

  // Details page data (set by quizDetailsPreviews)
  final Rxn<QuizDetailsData> quizDetails = Rxn<QuizDetailsData>();
  // final Rxn<StudentQuizData> studentQuizResult = Rxn<StudentQuizData>();
  final RxString lastError = ''.obs;

  // List page UI state
  final classNames = <String>[].obs;
  final selectedClassName = 'All'.obs;

  // List page data
  final Rxn<QuizData> _quizData = Rxn<QuizData>();

  // Flat cache for filters etc. (MUTABLE list, not a getter)
  final RxList<QuizItem> _allItems = <QuizItem>[].obs;
  final Rxn<AttendSummaryData> attendSummary = Rxn<AttendSummaryData>();
  final Rxn<StudentQuizData> studentQuiz = Rxn<StudentQuizData>();

  // ---------- Nice UI getters (avoid null bangs) ----------

  String get quizTitle => quizDetails.value?.title ?? '';
  String get quizSubject => quizDetails.value?.subject.name ?? '';
  String get quizClassLabel =>
      quizDetails.value == null
          ? ''
          : '${quizDetails.value!.quizClass.name}-${quizDetails.value!.quizClass.section}';
  String get quizTime => quizDetails.value?.time ?? '';
  String get quizDateRaw => quizDetails.value?.date ?? '';
  List<Question> get quizQuestions => quizDetails.value?.questions ?? const [];

  @override
  void onInit() {
    super.onInit();
    quizList();
  }

  void selectClass(String className) => selectedClassName.value = className;

  // ---------- Helpers for LIST data ----------

  bool _matchesSelectedClass(QuizItem q) {
    if (selectedClassName.value == 'All') return true;
    return q.quizClass.trim().toLowerCase() ==
        selectedClassName.value.trim().toLowerCase();
  }

  DateTime _parseTimeOfDay(String t) {
    try {
      return DateFormat('h:mm a').parse(t);
    } catch (_) {
      try {
        return DateFormat('hh:mm a').parse(t);
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }
  }

  // Map<String, List<QuizItem>> get groupedQuizzes {
  //   final Map<String, List<QuizItem>> out = {};
  //
  //   final today =
  //       (_quizData.value?.today ?? []).where(_matchesSelectedClass).toList()
  //         ..sort(
  //           (a, b) =>
  //               _parseTimeOfDay(b.time).compareTo(_parseTimeOfDay(a.time)),
  //         );
  //
  //   final yesterday =
  //       (_quizData.value?.yesterday ?? []).where(_matchesSelectedClass).toList()
  //         ..sort(
  //           (a, b) =>
  //               _parseTimeOfDay(b.time).compareTo(_parseTimeOfDay(a.time)),
  //         );
  //
  //   if (today.isNotEmpty) out['Today'] = today;
  //   if (yesterday.isNotEmpty) out['Yesterday'] = yesterday;
  //
  //   return out;
  // }

  Map<String, List<QuizItem>> get groupedQuizzes {
    final data = _quizData.value;
    if (data == null) return const {}; // <- avoid null

    final out = <String, List<QuizItem>>{};
    void addLabel(String label, List<QuizItem> items) {
      final filtered =
          items.where(_matchesSelectedClass).toList()..sort(
            (a, b) =>
                _parseTimeOfDay(b.time).compareTo(_parseTimeOfDay(a.time)),
          );
      if (filtered.isNotEmpty) out[label] = filtered;
    }

    // Today/Yesterday first
    for (final s in const ['Today', 'Yesterday']) {
      final hit = data.byLabel.entries.firstWhere(
        (e) => e.key.toLowerCase() == s.toLowerCase(),
        orElse: () => const MapEntry('', <QuizItem>[]),
      );
      if (hit.key.isNotEmpty) addLabel(s, hit.value);
    }
    // Then others
    data.byLabel.forEach((label, items) {
      final l = label.toLowerCase();
      if (l == 'today' || l == 'yesterday') return;
      addLabel(label, items);
    });
    return out;
  }

  QuizData _parseQuizPayload(dynamic raw) {
    if (raw is QuizListResponse) {
      return raw.data;
    }
    if (raw is Map<String, dynamic>) {
      // If it's already only the inner data block
      final hasTopKeys =
          raw.containsKey('status') ||
          raw.containsKey('code') ||
          raw.containsKey('message');
      if (hasTopKeys && raw['data'] is Map<String, dynamic>) {
        return QuizData.fromJson((raw['data'] as Map).cast<String, dynamic>());
      }
      // Or directly the groups
      return QuizData.fromJson(raw);
    }
    throw StateError('Unsupported quiz payload: ${raw.runtimeType}');
  }

  Map<String, List<QuizItem>> get groupedHomeworkByDate => groupedQuizzes;

  // ---------- API: LIST ----------

  Future<String?> quizList() async {
    try {
      isLoading.value = true;

      final results =
          await apiDataSource.quizList(); // <-- use your data source
      return results.fold(
        (Failure failure) {
          lastError.value = failure.message;
          AppLogger.log.e(failure.message);
          return failure.message;
        },
        (QuizListResponse resp) {
          try {
            final parsed = _parseQuizPayload(resp);
            _quizData.value = parsed;

            // rebuild flat list for filters
            // _allItems
            //   ..clear()
            //   ..addAll(parsed.today)
            //   ..addAll(parsed.yesterday);

            // WITH this (aggregate everything from byLabel):
            _allItems
              ..clear()
              ..addAll(parsed.byLabel.values.expand((e) => e));

            // Build class filter list
            final classes = <String>{};
            for (final q in _allItems) {
              final c = q.quizClass.trim();
              if (c.isNotEmpty) classes.add(c);
            }
            final sorted =
                classes.toList()
                  ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
            classNames.assignAll(['All', ...sorted]);

            AppLogger.log.i(
              'Quiz list fetched: Today=${parsed.today.length}, Yesterday=${parsed.yesterday.length}',
            );
            lastError.value = '';
            return null;
          } catch (e) {
            final msg = 'Parsing error: $e';
            AppLogger.log.e(msg);
            lastError.value = msg;
            return msg;
          }
        },
      );
    } catch (e) {
      final msg = e.toString();
      lastError.value = msg;
      AppLogger.log.e(msg);
      return msg;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------- API: CREATE (placeholder wiring) ----------
  Future<String?> quizCreate(
    BuildContext context,
    Map<String, dynamic> payload, {

    bool showLoader = true,
  }) async {
    try {
      if (showLoader) showPopupLoader();
      final results = await apiDataSource.quizCreate(payload);
      return results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          lastError.value = failure.message;
          AppLogger.log.e(failure.message);
          return failure.message;
        },
        (response) async {
          Navigator.pop(context);
          Get.off(() => const QuizHistory());
          if (showLoader) hidePopupLoader();
          CustomSnackBar.showSuccess(response.message);
          lastError.value = '';
          AppLogger.log.i(response.data ?? 'Data fetched');
          AppLogger.log.i(response.message);
          return null;
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();

      lastError.value = e.toString();
      AppLogger.log.e(e);
      return e.toString();
    }
  }

  void showPopupLoader() {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: AppColor.black,
              strokeAlign: 1,
            ),
          ),
        ),
      ),
      barrierDismissible: false, // user can't dismiss by tapping outside
      barrierColor: Colors.black.withOpacity(0.3), // transparent background
    );
  }

  void hidePopupLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Loads quiz details by classId and sets [quizDetails]; returns `null` on success or an error message.
  Future<String?> quizDetailsPreviews({required int classId}) async {
    try {
      quizDetailsPreview.value = true;

      final result = await apiDataSource.quizDetailsPreviews(code: classId);
      return result.fold(
        (failure) {
          quizDetailsPreview.value = false;
          lastError.value = failure.message;
          AppLogger.log.e(failure.message);
          return failure.message;
        },
        (preview) {
          // ✅ preview is QuizDetailsPreview
          final data = preview.data; // QuizDetailsData
          quizDetails.value = data;
          quizDetailsPreview.value = false;
          lastError.value = '';
          AppLogger.log.i('Details fetched: ${data?.title}');
          return null;
        },
      );
    } catch (e) {
      quizDetailsPreview.value = false;
      lastError.value = e.toString();
      AppLogger.log.e(e);
      return e.toString();
    }
  }

  Future<String?> loadQuizAttendByClass({required int code}) async {
    isLoading.value = true;
    try {
      final result = await apiDataSource.loadQuizAttendByClass(quizId: code);
      return result.fold(
        (failure) {
          final msg =
              failure.message.isNotEmpty
                  ? failure.message
                  : 'Something went wrong';
          lastError.value = msg;
          AppLogger.log.e(
            'AttendSummary FAILED: msg=${failure.message} code=${failure.code} data=${failure.data}',
          );
          return msg;
        },
        (resp) {
          final data = resp.data; // AttendSummaryData
          attendSummary.value = data;
          lastError.value = '';
          AppLogger.log.i(
            'History fetched: ${data.quiz.title} / done=${data.studentsDone.length}',
          );
          return null;
        },
      );
    } catch (e, st) {
      final msg = e.toString();
      lastError.value = msg;
      AppLogger.log.e('AttendSummary exception: $msg');
      AppLogger.log.e(st.toString());
      return msg;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> loadStudentQuizResult({
    required int quizId,
    required int studentId,

    bool openScreen = true,
  }) async {
    if (isLoading.value) return null;
    try {
      loadStudent.value = true;
      lastError.value = '';

      final result = await apiDataSource.studentQuizResults(
        quizId: quizId,
        studentId: studentId,
      );

      return result.fold(
        (failure) {
          loadStudent.value = false;
          lastError.value = failure.message;
          // 🔐 Prevent stale UI from showing old data on error:
          studentQuiz.value = null;
          studentQuiz.value = null; // keep alias in sync
          AppLogger.log.e(failure.message);
          return failure.message;
        },
        (resp) {
          loadStudent.value = false;
          studentQuiz.value = resp.data;
          AppLogger.log.i('Details fetched: ${resp.data}');
        },
      );
    } catch (e) {
      loadStudent.value = false;
      lastError.value = e.toString();
      studentQuiz.value = null;
      studentQuiz.value = null;
      AppLogger.log.e(e);
      return e.toString();
    } finally {
      loadStudent.value = false;
    }
  }
}
