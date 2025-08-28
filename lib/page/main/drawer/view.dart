import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/icons.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/util/date.dart';
import 'package:vibcat/util/haptic.dart';

import '../../../global/color.dart';
import '../home/logic.dart';
import '../logic.dart';
import 'logic.dart';
import 'state.dart';

class DrawerComponent extends StatelessWidget {
  DrawerComponent({super.key});

  final mainLogic = Get.find<MainLogic>();
  final DrawerLogic logic = Get.put(DrawerLogic());
  final DrawerState state = Get.find<DrawerLogic>().state;

  AppBar _appBar() {
    return AppBar(
      title: Container(
        height: kToolbarHeight - 10,
        decoration: BoxDecoration(
          color: GlobalStore.themeExt.container2,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, right: 10),
              child: Icon(AppIcon.search),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'search'.tr,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 4),
          child: IconButton(
            onPressed: () => mainLogic.controlSlideDrawer(false),
            icon: Icon(AppIcon.close),
          ),
        ),
      ],
    );
  }

  Rect _rectOf(GlobalKey key) {
    final ctx = key.currentContext!;
    final box = ctx.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    return offset & box.size;
  }

  void _showPreview({
    required BuildContext context,
    required int index,
    required LayerLink link,
    required GlobalKey itemKey,
    required Widget Function() buildItem,
    VoidCallback? onClose,
  }) {
    final overlay = Overlay.of(context);
    final rect = _rectOf(itemKey); // 拿到原 item 的宽高，给 overlay 限宽

    final isVisible = ValueNotifier(false); // 初始为 false（隐藏）

    void close() {
      isVisible.value = false; // 先触发淡出动画
      onClose?.call();
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder<bool>(
          valueListenable: isVisible,
          builder: (context, visible, _) {
            return Stack(
              children: [
                // 背景模糊 + 点击关闭
                Positioned.fill(
                  child: GestureDetector(
                    onTap: close,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: visible ? 1.0 : 0.0,
                      onEnd: () {
                        if (!visible) {
                          entry.remove(); // 动画结束再 remove
                        }
                      },
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: AppColor.black.withOpacity(0.08),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 悬浮的 item：使用 Follower 与原 item 完全对齐
                CompositedTransformFollower(
                  link: link,
                  showWhenUnlinked: false,
                  targetAnchor: Alignment.topLeft,
                  followerAnchor: Alignment.topLeft,
                  child: AnimatedScale(
                    scale: visible ? 1.02 : 1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: AnimatedOpacity(
                      opacity: visible ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Material(
                        color: GlobalStore.theme.scaffoldBackgroundColor,
                        elevation: 10,
                        shadowColor: AppColor.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox(width: rect.width, child: buildItem()),
                      ),
                    ),
                  ),
                ),

                // 菜单：同样用 Follower，基于 item 右侧（或左侧）偏移
                CompositedTransformFollower(
                  link: link,
                  showWhenUnlinked: false,
                  targetAnchor: Alignment.center,
                  followerAnchor: Alignment.center,
                  offset: Offset(
                    0,
                    rect.bottom > Get.height * 0.7
                        ? -(rect.height + 10)
                        : rect.height + 10,
                  ),
                  child: AnimatedScale(
                    scale: visible ? 1 : 0.9,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: AnimatedOpacity(
                      opacity: visible ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: _buildMenu(
                        icon: Icons.delete,
                        text: 'delete'.tr,
                        onClose: close,
                        onTap: () => logic.deleteConversation(index),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    overlay.insert(entry);

    // 下一帧再触发显示，跑入场动画
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isVisible.value = true;
    });
  }

  Widget _buildMenu({
    required IconData icon,
    required String text,
    required VoidCallback onClose,
    VoidCallback? onTap,
  }) {
    Widget item(IconData icon, String text, VoidCallback? onTap) {
      return InkWell(
        onTap: () {
          onClose();
          onTap?.call();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: Text(text)),
              const SizedBox(width: 8),
              Icon(icon, size: 18),
            ],
          ),
        ),
      );
    }

    return Material(
      color: GlobalStore.theme.scaffoldBackgroundColor,
      elevation: 10,
      shadowColor: AppColor.black.withOpacity(0.4),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: Get.width / 2,
          maxWidth: Get.width / 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [item(icon, text, onTap)],
        ),
      ),
    );
  }

  Widget _body() => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            'conversation'.tr,
            style: TextStyle(
              color: GlobalStore.themeExt.textHint,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SliverList.builder(
        itemCount: state.list.length,
        itemBuilder: (context, index) {
          final item = state.list[index];
          final isSelected = index == state.currentIndex.value;

          final link = LayerLink(); // 绑定 target/follower 的锚点
          final itemKey = GlobalKey(); // 取原 item 的宽高

          Widget buildTile({Function()? onTap}) => Material(
            color: AppColor.transparent,
            child: ListTile(
              tileColor: isSelected
                  ? GlobalStore.themeExt.container?.withAlpha(60)
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                side: isSelected
                    ? BorderSide(color: GlobalStore.themeExt.border!)
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                item.title,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
              subtitle: Text(DateUtil.formatDateTime(item.updatedAt)),
              onTap: onTap,
            ),
          );

          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: isSelected ? 4 : 0,
            ),
            // target：标记当前 item 的锚点
            child: CompositedTransformTarget(
              link: link,
              child: GestureDetector(
                key: itemKey, // 用来测量原 item 的尺寸（宽度要给 overlay 用）
                onLongPressStart: (_) {
                  HapticUtil.normal();

                  _showPreview(
                    context: context,
                    index: index,
                    link: link,
                    itemKey: itemKey,
                    // 传个 builder，overlay 里重新构建同款样式
                    buildItem: buildTile,
                  );
                },
                child: buildTile(
                  onTap: () {
                    Get.find<HomeLogic>().loadConversation(item);
                    mainLogic.controlSlideDrawer(false);
                    state.currentIndex.value = index;
                  },
                ),
              ),
            ),
          );
        },
      ),
    ],
  );

  Widget _bottom() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(16, 0, 16, Get.mediaQuery.padding.bottom),
      child: GestureDetector(
        // 支持空白区域也能响应点击事件
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: [
            Icon(AppIcon.settings, size: 32),
            SizedBox(width: 8),
            Text(
              'settings'.tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: GlobalStore.themeExt.border,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        ),
        onTap: () => logic.showSettingsSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      appBar: _appBar(),
      body: Obx(() => _body()),
      bottomNavigationBar: _bottom(),
    );
  }
}
