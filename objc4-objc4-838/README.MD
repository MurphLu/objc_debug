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

#### No.1 `unable to find sdk 'macosx.internal'`

project 下选择 objc -> Build Settings -> Base SDK 选择 `macOS`

#### No.2 `'xxxxx.h' file not found`

在我们下载好的源文件目录下使用 `find . -name "xxxx.h"`
将搜到的头文件 拷贝到 `importedHeaders` 目录下

`xnu-xnu-8019.41.5/bsd/sys/reason.h` -> `importedHeaders/sys`

`dyld-dyld-940/include/mach-o/dyld_priv.h` -> `importedHeaders/mach-o` 

`libplatform-libplatform-273.40.1/private/os/lock_private.h` -> `importedHeaders/os` 

`xnu-xnu-8019.41.5/osfmk/machine/cpu_capabilities.h` -> `importedHeaders/System/machine`

`xnu-xnu-8019.41.5/libsyscall/os/tsd.h` -> `importedHeaders/os` 

`libpthread-libpthread-485.40.4/private/pthread/spinlock_private.h` -> `importedHeaders/pthread`


Libc 自 825.40.1 之后就不再包含 pthreads，找到该版本，并下载我们需要的头文件 [下载地址](https://opensource.apple.com/source/Libc/Libc-825.40.1/pthreads/pthread_machdep.h), 拷贝到 `importedHeaders/System`

Libc-997.1.1 之后的版本 `CrashReporterClient.h` 已经没有了，找到老版本，并下载头文件，拷贝到 `importedHeaders`

继续编译还会报错，里面只是判断了一下宏，如果有则尝试去引用实际的头文件，这里直接定义一个宏让它跳过该引用 `#define LIBC_NO_LIBCRASHREPORTERCLIENT`

`libplatform-libplatform-273.40.1/private/_simple.h` -> `importedHeaders`

`libclosure-libclosure-79/Block_private.h` -> `importedHeaders`

`dyld-dyld-940/include/objc-shared-cache.h` -> `importedHeaders`

`xnu-xnu-8019.41.5/osfmk/kern/restartable.h` -> `importedHeaders/kern`

`Libc-Libc-1506.40.4/os/linker_set.h` -> `importedHeaders/os`

`xnu-xnu-8019.41.5/libkern/os/reason_private.h` -> `importedHeaders/os`

`xnu-xnu-8019.41.5/libsyscall/os/tsd.h` -> `importedHeaders/os`

`Libc-Libc-1506.40.4/os/variant_private.h` -> `importedHeaders/os`

`libpthread-libpthread-485.40.4/private/pthread/spinlock_private.h` -> `importedHeaders/pthread`

`xnu-xnu-8019.41.5/osfmk/machine/cpu_capabilities.h` -> `importedHeaders/System/machine`


以上是所有缺少的头文件

#### No.3 编译报错

##### bridgeos 相关的代码删掉

`dyld_priv.h` 中的 `bridgeos(3.0)`

`lock_private.h` 中的 `bridgeos(4.0)`

##### llvm-MathExtras 中的缺少的 typedef 及 宏

```C++
#define UINT64_C(v)  (v ## ULL)
#define INT64_C(v)   (v ## LL)

typedef unsigned long long uint64_t;
typedef unsigned int uint32_t;
typedef unsigned short uint16_t;
typedef unsigned char uint8_t;
```

##### 注释掉一些不需要的头文件

```
NSObject.mmm/objc-runtime.mm
//#include <os/feature_private.h>

objc-cache.mm
//#include <Cambria/Traps.h>
//#include <Cambria/Cambria.h>
```

##### 接下来再有报错的话基本就直接注释掉就好了

#### 将报错的 other link flag 删除掉 target -> build settings -> other linker flags
"-lCrashReporterClient",
"-loah",

#### 修改编译脚本

target -> objc -> build phases-> run script(markgc)

将其中的 macosx.internal 改为 macosx

#### 添加测试 target run

测试target -> build phaese -> dependencies

添加 当前工程下的 objc

测试target -> build settings -> enagle hardened runtime  设为 NO

运行 testApp 就可以进行调试了



