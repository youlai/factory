//
//  Constants.swift
//  StoryDemo
//
//  Created by mac on 2019/7/5.
//  Copyright © 2019年 zhkj. All rights reserved.
//
import UIKit
import Foundation

//let kIsIPhoneX = UIScreen.main.bounds.size.equalTo(CGSize (width: 375, height: 812))
let kIsIPhoneX = (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!>CGFloat(0)
let kNavigationBarHeight:CGFloat = kIsIPhoneX ? 88 : 64
let kBottomToolBarHeight:CGFloat = kIsIPhoneX ? 80 : 49

let kStatusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height

let screenW=UIScreen.main.bounds.width
let screenH=UIScreen.main.bounds.height
func kSize(width:CGFloat)->CGFloat{
    return CGFloat(width*(screenW/375))
}
func cutCorner(cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor,view:UIView)
{
    view.layer.cornerRadius = cornerRadius
    view.layer.borderColor = borderColor.cgColor
    view.layer.borderWidth = borderWidth
    view.layer.masksToBounds = true
}

let app_key="himalltest"
let secret="has2f5zbd4"
var userkey=UserDefaults.standard.string(forKey: "UserKey")
var UserID=UserDefaults.standard.string(forKey: "UserID")
var Pwd=UserDefaults.standard.string(forKey: "Pwd")
var adminToken=UserDefaults.standard.string(forKey: "adminToken")
var pushToken=UserDefaults.standard.string(forKey: "pushToken")
var Eye=UserDefaults.standard.bool(forKey: "Eye")//MARK:眼睛开闭

let BASE_URL = "http://mall.xigyu.com/"//商城正式服
//let BASE_URL = "http://47.111.124.153/"//商城测试服
//let BASE_URL = "http://42.51.69.35:8812/"//商城测试服
let BASE_URL2 = "https://api.xigyu.com/api/"//工厂师傅正式服
//let BASE_URL2 = "http://47.96.126.145:8001/api/"//工厂师傅正式服
//let BASE_URL2 = "http://47.111.124.153:8001/api/"//工厂师傅测试服
//let BASE_URL2 = "http://42.51.69.35:8810/api/"//工厂师傅测试服

//===================================工厂师傅接口===============================================
/**
* 新版首页今日待处理
* state=0
* 待服务 state=2
* 待寄件 state=11
* 待返件  state=8
* 待结算  state=12
*
* "11"://待寄件
* "12"://待结算
* "13"://急需处理
* "14"://明日需处理
* "15"://已超时
* "1"://待预约
* "16"://待发货
 * "6"://已完结
* */
let NewWorkerGetOrderList=BASE_URL2+"Order/NewWorkerGetOrderList"//MARK:v3师傅端获取工单列表
/**
* 各工单数量
* var Count1 = 0;//待处理数量
* var Count2 = 0;//待预约数量
* var Count3 = 0;//待服务数量
* var Count4 = 0;//待寄件数量
* var Count5 = 0;//待返件数量
* var Count6 = 0;//待结算数量
 * var Count7 = 0;/已完结数量
* */
let NavigationBarNumber=BASE_URL2+"Order/NavigationBarNumber"//MARK:师傅端获取工单列表选项卡数量
let WorkerGetOrderList=BASE_URL2+"Order/WorkerGetOrderList"//MARK:师傅端获取工单列表
let GetOrderInfoList2=BASE_URL2+"Order/GetOrderInfoList2"//MARK:师傅端搜索获取工单列表
let ValidateUserName=BASE_URL2+"Account/ValidateUserName"
let GettokenbyUserid=BASE_URL2+"account/GettokenbyUserid"//获取token
let LoginOn=BASE_URL2+"Account/LoginOn"//登录
let WxRegister=BASE_URL2+"Account/WxRegister"//微信登录
let WxReg=BASE_URL2+"Account/WxReg"//绑定手机号
let Reg=BASE_URL2+"Account/Reg"//注册
let GetChildAccountByParentUserID=BASE_URL2+"Account/GetChildAccountByParentUserID"//获取子账号
let CancelChildAccount=BASE_URL2+"Account/CancelChildAccount"//注销子账号
let ForgetPassword=BASE_URL2+"Account/ForgetPassword"//忘记密码ForgetPassword
let GetUserInfoList=BASE_URL2+"Account/GetUserInfoList"//西瓜鱼用户信息
let ToBepresent=BASE_URL2+"Account/ToBepresent"//查询提现中
let UploadAvator=BASE_URL2+"Upload/UploadAvator"//MARK:上传头像
let GetCode=BASE_URL2+"Message/Send"//发送验证码 type注册1  忘记密码2 验证码登录3
let LoginOnMessage=BASE_URL2+"Account/LoginOnMessage"//验证码登录
let GetFactoryCategory=BASE_URL2+"FactoryConfig/GetFactoryCategory"//获取分类
let GetBrandByCategory=BASE_URL2+"FactoryConfig/GetBrandByCategory"//获取品牌
let GetFactoryBrandByUserID=BASE_URL2+"FactoryConfig/GetFactoryBrandByUserID"//获取品牌
let AddFactoryBrand=BASE_URL2+"FactoryConfig/AddFactoryBrand"//添加品牌
let AddBrandCategory=BASE_URL2+"FactoryConfig/AddBrandCategory"//添加型号
let DeleteFactoryBrand=BASE_URL2+"FactoryConfig/DeleteFactoryBrand"//删除品牌
let GetBrandWithCategory=BASE_URL2+"FactoryConfig/GetBrandWithCategory"//获取产品型号
let DeleteBrandcategory=BASE_URL2+"FactoryConfig/DeleteBrandcategory"//删除产品型号
let AddOrder=BASE_URL2+"Order/AddOrder"//发单
let ConfirmReceipt=BASE_URL2+"Order/ConfirmReceipt"//确认收货
let FactoryGetOrderList=BASE_URL2+"Order/FactoryGetOrderList"//获取服务工单列表
let UpdateOrderState=BASE_URL2+"Order/UpdateOrderState"//更新工单状态
let ApplyCancelOrder=BASE_URL2+"order/ApplyCancelOrder"//工单作废
let FactoryComplaint=BASE_URL2+"Order/FactoryComplaint"//工厂投诉
let FactoryEnsureOrder=BASE_URL2+"Order/FactoryEnsureOrder"//工厂确认工单 结算
let EnSureOrder=BASE_URL2+"Order/EnSureOrder"//用户确认订单 结算
let ApplyCustomService=BASE_URL2+"Order/ApplyCustomService"//发起质保
let ApproveBeyondMoney=BASE_URL2+"Order/ApproveBeyondMoney"//审核远程费
let ApproveOrderAccessory=BASE_URL2+"Order/ApproveOrderAccessory"//审核配件申请
let AddOrUpdateExpressNo=BASE_URL2+"Order/AddOrUpdateExpressNo"//工厂添加配件快递信息
let UpdateIsReturnByOrderID=BASE_URL2+"Order/UpdateIsReturnByOrderID"//旧件是否需要返件
let GetOrderRecordByOrderID=BASE_URL2+"Order/GetOrderRecordByOrderID"//工单跟踪
let GetExpressInfo=BASE_URL2+"Order/GetExpressInfo"//物流信息
let GetOrderInfo=BASE_URL2+"Order/GetOrderInfo"//工单详情
let GetOrderStr=BASE_URL2+"Pay/GetOrderStr"//支付宝
let GetWXOrderStr=BASE_URL2+"Pay/GetWXOrderStr"//微信
let MallBalancePay=BASE_URL2+"Mall/MallBalancePay"//余额
let WXNotifyManual=BASE_URL2+"Pay/WXNotifyManual"//微信人工回调OutTradeNo
let FAddCon=BASE_URL2+"Account/FAddCon"//赠送西瓜币
let GetOrderByhmall=BASE_URL2+"Order/GetOrderByhmall"//获取待支付工单
let GetOrderByhmalluserid=BASE_URL2+"Order/GetOrderByhmalluserid"//获取待支付工单
let AddorUpdateAccountPayInfo=BASE_URL2+"Account/AddorUpdateAccountPayInfo"//添加银行卡
let GetAccountPayInfoList=BASE_URL2+"Account/GetAccountPayInfoList"//获取银行卡
let GetBankNameByCardNo=BASE_URL2+"Account/GetBankNameByCardNo"//根据银行卡号获取银行名 判断后台是否支持该银行的提现
let IsMallid=BASE_URL2+"Order/IsMallid"//判断商品订单号是否发起过保内安装
let ChangePayPassword=BASE_URL2+"Account/ChangePayPassword"//MARK:修改支付密码
let UpdatePassword=BASE_URL2+"Account/UpdatePassword"//MARK:修改密码
let PressWokerAccount=BASE_URL2+"Order/PressWokerAccount"//催单
let UpdateAccountNickName=BASE_URL2+"Account/UpdateAccountNickName"//修改昵称
let UpdateEmergencyContact=BASE_URL2+"Account/UpdateEmergencyContact"//添加紧急联系人
let updateTeamNumber=BASE_URL2+"Account/updateTeamNumber"//团队人数
let IsOrNoTruck=BASE_URL2+"Account/IsOrNoTruck"//有无货车
let UpdateSex=BASE_URL2+"Account/UpdateSex"//修改性别
let AddOpinion=BASE_URL2+"Account/AddOpinion"//意见反馈
let CoinList=BASE_URL2+"mall/CoinList"//西瓜币明细
let AccountBill=BASE_URL2+"Account/AccountBill"//MARK:支出、收支明细
let ServiceOrderPicUpload=BASE_URL2+"Upload/ServiceOrderPicUpload"//MARK:安装服务完成图片
let ReuturnAccessoryPicUpload=BASE_URL2+"Upload/ReuturnAccessoryPicUpload"//MARK:提现
let WithDraw=BASE_URL2+"Account/WithDraw"//MARK:提现
let UpdateFactoryAccessorybyFactory=BASE_URL2+"FactoryConfig/UpdateFactoryAccessorybyFactory"//审核配件 配件价格为0
let ApproveOrderAccessoryByModifyPrice=BASE_URL2+"Order/ApproveOrderAccessoryByModifyPrice"//审核配件 配件价格不为0
let IDCardUpload=BASE_URL2+"Upload/IDCardUpload"//MARK:上传身份证以及清晰头像 UserID用户名Sort（1：正面，2：反面，3：清晰自拍照）
let GetProvince=BASE_URL2+"Config/GetProvince"//MARK:获取省
let GetCity=BASE_URL2+"Config/GetCity"//MARK:获取市
let GetArea=BASE_URL2+"Config/GetArea"//MARK:获取区
let GetDistrict=BASE_URL2+"Config/GetDistrict"//MARK:获取街道
let AddorUpdateServiceArea=BASE_URL2+"Account/AddorUpdateServiceArea"//MARK:更新服务区域
let AddAccountAddress=BASE_URL2+"Account/AddAccountAddress"//MARK:添加收件地址
let UpdateAccountAddress=BASE_URL2+"Account/UpdateAccountAddress"//MARK:修改收件地址
let DeleteAccountAddress=BASE_URL2+"Account/DeleteAccountAddress"//MARK:删除收件地址
let GetAccountAddress=BASE_URL2+"Account/GetAccountAddress"//MARK:获取收件地址
let ApplyAuthInfo=BASE_URL2+"Account/ApplyAuthInfo"//MARK:申请实名认证
let GetAccountSkill=BASE_URL2+"Account/GetAccountSkill"//MARK:获取账号技能
let UpdateAccountSkillData=BASE_URL2+"Account/UpdateAccountSkillData"//MARK:更新账号技能
let GetServiceRangeByUserID=BASE_URL2+"Account/GetServiceRangeByUserID"//MARK:获取账号服务区域
let GetIDCardImg=BASE_URL2+"Account/GetIDCardImg"//MARK:获取账号身份证照片
let GetFactoryAccessory=BASE_URL2+"FactoryConfig/GetFactoryAccessory"//MARK:获取工厂配件信息
let GetFactoryService=BASE_URL2+"FactoryConfig/GetFactoryService"//MARK:获取工厂服务项
let ApplyAccessoryphotoUpload=BASE_URL2+"Upload/ApplyAccessoryphotoUpload"//MARK:上传配件图片
let OrderByondImgPicUpload=BASE_URL2+"Upload/OrderByondImgPicUpload"//MARK:上传远程费图片
let LeaveMessageImg=BASE_URL2+"Upload/LeaveMessageImg"//MARK:上传留言图片
let ComPlaintImg=BASE_URL2+"Upload/ComPlaintImg"//MARK:上传投诉图片
let WorkerComplaint=BASE_URL2+"Order/WorkerComplaint"//MARK:投诉
let ApplyBeyondMoney=BASE_URL2+"Order/ApplyBeyondMoney"//MARK:申请远程费
let UpdateSendOrderState=BASE_URL2+"Order/UpdateSendOrderState"//MARK:接单
let OrderIsCall=BASE_URL2+"Order/OrderIsCall"//MARK:是否拨打用户电话
let UpdateSendOrderAppointmentState=BASE_URL2+"Order/UpdateSendOrderAppointmentState"//MARK:预约成功与否
let UpdateSendOrderUpdateTime=BASE_URL2+"Order/UpdateSendOrderUpdateTime"//MARK:更新上门时间
let GetFactoryAccessoryMoney=BASE_URL2+"FactoryConfig/GetFactoryAccessoryMoney"//MARK:根据配件服务sizeID计算钱
let AddOrderAccessoryAndService=BASE_URL2+"Order/AddOrderAccessoryAndService"//MARK:添加配件跟服务
let UpdateOrderAddressByOrderID=BASE_URL2+"Order/UpdateOrderAddressByOrderID"//MARK:寄件地址
let PressFactoryAccount=BASE_URL2+"Order/PressFactoryAccount"//MARK:催件
let AddReturnAccessory=BASE_URL2+"Order/AddReturnAccessory"//MARK:开始返件Message/AddAndUpdatePushAccount
let AddAndUpdatePushAccount=BASE_URL2+"Message/AddAndUpdatePushAccount"//MARK:新增获取更新推送账户的token以及tags， 工厂的type是6 师傅的type是7 ， createtime可以不传 UserID为登录用户名
let GetmessageListByType=BASE_URL2+"Cms/GetmessageListByType"//MARK:获取个人消息  1.工单消息类型  2.交易消息类型
let GetmessagePag=BASE_URL2+"Cms/GetmessagePag"//MARK:消息页面
let AllRead=BASE_URL2+"Cms/AllRead"//MARK:消息全部已读
let MessgIsOrNo=BASE_URL2+"Cms/messgIsOrNo"//MARK:消息是否已读
let AddOrUpdatemessage=BASE_URL2+"Cms/AddOrUpdatemessage"//MARK:更新消息为已读
let GetNewsLeaveMessage=BASE_URL2+"LeaveMessage/GetNewsLeaveMessage"//MARK:留言消息
let GetListCategoryContentByCategoryID=BASE_URL2+"Cms/GetListCategoryContentByCategoryID"//MARK:CategoryID 7系统消息 8平台政策 9平台新闻 10接单必读
let AddLeaveMessageForOrder=BASE_URL2+"LeaveMessage/AddLeaveMessageForOrder"//MARK:添加工单留言
//===================================商城接口===============================================
let Get = BASE_URL+"api/home/Get"//首页
let home_json=BASE_URL+"AppHome/data/default.json"//首页
let GetlismitBuyList=BASE_URL+"api/LimitTimeBuy/GetLismitBuyList"//抢购列表
let GetCategories=BASE_URL+"api/Category/GetCategories"//所有分类
let GetProductDetail=BASE_URL+"api/product/GetProductDetail"//商品详情
let GetSKUInfo=BASE_URL+"api/product/GetSKUInfo"//商品sku
let integral_mall=BASE_URL+"IntegralMall/IndexJson"//西瓜币商城
let GetCartProduct=BASE_URL+"api/Cart/GetCartProduct"//购物车
let PostAddProductToCart=BASE_URL+"api/Cart/PostAddProductToCart"//添加商品到购物车
let PostUpdateCartItem=BASE_URL+"api/Cart/PostUpdateCartItem"//提交订单时同步数量到后台
let GetUser=BASE_URL+"api/Login/GetUser"//登录
let PostRegisterUser=BASE_URL+"api/Register/PostRegisterUser"//注册
let GetPhoneOrEmailCheckCode=BASE_URL+"api/Register/GetPhoneOrEmailCheckCode"//注册验证码
let GetCheckPhoneOrEmailCheckCode=BASE_URL+"aapi/Register/GetCheckPhoneOrEmailCheckCode"//验证注册验证码是否正确
let UserCenter_GetUser=BASE_URL+"api/UserCenter/GetUser"//获取个人信息

let GetPhoneCode=BASE_URL+"api/login/GetPhoneCode"//验证码
let GetUserWithoutPassword=BASE_URL+"api/Login/GetUserWithoutPassword"//验证码登录

//地址相关
let GetShippingAddressList=BASE_URL+"api/ShippingAddress/GetShippingAddressList"//收货地址列表
let PostAddShippingAddress=BASE_URL+"api/ShippingAddress/PostAddShippingAddress"//新增收货地址
let PostEditShippingAddress=BASE_URL+"api/ShippingAddress/PostEditShippingAddress"//编辑收货地址
let PostDeleteShippingAddress=BASE_URL+"api/ShippingAddress/PostDeleteShippingAddress"//删除收货地址
let GetAllRegion=BASE_URL+"common/RegionAPI/GetAllRegion"//获取省市区
let GetSubRegion=BASE_URL+"common/RegionAPI/GetSubRegion"//获取街道
let GetRegion=BASE_URL+"common/RegionAPI/GetRegion"//获取省市区code
//订单相关

let PostSubmitOrderByCart=BASE_URL+"api/Order/PostSubmitOrderByCart"//购物车提交
let PostSubmitOrder=BASE_URL+"api/Order/PostSubmitOrder"//立即购买提交
let GetSubmitModel=BASE_URL+"api/Order/GetSubmitModel"//取提交MODEL
let GetSubmitByCartModel=BASE_URL+"api/Order/GetSubmitByCartModel"//取购物车提交的MODEL
let GetOrders=BASE_URL+"api/MemberOrder/GetOrders"//订单列表
let PostChangeOrderState=BASE_URL+"api/MemberOrder/PostChangeOrderState"//更新订单状态
let GetOrderDetail=BASE_URL+"api/MemberOrder/GetOrderDetail"//获取订单详情
let PostCloseOrder=BASE_URL+"api/MemberOrder/PostCloseOrder"//取消订单
let CancelOrder=BASE_URL+"api/Order/CancelOrder"//删除订单
let PostConfirmOrder=BASE_URL+"api/MemberOrder/PostConfirmOrder"//确认收货
let MallGetExpressInfo=BASE_URL+"api/MemberOrder/GetExpressInfo"//物流
let PostChangeOrderAddress=BASE_URL+"Api/Order/PostChangeOrderAddress"//订单修改收货地址
//搜索
let GetSearchProducts=BASE_URL+"api/search/GetSearchProducts"//搜索
let GetSearchFilter=BASE_URL+"api/search/GetSearchFilter"//筛选
//积分商城
let GetGifts=BASE_URL+"api/Gifts/GetGifts"//积分详情
let ConfirmOrder=BASE_URL+"api/Gifts/ConfirmOrder"//积分确认订单
let SubmitOrder=BASE_URL+"api/Gifts/SubmitOrder"//积分提交订单
let GetMyOrderList=BASE_URL+"api/Gifts/GetMyOrderList"//积分订单列表
let ConfirmOrderOver=BASE_URL+"api/Gifts/ConfirmOrderOver"//积分订单确认收货
let GetOrderCount=BASE_URL+"api/Gifts/GetOrderCount"//积分订单各状态数量
let GetOrder=BASE_URL+"api/Gifts/GetOrder"//积分订单详情
//足迹
let GetHistoryVisite=BASE_URL+"api/product/GetHistoryVisite"//足迹

let GetUserCollectionProduct=BASE_URL+"api/UserCenter/GetUserCollectionProduct"//用户收藏的商品
let GetUserCollectionShop=BASE_URL+"api/UserCenter/GetUserCollectionShop"//用户收藏的店铺

let GetUserCounponList=BASE_URL+"api/coupon/GetUserCounponList"//我的优惠券列表
let GetHotProduct=BASE_URL+"product/GetHotProduct"//猜你喜欢，找相似


///
let Loading = {HUD.show()}
let Loadingwith:((String)->()) = {str in
    HUD.show(withStatus:str)
}
let Dismiss = {HUD.dismiss()}



public func SignTopRequest(params:Dictionary<String,String>) -> String {
    var str = ""
    let sortedKeys = Array(params.keys).sorted()
    for key in sortedKeys {
        if params[key] != ""{
            str+=key.lowercased()+params[key]!
        }
    }
    return md5(strs: str+secret).uppercased()
}
public func md5(strs:String) ->String!{
    let str = strs.cString(using: String.Encoding.utf8)
    let strLen = CUnsignedInt(strs.lengthOfBytes(using: String.Encoding.utf8))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
    CC_MD5(str!, strLen, result)
    let hash = NSMutableString()
    for i in 0 ..< digestLen {
        hash.appendFormat("%02x", result[i])
    }
    //    result.deinitialize(count: result.hashValue)
    return String(format: hash as String)
}
//获取当前时间戳
public func getTimestamp() ->String!{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"// 自定义时间格式
    let timestamp = dateformatter.string(from: Date())
    return timestamp
}
//日期转时间戳
public func getTimestampFromDate(date:Date) ->String!{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"// 自定义时间格式
    let timestamp = dateformatter.string(from: date)
    return timestamp
}
//时间字符串转date
public func getDateFromTime(time:String) ->Date{
    let dateformatter = DateFormatter()
    //自定义日期格式
    dateformatter.dateFormat="yyyy-MM-dd HH:mm:ss"
    return dateformatter.date(from: time)!
}

