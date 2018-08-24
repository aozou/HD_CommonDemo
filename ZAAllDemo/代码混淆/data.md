1.工程编译或者启动后,点击工程中的Products文件夹,选中"代码混淆.app",show in finder
2.通过桌面DaoBao.py更新appFileFullPath路径,然后通过终端cd到改目录并运行
3.运行 class-dump -H ~/desktop/PayLoad/代码混淆.app -o ~/desktop/PropertyManager/hehe6
4.在~/desktop/PropertyManager/hehe6查看viewcontroller.h文件会发现方法名称和全局参数名称被混淆了
