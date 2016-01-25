//
//  XWConst.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/8.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  新浪微博: @爱吃香干炒肉



import UIKit


//文字颜色
let XWRefreshLabelTextColor = xwColor(r: 100, g: 100, b: 100)
//字体大小
let XWRefreshLabelFont = UIFont.boldSystemFontOfSize(13)



/** 头部高度 */
let XWRefreshHeaderHeight:CGFloat = 100
/** 尾部高度 */
let XWRefreshFooterHeight:CGFloat = 50

/** gifView 偏差 */
let XWRefreshGifViewWidthDeviation:CGFloat = 99

/** footer 菊花 偏差 */
let XWRefreshFooterActivityViewDeviation:CGFloat = 100

/** 开始的动画时间 */
let XWRefreshFastAnimationDuration = 0.25
/** 慢的动画时间 */
let XWRefreshSlowAnimationDuration = 0.4

/** 更新的时间 */
let XWRefreshHeaderLastUpdatedTimeKey = "XWRefreshHeaderLastUpdatedTimeKey"
/** 也就是上拉下拉的多少*/
let XWRefreshKeyPathContentOffset = "contentOffset"
/** 内容的size */
let XWRefreshKeyPathContentSize = "contentSize"
/** 内边距 */
let XWRefreshKeyPathContentInset = "contentInset"
/** 手势状态 */
let XWRefreshKeyPathPanKeyPathState = "state"

let XWRefreshHeaderStateIdleText = "Pull down to refresh"
let XWRefreshHeaderStatePullingText = "Release to refresh"
let XWRefreshHeaderStateRefreshingText = "Loading..."


let XWRefreshFooterStateIdleText = "Tap to load more data"
let XWRefreshFooterStateRefreshingText = "Loading more data..."
let XWRefreshFooterStateNoMoreDataText = "Finish loading data"

/** 图片路径 */
let XWIconSrcPath:String = "Frameworks/XWSwiftRefresh.framework/xw_icon.bundle/xw_down.png"

let XWIconLocalPath:String = "xw_icon.bundle/xw_down.png"

/**
header.setTitle("Pull down to refresh", state: .Idle)
header.setTitle("Release to refresh", state: .Pulling)
header.setTitle("Loading...", state: .Refreshing)
*/
