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

在我们下载好的源文件目录下使用 `find . -name "reason.h"`,将搜到的文件 `xnu-xnu-8019.41.5/bsd/sys/reason.h` 拷贝到 `importedHeaders/sys` 文件夹下

#### 第三个 error `'mach-o/dyld_priv.h' file not found`

继续搜索将结果 `dyld-dyld-940/include/mach-o/dyld_priv.h` 拷贝到 `importedHeaders/mach-o` 下


#### 第四个 error `'os/lock_private.h' file not found`

继续搜索将结果 `libplatform-libplatform-273.40.1/private/os/lock_private.h` 拷贝到 `importedHeaders/os` 下


#### 第五个 error `'pthread/tsd_private.h' file not found`

继续搜索将结果 `libplatform-libplatform-273.40.1/private/os/lock_private.h` 拷贝到 `importedHeaders/os` 下


#### 第六个 error `'System/machine/cpu_capabilities.h' file not found`

继续搜索将结果 `xnu-xnu-8019.41.5/osfmk/machine/cpu_capabilities.h` 拷贝到 `importedHeaders/System/machine` 下


#### 第七个 error `'os/tsd.h' file not found`

继续搜索将结果 `xnu-xnu-8019.41.5/libsyscall/os/tsd.h` 拷贝到 `importedHeaders/os` 下


#### 第八个 error `'pthread/spinlock_private.h' file not found`

继续搜索将结果 `libpthread-libpthread-485.40.4/private/pthread/spinlock_private.h` 拷贝到 `importedHeaders/pthread`


#### 第九个 error `'System/pthread_machdep.h' file not found`

Libc 自 825.40.1 之后就不再包含 pthreads，找到该版本，并下载我们需要的头文件 [下载地址](https://opensource.apple.com/source/Libc/Libc-825.40.1/pthreads/pthread_machdep.h), 拷贝到 `importedHeaders/System`


#### 第十个 error `'CrashReporterClient.h' file not found`

Libc-997.1.1 之后的版本 `CrashReporterClient.h` 已经没有了，找到老版本，并下载头文件，拷贝到 `importedHeaders`

继续编译还会报错，里面只是判断了一下宏，如果有则尝试去引用实际的头文件，这里直接定义一个宏让它跳过该引用 `#define LIBC_NO_LIBCRASHREPORTERCLIENT`

继续编译

