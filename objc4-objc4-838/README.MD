#### 对应版本

macOS 12.3, Xode 13.3

需要用到的开源库
xnu-xnu-8019.41.5

OBCJ 版本 objc4-838 [下载](https://github.com/apple-oss-distributions/objc4/archive/objc4-838.tar.gz)

在项目根目录新建一个 `importedHeaders` 的文件夹，用来存放我们从其他项目中拷贝过来的 objc 项目中缺少的头文件

解压后打开 `objc.xcodeproj`

`target` -> `objc` -> `Build Settings` -> `Header Search Paths`
在下面添加 `$(SRCROOT)/importedHeaders` 我们刚刚新建好的文件夹，用来查找头文件

`⌘ + B` 编译

#### 第一个 error `unable to find sdk 'macosx.internal'`

project 下选择 objc -> Build Settings -> Base SDK 选择 `macOS`

#### 第二个 error `'sys/reason.h' file not found`

在我们下载好的源文件目录下使用 `find . -name "reason.h"`,将搜到的文件拷贝到 `importedHeaders` 下的 `sys` 文件夹下



