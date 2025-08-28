class Constants {
  static const markdownText = r"""
  好的 👍 我来帮你生成一份 **完整覆盖标准 Markdown 语法的示例文档**，这样你可以测试解析器或渲染效果。

# H1 标题
## H2 标题
### H3 标题
#### H4 标题
##### H5 标题
###### H6 标题

---

## 2. 段落与换行

这是一个段落。  
这里是同一段落中的换行。

另起一段。

---

# 2-段落与换行

---

## 3. 强调 (Emphasis)

*斜体*
_斜体_

**粗体**
__粗体__

***粗斜体***
___粗斜体___

---

## 4. 列表 (Lists)

### 无序列表
- 项目 A
- 项目 B
  - 子项目 B1
  - 子项目 B2

### 有序列表
1. 第一项
2. 第二项
   1. 子项 2.1
   2. 子项 2.2

---

## 5. 引用 (Blockquote)

> 这是一个引用。  
> 可以有多行。  
>> 也可以嵌套。

---

## 6. 代码 (Code)

### 行内代码
这是 `inline code` `是犯法撒娇看` 示例。

### 代码块
```javascript
function hello() {
  console.log("Hello, Markdown!");
}
```

```
  PreConfig copy({
    Decoration? decoration,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? codeBlockBodyPadding,
    TextStyle? codeBlockBodyTextStyle,
    EdgeInsetsGeometry? codeBlockTitlePadding,
    Decoration? codeBlockTitleDecoration,
    EdgeInsetsGeometry? codeBlockTitleMargin,
    TextStyle? codeBlockTitleTextStyle,
    String? codeBlockTitleCopyText,
    TextStyle? styleNotMatched,
    CodeWrapper? wrapper,
    CodeBuilder? builder,
    Map<String, TextStyle>? theme,
    String? language,
  }) {
    return PreConfig(
      decoration: decoration ?? this.decoration,
      margin: margin ?? this.margin,
      codeBlockBodyPadding: codeBlockBodyPadding ?? this.codeBlockBodyPadding,
      codeBlockBodyTextStyle:
          codeBlockBodyTextStyle ?? this.codeBlockBodyTextStyle,
      codeBlockTitlePadding:
          codeBlockTitlePadding ?? this.codeBlockTitlePadding,
      codeBlockTitleDecoration:
          codeBlockTitleDecoration ?? this.codeBlockTitleDecoration,
      codeBlockTitleMargin: codeBlockTitleMargin ?? this.codeBlockTitleMargin,
      codeBlockTitleTextStyle:
          codeBlockTitleTextStyle ?? this.codeBlockTitleTextStyle,
      codeBlockTitleCopyText:
          codeBlockTitleCopyText ?? this.codeBlockTitleCopyText,
      styleNotMatched: styleNotMatched ?? this.styleNotMatched,
      wrapper: wrapper ?? this.wrapper,
      builder: builder ?? this.builder,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }
```
```
[普通链接](https://www.example.com)
```

---

## 7. 链接 (Links)

[普通链接](https://www.example.com)
[带标题的链接](https://www.example.com "示例网站")
[https://www.example.com](https://www.example.com)

---

## 8. 图片 (Images)

![替代文字](https://woc.cool/assets/reading-C6jVr-Yu.gif "图片标题")

---

## 9. 表格 (Tables)

| 姓名      | 年龄 | 城市 |
| ------- | -- | -- |
| Alice   | 25 | 北京 |
| Bob     | 30 | 上海 |
| Charlie | 28 | 广州 |

---

| 姓名safs      | 年龄safsaf | 城市asasfag |
| ------- | -- | -- |
| Alice asdfasfasf  | 25 | 北京ssssss |
| Bob  safasfasfasf   | 30 | 上海dddddd |
| Charlie safasffasf | 28 | 广州ffff |

---

| 姓名safsaf      | 年龄safsafasf | 城市asfsafasfag |
| ------- | -- | -- |
| Alice asdsadsafasfasfasf  | 25 | 北京sssssssssss |
| Bob  safasfasfasfasfasfasf   | 30 | 上海ddddddddddddd |
| Charlie safasfasfasfasfasf | 28 | 广州ffffffffff |

---

## 10. 分隔线 (Horizontal Rule)

---

---

---

---

## 11. 任务列表 (Task List)

* [x] 已完成任务
* [ ] 待办任务
* [ ] 另一个待办

---

## 12. 转义字符 (Escapes)

\* 不会变成斜体 \*
\# 不会变成标题

$$$反斜杠

---

## 13. 脚注 (Footnotes)

这是一个带脚注的句子[^1]。  

[^1]: 这里是脚注内容。

---

## 14. 内嵌 HTML

<p style="color:red;">这是一段红色文字 (HTML)</p>

---

## 15. 数学公式 (部分解析器支持)

行内公式：$E = mc^2$  
块级公式：

$$
\int_{0}^{\infty} e^{-x} dx = 1
$$


要不要我帮你生成一份 **渲染后的效果版**（把 Markdown 转换成实际展示效果）方便预览？


## 目录
- [1. 标题 (Headings)](#1-标题-headings)
- [2. 段落与换行](#2-段落与换行)
- [3. 强调 (Emphasis)](#3-强调-emphasis)
- [4. 列表 (Lists)](#4-列表-lists)
- [5. 引用 (Blockquote)](#5-引用-blockquote)

  """;
}
