LNK系统框架开发文档
========================
![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/erp.png)

引言
-------------
计算机行业发展迅猛，实现快速开发已是当前不可或缺的开发方式，作为一个新兴的开发队伍，我们不能拥有像大公司大企业那样的IDE开发平台，但是总体系统框架还是要有。为此，我在此搭建出框架，用以调用此后开发出来的DLL文件，而DLL的建立我们也通过一个应用程序来快速创建，并初始化DLL中所需要的连接环境，开发人员只需要在界面上加上模块内需要的信息和布局，在相关事件中加上相应的处理代码即可，而自动生成的代码则原封不动即可。

### 1 搭建开发环境
#### 1.1 文件管理
![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/1.png)
  
    如图，文件结构如下：
    doc文件夹中存放需求文档设计文档等，
    exe文件夹存放可执行程序，
    img文件夹存放程序用到的图标，
    prj文件夹为创建新模块的工程，执行里面的exe程序可以创建模块，
    pub文件夹存储公用的pas文件，
    sql文件夹存放数据库脚本，
    src文件夹存放程序源代码。
#### 1.2 delphi ex环境配置
##### 1.2.1 配置可执行文件输出路径
![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/2.png)
##### 1.2.2 配置runtime package
![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/3.png)

    目前使用的runtime packages：
    vcl;vclx;vclsmp;vcldb;adortl;ibevnt;bdertl;vcldbx;teeui;teedb;tee;ibxpress;dsnap;vclie;inetdb;inet;frx19;frxDB19;frxe19
##### 1.2.3 配置主程序
![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/4.png)
##### 1.2.4 配置库路径
![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/5.png)
![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/6.png)
### 2 开发指南
#### 2.1 创建新模块工程
    我写了一个工程模版，一个创建工程的程序，经过使用验证，这些工具可行，方便，高效。
##### 2.1.1 工程模版
![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/7.png)

双击查询在相应的位置写查询语句即可，增删改查调用参考新增。这样主界面基本完成编程工作。而如果有不需要的按钮可以将其删掉或者直接将其visable值设为false即可。
##### 2.1.2 使用创建工程工具
该工具源码在目录prj下， 可执行文件在../prj/Win32/Debug下：

![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/8.png)

Exe为创建工程的执行文件，*.sql文件是该exe文件要调用的，为不采用ADO连接技术，这里直接让程序执行该sql脚本，达到初始化数据库的目的。

双击打开crtPrj.exe,输入工程名称，代码，创建者，如我要创建一个工程模块‘理财管家’，输入如下图。

![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/9.png)

点击确定

![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/10.png)

看到创建成功，关闭该程序。我们将在src文件夹下发现lnk_lcgj这个工程文件，没错，工程创建完毕。

使用delphi ex5打开该工程，你会发现，界面完全和工程模板一样，只是工程名称，文件名称改变了，没错，接下来我们就可以享受快捷的开发了。怎么做？当你看到工程代码的时候你再问我我保证不打死你。

#### 2.2 配置菜单

这个步骤目前还是需要的，后期我将考虑将当前开发的模块独立固定放到一个菜单下，不过这是后话，具体我要考虑下能不能直接在创建工程的时候配置。

配置步骤：

编译完你的工程模块，登录系统，选择基本资料-系统配置-权限管理

![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/11.png)

我们要用的是菜单和权限两个功能。选择菜单，配置如下，单击添加：

![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/12.png)

发现预览列表多出理财管家：

![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/13.png)

Ok,配置就这么简单，退出，点击权限设置：

![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/14.png)

比如要给用户谢振家分配权限，选中用户谢振家右键-查看/复制权限：

![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/15.png)

要分配的权限前会有个小勾，单击理财管家，将其变为小勾，点击确定即可完成配置。

重新登录谢振家用户，即可看到刚才配置的菜单：

![](https://github.com/qianlnk/LnkSys/blob/master/doc/docimg/16.png)

