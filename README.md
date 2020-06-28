## Hummer

### 1. 环境搭建

确保电脑已安装Xcode，若未安装可到 App Store 下载安装。然后拉取 Hummer 项目代码接口。

```
$ git clone git@github.com:huangjy/hummer-ios.git
```

### 2. 目录说明

#### 2.1. Files 目录

该目录下存放着基础组件的 Demo JS 文件，可以通过 Demo 运行展示。

#### 2.2. Script 目录

该目录下存放了本地 Server 的脚本实现，该脚本采用 Ruby 语言书写。

Xcode 模拟器执行 Demo 时会调用该目录的 start 脚本，实现 Playgroud 调试。当然你也可以手动启动本地 Server 服务，如下所示。


```bash
$ cd <where hummer-ios location>

$ ./Script/start

```

>注意:该服务使用的是 9292 端口，请勿占用。

#### 2.3. Vendor 目录

该目录存放了 Hummer 依赖的 Facebook 跨平台布局引擎 YogaKit 的源码。

如果需要更新，建议大家自行下载 YogaKit 的代码并替换。你也可以手动修改 Podfile 中的 YogaKit 依赖，改为远程依赖，如下所示：

```ruby

target 'Hummer' do
    pod 'Yoga', '1.9.0'
    pod 'YogaKit', '1.9.0'
end

target 'Demo' do
    pod 'Yoga', '1.9.0'
    pod 'YogaKit', '1.9.0'
end

```


#### 2.4. Hummer 目录

该目录存放了 Hummer 的内核代码，由于 iOS 系统支持 JavaScriptCore 库，所以 iOS 不存在 JS 引擎代码。


#### 2.5. Demo目录

该目录存放了 Hummer 测试项目 Demo 的实现，你可以通过在 Xcode 中执行该项目，进行内置控件的 Demo 预览。


### 3. 安装依赖
Hummer 本地 Server 需要依赖 ruby 的运行环境。可打开终端进入到工程中```Script```目录，执行下列命令安装：

```
$ bundle install
```

>注意：若本地未安装bundle，可打开终端，执行下列命令安装：
>
>```$ gem install bundler ```
>
>具体可参见bundle官方文档，[Bundler](https://bundler.io)

### 4. 编译并运行

确保先运行了模拟器或者连接了真机，然后编译并运行Xcode即可。


