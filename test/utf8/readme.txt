问题：
在unix下使用more查看，中文要正常。
在unix下使用vi编辑，中文要正常。
下载到windows上使用编辑软件后，再回传中文要正常。
文件要使用utf-8格式。


LANG=en_US.UTF-8
export LANG=zh_CN.UTF-8

中文文件utf-8格式：
  LANG=en_US.UTF-8下
  vi和more都乱码
  LANG=zh_CN.UTF-8下
  vi和more都乱码
  LANG=C下
  vi和more都乱码
中文文件gbk格式：
  LANG=en_US.UTF-8下
  LANG=C下
  vi和more查看正常。
    但输入中文只会显示..
  
打开putty,选择 Category中的Windows－－－>Appearance－－－> Font settings 
   把"字体"改为"新宋体"（其实改为其它中文字体都行像宋体之类的），字符集为CHINEASE_GB2312 
   
   
   
语言格式转化操作实践：

1. 将GBK格式的文本文档上传到28服务器（28服务器语言环境：NLS_LANG=AMERICAN_AMERICA.AL32UTF8; export NLS_LANG），有以下两种情况

   情况一：

     用Vi查看该文本文档，文档中的中文显示乱码，而用more查看文档，文档中的中文显示正常。

   情况二：
 
     使用unset LANG命令取消语言环境变量，则使用vi及more命令查看文本文档，文档中的中文显示正常，但编辑的话仍存在问题。

2. 将语言环境设置回：NLS_LANG=AMERICAN_AMERICA.AL32UTF8; export NLS_LANG，否则后台程序往数据库中插入的中文出现乱码，
   web端中文显示乱码。

3. 后台程序运行（将GBK格式文档转化为UTF-8格式后运行，例如：将GBK格式Yml文本转化为UTF-8格式后供后台读取，数据存入数据库显示正常）

     uiconv = Iconv.new("utf-8","gbk")


   