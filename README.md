# CWAlertManager
### **iOS 基于系统UIAlertController实现多个弹框按顺序依次弹出**

#### 前言

> 项目中偶尔会出现短时间内需要弹出多个提示框的情况, 类似新安装的App第一次启动时,系统会按顺序弹出多个权限提示框的情景.

> 但是系统提供的UIAlertController并不能很好的满足这个需求.如果一个ViewController已经弹出了一个AlertController, 此时你载添加一个是没有效果的,你会看到控制台输出如下:
>
> ```
> Warning: Attempt to present <UIAlertController: 0x7fe3a3841e00>  on <ViewController: 0x7fe3a2f0cc00> which is already presenting <UIAlertController: 0x7fe3a482a200>
> ```

**显然: 新安装的App第一次启动时,能弹出多个获取权限的AlertController系统是做过特许处理的**.

**如何在不使用自定义Alert的情况下也实现此功能呢?闲暇之余自己撸了一个管理类CWAlertManager** 

#### 正文

> 效果示意图:[图](https://upload-images.jianshu.io/upload_images/3096223-b9bc059b8237df2b.gif)

![效果示意图](https://github.com/baozoudiudiu/CWAlertManager/blob/master/souce/demo.gif)

#### 代码示例:

> 使用extension中的方法创建AlertController
>
> ```swift
> // 创建只有一个按钮的alert
> let alert = UIAlertController.cw_alertOneButton(title: "提示", text: "提示文字")
> // 调用present方法
> alert.cw_presentedBy(self, completion:nil)
> 
> // 创建有2个按钮的alert
> let alert = UIAlertController.cw_alertTwoButton(title: "提示", text: "提示文字")
> alert.cw_presentedBy(self, completion:nil)
> ```
>
> cw_alertOneButton 和 cw_alertTwoButton 方法中"按钮文字"和"按钮点击回调"这两个用的是默认值属性.需要修改就自己传值.
>
> ```swift
> class func cw_alertOneButton(title: String?, text: String?, buttonText: String? = "确定", buttonBlock:(()->Void)? = nil) -> UIAlertController
> 
> class func cw_alertTwoButton(title: String?, text: String?, leftButtonText: String? = "确定", rightButtonText: String? = "取消", buttonBlock:((Int)->Void)? = nil) -> UIAlertController
> ```
>
> 

#### 注意事项:

>因为extension中只是简单的封装了2个创建alert的方法, 如果使用的是系统API创建的AlertController.
>
>1. 弹出时请使用cw_presentedBy方法.不然不会被加到管理栈中.
>
>2. 在UIAlertAction的回调中需要添加出栈代码: CWAlertManager.shared.pop()
>
>   ```swift
>   let alert = UIAlertController.init(title: "title", message: "message", preferredStyle: .alert)
>   alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
>   	CWAlertManager.shared.pop()
>   }))
>   alert.cw_presentedBy(self)
>   ```
>
>   

