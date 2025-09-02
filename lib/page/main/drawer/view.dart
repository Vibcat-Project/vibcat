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

  // 常量定义
  static const double _searchBarHeight = kToolbarHeight - 10;
  static const double _itemElevation = 10;
  static const double _menuWidth = 0.5;
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Duration _backdropAnimationDuration = Duration(
    milliseconds: 200,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody()),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  /// 构建应用栏
  AppBar _buildAppBar() {
    return AppBar(
      title: _SearchBar(),
      actions: [
        _CloseButton(onPressed: () => mainLogic.controlSlideDrawer(false)),
      ],
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    return CustomScrollView(
      slivers: [_buildSectionHeader(), _buildConversationList()],
    );
  }

  /// 构建章节标题
  SliverToBoxAdapter _buildSectionHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Text(
          'conversation'.tr,
          style: TextStyle(
            color: GlobalStore.themeExt.textHint,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 构建对话列表
  SliverList _buildConversationList() {
    return SliverList.builder(
      itemCount: state.list.length,
      itemBuilder: (context, index) => _ConversationItem(
        key: ValueKey(state.list[index].hashCode),
        item: state.list[index],
        index: index,
        isSelected: index == state.currentIndex.value,
        onTap: () => _handleConversationTap(index),
        onLongPress: (link, itemKey) => _showPreview(
          context: context,
          index: index,
          link: link,
          itemKey: itemKey,
        ),
        onDelete: () => logic.deleteConversation(index),
      ),
    );
  }

  /// 构建底部导航
  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(16, 0, 16, Get.mediaQuery.padding.bottom),
      child: _SettingsButton(onTap: logic.showSettingsSheet),
    );
  }

  /// 处理对话点击事件
  void _handleConversationTap(int index) {
    final item = state.list[index];
    Get.find<HomeLogic>().loadConversation(item);
    mainLogic.controlSlideDrawer(false);
    state.currentIndex.value = index;
  }

  /// 显示预览弹窗
  void _showPreview({
    required BuildContext context,
    required int index,
    required LayerLink link,
    required GlobalKey itemKey,
  }) {
    final overlay = Overlay.of(context);
    final rect = _calculateItemRect(itemKey);

    _PreviewOverlay(
      overlay: overlay,
      rect: rect,
      link: link,
      index: index,
      onDelete: () => logic.deleteConversation(index),
      buildItem: () => _ConversationItem(
        item: state.list[index],
        index: index,
        isSelected: index == state.currentIndex.value,
        isPreview: true,
      ),
    ).show();
  }

  /// 计算列表项的矩形区域
  Rect _calculateItemRect(GlobalKey key) {
    final ctx = key.currentContext!;
    final box = ctx.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    return offset & box.size;
  }
}

/// 搜索栏组件
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: DrawerComponent._searchBarHeight,
      decoration: BoxDecoration(
        color: GlobalStore.themeExt.container2,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, right: 10),
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
    );
  }
}

/// 关闭按钮组件
class _CloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: IconButton(onPressed: onPressed, icon: Icon(AppIcon.close)),
    );
  }
}

/// 对话列表项组件
class _ConversationItem extends StatelessWidget {
  final dynamic item;
  final int index;
  final bool isSelected;
  final bool isPreview;
  final VoidCallback? onTap;
  final Function(LayerLink, GlobalKey)? onLongPress;
  final VoidCallback? onDelete;

  const _ConversationItem({
    super.key,
    required this.item,
    required this.index,
    required this.isSelected,
    this.isPreview = false,
    this.onTap,
    this.onLongPress,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isPreview) {
      return _buildTile();
    }

    final link = LayerLink();
    final itemKey = GlobalKey();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: isSelected ? 4 : 0),
      child: CompositedTransformTarget(
        link: link,
        child: GestureDetector(
          key: itemKey,
          onLongPressStart: (_) {
            HapticUtil.normal();
            onLongPress?.call(link, itemKey);
          },
          child: _buildTile(),
        ),
      ),
    );
  }

  /// 构建列表瓦片
  Widget _buildTile() {
    return Material(
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
  }
}

/// 设置按钮组件
class _SettingsButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SettingsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        children: [
          Icon(AppIcon.settings, size: 32),
          const SizedBox(width: 8),
          Text(
            'settings'.tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// 预览弹窗管理类
class _PreviewOverlay {
  final OverlayState overlay;
  final Rect rect;
  final LayerLink link;
  final int index;
  final VoidCallback onDelete;
  final Widget Function() buildItem;

  late final OverlayEntry _entry;
  final ValueNotifier<bool> _isVisible = ValueNotifier(false);

  _PreviewOverlay({
    required this.overlay,
    required this.rect,
    required this.link,
    required this.index,
    required this.onDelete,
    required this.buildItem,
  });

  /// 显示预览弹窗
  void show() {
    _entry = OverlayEntry(builder: _buildOverlay);
    overlay.insert(_entry);

    // 下一帧触发显示动画
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isVisible.value = true;
    });
  }

  /// 关闭预览弹窗
  void _close() {
    _isVisible.value = false;
  }

  /// 构建弹窗内容
  Widget _buildOverlay(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isVisible,
      builder: (context, visible, _) {
        return Stack(
          children: [
            _buildBackdrop(visible),
            _buildPreviewItem(visible),
            _buildContextMenu(visible),
          ],
        );
      },
    );
  }

  /// 构建背景模糊层
  Widget _buildBackdrop(bool visible) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _close,
        child: AnimatedOpacity(
          duration: DrawerComponent._backdropAnimationDuration,
          opacity: visible ? 1.0 : 0.0,
          onEnd: () {
            if (!visible) {
              _entry.remove();
            }
          },
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: AppColor.black.withOpacity(0.08)),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建预览项
  Widget _buildPreviewItem(bool visible) {
    return CompositedTransformFollower(
      link: link,
      showWhenUnlinked: false,
      targetAnchor: Alignment.topLeft,
      followerAnchor: Alignment.topLeft,
      child: AnimatedScale(
        scale: visible ? 1.02 : 1,
        duration: DrawerComponent._animationDuration,
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: DrawerComponent._animationDuration,
          child: Material(
            color: GlobalStore.theme.scaffoldBackgroundColor,
            elevation: DrawerComponent._itemElevation,
            shadowColor: AppColor.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(width: rect.width, child: buildItem()),
          ),
        ),
      ),
    );
  }

  /// 构建上下文菜单
  Widget _buildContextMenu(bool visible) {
    return CompositedTransformFollower(
      link: link,
      showWhenUnlinked: false,
      targetAnchor: Alignment.center,
      followerAnchor: Alignment.center,
      offset: _calculateMenuOffset(),
      child: AnimatedScale(
        scale: visible ? 1 : 0.9,
        duration: DrawerComponent._animationDuration,
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: DrawerComponent._animationDuration,
          child: _ContextMenu(
            onDelete: () {
              _close();
              onDelete();
            },
          ),
        ),
      ),
    );
  }

  /// 计算菜单偏移位置
  Offset _calculateMenuOffset() {
    final isNearBottom = rect.bottom > Get.height * 0.7;
    return Offset(0, isNearBottom ? -(rect.height + 10) : rect.height + 10);
  }
}

/// 上下文菜单组件
class _ContextMenu extends StatelessWidget {
  final VoidCallback onDelete;

  const _ContextMenu({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GlobalStore.theme.scaffoldBackgroundColor,
      elevation: DrawerComponent._itemElevation,
      shadowColor: AppColor.black.withOpacity(0.4),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: Get.width * DrawerComponent._menuWidth,
          maxWidth: Get.width * DrawerComponent._menuWidth,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ContextMenuItem(
              icon: Icons.delete,
              text: 'delete'.tr,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// 上下文菜单项组件
class _ContextMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContextMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
}
