import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/Utility/snack_bar.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/Presentation/Home/models/message_list_response.dart';
import 'package:st_teacher_app/Presentation/Home/models/react_response.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';

class MessageController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isPresentLoading = false.obs;
  final RxBool isAttendanceLoading = false.obs;
  final RxBool isMarkingLoading = false.obs;
  String accessToken = '';
  RxList<NotificationItem> messageList = <NotificationItem>[].obs;
  var reactData = Rxn<ReactData>(); // nullable reactive variable
  // Track loading for each message separately
  final RxSet<int> loadingMessages =
      <int>{}.obs; // stores ids of loading messages

  @override
  void onInit() {
    super.onInit();
    getMessageList();
  }

  Map<String, List<NotificationItem>> get groupedMessages {
    final Map<String, List<NotificationItem>> grouped = {};

    for (var msg in messageList) {
      final createdDate = DateUtils.dateOnly(msg.createdAt);
      final now = DateUtils.dateOnly(DateTime.now());
      final yesterday = now.subtract(const Duration(days: 1));

      String key;
      if (createdDate == now) {
        key = "Today Messages";
      } else if (createdDate == yesterday) {
        key = "Yesterday Messages";
      } else {
        key = DateFormat("dd MMM yyyy").format(createdDate);
      }

      grouped.putIfAbsent(key, () => []).add(msg);
    }

    return grouped;
  }

  Future<String?> getMessageList({bool load = true}) async {
    try {
      isLoading.value = load;
      final results = await apiDataSource.getMessageList();
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;

          // Store in memory
          // classList.assignAll(response.data);
          messageList.value = response.data.items;
          AppLogger.log.i(messageList.toString());

          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('token', response.token);
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> reactForStudentMessage({
    required int msgId,
    bool like = true,
  }) async {
    try {
      loadingMessages.add(msgId);

      final results = await apiDataSource.reactForStudentMessage(
        msgId: msgId,
        like: like,
      );

      results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
        },
        (response) async {
          await getMessageList(load: false);
          CustomSnackBar.showSuccess('Reacted');
          reactData.value = response.data;

          AppLogger.log.i(messageList.toString());
        },
      );
    } catch (e) {
      AppLogger.log.e(e);
      return e.toString();
    } finally {
      loadingMessages.remove(msgId); // stop loading for this msgId
    }
    return null;
  }
}
